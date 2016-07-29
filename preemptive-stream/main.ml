
open Lwt.Infix

module Worker = (struct
  type ('a, 'b) t = {
    processor: Thread.t;
    push_request: ('a * 'b Lwt.u) option -> unit;
  }

  let make f =
    let rec handle_requests requests =
      match Lwt_preemptive.run_in_main (fun () ->
        Lwt.catch
          (fun () -> Lwt_stream.next requests >>= fun x -> Lwt.return (Some x))
          (fun _ -> Lwt.return None)
        ) with
      | None -> () (* exit thread *)
      | Some (request, result) ->
        (* Here's where we can do something in our background thread *)
        let response = f request in
        Lwt_preemptive.run_in_main (fun () ->
          Lwt.wakeup_later result response;
          Lwt.return_unit
        );
        handle_requests requests in
    let requests, push_request = Lwt_stream.create () in
    let processor = Thread.create handle_requests requests in
    { processor; push_request }

  let call { push_request } x =
    let t, u = Lwt.task () in
    push_request (Some (x, u));
    t

  let destroy { processor; push_request } =
    push_request None;
    Lwt_preemptive.detach Thread.join processor
end: sig
  type ('a, 'b) t
  (** A background worker thread which runs a function from 'a -> 'b *)

  val make: ('a -> 'b) -> ('a, 'b) t

  val call: ('a, 'b) t -> 'a -> 'b Lwt.t
  (** Perform some work in the background worker thread *)

  val destroy: ('a, 'b) t -> unit Lwt.t
  (** Shutdown and join the background worker thread *)
end)

let rec range first last = if first > last then [] else first :: (range (first + 1) last)

(* Create a worker, perform 1000 requests and shut it down *)
let one_worker () =
  let w = Worker.make (fun () -> ()) in
  Lwt.join (List.map (fun _ -> Worker.call w ()) (range 1 1000))
  >>= fun () ->
  Worker.destroy w

let lots_of_workers () =
  Lwt.join (List.map (fun _ -> one_worker ()) (range 1 1000))

let _ = Lwt_main.run (lots_of_workers ())
