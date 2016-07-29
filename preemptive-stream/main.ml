
open Lwt.Infix

module Worker = (struct
  type t = Thread.t * (unit Lwt.u option -> unit)

  let make () =
    let rec handle_requests requests =
      match Lwt_preemptive.run_in_main (fun () ->
        Lwt.catch
          (fun () -> Lwt_stream.next requests >>= fun x -> Lwt.return (Some x))
          (fun _ -> Lwt.return None)
        ) with
      | None -> () (* exit thread *)
      | Some result ->
        (* Here's where we can do something in our background thread *)
        Lwt_preemptive.run_in_main (fun () ->
          Lwt.wakeup_later result ();
          Lwt.return_unit
        );
        handle_requests requests in
    let requests, push_request = Lwt_stream.create () in
    let processor = Thread.create handle_requests requests in
    processor, push_request

  let call (_, push_request) =
    let t, u = Lwt.task () in
    push_request (Some u);
    t

  let destroy (processor, push_request) =
    push_request None;
    Lwt_preemptive.detach Thread.join processor
end: sig
  type t
  (** A background worker thread *)

  val make: unit -> t

  val call: t -> unit Lwt.t
  (** Perform some work in the background worker thread *)

  val destroy: t -> unit Lwt.t
  (** Shutdown and join the background worker thread *)
end)

let one () =
  let w = Worker.make () in
  Worker.call w
  >>= fun () ->
  Worker.destroy w


let test () =
  one ()

let _ = Lwt_main.run (test ())
