(require '[clojure.string :as str])

(def sample1 "x00: 1
x01: 1
x02: 1
y00: 0
y01: 1
y02: 0

x00 AND y00 -> z00
x01 XOR y01 -> z01
x02 OR y02 -> z02
")
(defn parse-wires [wires]
  (into {} (for [[k v] (map #(str/split % #": ") (str/split-lines wires))] [k (parse-long v)])))

(defn parse-gates [gates]
(->>
  (str/split-lines gates)
  (map #(let [[i1 op i2 o] (rest (re-find #"([a-z0-9]+) (AND|OR|XOR) ([a-z0-9]+) -> ([a-z0-9]+)" %))]
          {:inputs [i1 i2]
           :op op
           :out o}))))

(let [[wires gates] (str/split sample1 #"\n\n")
      wires (parse-wires wires)
      ]
  wires
  (parse-gates gates)
  


  )
