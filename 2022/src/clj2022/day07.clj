(ns clj2022.day07
  (:require [clojure.string :as str])
  (:require [clojure.java.io :as io])
  (:require [clojure.set :as set]))

(defn build-tree [curdir
                  state
                  [cmd & rest]]
  ;(println "build-tre" curdir state "CMD" cmd)
  (if (empty? rest)
    (let [[_ & out] (str/split-lines cmd)]
      (merge state {curdir out}))

    (if (str/starts-with? cmd "cd")
      (let [[_, path] (str/split cmd #" ")]
        (if (= path "/")
          (recur "/" state rest)
          (recur (str (.getCanonicalFile (io/file curdir path))) state rest)))

                                        ; else
      (let [[_ & out] (str/split-lines cmd)]
        (recur curdir (merge state {curdir out}) rest)))))

(defn file-sizes [files]
  (->>
   files

   (map #(str/split % #" "))
   (map first)
   (map parse-long)
   (reduce +)))

(defn size [key tree]
  (println "Calculating size of", key)
  (let [v (tree key)]
    (let [{dirs true files false} (group-by #(str/starts-with? % "dir ") (sort v))]
      (println "files" files)
      (+ (file-sizes files) (->> (map #(str/split % #" ") dirs)
                                 (map second)
                                 (map #(str (.getCanonicalFile (io/file key %))))
                                 (map #(size % tree))
                                 (reduce +))))))

(defn day07-1 [input]
  (println "START")
  (def tree (->>

             (str/split input #"\$")
             (map #(str/trim %))
             (filter #(not= "" %))
             (build-tree "/" {})))

  (def ss (->> (keys tree)
               (map #(size % tree))
               sort))
  (println "ALLSIZES" ss)
  (let [total (size "/" tree)]
    (println "ALLSIZES" ss)
    (println "TOTAL" total)
    (some #(when (> (+ (- 70000000 total) %) 30000000) %) ss)))

(day07-1 "$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k")

(day07-1 (slurp "src/clj2022/input07"))







