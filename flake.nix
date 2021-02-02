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
    release-from = import ./examples/clj-lein/default.nix { inherit pkgs buildMavenRepositoryFromLockFile; };
  in
  rec {
    legacyPackages.x86_64-linux = {
      inherit nixpkgs pkgs;

      ## Tools
      mvn2nix = mvn2nix-pkgs.legacyPackages.x86_64-linux.mvn2nix;
      deploy = import ./deploy.nix { inherit pkgs release-from; };

      ## Builds

      flake-docker = import ./flake-docker.nix { inherit pkgs; };

      example-clj-lein = import ./examples/clj-lein/default.nix { inherit pkgs buildMavenRepositoryFromLockFile; };
      example-clj-lein-docker = import ./examples/clj-lein/docker.nix { inherit pkgs buildMavenRepositoryFromLockFile; };

      example-clj-deps = import ./examples/clj-deps/default.nix { inherit pkgs buildMavenRepositoryFromLockFile; };
    };

    defaultPackage.x86_64-linux = legacyPackages.x86_64-linux.flake-docker;
  };
}
