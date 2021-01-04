{ pkgs, buildMavenRepositoryFromLockFile }:
let
  app = import ./default.nix { inherit pkgs buildMavenRepositoryFromLockFile; };
in
pkgs.dockerTools.buildImage {
  name = "example-clj-lein";
  tag = "latest";
  config = {
    Cmd = [ "${app}/bin/example" ];
  };
}
