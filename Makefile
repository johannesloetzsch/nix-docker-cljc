## run or bootstrap a docker-container containing nix with flake-support

run:
	## just as an example we use nix-flakes to run a hello-world-app
	docker run -t johannesloetzsch/nix-flake nix run nixpkgs#hello

bootstrap:
	nix build .#flake-docker
	docker load < result
	make run

push:
	docker login
	docker push johannesloetzsch/nix-flake:latest
