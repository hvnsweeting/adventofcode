(ns clj2022.day13
  (:require [clojure.string :as str])
  (:require [clojure.java.io :as io])
  (:require [clojure.set :as set]))

(defn dbg [x]
  (prn "debug" x)
  x)

(defn to-pair [s]
  (let [[left, right] (str/split-lines s)]
    (map load-string [left, right])))

(defn cmp [[[l & rest1 :as left] [r & rest2 :as right]]]
  (cond (and (nil? l) (not (nil? r))) true
        (and (nil? r) (not (nil? l))) false
        (and (nil? l) (nil? r)) nil
        :else

        (cond
          (and (= (class l) (class r)) (= java.lang.Long (class l)))
          (cond
            (< l r) true
            (> l r) false
            :else (cmp [rest1 rest2]))
                                        ;
          (= java.lang.Long (class l)) (cmp [[l] r])
          (= java.lang.Long (class r)) (cmp [l [r]])

          :else (do
                  (first (filter boolean? [(cmp [l r])
                                           (cmp [rest1 rest2])]))))))

(assert (= true (cmp [[1,1,3,1,1] [1,1,5,1,1]])))
(assert (= false (cmp [[1,1,4,1,1] [1,1,3,1,1]])))

(assert (= false (cmp [[1,1,4,1,1] [1,1,3,1,1]])))
(assert (= true (cmp [[[1] [2 3 4]] [[1] 4]])))
(assert (= false (cmp [[[[]]] [[]]])))

(defn ordered? [xs]
  (let [[p1 p2] xs]
    (cmp [p1 p2])))

(defn day13-1 [input]
  (def orders (->>
               (str/split input #"\n\n")
               (map to-pair)
               (map ordered?)))

  (->>
   (partition 2 (interleave orders (range (count orders))))
   (filter #(first %))
   (map #(second %))
   (map inc)
   (reduce +)))
(defn mycompare [p1 p2]
  (let [v (cmp [p1 p2])]
    (cond
      (= v true) -1
      (= v false) 1
      :else 0)))

(defn day13-2 [input]
  (def orders (->> input
                   (str/split-lines)
                   (map load-string)
                   (filter #(not (nil? %)))))

  (def updated (conj orders [[2]] [[6]]))
  (let [sorted (into [] (sort mycompare updated))]
    (* (inc (.indexOf sorted [[2]]))
       (inc (.indexOf sorted [[6]])))))

(def sample "[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]

")
