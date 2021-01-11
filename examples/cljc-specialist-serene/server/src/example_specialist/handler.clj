(ns example-specialist.handler
  (:require [compojure.core :refer :all]
            [compojure.route :as route]
            [ring.middleware.json :refer [wrap-json-response wrap-json-body]]
            [ring.util.response :refer [response]]
            [example-specialist.hello-world :as hello]))

(defroutes app-routes
  (GET "/" [] "Try the /graphql endpoint :)")
  (POST "/graphql" req
    (response (hello/graphql (:body req))))
  (route/not-found "Not Found"))

(def app
  (-> app-routes
   (wrap-json-response)
   (wrap-json-body {:keywords? true :bigdecimals? true})))
