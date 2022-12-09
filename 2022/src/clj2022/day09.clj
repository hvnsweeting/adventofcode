(ns clj2022.day09
  (:require [clojure.string :as str])
  (:require [clojure.java.io :as io])
  (:require [clojure.set :as set]))

;; since I wrote for part 1 which not directly usable for part2
;; I use a simple python script to convert input to each move by 1 only
;; python3 newinp9.py input09  

(defn dbg [x]
  (prn "debug" x)
  x)

(defn next-tail [[xhead yhead] [xtail ytail]]
  (cond
    (and (>= 1 (abs (- xhead xtail))) (>= 1 (abs (- yhead ytail)))) (list xtail ytail)

    (= xhead xtail) (list xtail (if (< yhead ytail) (- ytail 1)
                                    (+ ytail 1)))
    (= yhead ytail) (list (if (< xhead xtail) (- xtail 1)
                              (+ xtail 1)) ytail)
    :else (cond
            ; h top right of t
            (and (< 0 (- xhead xtail)) (< 0 (- yhead ytail))) (list (+ 1 xtail) (+ 1 ytail))
            (and (< 0 (- xhead xtail)) (< 0 (- yhead ytail))) (list (+ 1 xtail) (+ 1 ytail))
            ; h bot right of t
            (and (< 0 (- xhead xtail)) (< (- yhead ytail) 0)) (list (+ 1 xtail) (- ytail 1))
            (and (< 0 (- xhead xtail)) (< (- yhead ytail) 0)) (list (+ 1 xtail) (- ytail 1))
            ; h bot left of t

            (and (< (- xhead xtail) 0) (< (- yhead ytail) 0)) (list (- xtail 1) (- ytail 1))
            (and (< (- xhead xtail) 0) (< (- yhead ytail) 0)) (list (- xtail 1) (- ytail 1))

            ; h top left of t

            (and (< (- xhead xtail) 0) (> (- yhead ytail) 0)) (list (- xtail 1) (+ ytail 1))
            (and (< (- xhead xtail) 0) (> (- yhead ytail) 0)) (list (- xtail 1) (+ ytail 1))
            :else (do (prn "troubleshoot" xhead yhead xtail ytail)
                      '(99 99)))))

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

  (if (nil? motion) (merge states {tail 1})
      (do
        (def r (str/split motion #" "))
        (def direction (first r))
        (def n (second r))

        (def newhead (cond
                       (= direction "R") (list (+ xhead (parse-long n)) yhead)
                       (= direction "L") (list (- xhead (parse-long n)) yhead)
                       (= direction "U") (list xhead (+ yhead (parse-long n)))
                       (= direction "D") (list xhead (- yhead (parse-long n)))))
        (recur rest newhead (next-tail newhead tail) (merge states {tail 1})))))

(defn day09-1 [input]

  (def tail_states {})
  (->>
   (move (str/split-lines input) '(0 0) '(0 0) {})
  ;(dbg)
   (keys)
   (count)
   (println)))

(day09-1 (slurp "src/clj2022/newinput09"))

;;;; p2

(defn updateall [[one & rest] head result]
  ;(prn "updateall" one rest)
  (if (nil? one) (reverse result)
      (let [[tail state] one]
        (let [newtail (next-tail head tail)]
          (recur rest newtail (cons (list newtail (merge state {newtail 1})) result))))))

(defn move9 [[motion & rest] [xhead yhead] states]

  (if (nil? motion) states             ;TODO update states
      (do
        (def r (str/split motion #" "))
        (def direction (first r))
        (def n (second r))
        ;(prn rest xhead yhead tail states)

        (def newhead (cond
                       (= direction "R") (list (+ xhead (parse-long n)) yhead)
                       (= direction "L") (list (- xhead (parse-long n)) yhead)
                       (= direction "U") (list xhead (+ yhead (parse-long n)))
                       (= direction "D") (list xhead (- yhead (parse-long n)))))

        ;(prn "HEAD AT" newhead)
        (def newstates (updateall states newhead []))
        (recur rest newhead newstates))))

(defn day09-2 [input]

  (def tail_states {})
  (->>
   (move9 (str/split-lines input) '(0 0) [(list '(0 0) {})
                                          (list '(0 0) {})
                                          (list '(0 0) {})
                                          (list '(0 0) {})
                                          (list '(0 0) {})
                                          (list '(0 0) {})
                                          (list '(0 0) {})
                                          (list '(0 0) {})
                                          (list '(0 0) {})])

   (last)
   (second)
   (keys)
   (count)))

(day09-2 (slurp "src/clj2022/newinput09"))
