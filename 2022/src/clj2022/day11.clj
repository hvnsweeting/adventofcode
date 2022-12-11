(ns clj2022.day11
  (:require [clojure.string :as str])
  (:require [clojure.java.io :as io])
  (:require [clojure.test :refer :all])
  (:require [clojure.set :as set]))

(defn dbg [x]
  (prn "debug" x)
  x)

(defn doop [worry input]
  (let [[oper arg] (str/split input #" ")]
    (def v (cond
            (= arg "old") worry
            :else (parse-long arg)
            ))
    (case oper
      "+" (quot (+ v worry) 3)
      "*" (quot (* v worry) 3)
      )
    )
  )

(doop 79 "* 19")

(defn parse-monkey [monkey]
  (let [[name items op test iftrue iffalse :as all] (str/split-lines monkey )]

    (let [[_ monkeyth :as line] (first (re-seq #"Monkey (\d+):" name))
          [_ ii] (first (re-seq #"Starting items: (.*)" items))
          [_ o] (first (re-seq #"  Operation: new = old (.*)" op))
          [_ t] (first (re-seq #"Test: divisible by (\d+)" test))
          [_ truetarget] (first (re-seq #"If true: .*(\d+)" iftrue))
          [_ falsetarget] (first (re-seq #"If false: .*(\d+)" iffalse))
          ]
      [monkeyth, {:id monkeyth, :inspected 0, :items (into [] (map parse-long (str/split ii #", "))), :op o, :test (parse-long t), :truetarget truetarget, :falsetarget falsetarget}]
      )
    ;all
    )
  )

(defn take-this-to-that [monkey target states]
  (let [[i & rest] (get-in states [(monkey :id) :items])]
    (def removed (assoc-in states [(monkey :id) :items] rest))
    (def removed (update-in removed [(monkey :id) :inspected] inc))
    (assoc-in removed [target :items] (conj (get-in states [target :items]) (doop i (monkey :op))))
    )
  )
(defn process-items [[i & rest] monkey states]
  (if (nil? i) states
      (do
        (def newstate (if (= 0 (rem (doop i (get monkey :op)) (get monkey :test)))
                        (take-this-to-that monkey (get monkey :truetarget) states)
                        (take-this-to-that monkey (get monkey :falsetarget) states)
                        ))
        (recur rest (newstate (monkey :id)) newstate))
      )
  )

;; (prn (process-items [79 98] {:id "0", :items [79 98], :op "* 19", :test 23, :truetarget "2", :falsetarget "3"}

;;                 {"0" {:id "0", :items [79 98], :op "* 19", :test 23, :truetarget "2", :falsetarget "3"}, "1" {:id "1", :items [54 65 75 74], :op "+ 6", :test 19, :truetarget "2", :falsetarget "0"}, "2" {:id "2", :items [79 60 97], :op "* old", :test 13, :truetarget "1", :falsetarget "3"}, "3" {:id "3", :items [74], :op "+ 3", :test 17, :truetarget "0", :falsetarget "1"}}
;;                 ))
(defn process-turn [monkeyid states]
  (process-items (get-in states [monkeyid :items]) (get states monkeyid) states)
  )

;; (prn "TEST PROCESS TURN" (process-turn
;; "0"

;;                 {"0" {:id "0", :items [79 98], :op "* 19", :test 23, :truetarget "2", :falsetarget "3"}, "1" {:id "1", :items [54 65 75 74], :op "+ 6", :test 19, :truetarget "2", :falsetarget "0"}, "2" {:id "2", :items [79 60 97], :op "* old", :test 13, :truetarget "1", :falsetarget "3"}, "3" {:id "3", :items [74], :op "+ 3", :test 17, :truetarget "0", :falsetarget "1"}}

;;       ))
(defn process-round [[m & rest] states]
  ; go to each monkey
  (if (nil? m) states
      (recur rest (process-turn m states))
      ))

(defn process-rounds [states]
  (process-round (keys states) states)
  )
;(process-rounds )

(defn day11 [input]
  (prn "STARTING")
  (def monkeys (->>
                (str/split input #"\n\n")
                (map parse-monkey)
                (into (sorted-map))
                ))

  (dbg monkeys)
  (->>
   (nth (iterate process-rounds monkeys) 20)
   (vals)
   (map #(get % :inspected) )
   (sort)
   (take-last 2)
   (reduce *)
   )
  )

(def sample "Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1")

(day11 sample)
(day11 (slurp "src/clj2022/input11"))

;; (deftest test-day10-1
;;   ((is (= 0 (day10 "1")))))
