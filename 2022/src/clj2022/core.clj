(ns clj2022.core)

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

(println "test 
this is multi
line 
string")
