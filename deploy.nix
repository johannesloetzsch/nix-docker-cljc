{ pkgs, release-from }:
(pkgs.writeScriptBin "deploy" ''
  #!${pkgs.runtimeShell} -xe
  export PATH="${pkgs.stdenv.lib.makeBinPath (with pkgs; [github-release])}"

  export GITHUB_USER="$CIRCLE_PROJECT_USERNAME"
  export GITHUB_REPO="$CIRCLE_PROJECT_REPONAME"
  export TAG="$CIRCLE_TAG"

  [ "$TAG" = "v${release-from.version}" ]

  github-release release -t $TAG
  github-release upload -t $TAG -f "${release-from}/${release-from.release-file}" -n ${release-from.release-file}
'')
