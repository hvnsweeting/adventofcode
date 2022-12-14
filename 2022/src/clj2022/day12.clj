(ns clj2022.day12
  (:require [clojure.string :as str])
  (:require [clojure.java.io :as io])
  (:require [clojure.set :as set]))

(defn dbg [x]
  (prn "debug" x)
  x)

(defn to_map [y acc [r & rest]]
  ;(println r rest)
   (if (nil? r) (merge acc)

       (do
         (def newacc (->>
                      (partition 2 (interleave (range (count r)) r))
                      (map #(hash-map [ (first %) y] (second %)))
                      (reduce merge)))

         (recur (+ y 1) (merge acc newacc) rest))))

(defn good? [tree visited point that]
  (and (contains? tree that)
       (not (contains? visited that))
       (or (= \E (tree that))
           (<= (- (int (get tree that)) (int (get tree point))) 1))
       ))

(defn neighbors [tree visited [x, y]]
  (let [ns [[(- x 1) y] [(+ x 1) y] [x (- y 1)] [x (+ y 1)] ]]
    (prn ns)
    (filter #(good? tree visited [x,y] %) ns)))

(defn bfs [start tree]
  (loop [ret []
         counter 0
         visited #{}
         queue (conj clojure.lang.PersistentList/EMPTY start)
         ]
    (if (seq queue)
      (let [node (peek queue)]
        (prn "VISITING" node (neighbors tree (conj visited node) node ))
        
        (if (= node \E)
          (do (prn "WIN")
              ret)
          ;(recur (conj ret (inc counter)) 0 #{} (pop queue))
          (recur ret 0 (conj visited node) (into (pop queue) (neighbors tree (conj visited node) node )))
          ))
    ret
      )))

(def sample "Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
")

(defn day12-1 [input]
  (def tree (->> (str/split-lines input)
       (to_map 0 {} )
    (dbg)
    ;(nth ins (- 1 %))
    ))
  (def tree2 (update tree [0 0] (fn [k] \a)))

  (neighbors tree2 #{} [0 0])
  (good? tree2 #{} [4 2] [5 2])
  (bfs [0 0] tree2)
  )

(day12-1 sample)
;(assert (= 13860 (day12-1 (slurp "src/clj2022/input12"))))
