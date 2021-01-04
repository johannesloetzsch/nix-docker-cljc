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
