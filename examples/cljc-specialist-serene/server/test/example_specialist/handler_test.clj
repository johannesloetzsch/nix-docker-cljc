(ns example-specialist.handler-test
  (:require [clojure.test :refer :all]
            [ring.mock.request :as mock]
            [example-specialist.handler :refer [app]]))

(deftest test-ring+compojure
  (testing "main route"
    (let [response (app (mock/request :get "/"))]
      (is (= (:status response) 200))
      (is (= (:body response) "Try the /graphql endpoint :)"))))

  (testing "not-found route"
    (let [response (app (mock/request :get "/invalid"))]
      (is (= (:status response) 404)))))
