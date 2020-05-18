(ns app.main
  (:require [reagent.dom :as rd]))

(defn hallo []
  [:p "Hallo Welt"])

(defn ^:export main! []
  (rd/render [hallo]
             (js/document.getElementById "app")))
