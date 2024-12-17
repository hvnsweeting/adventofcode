(require '[clojure.string :as str])

(def sample "##########
#..O..O.O#
#......O.#
#.OO..O.O#
#..O@..O.#
#O#..O...#
#O..O..O.#
#.OO.O.OO#
#....O...#
##########

<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
>^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^"
)

(defn parse-input [s]
  (let [[whmap movements] (str/split s #"\n\n")
        grid (into {} (for [[y row] (map-indexed vector (str/split-lines whmap))
                   [x c] (map-indexed vector row)]
               [[x y] c]))
        moves (seq (str/join "" (str/split-lines movements)))

        ]
    
    [grid moves]

    )
  )

(defn direction [step]
  ({\< [-1 0]
    \> [1 0]
    \^ [0 -1]
    \v [0 1]} step))

(defn expand [grid point direct]
  (loop [
         p point
         boxes []
        ]
    (let [[x y] p
        next-coor (map + [x y] direct)
        next (find grid next-coor)
        [coor nc] next
          ]
    ;(prn point next direct)
      (cond
        (= nc \O) (recur next-coor (conj boxes p))
        (= nc \.) [ (conj boxes p)  \.]
        (= nc \#) [ (conj boxes p)  \#]
        :else (assert false))
      )))

  
(defn shift [dir point]
  ;(prn :shift dir point)
  (map + dir point))

(defn move [{grid :grid robot :robot} step]
  (let [
        [x y] robot
      maxx (apply max (map first (keys grid)))
      maxy (apply max (map second (keys grid)))

        ]
    ;(prn :move step)
  ;(draw grid [maxx maxy])
       (let [next-coor (map + (direction step) [x y])
                        next (grid next-coor)
                          ]
                    (cond (= next \#) {:grid grid :robot robot}
                          (= next \.) {:grid (->
                                       (assoc grid next-coor \@)
                                       (assoc [x y] \.))
                                       :robot next-coor
                                       }
                          (= next \O) (let [[ps c] (do
                                                     (expand grid next-coor (direction step)))
                                            shifted (for [i (map #(shift (direction step) %) ps)] [i \O])

                                            ]
                                        (if (= c \#) {:grid grid :robot robot}
                                            {:grid (merge grid (into {[x y] \. next-coor \@} shifted ))
                                             :robot next-coor
                                             }
                                             )
                                        )
                          :else (do (prn :wat next-coor next)
                                    (assert false)))
                          
                        

                      )
      )
    )


(defn draw [points [wide tall]]
  (let [m points]
    (doseq [i (range (inc tall))]
      (println (for [x (range (inc wide))]

                 (if (m [x i]) (m [x i]) "?")))
      )))

(def small-example "########
#..O.O.#
##@.O..#
#...O..#
#.#.O..#
#...O..#
#......#
########

<^^>>>vv<v>>v<<")

(def input (slurp "src/input15"))
(defn part1 [input]
(let [[grid moves] (parse-input input)
      maxx (apply max (map first (keys grid)))
      maxy (apply max (map second (keys grid)))
      ]
  grid
  
  (prn (repeat 20 "="))
  (prn moves)
  ;(move grid \<)

  (def robot (first (first (filter (fn [[k v]] (= v \@)) grid ))))
  (prn :robot robot)
  (def r (reduce move {:grid grid :robot robot} moves))
  ;(draw r [maxx maxy])
  (->> (for [[[x y] c] (:grid r) :when (= c \O)] [x y])
       ;(prn)
       (map (fn [[x y]] (+ x (* 100 y))))
       (reduce +)
       )))

(part1 input) 
;; => 1475249

;; => nil;; => Syntax error compiling at (src/day15.clj:158:1).
;;    Unable to resolve symbol: part1 in this context
(println small-example)
(defn parse-input-2 [s]
  (let [[whmap movements] (str/split s #"\n\n")
        evenx (for [[y row] (map-indexed vector (str/split-lines whmap))
                             [x c] (map-indexed vector row)]
                [[(* x 2) y] (if (= c \O) \[ c)]
                         
                         )
        oddx (map (fn [[[x y] c]]
                    (def nc (cond
                      (= c \[) \]
                      (= c \@) \.
                      :else c))
                    [[(+ x 1) y] nc]) evenx)

        grid (into {} (concat evenx oddx ))
        moves (seq (str/join "" (str/split-lines movements)))
        ]
    [grid moves]
    )
  )

(defn move2 [{grid :grid robot :robot} step]
  (let [
        [x y] robot
      maxx (apply max (map first (keys grid)))
      maxy (apply max (map second (keys grid)))

        ]
    ;(prn :move step)
  ;(draw grid [maxx maxy])
       (let [next-coor (map + (direction step) [x y])
                        next (grid next-coor)
                          ]
                    (cond (= next \#) {:grid grid :robot robot}
                          (= next \.) {:grid (->
                                       (assoc grid next-coor \@)
                                       (assoc [x y] \.))
                                       :robot next-coor
                                       }
                          (= next \O) (let [[ps c] (do
                                                     (expand grid next-coor (direction step)))
                                            shifted (for [i (map #(shift (direction step) %) ps)] [i \O])

                                            ]
                                        (if (= c \#) {:grid grid :robot robot}
                                            {:grid (merge grid (into {[x y] \. next-coor \@} shifted ))
                                             :robot next-coor
                                             }
                                             )
                                        )
                          :else (do (prn :wat next-coor next)
                                    (assert false)))
                          
                        

                      )
      )
    )

;; todo: change move and shift to adapt part 2
(def sample-2 "#######
#...#.#
#.....#
#..OO@#
#..O..#
#.....#
#######

<vv<<^^<<^^")
(let [[grid moves] (parse-input-2 sample-2)
      x (prn (sort (keys grid)) moves)
      maxx (apply max (map first (keys grid)))
      maxy (apply max (map second (keys grid)))
      ]
  (draw grid [maxx maxy]))
