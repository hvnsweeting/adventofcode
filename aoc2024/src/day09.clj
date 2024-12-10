(ns day09
  [:require [clojure.string :as str]])


(def sample "2333133121414131402")
(def s sample)

(def input (str/trim (slurp "src/input09")))
(defn with-id [disk-map]
  (->>
  (map-indexed (fn [idx v]
                 (let [v (parse-long (str v))]
                   (if (= (mod idx 2) 0) [:file (/ idx 2) v]
                       [:free nil v])))
               disk-map)

               ;(filter (fn [idx [t i v]] (not (and (= t :free) (= v 0))))
                       ))


(with-id s)

(defn layout [disk-map]
  (->>
   
   (map (fn [[typ idx v]]
          (repeat v [typ idx v]))
        (with-id disk-map))
   (apply concat)
   (into [])
   ))
(layout s)


(defn move-blocks [acc]
  (loop [
         all acc
         ret []
         ]
    ;(prn (count all)) (prn all ret)
    (if (empty? all) ret
        (let [xs (subvec all 1)
              x (first all)
              [typ idx v] x]
          (if (= typ :file) (recur xs (conj ret [typ idx v]))
              (let [[t i v] (peek xs)]
                (if (= t :free) (recur (pop all) ret)
                    (recur (pop xs) (conj ret (peek xs))))))))
    ))


(let [s (str/trim ;sample
                                   input
                  )]
  (->>
   (layout s)
                                        ;(count)
                                        ;   (prn)
   (move-blocks)
   (filter #(= :file (first %)))
   (map-indexed (fn [idx [typ oldidx _]] (* idx oldidx)))
   (reduce +)
   )
  )
;; => 6211348208140


(defn defrag [disk-blocks]
  (loop [blocks (into [] (map-indexed vector disk-blocks))
         disk disk-blocks]
    ;(prn :block blocks )
    ;(prn :disk disk)
    (if (empty? blocks) disk
        (let [[bidx [t i v]] (peek blocks)
              free-space (first (filter (fn [[t2 i2 v2]] (and (= t2 :free) (>= v2 v))) disk))
              idx (.indexOf disk free-space)
              ]
          (if (or (= t :free)
                  (< bidx idx))
            (recur (pop blocks) disk)
            (do
          ;(prn "process" [t i v] :at bidx :moveto  free-space :at idx)
          (if (nil? free-space) (recur (pop blocks) disk)
              (let [
                    ;new-disk (assoc moved idx )
                    [tf iif vf] free-space
                    moved (assoc disk bidx [:free nil v])
                    ]
                (if (= v vf) (let [
                                   ]
                               (recur (pop blocks) (assoc moved idx [t i v])))
                    (let [
                    before (subvec moved 0 idx)
                    after (subvec moved (inc idx))
                    shifted-blocks (into [] (map (fn [[i b]] [(if (>= i idx) (inc i) i) b]) (pop blocks)))
                          ]
                      (recur shifted-blocks  (into [] (concat before [[t i v] [:free nil (- vf v)]] after))))
                    
                )))))))))
    
(prn "****************")

(defn layout-2 [blocks]
  (->>
   blocks
   (map (fn [[typ idx v]]
          (repeat v [typ idx v])))
   (apply concat)
   (into [])
   ))
 
(->>
(defrag (into [] (with-id input)))
   (filter (fn [[t i v]] (not (and (= t :free) (= v 0)))))
   (layout-2)
   ;(filter #(= :file (first %)))
   (map-indexed (fn [idx [typ oldidx _]] (if (= typ :free) 0 (* idx oldidx))))
   (reduce +)
)
