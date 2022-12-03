(ns clj2022.core
  (:require [clojure.string :as string]))

(defn foo
  "I don't do a whole lot."
  [x]
  (println x "Hello, World!"))

(defn my-double
  [x]
  (* x 2))

; todo TEST aoc2021 1
(defn -main
  [& args]
  (foo 1))

(defn sumeach [x]
  (->> x
       (string/split-lines)
       (map #(Integer/parseInt %))
       (reduce +)))

(defn day01-1 [s]
  (->>
   (string/split s #"\n\n")
   (map sumeach)
   (apply max)))

(defn day01-2 [s]
  (->>
   (string/split s #"\n\n")
   (map sumeach)
   sort
   (take-last 3)
   (reduce +)))

(defn day02-1
  [input]
  (def handmap1 {"A X" 4, "A Y" 8, "A Z" 3,
                 "B X" 1, "B Y" 5, "B Z" 9,
                 "C X" 7, "C Y" 2, "C Z" 6})

  (->> input
       (string/split-lines)
       (map handmap1)
       (reduce +)))

(defn day02-2
  [input]
  (def handmap {"A X" (+ 0 3), "A Y" (+ 3 1), "A Z" (+ 6 2),
                "B X" (+ 0 1), "B Y" (+ 3 2), "B Z" (+ 6 3),
                "C X" (+ 0 2), "C Y" (+ 3 3), "C Z" (+ 6 1)})

  (->> input
       (string/split-lines)
       (map handmap)
       (reduce +)))
(day02-2 (slurp "src/clj2022/input02"))

(defn day03-1
  [input]

  (defn doeach [x]
    (let [[left right] (map set (partition (/ (count x) 2) x))]
      (def n (int (first (clojure.set/intersection left right))))
      (if (and (>= n (int \A)) (<= n (int \Z)))
        (+ 27 (- n (int \A)))
        (- (+ 1 n) (int \a)))))

  (->> input
       (string/split-lines)
       (map doeach)
       (reduce +)))
(day03-1 "vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw")
(day03-1 (slurp "src/clj2022/input03"))

(defn day03-2
  [input]

  (defn doeach [x]
    (let [[left mid right] (map set x)]
      (def n (int (first (clojure.set/intersection mid (clojure.set/intersection left right)))))
      (if (and (>= n (int \A)) (<= n (int \Z)))
        (+ 27 (- n (int \A)))
        (- (+ 1 n) (int \a)))))

  (->> input
       (string/split-lines)
       (partition 3)
       (map doeach)
       (reduce +)))
(day03-2 "vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw")
(day03-2 (slurp "src/clj2022/input03"))
