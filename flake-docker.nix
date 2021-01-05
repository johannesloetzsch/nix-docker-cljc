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
    mkdir -p /etc/nix
    echo 'experimental-features = nix-command flakes' > /etc/nix/nix.conf

    mkdir /tmp/ && chmod 777 /tmp/

    groupadd -g 0 root
    useradd -u 0 -g root -d /root -m root
    groupmems -g root -a root
    groupadd --system nixbld
    useradd --system -g nixbld nixbld
    groupmems -g nixbld -a nixbld

    ln -s /etc/ssl/certs/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt
  '';
  config = {
    Cmd = [ "bash" ];
    Env = [ "PATH=${binPath}:/nix/var/nix/profiles/default/bin" ];
  };
}
