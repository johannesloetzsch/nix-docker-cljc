```sh
nix-shell --pure
```

```sh
nix-build && ./result/bin/shell
```

```sh
nix-build docker.nix && docker load < result && docker run -it nix-base
```
