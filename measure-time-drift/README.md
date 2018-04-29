This is a linuxkit-based application to measure time drift within
a VM.

Build and run the test with:
```
./test.sh
```
This should run a background process (`client`) which attempts to query a VM
with a port exposed on port 1234. In parallel it will build and then run a
VM with the server. The VM will be rebooted until the script is terminated.

The results accumulate in `_results/` in files called `drift.%d.dat` where
a `%d` is incremented on each VM boot.

To produce a graph:
```
make graph
```
This produces a file `drift.png` with one line per boot.
