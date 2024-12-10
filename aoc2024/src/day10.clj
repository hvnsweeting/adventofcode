(require ['clojure.string :as 'str])
(require '[clojure.pprint :as pp])

(def sample "0123
1234
8765
9876")

(def s2 "...0...
...1...
...2...
6543456
7.....7
8.....8
9.....9")

(defn parse-topo [tmap]
  (let [lines (str/split-lines tmap)]
    (->>
    (map-indexed (fn [y row]
                   (map-indexed (fn [x c] [[x y] (Character/digit c 10)])
                                (map (fn [v] (if (= v \.) -1 v)) row)))
                 lines) 
    (apply concat)
    (into {})

    )))

(def m (parse-topo sample))

(defn neighbors
  [topo [[x y] c]]
  (prn :neighbor [[x y] c])
  (->>
  (select-keys topo [[(dec x) y]
                 [(inc x) y]
                 [x (inc y)]
                 [x (dec y)]])
  (filter (fn [[coor v]] (= (- v c) 1)))
  ))

(neighbors m [[0 0] 0])
(defn find-trail [topo start]
  (loop [[[x y] v] start
         visited #{}
         todo (neighbors topo [[x y] v])
         ret #{}
         ]
    ;(prn [[x y] v] visited todo ret)
    (if (empty? todo) ret
        (let [[[coor p] & xs] todo

                  next [coor p]
                  visited (conj visited [x y])
                  todo (concat (or xs []) (neighbors topo [coor p]))
              ]
                  ;(prn :concat xs :neighbors topo [coor p])
          (if (= p 9)

            (recur next visited todo (conj ret coor))
            (recur next visited todo ret ))
          )

        )))
(prn "FINDING trail")
(find-trail m [[0 0] 0])

(find-trail (parse-topo s2) [[ 3 0] 0])

(def s3 "10..9..
2...8..
3...7..
4567654
...8..3
...9..2
.....01")
(def s3 "89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732")

(defn find-trailheads [topo]
  (filter (fn [[coor v]] (= v 0)) topo))
(def input (slurp "src/input10"))
(let [t3 (parse-topo input)
      ]
  (->>
  (find-trailheads t3)
  (map #(find-trail t3 %))
  (apply concat)
  (count)

  )) 
;; => Syntax error compiling at (day10.clj:87:10).
;;    Unable to resolve symbol: parse-topo in this context;; => Syntax error compiling at (day10.clj:87:10).
;;    Unable to resolve symbol: parse-topo in this context(defn find-trailheads [topo]
  
