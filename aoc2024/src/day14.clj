(require '[clojure.string :as str])

(def point {:loc [2 4]
            :velocity [2 -3]})
(def wide 101)
(def tall 103)
(defn move [point _sec]
  
  (let [;[wide tall] [11 7]
        [maxx maxy] [wide tall]
        [x y] (point :loc)
        [vx vy :as v] (point :velocity)
        [nx ny] [(+ x vx) (+ y vy)]
        newx (cond
               (>= nx maxx) (rem nx maxx)
               (< nx 0) (rem (+ nx maxx) maxx)
               :else nx
               )
        newy (cond
               (>= ny maxy) (rem ny maxy)
               (< ny 0) (rem (+ ny maxy) maxy)
               :else ny
               )
        ]

    {:loc [newx newy]
     :velocity v}
    ))

(prn point)

(defn movepoint [point n]
  (reduce move point (range n))
  )
;; => {:loc [2 4], :velocity [2 -3]}
;; => {:loc [6 -2], :velocity [2 -3]}
(def sample "p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3

(defn parse-input [input]
p=9,5 v=-3,-3")

(defn line-to-point [line]
  (let [[x y vx vy]
        (->>
         (rest (re-find #"p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)" line))
         (map parse-long)
         )]
    {:loc [x y]
     :velocity [vx vy]}
    ))


(defn parse-input [input]
  (->>
   (str/split-lines input)
   (map line-to-point)

   ))

(defn count-quadrants [points [wide tall]]
  (let [[wide tall] [wide tall]
        q1 (filter (fn [{[x y] :loc}] (and (< x (quot wide 2))
                                           (< y (quot tall 2)))) points)
        q2 (filter (fn [{[x y] :loc}] (and (> x (quot wide 2))
                                           (< y (quot tall 2)))) points)
        q3 (filter (fn [{[x y] :loc}] (and (> x (quot wide 2))
                                           (> y (quot tall 2)))) points)
        q4 (filter (fn [{[x y] :loc}] (and (< x (quot wide 2))
                                           (> y (quot tall 2)))) points)
        
        ]
    [q1 q2 q3 q4]
    )
  )

(defn part1 [input]
  (def points (parse-input input))

  (def moved 
    (->> points
         (map #(movepoint % 100))))
  
  ;; => #'user/count-quadrants;; => #'user/count-quadrants
  (let [[q1 q2 q3 q4] (count-quadrants moved [wide tall])]
    (apply * (map count [q1 q2 q3 q4])))
  )
(part1 (slurp "src/input14"))
;; => 231221760;; => 231221760


(defn draw [points [wide tall]]
  (let [m (into #{} (map :loc points))]
    (doseq [i (range tall)]
      (println (for [x (range wide)]
                 (if (m [x i]) "X" " ")))
      )))

(defn find-tree[points [wide tall] i]

  (let [m (into #{} (map :loc points))]
    (doseq [j (range tall)]
      (if (>
           (count (for [x (range wide) :when (m [x j])]
                    [x]))
           20)
        (do (println :dbg i (repeat 20 "*"))
            (draw points [wide tall]))
        
        ))))

(defn part2 [input]
  (def points (parse-input input))
  (def cache {})

  (doseq [i (range 1 (* wide tall))]
    (def points (map #(move % 1) points))
    (find-tree points [wide tall] i)
                                        ;(Thread/sleep 300)
    ))

(part2 (slurp "src/input14"))
