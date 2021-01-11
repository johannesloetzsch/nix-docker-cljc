(defproject example-specialist "0.1.0-SNAPSHOT"
  :description "an example server using specialist"
  :min-lein-version "2.0.0"
  :dependencies [[org.clojure/clojure "1.10.0"]
                 [orchestra "2021.01.01-1"]
                 [compojure "1.6.1"]
                 [ring/ring-json "0.4.0"]
                 [ajk/specialist-server "0.6.0"]]
  :plugins [[lein-ring "0.12.5"]]
  :ring {:handler example-specialist.handler/app}
  :profiles
  {:dev {:dependencies [[javax.servlet/servlet-api "2.5"]
                        [ring/ring-mock "0.3.2"]]}})
