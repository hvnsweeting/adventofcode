(ns clj2022.day22
  (:require [clojure.string :as str])
  (:require [clojure.java.io :as io])
  (:require [clojure.set :as set]))

(defn dbg [& [x]]
  (prn "debug" x)
  x)

(def sample "        ...#
        .#..
        #...
        ....
...#.......#
........#...
..#....#....
..........#.
        ...#....
        .....#..
        .#......
        ......#.

10R5L5R10L4R5L5
")
(defn parse-line [line]

  (parse-long line))

(defn build-board [lines]
  (loop [[line & rest] (str/split-lines lines)
         row 0
         board {}]

    (if (nil? line) board
        (->> (map-indexed vector line)
             (filter (fn [[idx v]] (not= v \space)))
             (map (fn [[x v]] [[row x] v]))
             (into {})
             (merge board)
             (recur rest (inc row))))))

(defn find-start [lines]
  (let [line (first (str/split-lines lines))]
    (->> (map-indexed vector line)
         (filter (fn [[idx v]] (not= v \space)))
         (map (fn [[x v]] [[0 x] v]))
         (first)
         (first))))

(defn print-board [board]
                                        ; todo
  )
(defn steps [path]
  (->>

   (identity (re-seq #"\d+|[RL]" path))
   (map  #(if (nil? (parse-long %)) % (parse-long %)))))

(steps "10R5L5R10L4R5L5")

(defn rotate [current r]
  (get {[">" "R"] "v",
        ["v" "R"] "<",
        ["<" "R"] "^",
        ["^" "R"] ">",
        [">" "L"] "^",
        ["v" "L"] ">",
        ["<" "L"] "v",
        ["^" "L"] "<"} [current r]))

(defn wrap [board [row col] direction]
  ;(prn "wrap from " [row col] direction)
  (cond
    (= direction ">")

    (let [[p v] (->> board
                     (filter (fn [[[r c] _]]  (= r row)))
                     (sort-by (fn [[[r c] _]] c))
                     (first))]

      (if (= v \#) [row col]
          p))

    (= direction "<")
    (let [[p v] (->> board
                     (filter (fn [[[r c] _]]  (= r row)))
                     (sort-by (fn [[[r c] _]] c))
                     (last))]

      (if (= v \#) [row col]
          p))
    (= direction "^")
    (let [[p v] (->> board
                     (filter (fn [[[r c] _]]  (= c col)))
                     (sort-by (fn [[[r c] _]] r))
                     (last))]

      (if (= v \#) [row col]
          p))
    (= direction "v")
    (let [[p v] (->> board
                     (filter (fn [[[r c] _]]  (= c col)))
                     (sort-by (fn [[[r c] _]] r))
                     ;(dbg)
                     (first))]

      (if (= v \#) [row col]
          p))))

(defn move-ahead [n direction from board]
  ;(prn "move-ahead" [n direction from ])
  (loop [n n
         [row col] from
         taken {}]
    (if (= n 0) [[row col] taken]
        (do

          (let [next-point (cond
                             (= direction ">") [row (inc col)]
                             (= direction "<") [row (dec col)]
                             (= direction "^") [(dec row) col]
                             (= direction "v") [(inc row) col])]

            (cond

              (and (contains? board next-point) (= \# (board next-point)))
              (recur (dec n) [row col] taken)
              (and (contains? board next-point) (= \. (board next-point)))
              (recur (dec n) next-point (assoc taken next-point direction))
              (not (contains? board next-point))
              (let [np (wrap board [row col] direction)]
                (recur (dec n) np (assoc taken np direction)))
                                        ;wrap around (= \. (second (board next-point)))
              ))))))
(defn move [board steps start]
  (loop [[step & tail] steps
         current start
         direction ">"
         taken (assoc {} start direction)]
    ;(prn "Processing" step direction taken)

    (if (nil? step) [current direction taken]
        (cond
          (= step "R") (recur tail current (rotate direction "R") (assoc taken current (rotate direction "R")))
          (= step "L") (recur tail current (rotate direction "L") (assoc taken current (rotate direction "L")))
          :else (let [[current mah] (move-ahead step direction current board)]
                  (recur tail current direction (merge taken mah))))
                                        ; get next
                                        ;(recur tail current "R" (conj taken current))
        )))

(defn dscore [d]
  ; Facing is 0 for right (>), 1 for down (v), 2 for left (<), and 3 for up (^). 
  ({">" 0 "v" 1 "<" 2 "^" 3} d))
(defn day22-1 [input]
  (prn "STARTING day22-1")
  (let [[lines path] (str/split input #"\n\n")
        board (build-board lines)
        ss (steps path)
        start (find-start lines)]
    ;(println "board\n" board "\npath" path)
    ;(prn ss)
    (prn "start" start)

    (->>
     (let [[[row col] direction taken] (move board ss start)]
       (reduce +
               [(* 1000 (inc row)) (* 4 (inc col)) (dscore direction)])

       ; The final password is the sum of 1000 times the row, 4 times the column, and the facing.
       )
     (prn "RES"))
    ;(prn (wrap board start "<"))
    ))

(day22-1 sample)
(day22-1 (slurp "src/clj2022/input22"))
