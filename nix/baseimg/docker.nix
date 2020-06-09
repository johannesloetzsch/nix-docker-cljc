{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/20.03.tar.gz") {},
  shell ? import ./default.nix { inherit pkgs; },
  cmd ? [ "${shell}/bin/shell" ]
}:

pkgs.dockerTools.buildImage {
  name = "nix-base";
  tag = "latest";
  config = {
    Cmd = cmd;
  };
}
