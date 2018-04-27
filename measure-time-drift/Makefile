.PHONY: run clean

run: time-kernel time-initrd.img time-cmdline
	linuxkit run -publish 2222:22/tcp time

time-kernel time-initrd.img time-cmdline: time.yml
	linuxkit build time.yml

clean:
	rm -f time-kernel
	rm -f time-initrd.img
	rm -f time-cmdline
	rm -rf time-state
