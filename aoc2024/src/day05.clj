(ns day05
  (:require [clojure.string :as str]))


(def input (slurp "src/input05"))
(def s input)
(def s "
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47")

(defn parse-input [input]
  (let [[orders updates] (-> input (str/trim) (str/split #"\n\n"))]
    [
     (into #{} (-> orders (str/split-lines)))
     (->> updates (str/split-lines) (map #(str/split % #",")))

     ]

    ))

(def line ["75" "47" "61" "53" "29"])
(for [x line
      y line :while (not= x y)]
     [x y])
  
(defn gen-order [ret 
                 line]
  (let [[x & xs] line

        new-orders (for [i xs] (format "%s|%s" x i))
        ]
    (if (nil? xs) (into #{} ret)
    (recur (concat ret new-orders) xs))
  ))
(def ods (gen-order [] line))

(defn get-mid [ns]
(nth ns (unchecked-divide-int (count ns) 2)))
(defn solve1 [input]
(let [[orders updates] (parse-input input)]
  (->>
  (filter #(clojure.set/subset? (gen-order [] %) orders) updates)
  ;(prn)
  (map get-mid)
  (map parse-long)
  (reduce +)
  )
  )
  )

(solve1 input)
;; => 143
(def unordline [75,97,47,61,53])
(def orders (first (parse-input input)))
(defn compare [a b]
  (let [ret (cond
    (= a b) 0
    (orders (format "%s|%s" a b)) 1
    :else -1)]
    ret))
(sort compare unordline)
  
(defn solve2 [input]
(let [[orders updates] (parse-input input)]
  (->>
  (filter #(not (clojure.set/subset? (gen-order [] %) orders)) updates)
  ;(prn)
  (map #(sort compare %))
  (map get-mid)
  (map parse-long)
  (reduce +))))
(solve2 input)
;; => 4679
