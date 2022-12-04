(ns clj2022.core
  (:require [clojure.string :as string])
  (:require [clojure.set :as cset]))

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
       (map parse-long)
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

(defn day03score [x]
  (def n (int x))
  (+ 1 (if (and (>= n (int \A)) (<= n (int \Z)))
         (+ 26 (- n (int \A)))
         (- n (int \a)))))

(defn day03-1
  [input]

  (defn doeach [x]
    (let [[left right] (map set (partition (/ (count x) 2) x))]
      (def n (first (cset/intersection left right)))
      (day03score n)))

  (->> input
       (string/split-lines)
       (map doeach)
       (reduce +)))

(defn day03-2
  [input]

  (defn doeach [x]
    (-> (apply cset/intersection (map set x))
        first
        day03score))

  (->> input
       (string/split-lines)
       (partition 3)
       (map doeach)
       (reduce +)))

(defn day04-2
  [input]
  (->> (string/split input #" ")))

(day04-2 "
")

(defn day04-1
  [input]
  (defn each [x]
    (let [[left, right] (string/split x #",")]
      (let [[sl, el] (map parse-long (string/split left #"-"))
            [sr, er] (map parse-long (string/split right #"-"))]
        (or (and (<= sl sr) (>= el er))
            (and (<= sr sl) (>= er el))))))

  (->> (string/split-lines input)
       (filter each)
       count))

(defn day04-2
  [input]
  (defn each [x]
    (let [[left, right] (string/split x #",")]
      (let [[sl, el] (map #(Integer/parseInt %) (string/split left #"-"))
            [sr, er] (map #(Integer/parseInt %) (string/split right #"-"))]
        (or (and (<= sl sr) (>= el er))
            (and (<= sr sl) (>= er el))
            (and (<= sl sr) (>= el sr))
            (and (<= sr sl) (>= er sl))))))

  (->> (string/split-lines input)
       (filter each)
       count))
