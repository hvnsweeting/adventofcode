(ns clj2022.day09
  (:require [clojure.string :as str])
  (:require [clojure.java.io :as io])
  (:require [clojure.set :as set]))

(defn dbg [x]
  (prn "debug" x)
  x)

(defn calculate
  ([arg cntr x] (calculate arg cntr x '()))
  ([[i & rest] cntr x result]
   (cond
     (nil? i) (reverse result)
     (= i "noop") (recur rest (inc cntr) x (cons (list (inc cntr) x) result))
     :else
     (let [[ins v] (str/split i #" ")]
       (def newx (+ x (parse-long v)))
       (recur rest (+ 2 cntr) newx (concat (list (list (+ 2 cntr) x) (list (inc cntr) x)) result))))))

(defn day10-1 [input]
  (let [instructions (str/split-lines input)]
    (def ins (calculate instructions 0 1))
    ;(dbg ins)
    ;(nth ins (- 1 %))
    (->>
     (map #(nth ins (- % 1)) [20 60 100 140 180 220])
     (map #(apply * %))
     (apply +))))

(def sample "addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx -35
addx 1
addx 24
addx -19
addx 1
addx 16
addx -11
noop
noop
addx 21
addx -15
noop
noop
addx -3
addx 9
addx 1
addx -3
addx 8
addx 1
addx 5
noop
noop
noop
noop
noop
addx -36
noop
addx 1
addx 7
noop
noop
noop
addx 2
addx 6
noop
noop
noop
noop
noop
addx 1
noop
noop
addx 7
addx 1
noop
addx -13
addx 13
addx 7
noop
addx 1
addx -33
noop
noop
noop
addx 2
noop
noop
noop
addx 8
noop
addx -1
addx 2
addx 1
noop
addx 17
addx -9
addx 1
addx 1
addx -3
addx 11
noop
noop
addx 1
noop
addx 1
noop
noop
addx -13
addx -19
addx 1
addx 3
addx 26
addx -30
addx 12
addx -1
addx 3
addx 1
noop
noop
noop
addx -9
addx 18
addx 1
addx 2
noop
noop
addx 9
noop
noop
noop
addx -1
addx 2
addx -37
addx 1
addx 3
noop
addx 15
addx -21
addx 22
addx -6
addx 1
noop
addx 2
addx 1
noop
addx -10
noop
noop
addx 20
addx 1
addx 2
addx 2
addx -6
addx -11
noop
noop
noop
")
(day10-1 sample)
(assert (= 13860 (day10-1 (slurp "src/clj2022/input10"))))

(defn draw-one [[pos [cycle x]]]
  (if (nil? (#{(- x 1) x (+ x 1)} pos)) "." "#"))

(defn to-pixels [xs]
  (->>
   (map-indexed vector xs)
   (map draw-one)))

(defn day10-2 [input]
  (let [instructions (str/split-lines input)]
    (->>
     (calculate instructions 0 1)
     (partition 40)
     (map to-pixels)
     (map #(str/join "" %))
     (map println))))

(day10-2 sample)
(day10-2 (slurp "src/clj2022/input10"))
