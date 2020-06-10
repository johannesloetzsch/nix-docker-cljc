{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/20.03.tar.gz") {},
  shell ? import ./default.nix { inherit pkgs; },
  cmd ? [ "${shell}/bin/shell" ]
}:
let

  script-nix-setup = pkgs.writeScript "nix-setup" ''
    #!${pkgs.stdenv.shell}
    . /etc/profile.d/nix-daemon.sh
    nix-channel --add https://nixos.org/channels/nixpkgs-unstable
    nix-channel --update
  '';

in
pkgs.dockerTools.buildImage {
  name = "nix-base";
  tag = "latest";
  created = "now";

  contents = [ pkgs.cacert pkgs.nix ];

  runAsRoot = ''
    #!${pkgs.runtimeShell}
    ${pkgs.dockerTools.shadowSetup}

    mkdir /tmp
    mkdir -p /etc/nix
    echo 'build-users-group =' > /etc/nix/nix.conf  ## single user

    mkdir -p /root/bin
    cp ${script-nix-setup} /root/bin/nix-setup

    mkdir -p /home/user
    ${pkgs.busybox}/bin/addgroup user
    ${pkgs.busybox}/bin/adduser -D -s ${pkgs.bashInteractive}/bin/bash -G user user
    chown user:user /home/user
  '';

  config = {
    Cmd = cmd;
  };
}
