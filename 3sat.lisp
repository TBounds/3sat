(defun eval-var (var state)
  nil)  ;;; Your code here

(defvar *clause* '(a (not b) c))

(defun eval-clause (clause state)
  nil)  ;;; Your code here
  
(defun get-vars (clause)
  nil)  ;;; Your code here

(defvar *clauses* '((a (not b) c) (a (not b) (not c)) (a (not b) d)))

(defun get-all-vars (clauses)
  nil)  ;;; Your code here

(defun unsat-clauses (clauses state)
  nil)  ;;; Your code here
            
(defun flip-var (var state)
  nil)  ;;; Your code here

(defun get-better-neighbor (clauses state vars max-num-unsat)
  nil)  ;;; Your code here

(defun simple-hill-climb (clauses state dist unsat)
  nil)  ;;; Your code here

