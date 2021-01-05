This repository contains examples how to package clojure(script) applications with nix.

## buildserver

In case your build-system doesn't have nix installed, you can use the docker-container defined in `flake-docker.nix` [from hub.docker.com](https://hub.docker.com/repository/docker/johannesloetzsch/nix-flake).

```shell
docker run -ti johannesloetzsch/nix-flake:latest bash

docker run -ti johannesloetzsch/nix-flake:latest nix run nixpkgs#hello
```

`Dockerfile` is an example how to build local repositories, on a system without nix.


```shell
docker build -t buildserver-example .
docker run -ti -v nix:/nix/ buildserver-example
```

## caching

Using nix allows simple and efficient caching. To keep downloaded and built derivations between restarts of the docker-buildserver, define `/nix` to be a volume. 
For efficient usage of remote flakes, keep `~/.cache/nix/flake-registry.json`. Further speedup is achieved, by memorization of nix-expressions in `~/.cache/nix/eval-cache*`.

```shell
docker run -ti -v nix:/nix/ -v root:/root/ johannesloetzsch/nix-flake:latest nix run nixpkgs#hello
```
