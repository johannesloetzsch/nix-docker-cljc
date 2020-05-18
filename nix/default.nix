{ pkgs ? import <nixpkgs> {},
  stdenv ? pkgs.stdenv,
  makeWrapper ? pkgs.makeWrapper,
  nodejs ? pkgs.nodejs,
  jre ? pkgs.jre
}: 

let

  # to create this, call `nix-shell deps` first
  node2nix-deps = import ./deps/node/default.nix { inherit (pkgs); };

  binPath = with pkgs; stdenv.lib.makeBinPath [ jdk ];

  bin = { npm = "${nodejs}/bin/npm";
  shadow-cljs =
    "${node2nix-deps.shadow-cljs}/bin/shadow-cljs"; };

  script-dev = pkgs.writeScript "dev" ''
    #!${pkgs.stdenv.shell}
    ${bin.npm} install
    ${bin.shadow-cljs} watch app
  '';

  script-release = pkgs.writeScript "release" ''
    #!${pkgs.stdenv.shell}
    ${bin.npm} install
    ${bin.shadow-cljs} release app
  '';

in
pkgs.stdenv.mkDerivation {
  name = "example-shadow-cljs";
  src = ./..;
  buildInputs = [ makeWrapper
                  nodejs node2nix-deps.shadow-cljs ];

  shellHook = ''
    echo "Available scripts:"
    ls -l ${script-dev} ${script-release}
  '';

  buildPhase = ''
    # TODO
    # * get shadow-maven-dependencies via nix
    # * get node-dependencies via nix (with node2nix like in deps/node)
    # * offline build
    #
    # For now use ${script-release} to build from a source-package
  '';
  installPhase = ''
    mkdir -p $out/bin;
    cp -r . $out;
    cp ${script-dev} $out/bin/dev
    cp ${script-release} $out/bin/release
    wrapProgram $out/bin/dev --prefix PATH : $out/bin:${binPath}
  '';
}
