(require '[clojure.string :as str])
(require '[clojure.pprint :as pp])

(def sample "kh-tc
qp-kh
de-cg
ka-co
yn-aq
qp-ub
cg-tb
vc-aq
tb-ka
wh-tc
yn-cg
kh-ub
ta-co
de-co
tc-td
tb-wq
wh-td
ta-ka
td-qp
aq-cg
wq-ub
ub-vc
de-ta
wq-aq
wq-vc
wh-yn
ka-de
kh-ta
co-tc
wh-qp
tb-vc
td-yn")

(defn parse-input [input]
  (->>
   (str/split-lines input)
   (reduce (fn [acc line]
             (let [[left right] (str/split line #"-")
                   updated-left (update acc left (fn [old] (if (nil? old) #{right} (conj old right))))
                   updated-right (update updated-left right (fn [old] (if (nil? old) #{left} (conj old left))))
                   ]
               updated-right

               )) {})
   
   ))
(parse-input "kh-tc")

(let [ ;groups (parse-input sample)
      groups (parse-input (slurp "src/input23"))
      ]
  (pp/pprint groups)
  (->>
   (for [[k v] groups
         [k2 v2] groups
         :when (and (v k2) (v2 k))
         ]
     (if-let [x (clojure.set/intersection v v2)]
       (mapcat #(vector [k k2 %]) x)
       []
       )
     )
   (apply concat)
   (map sort)
   (into #{})
   (sort-by first)
   (remove (fn [g] (empty? (filter #(str/starts-with? % "t") g))))
   (count)
   ))
;; => 1423

(defn password [xs]
  (str/join "," (sort xs)))

(let [; groups (parse-input sample)
      groups (parse-input (slurp "src/input23"))
      ]
  (pp/pprint groups)
  (->>
   (for [[k v] groups
         [k2 v2] groups
         :when (and (v k2) (v2 k))
         ]
     (if-let [x (clojure.set/intersection v v2)]
       (apply clojure.set/intersection (map (fn [i] (conj (groups i) i)) (conj x k k2)))
       []
       )
     )
   (sort-by count)
   (last)
   (password)
   )
  )
;; => "gt,ha,ir,jn,jq,kb,lr,lt,nl,oj,pp,qh,vy"
