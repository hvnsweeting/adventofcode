(require '[clojure.string :as str])

(defn parse-input [s]
  
  (into {} (for [[y row] (map-indexed vector (str/split-lines s))
                 [x c] (map-indexed vector row)]
             [[x y] c]))

  )

(defn direction [step]
  ({\< [-1 0]
    \> [1 0]
    \^ [0 -1]
    \v [0 1]} step))

(defn draw [grid]
  (let [
      wide (apply max (map first (keys grid)))
      tall (apply max (map second (keys grid)))
        ]
    (doseq [i (range (inc tall))]
      (println (str/join (for [x (range (inc wide))]
                 (if (grid [x i]) (grid [x i]) "?"))))
      )))


(def sample "###############
#.......#....E#
#.#.###.#.###.#
#.....#.#...#.#
#.###.#####.#.#
#.#.#.......#.#
#.#.#####.###.#
#...........#.#
###.#.#####.#.#
#...#.....#.#.#
#.#.#.###.#.#.#
#.....#...#.#.#
#.###.#.#.#.#.#
#S..#.....#...#
###############
")

(defn rotate-score [d o]
  (let [direct (direction d)
        other (direction o)]
  
  (cond (= (map + direct other) '(0 0)) 2000
        (= direct other) 1
        :else 1000)))

(rotate-score \> \<)
(rotate-score \> \>)
(rotate-score \> \^)
      


(defn vec-to-dir [v]
  ({[1 0] \>
    [-1 0] \<
    [0 1] \v
    [0 -1] \^} v)
  )

(defn neighbors [grid [[[x y] c] direct]]
  (->>
   (map (fn [[xi yi]]
          [(map + [xi yi] [x y]) (vec-to-dir [xi yi])])
        [[1 0] [-1 0] [0 -1] [0 1]])
   (map (fn [[coord dir]] [(find grid coord) dir (rotate-score dir direct)]))
   (filter #(identity (first %)))
   (filter (fn [[[_ c] _ _]] (not= c \# )))
   ))


(let [grid (parse-input sample)
      scores (into {} (map (fn [p] [p 0]) grid))
      ]
  scores
  (prn :neighbors (neighbors grid [[[1 1] \.] \>]))

  (def start [(first (filter (fn [[k v]] (= v \S)) grid)) \> 0])


  (loop [
         ss scores
         direct \>
         queue [start]
         ts 0

         visited #{}
         ]
    
    (if (empty? queue) ss

        (let [
              next (peek queue)
              [p d s] next
              newqueue (pop queue)
              ns (filter (fn [[p d s]] (nil? (visited [p d]))) (neighbors grid next))
              ]
          
        (prn :dir direct :check next :score newscore :ns ns)
        (recur (update ss p #(if (< newscore %)
                               newscore
                               %))
               d
               (vec (concat newqueue ns))
               newscore

               (conj visited [p d]))


          )


        )
    )

  )
