.PHONY: run clean

VM:=time-kernel time-initrd.img time-cmdline

build: $(VM) client/client

client/client: client/main.go
	cd client && go build

run: time-kernel time-initrd.img time-cmdline
	linuxkit run -publish 2222:22/tcp -publish 1234:1234/tcp time

$(VM): time.yml pkg/measure-time/Dockerfile pkg/measure-time/build.yml pkg/measure-time/main.go
	cd pkg && linuxkit pkg build -org djs55 -hash testing measure-time
	linuxkit build time.yml

clean:
	rm -f time-kernel
	rm -f time-initrd.img
	rm -f time-cmdline
	rm -rf time-state
