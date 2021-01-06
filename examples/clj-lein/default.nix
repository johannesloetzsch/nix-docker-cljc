{ pkgs ? import <nixpkgs> {},
  buildMavenRepositoryFromLockFile ? (import (fetchTarball "https://github.com/fzakaria/mvn2nix/archive/master.tar.gz") {}).buildMavenRepositoryFromLockFile
}:
let
  mavenRepository = buildMavenRepositoryFromLockFile { file = ./mvn2nix-lock.json; };
inherit (pkgs) lib stdenv jdk11_headless maven makeWrapper leiningen;
inherit (stdenv) mkDerivation;
in mkDerivation rec {
  pname = "example";
  version = "0.0.1-SNAPSHOT";
  name = "${pname}-${version}";
  src = lib.cleanSource ./.;

  buildInputs = [ jdk11_headless maven makeWrapper leiningen ];
  buildPhase = ''
    echo "Building with maven repository ${mavenRepository}"

    export HOME=.
    mkdir .lein
    echo '{:user {:offline? true :local-repo "${mavenRepository}"}}' > ~/.lein/profiles.clj
    lein uberjar
  '';

  installPhase = ''
    # create the bin directory
    mkdir -p $out/bin

    # create a symbolic link for the lib directory
    ln -s ${mavenRepository} $out/lib

    # copy out the JAR
    # Maven already setup the classpath to use m2 repository layout
    # with the prefix of lib/
    cp target/uberjar/${name}-standalone.jar $out/

    # create a wrapper that will automatically set the classpath
    # this should be the paths from the dependency derivation
    makeWrapper ${jdk11_headless}/bin/java $out/bin/${pname} --add-flags "-jar $out/${name}-standalone.jar"
  '';

  ## Upload into github release via ../../deploy.nix
  release-file = "${name}-standalone.jar";
}
