(def s "3   4
4   3
2   5
1   3
3   9
3   3
")
(prn s)
(require '[clojure.string :as str])
(def input (slurp "src/input01"))
(let [c1 (map #(Integer/parseInt (first %)) (for [line (str/split-lines input)] (str/split line #"\s+")))
      c2 (map #(Integer/parseInt (second %)) (for [line (str/split-lines input)] (str/split line #"\s+")))]
  (->>
   (map - (sort c1) (sort c2))
   (map abs)
   (reduce +)
   )
  )
;; => 1579939
(defn count-in [x xs]
  (count (filter #(= x %) xs)))
(let [c1 (map #(Integer/parseInt (first %)) (for [line (str/split-lines input)] (str/split line #"\s+")))
      c2 (map #(Integer/parseInt (second %)) (for [line (str/split-lines input)] (str/split line #"\s+")))]
  (->>
   (map #(* % (count-in % c2)) c1)
   (reduce +)
   )
  )
;; => 20351745
