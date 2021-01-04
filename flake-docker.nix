{ pkgs }:
let
  contents = with pkgs; [ nixFlakes coreutils shadow cacert bashInteractive ];
  binPath = pkgs.stdenv.lib.makeBinPath contents;
in
pkgs.dockerTools.buildImage {
  name = "nix-flake";
  tag = "latest";
  contents = contents;
  runAsRoot = ''
    mkdir -p /etc/nix
    echo 'experimental-features = nix-command flakes' > /etc/nix/nix.conf

    mkdir /tmp/
    groupadd -g 0 root
    useradd -u 0 -g root -d /root -m root
    groupmems -g root -a root
    groupadd --system nixbld
    useradd --system -g nixbld nixbld
    groupmems -g nixbld -a nixbld

    ln -s /etc/ssl/certs/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt
  '';
  config = {
    #Cmd = [ "nix" "run" "nixpkgs#hello" ];
    Env = [ "PATH=${binPath}" ];
  };
}
