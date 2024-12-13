(require '[clojure.string :as str])

(defn find-options [Ax Ay Bx By X Y]
  (for [ax (range (inc (quot X Ax)))
        bx (range (inc (quot X Bx)))

        ;y (range (inc (quot Y dy)))
        :when (and (= (+ (* ax Ax) (* bx Bx)) X)
                   (= (+ (* ax Ay) (* bx By)) Y))
        ]
    [ax bx]
    ; (+ (* x dx) (* y dy))
    )
  ;[x y])
  )

(defn find-options-2 [Ax Ay Bx By X Y]
  (let [
        X (+ 10000000000000 X)
        Y (+ 10000000000000 Y)
        x (/ (- (* By X) (* Y Bx) )
             (- (* Ax By) (* Bx Ay)))
        y (/ (- X (* x Ax)) Bx)
        ]
    (if (and (int? x) (int? y)) [[x y]]
      [])
    )
  )

(let [X 8400
      Ax 94
      Bx 22
      Ay 34
      By 67
      Y 5400
      ]
  (find-options-2 Ax Ay Bx By X Y))

(def s "Button A: X+94, Y+34
       Button B: X+22, Y+67
       Prize: X=8400, Y=5400")

(defn parse-input [puzzle]
  (re-find #"Button A: X\+([0-9]+), Y\+([0-9]+) Button B: X\+([0-9]+), Y\+([0-9]+) Prize: X=([0-9]+), Y=([0-9]+)"
           puzzle))

(def s "Button A: X+69, Y+23
       Button B: X+27, Y+71
       Prize: X=18641, Y=10279")
(def s "Button A: X+17, Y+86
       Button B: X+84, Y+37
       Prize: X=7870, Y=6450")

(defn dbg [x]
  (prn x)
  x)

(defn find-best [s f]
  (let [[_ & rest] (parse-input (str/join " " (str/split-lines s)) )
        ]
    (->>
      (map parse-long rest)
      (apply f)
      (map (fn [[x y]] (+ (* x 3) y)))
      (min)
      )
    ))

(->>
  (str/split
    (slurp "src/input13")
    #"\n\n")
  (map #(find-best % find-options))
  (flatten)
  (reduce +)
  )
;; => 34393

(->>
  (str/split
    (slurp "src/input13")
    #"\n\n")
  (map #(find-best % find-options-2))
  (flatten)
  (reduce +)
  (prn)
  )
;; => 83551068361379
