(ns day03
  (:require [clojure.string :as str]))


(def s "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))")
(def input (slurp "src/input03"))
(def s input)
(->>
 (re-seq #"mul\(([0-9]{1,3}),([0-9]{1,3})\)" s)
 (map rest)
 (map #(apply * (map parse-long %)))
 (reduce +)
 )
;; => 161289189
(defn parse-input [input]
  (->> input
       (re-seq #"(do\(\))|(don't\(\))|mul\(([0-9]{1,3}),([0-9]{1,3})\)")
       (map rest)
       (map #(remove nil? %))))

(defn multiply-captured-groups [groups]
  (apply * (map parse-long groups)))

(defn reducer [xs]
  (loop [ret 0
         active? true
         [x & rest] xs]
    (cond
      (nil? x) ret
      (= (first x) "don't()") (recur ret false rest)
      (= (first x) "do()") (recur ret true rest)
      :else
      (let [multiplied (multiply-captured-groups x)
            updated-ret (if active? (+ ret multiplied) ret)]
        (recur updated-ret active? rest)))))



(def s "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))")
(parse-input s)
;; => (("2" "4") ("don't()") ("5" "5") ("11" "8") ("do()") ("8" "5"))
(let [xs (parse-input input)]
  (reducer xs))
;; => 83595109
