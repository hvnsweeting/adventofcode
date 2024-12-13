(ns day12
  [:require [clojure.string :as str]
   [clojure.pprint :as pp]
   ])


(def x 10)   

(def sample "AAAA
BBCD
BBCC
EEEC")


(defn parse-input [input]
  (->>
   (for [[y row] (map-indexed vector (str/split-lines input))
         [x c] (map-indexed vector row)]
     [[x y] c])
   (into {}))

  )

(def grid (parse-input sample))
;; => {[2 2] \C,
;;     [0 0] \A,
;;     [1 0] \A,
;;     [2 3] \E,
;;     [3 3] \C,
;;     [1 1] \B,
;;     [3 0] \A,
;;     [1 3] \E,
;;     [0 3] \E,
;;     [0 2] \B,
;;     [2 0] \A,
;;     [3 1] \D,
;;     [2 1] \C,
;;     [1 2] \B,
;;     [3 2] \C,
;;     [0 1] \B}

(defn neighbors [grid [[x y] c :as all]]
  (if (nil? all) '()
      (->>
       [[0 1] [0 -1] [1 0] [-1 0]]
       (map (fn [[dx dy]] [(+ x dx) (+ y dy)]) )
       (filter #(= (grid %) c) )
       (map #(find grid %))
       )))

(defn partitions [grid]
  
  (loop [
         kvs (into [] grid)
         queue [(first kvs)]
         region '()
         ps []
         ]
                                        ;(pp/pprint {:kvs kvs :q queue :r region :ps ps })
    (if (and (empty? kvs) (= [nil] queue)) ps
        (let [
                                        ;[i & restq] queue
              [i & restq] queue
              new-kvs (remove #(= i %) kvs)
              updated-region (conj region i)

              ]
                                        ;(prn {:newkv new-kvs :i i :restq restq})
          (def updated-queue (vec (concat (neighbors (into {} new-kvs) i) restq)))
                                        ;updated-queue (concat (neighbors (into {} new-kvs) i) restq)
          (if (empty? updated-queue) (recur (rest new-kvs)
                                            [(first new-kvs)]
                                            '()
                                            (conj ps (into {} updated-region)))
              (recur new-kvs
                     updated-queue
                     updated-region ps))))))


(defn count-ext-bound [grid [[x y] c]]
  (->>
   [[0 1] [0 -1] [1 0] [-1 0]]
   (map (fn [[dx dy]] [(+ x dx) (+ y dy)]) )
   (filter #(not= (grid %) c) )
   (count)
   ))

(count-ext-bound grid [[0 0] \A])

(defn perimeter [grid region]
  (*
   (reduce +
           (map #(count-ext-bound grid %) region))
   (count region))

  )



(->> (partitions grid)
     (map #(perimeter grid %))
                                        ;(prn)
     (reduce +)
     )

(let [
      ex2 "RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE"
      grid (parse-input ex2)]
  (->> (partitions grid)
       (map #(perimeter grid %))
                                        ;(prn)
       (reduce +)
       )
  )
(defn part-1 []
  (let [
        grid (parse-input (slurp "src/input12"))]
    (->> (partitions grid)
         (map #(perimeter grid %))
                                        ;(prn)
         (reduce +)
         (prn)
         )
    ))
;; 1431440


(defn count-side [region]
  ;; display region in grid
  ;; go top to bottom count
  ;; get region top and bottom
  ;; go left to right count 
  (let [sorted (->> region keys (sort))
        miny (apply min (map second sorted))
        maxy (apply max (map second sorted))
        ]
    (map (fn [y]
           (filter (fn [[xi, yi]] (= yi y))
           )
    (range miny (inc maxy)))

    
                                        ;(sort-by (fn [[x y]] [x y]))
  ))

grid
(count-side (first (partitions grid)))
