(require '[clojure.string :as str])


(def n 123)
(defn mix [s n]
  (bit-xor n s))

(assert (= (mix 42 15) 37))

(defn prune [n]
  (rem n 16777216)
  )

(assert (= (prune 100000000) 16113920))


(defn gen [n]
  (let [p1 (-> (* n 64) (mix n) (prune))
        p2 (-> p1 (quot 32) (mix p1) (prune))
        ]
    
    (-> p2
        (* 2048)
        (mix p2)
        (prune)

        )
    ))
(assert (= (gen 123) 15887950))

(defn gen-nth [n nth]
  (first (drop nth (iterate gen n))))

(assert (= (gen-nth 1 2000) 8685429))

(def lines (map parse-long (str/split-lines (slurp "src/input22"))))
(->> lines
     (pmap #(gen-nth % 2000))
     (reduce +))
;; => 17965282217

(count lines)

(defn create-seq-map [n nth]
  (let
      [ns (take nth (iterate gen n))
       ps (map #(rem % 10) ns)
       diff (->> (partition 2 1 ps) (map (fn [[a b]] (- b a))))
       ]
    (->>
     (map vector (drop 1 ps) diff)
     (partition 4 1)
     (reduce (fn [acc x]
               (let [key (map second x)
                     [banana _] (last x)
                     ]
                 [key banana]
                 (if (acc key) acc
                     (assoc acc key banana))
                 )
               ) {})
     )

    ))

(defn part2 [xs]
  (prn :start)
  (let [;xs [1 2 3 2024]
        ms (->> xs (map #(create-seq-map % 2000)))
        allseqs (apply concat (map keys ms))
        ]
    (prn :allseqs  (count allseqs) :allmap (count ms))

    (->>
     allseqs
     (into #{})
     (pmap (fn [s]
             (->> ms 
                  (map (fn [m] (get m s 0)))
                  (reduce +)
                  )))
     (apply max)
     )))

(part2 [1 2 3 2024])
;; => 23
(part2 lines)
;; => 2152
