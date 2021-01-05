## Run or bootstrap a docker-container containing nix with flake-support

run:
	## Just as an example we use nix-flakes to run a hello-world-app
	docker run -t johannesloetzsch/nix-flake nix run nixpkgs#hello

run-derived-buildserver:
	## Example of using tho docker-container to build your local projects via Dockerfile
	## Note: `--privileged` is required for creating containers with dockerTools
	docker build -t buildserver-example .
	docker run --privileged -ti -v nix:/nix/ buildserver-example

bootstrap:
	nix build .#flake-docker
	docker load < result
	make run

push:
	docker login
	docker push johannesloetzsch/nix-flake:latest
