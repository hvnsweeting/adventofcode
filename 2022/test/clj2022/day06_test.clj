(ns clj2022.day06-test
  (:require [clojure.test :refer :all]
            [clj2022.day06 :refer :all]))

(deftest test-day06-1 (is (= 7 (day06-1 "mjqjpqmgbljsphdztnvjfqwrcgsmlb"))))
(deftest test-day06-1r (is (= 1876 (day06-1 (slurp "src/clj2022/input06")))))
(deftest test-day06-2 (is (= 19 (day06-2 "mjqjpqmgbljsphdztnvjfqwrcgsmlb"))))
(deftest test-day06-2r (is (= 2202 (day06-2 (slurp "src/clj2022/input06")))))
