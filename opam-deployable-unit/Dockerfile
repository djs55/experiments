FROM ocaml/opam:alpine as ocaml

RUN opam depext cryptokit jbuilder -y -i
ADD . src
RUN sudo chown opam src -R
RUN cd src && opam config exec -- sh -c 'jbuilder build main.exe'

# Assume that 
# - all external C libraries have an alpine depext called foo-dev
# - foo-dev has a corresponding runtime package called foo
RUN opam depext -n cryptokit | grep -v '#' | grep '\-dev' | while read in; do basename "$in" -dev; done > needed-packages.txt

# Create a minimal alpine root with only these packages
USER 0
RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/
RUN apk add --no-cache --initdb -p /out alpine-baselayout busybox
RUN cat needed-packages.txt | xargs apk add --no-cache -p /out

# Install the minimal alpine and our binary into an empty image
FROM scratch
COPY --from=ocaml /out /
COPY --from=ocaml /home/opam/src/_build/default/main.exe /main.exe
ENTRYPOINT /main.exe

