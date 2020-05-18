{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/20.03.tar.gz") {} }:

let

  myapp = import ./default.nix { inherit pkgs; };

  bin = with pkgs; { cp = "${coreutils}/bin/cp"; };

  workingdir = "/workingdir";
  cmd = pkgs.writeScript "cmd" ''
    #!${pkgs.stdenv.shell}
    ${bin.cp} -r ${myapp} ${workingdir}
    cd ${workingdir}
    ${myapp}/bin/dev
  '';
  
in
pkgs.dockerTools.buildImage {
  name = "nix-shadow-cljs";
  tag = "latest";
  config = {
    Cmd = [ "${cmd}" ];
  };
}
