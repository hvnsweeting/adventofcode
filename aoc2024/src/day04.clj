(ns day04
  (:require [clojure.string :as str]))


(def input (slurp "src/input04"))
(def s input)

(defn flat [[row [col c]]]
  [[row col] c])
(defn transform-line [[idx cs]]
  (let [nested (map vector (repeat idx) (map-indexed vector cs))]
    (map flat nested)))

(transform-line [0 "ABCD"])
(defn parse-input [input]
  (->> input
       (str/split-lines)
       (map-indexed vector)
       (map transform-line)
       (map #(into {} %))
       (apply merge)

       ))

(def s "MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
")
(def input s)
(parse-input s)
(defn find-word [word input]
  (def grid (parse-input input))
  (reduce (fn [ret coor]
            (let [[r c] coor
                  left-right (map grid [[r c] [r (inc c)] [r (inc (inc c))] [r (+ c 3)]])
                  right-left (map grid [[r c] [r (- c 1)] [r (- c 2)] [r (- c 3)]])
                  top-bot (map grid [[r c] [(+ r 1) c] [(+ r 2) c] [(+ r 3) c]])
                  bot-top (map grid [[r c] [(- r 1) c] [(- r 2) c] [(- r 3) c]])
                  diag2 (map grid [[r c] [(- r 1) (+ c 1)] [(- r 2) (+ c 2)] [(- r 3) (+ c 3)]])
                  diag4 (map grid [[r c] [(+ r 1) (+ c 1)] [(+ r 2) (+ c 2)] [(+ r 3) (+ c 3)]])
                  diag8 (map grid [[r c] [(+ r 1) (- c 1)] [(+ r 2) (- c 2)] [(+ r 3) (- c 3)]])
                  diag10 (map grid [[r c] [(- r 1) (- c 1)] [(- r 2) (- c 2)] [(- r 3) (- c 3)]])
                  ]
              (+ ret (count (filter #(= word %) [left-right right-left top-bot bot-top diag2 diag4 diag8 diag10])))

              )

            )
          0
          (for [row (range (count (str/split-lines input)))
                col (range (count (first (str/split-lines input))))]
            [row col]
            ))
                                        ;(reduce (fn [[row col] c] (prn [row col])) )
  )
(find-word '(\X \M \A \S) s)

(def input (slurp "src/input04"))
(find-word '(\X \M \A \S) input)
;; => 2685

(defn find-word-2 [word input]
  (def grid (parse-input input))
  (reduce (fn [ret coor]
            (let [[r c] coor
                  diag2 (map grid [[(+ 1 r) (- c 1)] [r c] [(- r 1) (+ c 1)]  ])
                  diag4 (map grid [[(- r 1) (- c 1)]  [r c] [(+ r 1) (+ c 1)]  ])
                  ]
              (if (#{[[\M \A \S] [\S \A \M]]
                        [[\M \A \S] [\M \A \S]]
                        [[\S \A \M] [\M \A \S]]
                        [[\S \A \M] [\S \A \M]]
                     } [diag2 diag4])
                (+ ret 1)
                ret
                )))
          0
          (for [row (range (count (str/split-lines input)))
                col (range (count (first (str/split-lines input))))]
            [row col]
            ))
                                        ;(reduce (fn [[row col] c] (prn [row col])) )
  )
(find-word-2 '(\X \M \A \S) s)
;; => 9
(find-word-2 '(\X \M \A \S) input)
;; => 2048
