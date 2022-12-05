(ns clj2022.core
  (:require [clojure.string :as str])
  (:require [clojure.set :as set]))

(defn foo
  "I don't do a whole lot."
  [x]
  (println x "Hello, World!"))

(defn my-double
  [x]
  (* x 2))

; todo TEST aoc2021 
(defn -main
  [& args]
  (foo 1))

(defn sumeach [x]
  (->> x
       (str/split-lines)
       (map parse-long)
       (reduce +)))

(defn day01-1 [s]
  (->>
   (str/split s #"\n\n")
   (map sumeach)
   (apply max)))

(defn day01-2 [s]
  (->>
   (str/split s #"\n\n")
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
       (str/split-lines)
       (map handmap1)
       (reduce +)))

(defn day02-2
  [input]
  (def handmap {"A X" (+ 0 3), "A Y" (+ 3 1), "A Z" (+ 6 2),
                "B X" (+ 0 1), "B Y" (+ 3 2), "B Z" (+ 6 3),
                "C X" (+ 0 2), "C Y" (+ 3 3), "C Z" (+ 6 1)})

  (->> input
       (str/split-lines)
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
      (def n (first (set/intersection left right)))
      (day03score n)))

  (->> input
       (str/split-lines)
       (map doeach)
       (reduce +)))

(defn day03-2
  [input]

  (defn doeach [x]
    (-> (apply set/intersection (map set x))
        first
        day03score))

  (->> input
       (str/split-lines)
       (partition 3)
       (map doeach)
       (reduce +)))

(defn day04-1
  [input]
  (defn each [x]
    (let [[start_left end_left start_right end_right] (map parse-long (str/split x #"[^0-9]"))]

      (or (and (<= start_left start_right) (<= end_right end_left))
          (and (<= start_right start_left) (<= end_left end_right)))))

  (->> (str/split-lines input)
       (filter each)
       count))

(defn day04-2
  [input]
  (defn each [x]
    (let [[start_left end_left start_right end_right] (map parse-long (str/split x #"[^0-9]"))]
      (or (and (<= start_left start_right) (>= end_left end_right))
          (and (<= start_right start_left) (>= end_right end_left))
          (and (<= start_left start_right) (>= end_left start_right))
          (and (<= start_right start_left) (>= end_right start_left)))))

  (->> (str/split-lines input)
       (filter each)
       count))

;; DAY 05 ===========================
(defn day05-2
  [input]

  (defn to_map [xs]
    (let [[head & rest] xs]
      {(Character/digit head 10) (into [] (filter #(not= \space %) rest))}))

  (defn parse_stacks [start]

    (def lines (str/split-lines start))
    (->> lines
         (map #(take-nth 4 (drop 1 %)))
         (reverse)
         (apply interleave)
         (partition (count lines))
         (map to_map)
         (apply merge)))

  (defn get_number [xs]
    (->>
     xs
     (map parse-long)
     (filter some?)))

  (defn parse_command [xs]
    (->>
     (str/split-lines xs)
     (map #(str/split % #"[^0-9]"))
     (map get_number)))

  (defn move-one [stacks volume start target]
    (if (= 0 volume) stacks
        (let [new_row (drop-last volume (stacks start))
              value (take-last volume (stacks start))]
          (def newstacks (assoc stacks start new_row))
          (assoc newstacks target (concat (newstacks target) value)))))

  (defn move-one-p1 [stacks volume start target]
    (if (= 0 volume) stacks

        (let [new_row (pop (stacks start))
              value (last (stacks start))]
          (def newstacks (assoc stacks start new_row))
          (def r (assoc newstacks target (conj (newstacks target) value)))
          (move-one-p1 r (- volume 1) start target))))

  (defn run-cmd [stacks move]
    (let [[volume start target] move]
      (move-one stacks volume start target)))

  (defn do-move [stacks moves]
    (->> moves
         (reduce run-cmd stacks)))
  (defn get-top-chars [stacks]
    (->> stacks
         vec
         sort
         (map #(last (nth % 1)))
         (apply str)))

  (let [[ss, moves] (str/split input #"\n\n")]
    (let [stacks (parse_stacks ss)
          commands (parse_command moves)]
      (->>
       (do-move stacks commands)
       (get-top-chars)))))


;; day5 p1

(defn day05-1
  [input]

  (defn to_map [xs]
    (let [[head & rest] xs]
      {(Character/digit head 10) (into [] (filter #(not= \space %) rest))}))

  (defn parse_stacks [start]

    (def lines (str/split-lines start))
    (->> lines
         (map #(take-nth 4 (drop 1 %)))
         (reverse)
         (apply interleave)
         (partition (count lines))
         (map to_map)
         (apply merge)))

  (defn get_number [xs]
    (->>
     xs
     (map parse-long)
     (filter some?)))

  (defn parse_command [xs]
    (->>
     (str/split-lines xs)
     (map #(str/split % #"[^0-9]"))
     (map get_number)))

  (defn move-one-p1 [stacks volume start target]
    (if (= 0 volume) stacks

        (let [new_row (pop (stacks start))
              value (last (stacks start))]
          (def newstacks (assoc stacks start new_row))
          (def r (assoc newstacks target (conj (newstacks target) value)))
          (move-one-p1 r (- volume 1) start target))))

  (defn run-cmd [stacks move]
    (let [[volume start target] move]
      (move-one-p1 stacks volume start target)))

  (defn do-move [stacks moves]
    (->> moves
         (reduce run-cmd stacks)))
  (defn get-top-chars [stacks]
    (->> stacks
         vec
         sort
         (map #(last (nth % 1)))
         (apply str)))

  (let [[ss, moves] (str/split input #"\n\n")]
    (let [stacks (parse_stacks ss)
          commands (parse_command moves)]
      (->>
       (do-move stacks commands)
       (get-top-chars)))))
