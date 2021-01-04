{
  description = "Example for tooling to build cljc with nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
    mvn2nix-pkgs.url = "github:johannesloetzsch/mvn2nix/master";
  };

  outputs = { self, nixpkgs, mvn2nix-pkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { system="x86_64-linux"; };
    buildMavenRepositoryFromLockFile = mvn2nix-pkgs.legacyPackages.x86_64-linux.buildMavenRepositoryFromLockFile;
  in
  rec {
    legacyPackages.x86_64-linux = {
      mvn2nix = mvn2nix-pkgs.legacyPackages.x86_64-linux.mvn2nix;

      example-clj-lein = import ./examples/clj-lein/default.nix { inherit pkgs buildMavenRepositoryFromLockFile; };
      example-clj-lein-docker = import ./examples/clj-lein/docker.nix { inherit pkgs buildMavenRepositoryFromLockFile; };

      flake-docker = import ./flake-docker.nix { inherit pkgs; };
    };

    defaultPackage.x86_64-linux = legacyPackages.x86_64-linux.mvn2nix;
  };
}
