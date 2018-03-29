Show how to package an OCaml app built with docker and which uses C libs
as a small docker image.

The example is

https://github.com/xavierleroy/cryptokit/blob/master/test/prngtest.ml

which needs libgmp

Build with

```
$ docker build -t test .
```

Run with

```
$ docker run test
```

If you see a linking error, it failed. Otherwise it worked!
