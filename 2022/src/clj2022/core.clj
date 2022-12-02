(ns clj2022.core
  (:require [clojure.string :as string])
  )

(defn foo
  "I don't do a whole lot."
  [x]
  (println x "Hello, World!"))

(defn my-double
  [x]
  (* x 2))

; todo TEST aoc2021 1
(defn -main
  [& args]
  (foo 1))

  (defn sumeach [x]
    (->> x
        (string/split-lines)
              (map #(Integer/parseInt %))
              (reduce +)
    ))

(defn day01-1 [s]
  (as-> s x
    (string/split x #"\n\n")
    (map sumeach x)
    (apply max x)
    ))


(defn day01-2 [s]
  (as-> s x
    (string/split x #"\n\n")
    (map sumeach x)
    (sort x)
    (take-last 3 x)
    (reduce + x)
    ;(apply max x)
    ))


(assert (= 24000 (day01-1 "1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
")))


(day01-1 (slurp "src/clj2022/input01")) 
(day01-2 (slurp "src/clj2022/input01")) 

(def cardmap {"A" 1, "B" 2, "C" 3, "X" 1, "Y" 2, "Z" 3})
(def handmap {"A X" 4, "A Y" 8, "A Z" 3,
              "B X" 1, "B Y" 5, "B Z" 9,
              "C X" 7, "C Y" 2, "C Z" 6 })
(defn mapeach
  [x]
  (handmap x
           )
  
  )
(defn day02-1
  [input]
  
  (as-> input x
      (string/split-lines x)
      ;(take 100 x)
      (map mapeach x)
      ;(count x)
      
                                        ;
      (reduce + x)
    )
)

(day02-1 "A Y
B X
C Z
")
(day02-1 (slurp "src/clj2022/input02") )

(def handmap {"A X" (+ 0 3), "A Y" (+ 3 1), "A Z" (+ 6 2),
              "B X" (+ 0 1), "B Y" (+ 3 2), "B Z" (+ 6 3),
              "C X" (+ 0 2), "C Y" (+ 3 3), "C Z" (+ 6 1)})
(defn mapeach
  [x]
  (handmap x
           )
  
  )
(defn day02-2
  [input]
  
  (as-> input x
      (string/split-lines x)
      ;(take 100 x)
      (map mapeach x)
      ;(count x)
      
                                        ;
      (reduce + x)
    )
)
(day02-2 "A Y
B X
C Z
")
(day02-2 (slurp "src/clj2022/input02") )
;  how to matching (x y) instead of using first, second
