; TODO learn regex parsing
; TODO learn do loop
; TODO learn all hashmap functions
; TODO learn recur
(ns clj2022.day06
  (:require [clojure.string :as str])
  (:require [clojure.set :as set]))

(defn find-start-of-packet [[a b c d & rest :as all] counter]
  (if (= 4 (count (set [a b c d])))
    (+ counter 4)
    (recur (drop 1 all) (inc counter))))

(defn find-start-of-message-marker [[a b c d e f g h i j k l m n & rest :as all] counter]
  (if (= 14 (count (set [a b c d e f g h i j k l m n])))
    (+ counter 14)
    (recur (drop 1 all) (inc counter))))

(defn day06-1 [input]
  (find-start-of-packet input 0))

(defn day06-2 [input]
  (find-start-of-message-marker input 0))
