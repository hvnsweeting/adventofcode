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

(def data
  (map (fn [line] (mapv #(parse-long %) (str/split line #"\s+")))
       (str/split-lines input)))

(def c1 (map first data))
(def c2 (map second data))

(defn calculate-diff [c1 c2]
  (->> (map - (sort c1) (sort c2))
       (map abs)
       (reduce +)))
(prn (calculate-diff c1 c2))
;; => 1579939

(defn count-in [x xs]
  (count (filter #(= x %) xs)))
(defn calculate-weighted-sum [c1 c2]
  (->>
   (map #(* % (count-in % c2)) c1)
   (reduce +)))
(prn (calculate-weighted-sum c1 c2))
;; => 20351745
