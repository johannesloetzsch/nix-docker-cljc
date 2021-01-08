`:extra-deps` need be specified manually

```shell
clj -Sdeps '{:deps { lambdaisland/kaocha {:mvn/version "0.0-529"} }}' -Spom

nix shell ../..#mvn2nix --command mvn2nix -v --repositories https://clojars.org/repo https://repo1.maven.org/maven2 > mvn2nix-lock.json
```
