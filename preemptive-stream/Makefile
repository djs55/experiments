main: main.ml
	ocamlfind ocamlopt -package lwt,lwt.preemptive -linkpkg -thread -o main main.ml

.PHONY: clean
clean:
	rm -f main.cm* main
