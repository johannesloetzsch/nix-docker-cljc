(ns example-specialist.hello-world
  (:require [clojure.spec.alpha :as s]
            [orchestra.core :refer [defn-spec]]
            [orchestra.spec.test :as st]
            [specialist-server.type :as t]
            [specialist-server.core :refer [executor]]))

(s/def ::hello-node (s/keys :req-un [::greeting ::happy]))

;; This will be included as a child node in resolver function below.
(defn-spec happy t/boolean
  "See if our greeting is happy or not."
  [node ::hello-node
   opt map?
   ctx map?
   info map?]
  (boolean (re-find #"!\s*$" (:greeting node))))

;; This is the (only) entry node in our graph.
(defn-spec hello ::hello-node
  "Basic example resolver."
  [node map?
   opt map?
   ctx (s/keys :opt-un [::name])
   info map?]
  (let [n (get opt :name "world!")]
    {:greeting (str "Hello " n)
     :happy #'happy}))

(s/def ::greeting t/string)
(s/def ::happy (t/resolver #'happy))
(s/def ::name (s/nilable (t/field t/string "Recipient of our greeting.")))

;;; Executor function
(def graphql (executor {:query {:hello #'hello}}))
