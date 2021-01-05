## Run or bootstrap a docker-container containing nix with flake-support

bootstrap-test-push: bootstrap run run-derived-buildserver push

run:
	## Just as an example we use nix-flakes to run a hello-world-app
	docker run -t -v nix:/nix/ -v root:/root/ johannesloetzsch/nix-flake nix run nixpkgs#hello

run-derived-buildserver:
	## Example of using tho docker-container to build your local projects via Dockerfile
	## Note: `--privileged` is required for creating containers with dockerTools
	docker build -t buildserver-example .
	docker run --privileged -ti -v nix:/nix/ -v ${PWD}/out:/out/ buildserver-example
	ls -l out

bootstrap:
	nix build .#flake-docker
	docker load < result

push:
	docker login
	docker push johannesloetzsch/nix-flake:latest
