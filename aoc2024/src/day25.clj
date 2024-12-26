(require '[clojure.string :as str])

(def sample "#####
.####
.####
.####
.#.#.
.#...
.....

#####
##.##
.#.##
...##
...#.
...#.
.....

.....
#....
#....
#...#
#.#.#
#.###
#####

.....
.....
#.#..
###..
###.#
###.#
#####

.....
.....
.....
#....
#.#..
#.#.#
#####")


(def schematics (str/split sample #"\n\n"))

(defn parse-line [s]
  (map #(if (= % \#) 1 0) s))

(defn schem-to-heights [lines]
  (->>
   lines
   (map parse-line)
   (apply map +)
   (map #(- % 1))
   )
  )

(defn parse-schem [schem]
                                        ;(println schem)
  
  (let [lines (str/split-lines schem)
        top (first lines)
        bot (last lines)
        type (if (= top "#####") :lock :key)
        ]
    {:t type
     :h (schem-to-heights lines)}

    ))


(def schematics (str/split (slurp "src/input25") #"\n\n"))
(let [[locks keys] (->> schematics
                        (map parse-schem)
                        (sort-by :t)
                        (partition-by :t)) ]
  (->>
   (for [k keys
         l locks
         ]
     [(k :h) (l :h)])
   (map (fn [[k l]] (map + k l)))
   (filter (fn [ns] (every? #(< % 6) ns)))
   (count)
   )
  )
;; => 3133

