(ns example-specialist.graphql-test
  (:require [clojure.test :refer :all]
            [example-specialist.hello-world :refer [graphql]]
            [ring.mock.request :as mock]
            [example-specialist.handler :refer [app]]))

(deftest test-graphql-local
  (testing "(graphql)"
    (is (= (graphql {:query "{hello {greeting}}"})
           {:data {:hello {:greeting "Hello world!"}}}))))

(deftest test-graphql-endpoint
  (testing "/graphql"
    (let [response (app (-> (mock/request :post "/graphql")
                            (mock/json-body {:query "{hello {greeting}}"})))]
      (is (= (:status response) 200))
      (is (= (:body response)
             "{\"data\":{\"hello\":{\"greeting\":\"Hello world!\"}}}")))))
