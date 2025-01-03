(require '[clojure.string :as str])
(require '[clojure.pprint :as pp])
(require '[clojure.data.priority-map :refer [priority-map]])

(priority-map 1 2)
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
(def sample2 "#################
#...#...#...#..E#
#.#.#.#.#.#.#.#.#
#.#.#.#...#...#.#
#.#.#.#.###.#.#.#
#...#.#.#.....#.#
#.#.#.#.#.#####.#
#.#...#.#.#.....#
#.#.#####.#.###.#
#.#.#.......#...#
#.#.###.#####.###
#.#.#...#.....#.#
#.#.#.#####.###.#
#.#.#.........#.#
#.#.#.#########.#
#S#.............#
#################
")


(defn rotate-score [d o]
  (let [direct (direction d)
        other (direction o)]
    
    (cond (= (map + direct other) '(0 0)) 2000
          (= direct other) 1
          :else 1001)))

(rotate-score \> \<)
(rotate-score \> \>)
(rotate-score \> \^)



(defn vec-to-dir [v]
  ({[1 0] \>
    [-1 0] \<
    [0 1] \v
    [0 -1] \^} v)
  )

(defn neighbors [grid [[x y] direct]]
  (let [w (apply max (map (comp first key) grid))
        h (apply max (map (comp second key) grid))]
    (->>
     (for [[dx dy] [[1 0] [-1 0] [0 -1] [0 1]]
           :let [nx (+ x dx) ny (+ y dy)
                 ]
           :when (and (>= nx 0) (<= nx w) (>= ny 0) (<= ny h) (not= (grid [nx ny]) \#))
           ] 
       [[nx ny] (vec-to-dir [dx dy])])
     (map (fn [[coord dir]] [[coord dir] (rotate-score dir direct)]))
     (filter (fn [[_ s]] (< s 2000)))
     )))

(defn shortest-path [grid start]
  "Using dijkstra"
  (loop [q (priority-map start 0)
         cost {}
         prevs {}
         ]
    (let [[p dist] (peek q)
          nbrs (neighbors grid p)
                                        ;x (prn :debug :nbrs nbrs)
          nb-costs (->>
                    (map (fn [[p c]] [p (+ c dist)]) nbrs)
                    (filter (fn [[p c]] (<= c (cost p 9999999999999) )))
                    (into {})
                    )
                                        ;x (prn :debug p :nbcost nb-costs)
          new-costs (merge cost nb-costs)
          new-q (apply conj (pop q) nb-costs)
          new-prevs (merge prevs (into {} (for [n (keys nb-costs)
                                                :let [v (prevs n)]
                                                ]
                                            [n (if (nil? v) [p] (conj v p))]
                                            )))
          ]
      (if (empty? new-q) [cost new-prevs]
          (recur new-q new-costs new-prevs)))))

(defn travel-path [prevs end start]
  (loop [
         q [end]
         visited #{end}
         ]
    (let [p (peek q)
          nbrs (prevs p)
                                        ;_ (prn p :nbrs nbrs)
          new-q (apply conj (pop q) (filter (fn [i] (not (visited i))) nbrs))
          new-visited (apply conj visited nbrs)
          ]
      (if (empty? new-q) (into #{} (map first new-visited))
          (recur new-q new-visited)))))


(defn draw [grid]
  (let [
        wide (apply max (map first (keys grid)))
        tall (apply max (map second (keys grid)))
        ]
    (doseq [i (range (inc tall))]
      (println (if (< i 10) (str i "  ") (str i " ")) (str/join (for [x (range (inc wide))]
                                                                  (if (grid [x i]) (grid [x i]) " "))))
      )))

(defn neighbors2 [grid point]
  (let [[x y] (point :coord)
        dir  (point :dir)
        w (apply max (map (comp first key) grid))
        h (apply max (map (comp second key) grid))
        ]
    (for [[dx dy] [[0 1] [0 -1] [1 0] [-1 0]]
          :let [nx (+ x dx)
                ny (+ y dy)
                ndir (vec-to-dir [dx dy])
                score (rotate-score ndir dir)
                ]
          :when (and (> nx 0) (< nx w) (> ny 0) (< ny h) (not= \# (grid [nx ny]))
                     (< score 2000)
                     )
          ]
      {:coord [nx ny]
       :dir ndir
       :score score}
      )))

(defn shortest-path2
  [grid start ]
  "Using dijkstra"
  (loop [q (priority-map start 0)
         cost {}
                                        ;prevs {}
         ]
    (let [[p dist] (peek q)
          _ (prn :p p)
          nbrs (neighbors2 grid p)
                                        x (prn :debug :nbrs nbrs)
          nb-costs (->>
                    (map (fn [p] (update p :score (+ dist))) nbrs)
                    (filter (fn [p] (<= (p :score) (cost (p :coord) 9999999999999) )))
                    (into {})
                    )
                                        ;x (prn :debug p :nbcost nb-costs)
          new-costs (merge cost nb-costs)
          new-q (apply conj (pop q) nb-costs)
                                        ;new-prevs (merge prevs (into {} (for [n (keys nb-costs)
                                        ;                                      :let [v (prevs n)]
                                        ;                                      ]
                                        ;                                  [n (if (nil? v) [p] (conj v p))]
                                        ;                                  )))
          ]
      (if (empty? new-q) cost ;[cost new-prevs]
          (recur new-q new-costs )))))
)

(let [
                                        ;grid (parse-input (slurp "src/input16"))
      grid (parse-input sample)
      ]
(neighbors2 grid {:coord [1 1]
                  :dir \>
                  :score 0})
(def start [{:coord (first (first (filter (fn [[k v]] (= v \S)) grid)))
             :dir \>
             :score 0}])
(let [m (shortest-path2 grid start)]
  (prn m)))

(let [
      grid (parse-input (slurp "src/input16"))
      grid (parse-input sample)
      grid (parse-input sample2)
      ]

(def start [(first (first (filter (fn [[k v]] (= v \S)) grid))) \> 0])
(let [m (shortest-path grid start)
      [costs prevs] m
      ends (filter (fn [[k v]] (= (grid k) \E)) (keys prevs))
      ends (filter (fn [[[k v] c]] (= (grid k) \E)) costs)
      _ (prn :ends ends)
      [end _cost] (first (sort-by val ends))
      _ (prn :ends ends :end end)

      ]
                                        ;(pp/pprint (sort prevs))
  (let [tiles (into {} (map #(vector % \O) (travel-path prevs end start)))]
    (draw tiles)
    (count tiles)
    )
  ))

;; => 520
;; => 520
;; => Syntax error reading source at (REPL:128:8).
;;    Unmatched delimiter: ]
