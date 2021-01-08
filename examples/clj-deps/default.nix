{ pkgs, buildMavenRepositoryFromLockFile }:
let
  mavenRepository = buildMavenRepositoryFromLockFile { file = ./mvn2nix-lock.json; };
inherit (pkgs) lib stdenv jdk11_headless maven makeWrapper clojure jre coreutils;
inherit (stdenv) mkDerivation;
in mkDerivation rec {
  pname = "example";
  version = "0.0.1-SNAPSHOT";
  name = "${pname}-${version}";
  src = lib.cleanSource ./.;

  script = (pkgs.writeScriptBin "${pname}" ''
    #!${pkgs.runtimeShell}
    CLASSPATH_FILE="$(dirname $0)/../classpath"
    export CLASSPATH="$(${coreutils}/bin/cat $CLASSPATH_FILE)"
    cd ${src}
    ${jre}/bin/java clojure.main -m example.core
  '');
  
  buildInputs = [ jdk11_headless maven ];

  buildPhase = ''
    export HOME=.
    ${clojure}/bin/clj -Sdeps '{:mvn/local-repo "${mavenRepository}"}' -Spath > classpath
  '';

  checkPhase = ''
    export HOME=.
    ${clojure}/bin/clj -Sdeps '{:mvn/local-repo "${mavenRepository}" :deps {lambdaisland/kaocha {:mvn/version "0.0-529"}}}' -Mtest
  '';
  doCheck = true;

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${src} $out/src
    ln -s ${mavenRepository} $out/lib
    cp classpath $out/
    cp ${script}/bin/${pname} $out/bin/${pname}
  '';
}
