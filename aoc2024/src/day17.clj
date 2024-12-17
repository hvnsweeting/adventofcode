(require '[clojure.string :as str])


(defn pow [x n]
  (apply * (repeat n x)))

(pow 2 8)
(pow 2 2)

(defn dv [reg operand]
  (quot reg (pow 2 operand)) 
  )

(defn eval-opd [states mode operand]
  (if (= mode :literal) operand
      (cond
        (= operand 0) 0
        (= operand 1) 1
        (= operand 2) 2
        (= operand 3) 3
        (= operand 4) (states :regA)
        (= operand 5) (states :regB)
        (= operand 6) (states :regC)
        (= operand 7) (assert false))))

(evil-opd {:regA 2} :combo 4)


(defn run [A B C ins]
  (let [init-states {:ip 0
                     :opcode 0
                     :operand 0
                     :regA A
                     :regB B
                     :regC C
                     :out ""}
        adv 0
        bxl 1
        bst 2
        jnz 3
        bxc 4
        out 5
        bdv 6
        cdv 7
        ]
    (loop [states init-states]
      (let [ip (states :ip)
            [opcode operand] [(nth ins ip nil) (nth ins (inc ip) nil)]
            states (update states :ip #(+ % 2))
            ]
        (if (nil? opcode) states

            (let [new-state (cond
                              (= opcode adv) (assoc states :regA (dv (states :regA) (eval-opd states :combo operand))) ; =>A
                              (= opcode bxl) (assoc states :regB (bit-xor (states :regB) (eval-opd states :literal operand)))
                              (= opcode bst) (assoc states :regB (mod (eval-opd states :combo operand) 8)) ; => B
                              (= opcode jnz) (if (= (states :regA) 0) states
                                                 (assoc states :ip (eval-opd states :literal operand)))
                              (= opcode bxc) (assoc states :regB (bit-xor (states :regB) (states :regC))) ; => B ; ignore operand
                              (= opcode out) (update states :out (fn [v] (str/join "," [v (mod (eval-opd states :combo operand) 8)])))
                              (= opcode bdv) (assoc states :regB (dv (states :regA) (eval-opd states :combo operand))) ; =>A
                              (= opcode cdv) (assoc states :regC (dv (states :regA) (eval-opd states :combo operand))) ; =>A
                              )]
              (recur new-state)
              ))
        ))
    ))


(run 0 0 9 [2 6])
;; => {:ip 2, :opcode 0, :operand 0, :regA 0, :regB 1, :regC 9, :out ""}
(defn parse-input [s]
  (mapv parse-long (str/split s #",")))
(run 10 0 9 (parse-input "5,0,5,1,5,4")) 
;; => {:ip 8,
;;     :opcode 0,
;;     :operand 0,
;;     :regA 10,
;;     :regB 0,
;;     :regC 9,
;;     :out ",0,1,2"}

(run 2024 0 0 (parse-input "0,1,5,4,3,0")) 
;; => {:ip 8,
;;     :opcode 0,
;;     :operand 0,
;;     :regA 0,
;;     :regB 0,
;;     :regC 0,
;;     :out ",4,2,5,6,7,7,7,7,3,1,0"}


(run 0 29 0 (parse-input "1,7")) 
;; => {:ip 4, :opcode 0, :operand 0, :regA 0, :regB 26, :regC 0, :out ""}
(run 0 2024 43690 (parse-input "4,0"))  
;; => {:ip 4,
;;     :opcode 0,
;;     :operand 0,
;;     :regA 0,
;;     :regB 44354,
;;     :regC 43690,
;;     :out ""}

(run 729 0 0 (parse-input "0,1,5,4,3,0"))  
;; => {:ip 8,
;;     :opcode 0,
;;     :operand 0,
;;     :regA 0,
;;     :regB 0,
;;     :regC 0,
;;     :out ",4,6,3,5,6,3,5,2,1,0"}

(def ins (parse-input "2,4,1,3,7,5,0,3,1,4,4,7,5,5,3,0"))
(comment
  ;; p1
  ;; => {:ip 18,
  ;;     :opcode 0,
  ;;     :operand 0,
  ;;     :regA 0,
  ;;     :regB 4,
  ;;     :regC 1,
  ;;     :out ",2,1,4,7,6,0,3,1,4"}
  )

(def exp ",2,4,1,3,7,5,0,3,1,4,4,7,5,5,3,0")
