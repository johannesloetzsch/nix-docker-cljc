{ pkgs }:
let
  contents = with pkgs; [ ## Minimal dependencies (~50MB)
                          nixFlakes coreutils shadow cacert bashInteractive
                          ## Requirements for circleci (~110MB)
                          git gnutar gzip
                        ];
  binPath = pkgs.stdenv.lib.makeBinPath contents;
in
pkgs.dockerTools.buildImage {
  name = "johannesloetzsch/nix-flake";
  tag = "latest";
  contents = contents;
  runAsRoot = ''
    ## nix flakes support

    mkdir -p /etc/nix /etc/nixos
    echo 'experimental-features = nix-command flakes' > /etc/nix/nix.conf

    ## keep the flake.nix and the flake.lock
    ## this allows us to install software of the same pkgs state inside the container

    cp ${./flake.nix} /etc/nixos/flake.nix
    cp ${./flake.lock} /etc/nixos/flake.lock

    ## minimal essentials required to run nix

    ln -s /etc/ssl/certs/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt

    mkdir /tmp/ && chmod 777 /tmp/

    groupadd -g 0 root
    useradd -u 0 -g root -d /root -m root
    groupmems -g root -a root
    groupadd --system nixbld
    useradd --system -g nixbld nixbld
    groupmems -g nixbld -a nixbld

    ## a few common expectations by other tools

    groupadd nogroup
    useradd --system -g nogroup nobody

    mkdir -p /usr/bin && cp $(${pkgs.which}/bin/which env) /usr/bin/
  '';
  config = {
    Cmd = [ "bash" ];
    Env = [ "PATH=${binPath}:/nix/var/nix/profiles/default/bin" ];
  };
}
