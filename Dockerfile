FROM johannesloetzsch/nix-flake

RUN mkdir /source/
COPY . /source/
WORKDIR /source/

## Use the out-directory as a volume to retrieve the build results
RUN mkdir /out/

## 1. Build and run the clojure hello world example.
## 2. Build the docker-container and put the result into a volume.
CMD nix run .#example-clj-lein && \
    nix build .#flake-docker && cp -L result /out/docker-image-nix-flake.tar.gz
