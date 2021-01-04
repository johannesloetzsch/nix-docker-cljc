## run with pure leiningen

run-lein:
	lein test
	lein run


## build and run by flake.nix

pom.xml: project.clj
	lein pom

mvn2nix-lock.json: pom.xml
	nix run ../..#mvn2nix > mvn2nix-lock.json
	git add mvn2nix-lock.json

run-nix: mvn2nix-lock.json
	nix run ../..#example-clj-lein


## docker container build by flake.nix

run-docker:
	nix build ../..#example-clj-lein-docker
	docker load < result
	docker run example-clj-lein:latest
