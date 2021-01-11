(ns example-specialist.orchestra-test
  (:require [clojure.test :refer :all]
            [orchestra.spec.test :as st]
            [example-specialist.hello-world :refer [hello]]))

(deftest test-instrumentation
  (testing "call according to spec"
    (is (= (hello nil {:name "orchestra"} nil nil)
           {:greeting "Hello orchestra", :happy #'example-specialist.hello-world/happy})))

  (testing "call with wrong type without instrumentation"
    (is (= (hello nil {:name :orchestra} nil nil)
           {:greeting "Hello :orchestra", :happy #'example-specialist.hello-world/happy})))

  (st/instrument)
  (testing "call with wrong type after instrumentation"
    (is (thrown-with-msg? Exception #"Call to #'example-specialist.hello-world/hello did not conform to spec."
          (hello nil {:name :orchestra} nil nil)))))
