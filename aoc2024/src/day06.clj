(ns day06)

(require '[clojure.string :as str])
(def input (slurp "src/input06"))
(def sample "....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
")

(def s sample)


(defn parse-grid [input]
    (def lines (str/split-lines input))
    
  (->>
   lines
   (map-indexed (fn [y row]
                  (map-indexed (fn [x ch]
                                 [[x y] ch]) row)))
   (apply concat)
   (into {})
   ))

(def grid (parse-grid s))
grid

(defn next [grid [[x y] d]]
    ;(prn "AT" [x y] d)
  (cond
    (= d \^) (let [ahead (grid [x (dec y)])]
               (cond
                 (= ahead \.) [[x (dec y)] \^]
                 (= ahead \#) [[x y] \>]
                 (nil? ahead) [nil nil]
                 ))

    (= d \>) (let [new-coor [(inc x) y]
                   ahead (grid new-coor)
                   ]
               (cond
                 (nil? ahead) [nil nil]
                 (= ahead \.) [new-coor \>]
                 (= ahead \#) [[x y] \v]
                 ))
    (= d \v) (let [new-coor [x (inc y)]
                   ahead (grid new-coor)
                   ]
               (cond
                 (nil? ahead) [nil nil]
                 (= ahead \.) [new-coor \v]
                 (= ahead \#) [[x y] \<]
                 ))
    (= d \<) (let [new-coor [(dec x) y]
                   ahead (grid new-coor)
                   ]
               (cond
                 (nil? ahead) [nil nil]
                 (= ahead \.) [new-coor \<]
                 (= ahead \#) [[x y] \^]
                 ))
    ))

(def start (first (for [[k v] grid :when (#{\v \^ \> \<} v)] [k v])))

(next grid start)
;; => [[4 5] \^]


(next grid [[4 1] \^])
;; => [[4 1] \>]

(defn cal-pos [grid visited [[x y] c]]
    (let [[coor d] (next grid [[x y] c])]
      (if (nil? coor) (do
                        ;(prn "EXIT AT" [x y] c "NEXT IS" coor d)
                        visited)
            (recur grid (conj visited coor) [coor d]))))

(let [grid (parse-grid sample)
     cur (first (for [[k v] grid :when (#{\v \^ \> \<} v)] [k v]))
     new-grid (assoc grid (first cur) \.)
      visited (cal-pos new-grid #{} cur)]
  (count visited))
;; => 41

(comment
(let [grid (parse-grid input)
     cur (first (for [[k v] grid :when (#{\v \^ \> \<} v)] [k v]))
     new-grid (assoc grid (first cur) \.)
      visited (cal-pos new-grid #{} cur)]
  (prn "GRID SIZE" (count grid))
  (count visited))
;; => 5329
)
(defn cal-pos-until [grid visited [[x y] c] steps]
    (let [[coor d] (next grid [[x y] c])]
      (cond
        (> steps (count grid)) :loop
        (nil? coor) (do
                      ;(prn "EXIT AT" [x y] c "NEXT IS" coor d)
                      :noloop)
        :else (recur grid (conj visited coor) [coor d] (inc steps)))))

start
(cal-pos-until (assoc (assoc grid (first start) \.) [3 6] \#) #{} start 41)



(let [grid (parse-grid input)
     cur (first (for [[k v] grid :when (#{\v \^ \> \<} v)] [k v]))
      new-grid (assoc grid (first cur) \.)]
(def ps (keys (filter (fn [[coor d]] (= d \.)) (into [] new-grid))))
  (->>
   ps
   (map #(assoc new-grid % \#))
   (map #(cal-pos-until % #{} cur 0))
   (filter #(= :loop %))
   (count)
   ))


(comment
(let [grid (parse-grid sample)
     cur (first (for [[k v] grid :when (#{\v \^ \> \<} v)] [k v]))
     new-grid (assoc grid (first cur) \.)
      slots (filter (fn [[k v]] (= v \.)) (into [] new-grid))
      ]
  (->>
   slots
  (map #(assoc new-grid % \#))
  (prn)
  (map #(cal-pos-until % #{} cur 41))
  (filter (fn [v] (= v :loop)))
  )))
