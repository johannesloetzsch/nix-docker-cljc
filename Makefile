## build a docker-container containing nix with flake-support

bootstrap:
	nix build .#flake-docker
	docker load < result
	## just as an example we use nix-flakes to run a hello-world-app
	docker run -t nix-flake nix run nixpkgs#hello
