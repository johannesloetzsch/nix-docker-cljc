{ pkgs ? import <nixpkgs> {},
  bash ? pkgs.bashInteractive,
  binPath ? pkgs.stdenv.lib.makeBinPath [ pkgs.coreutils pkgs.busybox ],
  PS1 ? ''\n\$ ''
}: 
let

  script-shell = pkgs.writeScript "shell" ''
    #!${pkgs.stdenv.shell}

    export PATH="$PATH:${binPath}"
    export PS1="${PS1}"
    ${bash}/bin/bash --norc -i
  '';

in
pkgs.stdenv.mkDerivation {
  name = "shell";
  src = ./.;

  shellHook = ''
    ${script-shell}
  '';

  installPhase = ''
    mkdir -p $out/bin;
    cp ${script-shell} $out/bin/shell
  '';
}
