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
(defn parse-line [decryption-key line]

  (* decryption-key (parse-long line)))

(defn makemap [start]
  (loop [[k v & rest :as all] start
         states {}]
    (if (nil? v) (assoc states k (first start))
        (recur (drop 1 all) (assoc states k v)))))
(defn revmap [m]
  (->>
   (map #(into [] %) (partition 2 (interleave (vals m) (keys m))))
   (into {})))

(defn nth' [m from steps]
  (def s (rem steps (count m)))
  (def n (if (< s 0) (- (count m) (abs s) 1)
             s))
  ;(prn "STEPS" steps "real n" n "m" m "from" from)
  (nth (iterate m from) n))

(defn visit [m from steps]
  (def s (rem steps (dec (count m))))
  (def n (if (< s 0) (- (count m) (abs s) 1)
             s))
  ;(prn "STEPS" steps "real n" n)
  (nth (iterate m from) n))

(defn mix [[x & rest] m]
  (if (nil? x) m
      (do
    ;(prn "mix" x (take (count m) (iterate m p0)))
        (def before (revmap m))
        (let [[_idx v] x]
          (if (= 0 (rem v (dec (count m)))) (recur rest m)
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

(defn day20-2 [input]
  (def decryption-key 1)
  (def decryption-key 811589153)
  (def links (->>
              (str/split-lines input)
              (map #(parse-line decryption-key %))
              ;(dbg)
              (map-indexed vector)))
  (def m (makemap links))

  (do
    (def p0 [4094 0])
    (def r (nth (iterate #(mix links %) m) 10))
    ;(prn "RES" (map second (take (count links) (iterate r p0))))
    ;(prn "map" r)

    (->> (map second [(nth' r  p0 1000)
                      (nth' r p0 2000)
                      (nth' r p0 3000)])
         (dbg)
         (reduce +))))

(day20-2 sample)

(= 7865110481723 (day20-2 (slurp "src/clj2022/input20")))
