(ns clj2022.core-test
  (:require [clojure.test :refer :all]
            [clj2022.core :refer :all]))

(deftest a-test
  (testing "0 != 1"
    (not (= 0 1))))

(deftest test-my-double
  (is (= 6 (my-double 3))))

(deftest test-day01-1
  (is
   (= 24000 (day01-1 "1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
"))))

(deftest test-day01-1r
  (is (= 72511 (day01-1 (slurp "src/clj2022/input01")))))
(deftest test-day01-2r
  (is (= 212117
         (day01-2 (slurp "src/clj2022/input01")))))

(deftest test-day02-1
  (is
   (= 15 (day02-1 "A Y
B X
C Z
"))))

(deftest test-day02-1r
  (is (= 11475 (day02-1 (slurp "src/clj2022/input02")))))

(deftest test-day02-2
  (is (= 12 (day02-2 "A Y
B X
C Z
"))))

(deftest test-day02-2r
  (is (= 16862 (day02-2 (slurp "src/clj2022/input02")))))

(deftest test-day03-1
  (is (= 157
         (day03-1 "vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw"))))
(deftest test-day03-1r
  (is (= 8298
         (day03-1 (slurp "src/clj2022/input03")))))

(deftest test-day03-2
  (is (= 70 (day03-2 "vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw"))))

(deftest test-day03-2r
  (is (= 2708 (day03-2 (slurp "src/clj2022/input03")))))


(deftest test-day04-1
  (is (= 2 (day04-1 "2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8"))))

(deftest test-day04-1r
  (is (= 560 (day04-1 (slurp "src/clj2022/input04")))))

(deftest test-day04-2
  (is (= 4 (day04-2 "2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8"))))


(deftest test-day04-2r
  (is (= 839 (day04-2 (slurp "src/clj2022/input04")))))
