(require ['clojure.string :as 'str])
(require '[clojure.pprint :as pp])

(def sample "...#...
..#..#.
....#..
...#..#
..#..#.
.#..#..
#.#....")

(def input "5,4
4,2
4,5
3,0
2,1
6,3
2,4
1,5
0,6
3,3
2,6
5,1
1,2
5,5
2,5
6,5
1,4
0,4
6,4
1,1
6,1
1,0
0,5
1,6
2,0
6,1
")


(defn parse-topo [tmap]
  (let [lines (str/split-lines tmap)]
    (->>
     (map-indexed (fn [y row]
                    (map-indexed (fn [x c] [[x y] c]) row))
                  lines)
     (apply concat)
     (into {})

     )))

(def m (parse-topo sample))
m

(defn neighbors
  [topo [x y]]
  (->>
   [[(dec x) y] [(inc x) y] [x (inc y)] [x (dec y)]]
   (filter (fn [p] (not= (topo p) \#)))
   ))

(neighbors m [0 0])

(defn find-trail [topo start]
  (let [[x y] start
        todo (conj clojure.lang.PersistentQueue/EMPTY [[x y] 0])
        w (apply max (map (comp first key) topo))
        h (apply max (map (comp second key) topo))
        end [w h]
        ]
                                        ;(prn [[x y] v] visited todo ret)
    (if (empty? todo) 0
        (loop [
               queue todo
               visited #{}
               ]
          (let [[point dist] (peek queue)
                nbrs (for [p (neighbors topo point)
                           :let [[nx ny] p]
                           :when (and (>= nx 0) (<= nx w) (>= ny 0) (<= ny h) (not (visited [nx ny])))]
                       p)
                ]

                                        ;(prn :db point :dist dist); :nbrs nbrs :visited visited)
                                        ;(prn (count visited))
            (if (= point end) dist
                (recur (apply conj (pop queue) (map #(vector % (inc dist)) nbrs)) (into visited nbrs))))))))


(prn "FINDING trail")
(defn grid
  ([input n] (grid {'(70 70) \.} input n))
  ([basegrid input n] 

   (let [topo basegrid]
     (->>
      (str/split-lines input)
      (take n)
      (map (fn [line] [(map parse-long (str/split line #",")) \#]))
      (into topo)
      ))))
(defn part1 []
  (def topo {'(70 70) \.})
  (->>
   (str/split-lines input)
   (take 1024)
   (map (fn [line] [(map parse-long (str/split line #",")) \#]))
   (into topo)
   )

  (let [
        g (grid (slurp "src/input18") 1024)
        ]
                                        ;(prn g)
    (find-trail g [0 0])))
(part1) 
;; => 252;; => 252


;; part2


(let [
      input (slurp "src/input18")
      lines (str/split-lines input)
      ]
  (doseq [i (range 1024 (count lines ))]
    (let [g (grid input i)]
      (try
        (find-trail g [0 0])
        (catch Exception e
          (do (prn (nth lines (dec i)))
              (System/exit 0))
          )))))
