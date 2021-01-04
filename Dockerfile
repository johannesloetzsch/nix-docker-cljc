FROM johannesloetzsch/nix-flake
## Building local repositorys with flake requires git
RUN nix-channel --add https://nixos.org/channels/nixpkgs-unstable && \
    nix-channel --update && \
    nix-env -i git

## Having /nix/ as a volume allows caching between restarts of the build container
VOLUME /nix/

RUN mkdir /source/
COPY . /source/
WORKDIR /source/

CMD nix build && ls -l result
