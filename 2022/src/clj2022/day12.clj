(ns clj2022.day12
  (:require [clojure.string :as str])
  (:require [clojure.java.io :as io])
  (:require [clojure.set :as set]))

(defn dbg [x]
  (prn "debug" x)
  x)

(defn to_map [y acc [r & rest]]
  ;(println r rest)
  (if (nil? r) (merge acc)

      (do
        (def newacc (->>
                     (partition 2 (interleave (range (count r)) r))
                     (map #(hash-map [(first %) y] (second %)))
                     (reduce merge)))

        (recur (+ y 1) (merge acc newacc) rest))))

(defn good? [tree point that]
  (and (contains? tree that)
       (<= (- (int (get tree that)) (int (get tree point))) 1)))

(defn find-neighbors [tree [x, y]]
  (let [ns [[(- x 1) y] [(+ x 1) y] [x (- y 1)] [x (+ y 1)]]]
    (filter #(good? tree [x,y] %) ns)))

(defn visited?
  [v coll]
  (contains? coll v))

(defn bfs [start tree]
  (loop [visited #{}
         queue (conj clojure.lang.PersistentQueue/EMPTY start)
         backpath {start 1}]
    (if
        ;(= v end)
      ;(backpath v)
     (empty? queue)
      [visited backpath]
      (let [v  (peek queue)
            neighbors (find-neighbors tree v)
            not-visited (filter (complement #(visited? % visited)) neighbors)
            new-queue (apply conj (pop queue) not-visited)
            new-backpath (merge backpath (into {} (map #(vector % (inc (backpath v))) not-visited)))
            ;new-backpath (merge backpath (into {} (map #(vector % (inc (backpath v))) not-visited)))
            ]
        ;(prn "v" v "ns" neighbors "notvs" not-visited "q" new-queue)
        ;(prn "point" v (count new-queue))
        (if (visited? v visited)
          (recur visited (pop queue) backpath)
          (recur (conj visited v) new-queue new-backpath))))))

(def sample "Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
")
(defn get-path
  [end start r m]
  (if (= (m end) start)
    r
    (recur (m end) start (conj r end) m)))

(defn shortest-path
  [tree start end]

  (def r (->> (bfs start tree)
              (take-while #(not= end %))
              (second)))

  (if (contains? r end)
    (dec (r end))
    999999))

(defn day12-1 [input]
  (def tree (->> (str/split-lines input)
                 (to_map 0 {})
                 (dbg)
    ;(nth ins (- 1 %))
                 ))
  (let [[start _] (first (filter (fn [[k v]] (= \S v)) tree))
        [end _] (first (filter (fn [[k v]] (= \E v)) tree))]

                                        ; find start
                                        ; find end
                                        ;update high as A and Z
    (def tree2 (assoc tree start \a))
    (def tree2 (assoc tree2 end \z))
    (prn "start " start "end" end)

                                        ;(find-neighbors tree2 [0 0])

    (shortest-path tree2 start end)))

(defn day12-2 [input]
  (def tree (->> (str/split-lines input)
                 (to_map 0 {})
                 (dbg)
    ;(nth ins (- 1 %))
                 ))
  (let [[start _] (first (filter (fn [[k v]] (= \S v)) tree))
        [end _] (first (filter (fn [[k v]] (= \E v)) tree))]

    (def tree2 (assoc tree start \a))
    (def tree2 (assoc tree2 end \z))
    (prn "start " start "end" end)
    (->>
     (filter (fn [[k v]] (= v \a)) tree2)
     (map (fn [[k v]] k))
     (map #(shortest-path tree2 % end))
     (apply min))))
