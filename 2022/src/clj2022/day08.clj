(ns clj2022.day07
  (:require [clojure.string :as str])
  (:require [clojure.java.io :as io])
  (:require [clojure.set :as set]))

(defn to_map [y acc [r & rest]]
  ;(println r rest)
  (if (nil? r) (merge acc)

      (do
        (def newacc (->>
                     (partition 2 (interleave (range (count r)) r))
                     (map #(hash-map (list (first %) y) (Character/digit (second %) 10)))
                     (reduce merge)))

        (recur (+ y 1) (merge acc newacc) rest))))

(defn max-to [x y])
(defn visible? [table [x y]]
  ;(println "INVISIBLE", x, y (count table))
  (def wid 99)
  (if (or (= x 0)
          (= y 0)
          (= (+ 1 x) wid)
          (= (+ 1 y) wid))
    true

    (do
      (def v (table (list x y)))

      (or
       (< (apply max (map #(table (list % y)) (range 0 x))) (table (list x y)))
       (< (apply max (map #(table (list % y)) (range (+ 1 x) wid))) (table (list x y)))
       (< (apply max (map #(table (list x %)) (range 0 y))) (table (list x y)))
       (< (apply max (map #(table (list x %)) (range (+ 1 y) wid))) (table (list x y)))))))

(defn day08-1 [input]
  (def size (count (str/split-lines input)))
  
  (def table ;
    (->> input
         (str/split-lines)
         (map #(vec %))
         (to_map 0 {})))

  (->>

   (keys table)
   (sort-by #(first %))
   (filter #(visible? table %))
   (count)))

(defn calculate-score [[good bad]]
  (+ (count good)
     (if (empty? bad) 0
         1)))

(defn cansee [table [x y]]
  (def wid 99)
  ;(println "INVISIBLE", x, y (count table))
  (do
    (def v (table (list x y)))
    (if (or (= x 0)
            (= y 0)
            (= (+ 1 x) wid)
            (= (+ 1 y) wid) ; todo maybe not
            )
      0

      (->>
       [(split-with #(< % v) (reverse (map #(table (list % y)) (range 0 x))))
        (split-with #(< % v) (map #(table (list % y)) (range (+ 1 x) wid)))
        (split-with #(< % v) (reverse (map #(table (list x %)) (range 0 y))))
        (split-with #(< % v) (map #(table (list x %)) (range (+ 1 y) wid)))]
       (map calculate-score)
       (reduce *)))))

(defn day08-2 [input]
  (def size (count (str/split-lines input)))
  (def table (->> input
                  (str/split-lines)
                  (map #(vec %))
                  (to_map 0 {})))
  (->>
   (keys table)
   (map #(cansee table %))
   (reduce max)
   ))
(assert (= 1840 (day08-1 (slurp "src/clj2022/input08"))))
(assert (= 405769 (day08-2 (slurp "src/clj2022/input08"))))
