{ pkgs ? import <nixpkgs> {}
}: 

pkgs.mkShell {
  buildInputs = with pkgs; [ nodePackages.node2nix ];
  shellHook = ''
    cd deps; cd node
    node2nix --nodejs-12 -i node-packages.json
    exit
  '';
}
