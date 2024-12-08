(ns day08
  (:require [clojure.string :as str]))


(def sample "............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
")

(defn parse-input [input]
  (let [lines (str/split-lines (str/trim input))]
    (->>
     (map-indexed (fn [y row] (map-indexed (fn [x c]
                                             [[x y] c]) row)) lines)
     (apply concat)
     (into {})
     )))

(def grid (parse-input sample))

grid
(defn freqs [grid]
  (->>
   grid
   (filter (fn [[k v]] (not= v \.)))
   (sort-by (fn [[k v]] v))
   (partition-by (fn [[k v]] v))
   ))
(def antennas (last (freqs grid)))


(defn pairs [antennas]
  (for [x antennas y antennas :when (not= x y)]
    [x y]))

                                        ;(pairs antennas)


(defn antinode [[x1 y1] [x2 y2]]
  [(+ x2 (- x2 x1))
   (+ y2 (- y2 y1))])


(prn "XXX")

(defn antinodes [antennas]
  (->>
   (pairs antennas)

   (map (fn [[[coor1 _] [coor2 -]]] (antinode coor1 coor2)))
                                        ;(first) (map first) (apply antinode)
   ))
                                        ;(antinodes antennas)

(def input (slurp "src/input08"))
(let [ grid (parse-input input)
      fs (freqs grid)
      ]

  (->>
   fs
   (map antinodes)
                                        ;(prn)
   (apply concat)
                                        ;(into {})
   (filter grid)
   (sort)
                                        ;(into {})

                                        ;(map prn)
   (into #{})
   (count)
   )
  )
;; => 348



(defn antinode2 [grid [x1 y1] [x2 y2] ret]
  (let [new [(+ x2 (- x2 x1)) (+ y2 (- y2 y1))]]
    (if (grid new) (recur grid [x2 y2] new (conj ret new ))
        ret)))
(antinode2 grid [0 0] [1 2] [])

(defn antinodes2 [grid antennas]
  (->>
   (pairs antennas)

   (map (fn [[[coor1 _] [coor2 _]]] (antinode2 grid coor1 coor2 [coor1 coor2])))
   (apply concat)
                                        ;(first) (map first) (apply antinode)
   ))

(defn solve-2 [input]
  (let [ grid (parse-input input)
        fs (freqs grid)
        ]

    (prn fs)
    (->>
     fs
     (map #(antinodes2 grid %))
     (apply concat)
     (filter grid)
     (sort)
     (into #{})
     (count)
     )))
(solve-2 input) 
;; => 1221
