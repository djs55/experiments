FROM linuxkit/alpine:f3cd219615428b2bd943411723eb28875275fae7 AS build

RUN apk add --no-cache go musl-dev build-base
ENV GOPATH=/go PATH=$PATH:/go/bin 

RUN mkdir -p /go/cmd/measure-time
COPY main.go /go/cmd/measure-time
RUN cd /go/cmd/measure-time && go build

FROM alpine
COPY --from=build /go/cmd/measure-time/measure-time /measure-time
CMD ["/measure-time"]
