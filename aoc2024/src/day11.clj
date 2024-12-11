(require '[clojure.string :as str])
(def s "0 1 10 99 999")
(defn parse-stones [s]
  (->>
   (str/split s #"\s")
   (map parse-long)
   ))
;; => (0 1 10 99 999)
(parse-stones s)                        ;
;; => (0 1 10 99 999)
(defn pow [n e]
  (reduce * (repeat e n)))
(pow 10 3)

(def cache {})
(defn change [n]
  (if (cache n) (cache n)
      (do
        (def len (count (str n)))

        (def ret (cond
                   (= n 0) 1
                   (even? len) (let [div (pow 10N (quot len 2))] [(quot n div) (rem n div)])
                                        ;  (let [s (str n) c (count s) mid (quot c 2)] (map parse-long [(subs s 0 mid) (subs s mid)]))
                   :else (* n 2024)
                   ))

        (def cache (assoc cache n ret))
        ret
        )))
cache
(change 1000)
(defn debug [xs]
  (prn xs)
  xs)
(defn batch [xs n]

  (println n (count cache) (count xs) (frequencies xs))
  (->>
   (map change xs)
                                        ;(debug)
   (flatten)
   )
  )

(change 125)
;; => 253000
(change 17)                             ;
;; => (1 7)
(assert (= (count (reduce batch (parse-stones "125 17") (range 6))) 22))
(time
 (assert (= (count (reduce batch (parse-stones (slurp "src/input11")) (range 25))) 233050)))
;; =>
;; => 233050
                                        ;(count (reduce batch (parse-stones "7725 185 2 132869 0 1840437 62 26310") (range 75)))
(reduce batch [0] (range 11))

;; Part 2

(defn change2 [[n f]]
  (def len (count (str n)))

  (def ret (cond
             (= n 0) [[1 f]]
             (even? len) (let [div (pow 10N (quot len 2))] [[(quot n div) f] [(rem n div) f]])
                                        ;  (let [s (str n) c (count s) mid (quot c 2)] (map parse-long [(subs s 0 mid) (subs s mid)]))
             :else [[(* n 2024) f]]
             ))

  ret
  ))
(change2 [2024 1])
(change2 [0 1])

(defn mulfreq [xs]
(->>
 xs
 (frequencies)

 (map (fn [[[n c1] c2]] [n (* c1 c2)]))
 ))

(map change2 [[0 1]])
(defn fastbatch [xs n]
(println :here n (count xs) )

(->>
 xs
 (mulfreq)
 (map change2)
                                        ;(debug)
 (apply concat)
 )
)
;; hello
(reduce fastbatch [[0 1]] (range 10))
(defn count-stone [freqs]
(reduce + (map second freqs)))
(->>
(reduce fastbatch ;[[125 1] [17 1]]
        (frequencies (parse-stones (slurp "src/input11")))

        (range 75))
(count-stone)
)
;; => 276661131175807
