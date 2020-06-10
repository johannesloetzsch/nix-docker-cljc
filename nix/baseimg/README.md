```sh
nix-shell --pure
```

```sh
nix-build && ./result/bin/shell
```

```sh
nix-build docker.nix && docker load < result && docker run -it nix-base
```

The compressed `result` (`docker-image-nix-base.tar.gz`) should have a size about 30MB.

You can use `nix` from within the container, but need to setup and update a channel first:

```sh
$ . /root/bin/nix-setup ; nix-shell -p hello --run hello
```
