(ns clj2022.core-test
  (:require [clojure.test :refer :all]
            [clj2022.core :refer :all]))

(deftest a-test
  (testing "0 != 1"
    (not (= 0 1))))

(deftest test-my-double
  (is (= 6 (my-double 3))))
