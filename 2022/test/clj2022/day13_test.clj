(ns clj2022.day13-test
  (:require [clojure.test :refer :all]
            [clj2022.day13 :refer :all]))

(deftest test-day13-1
  (is (= 13 (day13-1 sample))))
(deftest test-day13-1r
  (is (= 5555 (day13-1 (slurp "src/clj2022/input13")))))

(deftest test-day-13-2 (is (= 140 (day13-2 clj2022.day13/sample))))
(deftest test-day-13-2r
  (is (= 22852 (day13-2 (slurp "src/clj2022/input13")))))

