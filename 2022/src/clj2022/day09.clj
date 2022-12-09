(ns clj2022.day09
  (:require [clojure.string :as str])
  (:require [clojure.java.io :as io])
  (:require [clojure.set :as set]))

(defn dbg [x]
  (prn "debug" x)
  x)


(defn next-tail [[xhead yhead] [xtail ytail]]
  ;(prn "calculate next-tail for" xhead yhead xtail ytail)
  (cond
    (and (>= 1 (abs (- xhead xtail))) (>= 1 (abs (- yhead ytail)))) (list xtail ytail)

    (= xhead xtail) (list xtail (if (< yhead ytail) (- ytail 1)
                                    (+ ytail 1)))
    (= yhead ytail) (list (if (< xhead xtail) (- xtail 1)
                              (+ xtail 1)) ytail)
    :else (cond
            ; h top right of t
            (and (= 1 (- xhead xtail)) (= 2 (- yhead ytail))) (list (+ 1 xtail) (+ 1 ytail))
            (and (= 2 (- xhead xtail)) (= 1 (- yhead ytail))) (list (+ 1 xtail) (+ 1 ytail))
            ; h bot right of t
            (and (= 1 (- xhead xtail)) (= -2 (- yhead ytail))) (list (+ 1 xtail) (- ytail 1))
            (and (= 2 (- xhead xtail)) (= -1 (- yhead ytail))) (list (+ 1 xtail) (- ytail 1))
            ; h bot left of t

            (and (= -1 (- xhead xtail)) (= -2 (- yhead ytail))) (list (- xtail 1) (- ytail 1))
            (and (= -2 (- xhead xtail)) (= -1 (- yhead ytail))) (list (- xtail 1) (- ytail 1))
            
            ; h top left of t

            (and (= -1 (- xhead xtail)) (= 2 (- yhead ytail))) (list (- xtail 1) (+ ytail 1))
            (and (= -2 (- xhead xtail)) (= 1 (- yhead ytail))) (list (- xtail 1) (+ ytail 1))
            :else '(0 0)
          
           )

    )
  )

(assert (= '(1 1) (next-tail '(2 1) '(1 1))))
(assert (= '(1 1) (next-tail '(1 1) '(1 1))))
(assert (= '(1 1) (next-tail '(1 2) '(1 1))))
(assert (= '(1 2) (next-tail '(1 3) '(1 1))))
(assert (= '(2 1) (next-tail '(3 1) '(1 1))))
(assert (= '(1 1) (next-tail '(1 2) '(0 0))))
(assert (= '(1 1) (next-tail '(2 1) '(0 0))))
(assert (= '(1 -1) (next-tail '(2 -1) '(0 0))))
(assert (= '(1 -1) (next-tail '(1 -2) '(0 0))))

(assert (= '(-1 -1) (next-tail '(-1 -2) '(0 0))))
(assert (= '(-1 -1) (next-tail '(-2 -1) '(0 0))))

(assert (= '(-1 1) (next-tail '(-2 1) '(0 0))))
(assert (= '(-1 1) (next-tail '(-1 2) '(0 0))))


(defn move [[motion & rest] [xhead yhead] tail states]

  (if (nil? motion) (merge states {tail 1})             ;TODO update states
      (do
        (def r (str/split motion #" "))
        (def direction (first r))
        (def n (second r))
        ;(prn rest xhead yhead tail states)

        (cond
          (= direction "R") (let [newhead (list (+ xhead (parse-long n)) yhead)] (recur rest newhead (next-tail newhead tail) (merge states {tail 1}) ))
          (= direction "L") (let [newhead (list (- xhead (parse-long n)) yhead)] (recur rest newhead (next-tail newhead tail) (merge states {tail 1}) ))
          (= direction "U") (let [newhead (list xhead (+ yhead (parse-long n)))] (recur rest newhead (next-tail newhead tail) (merge states {tail 1})))
          (= direction "D") (let [newhead (list xhead (- yhead (parse-long n))) ] (recur rest newhead (next-tail newhead tail) (merge states {tail 1}) ))))))
      

      

(defn day09-1 [input]

  (def tail_states {})
  (->>
  (move (str/split-lines input) '(0 0) '(0 0) {})
  ;(dbg)
  (keys)
  (count)
  (println)
  )
  
  )


(day09-1 (slurp "src/clj2022/newinput09"))

