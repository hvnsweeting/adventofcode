(require '[clojure.string :as str])
(require '[clojure.set :as set])
;; --- Day 19: Linen Layout ---

(defn parse-input [input]
  (let [[patterns designs] (str/split input #"\n\n")]
    [(str/split patterns #", ") (str/split-lines designs)]))

(def input "r, wr, b, g, bwu, rb, gb, br

brwrr
bggr
gbbr
rrbgbr
ubwu
bwurrg
brgr
bbrgwb")

(declare possible?)

(defn check
  [c design patterns]
  (if (= c design)  true
      (if (str/starts-with? design c) ((memoize possible?) (subs design (count c)) patterns)
          false)))

(defn possible? [design patterns]
  (some identity (map #(check % design patterns) patterns)))

(defn pos? [design patterns]
  (let [patterns (filter #(str/includes? design %) patterns)]
                                        ;(prn :pat patterns)
    ((memoize possible?) design patterns)))



(let [
      input (slurp "src/input19")
      [patterns designs] (parse-input input)
      patterns (into #{} patterns)
      combine (into #{} (for [i patterns j patterns :when (patterns (str i j))] (str i j)))
      patterns (reverse (sort-by count (into [] (set/difference patterns combine))))
      ]
  
  (->>
   designs

   (pmap #(pos? % patterns))
   (filter identity)
   (count)
   ))
;; => 302


;; part2 


(def g (atom 0))
(declare possible2?)
(defn check2
  [c design patterns chose]
  ;(prn :check2 chose)
  (if (= c design) (conj chose c)
      (if (str/starts-with? design c) ((memoize possible2?) (subs design (count c)) patterns (conj chose c))
          nil)))

(defn possible2? [design patterns chose]
  (some identity (map #(check2 % design patterns chose) patterns)))

(defn pos2? [design patterns]
  (let [patterns (filter #(str/includes? design %) patterns)]
    ;(prn :pat patterns)
    ((memoize possible2?) design patterns [])))


(defn neighbors [p patterns]
   
  )

(defn ways [design patterns]
  (loop [d design
         q [(first patterns)]
         ret []
         ]
    (let [p (peek q)
          [c todo visited] p
          ]
      (if (nil? p) (conj ret visited)
          (let [nbrs (neighbors p patterns)]
            (recur (apply conj q nbrs) ret) 
            )
          
          

        )
      )
    )
  )

(ways "brwrr", ["b" "r" "wr" "r"])
                

(let [
                      ;               input (slurp "src/input19")
      [patterns designs] (parse-input input)
      patterns (into #{} patterns)
      combine (into #{} (for [i patterns j patterns :when (patterns (str i j))] (str i j)))
      atom-patterns (reverse (sort-by count (into [] (set/difference patterns combine))))
      ]
  
  (->>
   designs
   (pmap #(pos2? % atom-patterns))
   (filter identity)
   
   )
  ;(prn (count r) @g)
  ;(pos2? "rrbgbr" patterns)

  ) 
;; => 18982

;; => (["b" "r" "wr"]
;;     ["b" "g" "g"]
;;     ["g" "b" "b"]
;;     ["r" "r" "b" "g" "b"]
;;     ["bwu" "r" "r"]
;;     ["b" "r" "g"])
