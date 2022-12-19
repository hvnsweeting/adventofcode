(ns clj2022.day18
  (:require [clojure.string :as str])
  (:require [clojure.java.io :as io])
  (:require [clojure.set :as set]))

(defn dbg [& [x]]
  (prn "debug" x)
  x)

(defn parse-line [x]
  (map parse-long (str/split x #",")))

(defn diff [[a b]]
  (abs (- a b))
  )
(defn intersect? [p1 p2]
  (->>
   (interleave p1 p2)
   (partition 2)
   (map diff)
   (reduce +)
   (= 1)
   )
  )

(defn one-vs-all [one all]
  (def vs (->>
           (filter #(intersect? one %) all)
           ))
  {one vs}
  )

(defn day18-1 [input]
  (def cubes 
    (->>
     (str/split-lines input)
     (map parse-line)))


  ;(intersect (first cubes) (second cubes))
  (def sides (* 6 (count cubes)))
  (def connected (->>
                  (map #(one-vs-all % cubes) cubes)
                  (map vals)
                  (reduce concat)
                  (reduce concat)
                  (dbg)
                  ;(map dbg)
                  (count)

                  ))


  (- sides connected))
  

(def sample "2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5
"
  )
(day18-1 sample)
;(= 4320 (day18-1 (slurp "src/clj2022/input18")))

                                        ;(day18-2 sample)
                                        ;(day18-2 (slurp "src/clj2022/input10"))
