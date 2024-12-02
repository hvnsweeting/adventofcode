(ns day02
 (:require [clojure.string :as str]))

(def s "7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9")

(def input (slurp "src/input02"))

(defn is-safe? [[x & rest :as xs]]
  (cond
    (> x 0) (every? #(and (>= % 1) (<= % 3)) xs)
    (< x 0) (every? #(and (>= % -3) (<= % -1)) xs)
    :else false
    )
  )
(assert (= true (is-safe? [1 2 3 1])))
;; => true

(defn parse-report [report]
  (mapv parse-long (str/split report #"\s+")))

(defn lvl-diff [lvls]
  (map - lvls (rest lvls)))

(defn count-safe-reports [lines]
  (->> lines
       (map parse-report)
       (map check-report)
       (filter identity)
       (count)))

(let [lines (str/split-lines input)]
  (println (count-safe-reports lines)))
;; => 502

(def report  [1 2 7 8 9])
(check-report report)

(defn vec-remove [pos coll]
  (vec (concat (subvec coll 0 pos) (subvec coll (inc pos)))))

;; Check if removing any element from the report results in a safe report
(defn check-report-2
  [report]
  (some true? (map #(check-report (vec-remove % report)) (range (count report)))))

(defn count-safe-modified-reports [lines]
  (->> lines
       (map parse-report)
       (map check-report-2)
       (filter true?)
       (count)))

(let [lines (str/split-lines input)]
  (println (count-safe-modified-reports lines)))
;; => 544
