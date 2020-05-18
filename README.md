### Prepare the dev-dependencies

```sh
cd nix
nix-shell dev
```

### Develop and test in a pure environment

```sh
nix-shell --pure
```

### Create a docker image

```sh
nix-build docker.nix && docker load < result
docker run -p 8080:8080 nix-shadow-cljs
```
