(ns clj2022.day20
  (:require [clojure.string :as str])
  (:require [clojure.java.io :as io])
  (:require [clojure.set :as set]))

(defn dbg [& [x]]
  (prn "debug" x)
  x)

(def sample "1
2
-3
3
-2
0
4
")
(defn parse-line [line key]
  (* key (parse-long line)))

(defn makemap [start]
  (loop [[k v & rest :as all] start
         states {}]
    (if (nil? v) (assoc states k (first start))
        (recur (drop 1 all) (assoc states k v)))))
(defn revmap [m]
  (->>
   (map #(into [] %) (partition 2 (interleave (vals m) (keys m))))
   (into {})))

(defn visit [m from steps]
  (def s (rem steps (count m)))
  (def n (if (< s 0) (- (count m) (abs s) 1)
             s))
  (nth (iterate m from) n))

(defn mix [[x & rest] m]
  (if (nil? x) m
      (do
        (def before (revmap m))
        (let [[_idx v] x]
          (if (= 0 v) (recur rest m)
                                        ; x ---v----> y x
              (let [y (visit m x v)]
                                        ; beforex x afterx ... y after-y
                                        ; beforex afterx ... y x after-y
                                        ; x now point to after-y
                (def after (assoc m x (m y)))
                                        ; y now point to x
                (def after (assoc after y x))
                                        ; before-x now point to after-x
                (def after (assoc after (before x) (m x)))

                (recur rest after)))))))

(defn day20-1 [input]
  (def decrypt-key 811589153)
  (def links (->>
              (str/split-lines input)
              (map #(parse-line % decrypt-key))
              (dbg)
              (map-indexed vector)))
  (def m (makemap links))

  (do
    ;(def p0 [4094 0])
    (def p0 [5 0])
    ;(def r (mix links m))
    (def r2 (take 1 (iterate #(mix links %) m)))
    (prn r2)
    (def r (last r2))

    (->> (map second [(visit r p0 1000)
                      (visit r p0 2000)
                      (visit r p0 3000)])
         ;(reduce +)
         )))

(day20-1 sample)
;(assert (= 8372 (day20-1 (slurp "src/clj2022/input20"))
