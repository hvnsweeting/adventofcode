(ns clj2022.day09-test
  (:require [clojure.test :refer :all]
            [clj2022.day09 :refer :all]))

;; (deftest test-day09-2
;;   (is (= 36 (day09-2 (slurp "src/clj2022/newinput09")))))

(deftest test-day09-1r
  (is (= 5513 (day09-1 (slurp "src/clj2022/input09")))))

(deftest test-day09-2r
        (is (= 2427 (day09-2 (slurp "src/clj2022/input09")))))
