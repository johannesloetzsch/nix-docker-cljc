This repository contains examples how to package clojure(script) applications with nix.

## Buildserver

[
![docker image size](https://img.shields.io/docker/image-size/johannesloetzsch/nix-flake.svg)
![docker pulls](https://img.shields.io/docker/pulls/johannesloetzsch/nix-flake.svg)
](https://hub.docker.com/repository/docker/johannesloetzsch/nix-flake)

In case your build-system doesn't have nix installed, you can use the docker-container defined in `flake-docker.nix` [from hub.docker.com](https://hub.docker.com/repository/docker/johannesloetzsch/nix-flake).

```shell
docker run -ti johannesloetzsch/nix-flake:latest bash

docker run -ti johannesloetzsch/nix-flake:latest nix run nixpkgs#hello
```

The last command downloads the latest version of `hello` from the flake-registry.

When reproducibility matters, you can use `nixpkgs` in the version provided by the flake used to build the container.
This also helps keeping the `/nix/store` thin, by preventing the installation of packages in multiple versions.

```shell
docker run -ti johannesloetzsch/nix-flake:latest nix run /etc/nixos#pkgs.hello
docker run -ti johannesloetzsch/nix-flake:latest nix eval /etc/nixos#nixpkgs.lastModifiedDate
docker run -ti johannesloetzsch/nix-flake:latest nix eval /etc/nixos#nixpkgs.rev
```

`Dockerfile` is an example how to build local repositories, on a system without nix.


```shell
docker build -t buildserver-example .
docker run -ti -v nix:/nix/ buildserver-example
```

You can even use a `configuration.nix` (or `flake.nix`) to profit from [config options provided by nixos](https://nixos.org/manual/nixos/stable/index.html#ch-configuration): See
[Example](https://github.com/community-garden/fdroid-repo/commit/8264638ddc1d30ee5098a98f81c4b2b82e7a0b83#diff-dd2c0eb6ea5cfc6c4bd4eac30934e2d5746747af48fef6da689e85b752f39557)

## Caching

Using nix allows simple and efficient caching. To keep downloaded and built derivations between restarts of the docker-buildserver, define `/nix` to be a volume. 
For efficient usage of remote flakes, keep `~/.cache/nix/flake-registry.json`. Further speedup is achieved, by memorization of nix-expressions in `~/.cache/nix/eval-cache*`.

```shell
docker run -ti -v nix:/nix/ -v root:/root/ johannesloetzsch/nix-flake:latest nix run nixpkgs#hello
```

## Circleci

[![circleci](https://circleci.com/gh/johannesloetzsch/nix-docker-cljc.svg?style=shield)](https://app.circleci.com/pipelines/github/johannesloetzsch/nix-docker-cljc)

The repository contains a `.circleci/config.yml`, showing an example of how to configure a ci build based on nix.
Caching is done based on `flake.lock` and `flake.nix`. In case one of the files changed, it will fallback to the latest available cache.

The example also shows how a file from a derivation can be uploaded to an github release. For using it, in circleci set `GITHUB_TOKEN` as a valid personal access token with scope `public_repo`.

## Troubleshooting

Circleci requires that nix builds run without `sandboxing`, otherwise it fails with „_cannot set host name: Operation not permitted_“. So we disable it by setting `sandbox = false` in `~/.config/nix/nix.conf`.

Building a derivation with `dockerTools.buildImage.runAsRoot` might fail with „_'x86_64-linux' with features {kvm} is required to build_“. If you want use qemu without kvm, set `system-features = kvm` in `~/.config/nix/nix.conf`.
