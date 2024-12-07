(def ns [1 2 3 4])

(defn pos-sum [[x & xs] test ret]
  ;(prn "possum" [x xs] ret)
  (if (nil? xs) (do
                  ;(prn "that" ret x (+ ret x) (* ret x) test)
                  (or
                   (= test (+ ret x))
                   (= test (* ret x))))
      
      (do
        ;(prn "this ithis")
        (or
         (pos-sum xs test (+ x ret))
         (pos-sum xs test (* x ret))
         ))))

(pos-sum [10 19] 1902 0)
(pos-sum [10 19] 190 0)


(def sample "190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20")

(require '[clojure.string :as str])
(defn parse-input [input]
  (let  [lines (str/split-lines input)]

  (->>
   lines
   (map #(map parse-long (str/split % #"\s+|:\s+"))))
  ))

;(pos-sum [81 40 27] 2267)
(prn "p1")
(->>
 (parse-input sample)
                                        ;(prn)
 (filter (fn [[test & ns]]
        (pos-sum ns test 0)))
 (map first)
 (reduce +)
 )
;; => 3749

(comment
(->>
 (parse-input (slurp "src/input07"))
                                        ;(prn)
 (filter (fn [[test & ns]]
        (pos-sum ns test 0)))
 (map first)
 (reduce +)))


(defn pos-sum-2 [[x & xs] test ret]
  ;(prn "possum" [x xs] ret)
  (if (nil? xs) (do
  ;                (prn "that" ret x test)
                  (or
                   (= test (parse-long (apply str [ret x])))
                   (= test (+ ret x))
                   (= test (* ret x))))
      
      (do
  ;      (prn "this ithis")
        (or
         (pos-sum-2 xs test (+ x ret))
         (pos-sum-2 xs test (* x ret))
         (pos-sum-2 xs test (parse-long (apply str [ret x])))
         ))))

(pos-sum-2 [ 6 8 6 15] 7290 0)

(->>
 (parse-input (slurp "src/input07"))
                                        ;(prn)
 (filter (fn [[test & ns]]
        (pos-sum-2 ns test 0)))
 (map first)
 (reduce +))
;; => 354060705047464
