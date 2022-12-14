(ns clj2022.day14
  (:require [clojure.string :as str])
  (:require [clojure.java.io :as io])
  (:require [clojure.set :as set]))

(defn dbg [& x]
  (prn "debug" x)
  x)

(defn to-point [s]
  (map parse-long (str/split s #",")))

(defn make-range [y1 y2]
  (if (< y1 y2) (range y1 (+ 1 y2))
      (range y2 (inc y1))))

(make-range 3 5)

(defn fill-points [[[x1 y1] [x2 y2]]]
  (->>
   (cond
     (= x1 x2) (interleave (repeat x1) (make-range y1 y2))
     (= y1 y2) (interleave (make-range x1 x2) (repeat y1))
     :else (do (prn "NO HERE") '()))
   (partition 2)))

(defn parse-line [s]
  (let [x (->>
           (str/split s #" -> ")
           (map to-point))]
    (->>

     (map fill-points (filter #(= 2 (count %)) (partition 2 (interleave x (rest x))))))))

(defn falling [ymax board]
  (loop [[x y] [500 0]
         m board
         ret #{}]
    ;(prn "check" [x y] "len" (count m) m)

    (if (> y ymax)
      ret
      ;else
      (if (contains? m [x (inc y)])
        (if (contains? m [(dec x) (inc y)])
          (if (contains? m [(inc x) (inc y)])
            (recur [500 0] (conj m [x y]) (conj ret [x y]))
            (recur [(inc x) (inc y)] m ret))
          (recur [(dec x) (inc y)] m ret))
        (recur [x (inc y)] m ret)))))

(defn day14-1 [input]
  (prn "START==============")
  (def ps (apply concat (apply concat
                               (->> (str/split-lines input)

                                        ; convert to line
                                        ; build map of points
                                        ; simulate the fall
                                    (map parse-line)

                                        ;(dbg)
                                    ))))
  (def pmap (into #{} (map #(into [] %) ps)))
  (let [[_ ymax] (last (sort-by (fn [[_ y]] y) pmap))]
    (println ymax pmap)
    (->>
     (falling ymax pmap)
     (count))))

(def sample "498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9
")

(day14-1 sample)
(day14-1 (slurp "src/clj2022/input14"))

(defn falling2 [floor board]
  (loop [[x y] [500 0]
         m board
         ret #{}]
    ;(prn floor "check" [x y] "len" (count m) (count ret))

    (if (= (inc y) floor) (recur [500 0] (conj m [x y]) (conj ret [x y]))
        (if (contains? m [x (inc y)])
          (if (contains? m [(dec x) (inc y)])
            (if (contains? m [(inc x) (inc y)])
              (if (contains? m [501 1]) (conj ret [500 0])
                  (recur [500 0] (conj m [x y]) (conj ret [x y])))
              (recur [(inc x) (inc y)] m ret))
            (recur [(dec x) (inc y)] m ret))
          (recur [x (inc y)] m ret)))))

(defn day14-2 [input]
  (def ps (apply concat (apply concat
                               (->> (str/split-lines input)
                                    (map parse-line)))))
  (def pmap (into #{} (map #(into [] %) ps)))
  (let [[_ ymax] (last (sort-by (fn [[_ y]] y) pmap))]

    (->> (falling2 (+ 2 ymax) pmap) (count))))

(day14-2 sample)
