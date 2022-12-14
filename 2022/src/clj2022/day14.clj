(ns clj2022.day14
  (:require [clojure.string :as str])
  (:require [clojure.java.io :as io])
  (:require [clojure.set :as set]))

(defn dbg [& x]
  (prn "debug" x)
  x)

(defn to-point [s]
  (map parse-long (str/split s #","))
  )

(defn make-range [y1 y2]
  (if (< y1 y2) (range y1 (+ 1 y2))
      (range y2 (inc y1))
      )
  )

(make-range 3 5)

(defn fill-points [[[x1 y1] [x2 y2]]]
  (->>
   (cond
     (= x1 x2) (interleave (repeat x1) (make-range y1 y2))
     (= y1 y2) (interleave (make-range x1 x2) (repeat y1))
     :else (do (prn "NO HERE") '()))
   (partition 2)
  ))


(defn parse-line [s]
  (let [x (->>
           (str/split s #" -> ")
           (map to-point)
           )]
    (->>
     
     (map fill-points (filter #(= 2 (count %)) (partition 2 (interleave x (rest x)))))
     ))
  )

(defn falling [ymax pmap restsand]
  (loop [
         [x y] [500 0]
         ret #{}
         ]

    (if (> y ymax)
      restsand
      (let [newpoint [x (inc y)]]
        

        )
      (recur [x (inc y)])
      )
    )

  )
(defn day14-1 [input]
  (def ps (apply concat (apply concat
                               (->> (str/split-lines input)

                                        ; convert to line
                                        ; build map of points
                                        ; simulate the fall
                                    (map parse-line)

                                        ;(dbg)
                                    )


                               )))
  (def pmap (into #{} (map #(into [] %) ps)))
  (let [[_ ymax] (last (sort-by (fn [[_ y]] y) pmap))]
    (println ymax pmap)
    (falling ymax pmap #{})
    ))


(def sample "498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9
")

(day14-1 sample)
