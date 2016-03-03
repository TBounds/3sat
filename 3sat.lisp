(defun eval-var (var state)
  (error "not-implemented"))  ;;; Your code here

(defvar *clause* '(a (not b) c))

(defun eval-clause (clause state)
  (error "not-implemented"))  ;;; Your code here
  
(defun get-vars (clause)
  (error "not-implemented"))  ;;; Your code here

(defvar *clauses* '((a (not b) c) (a (not b) (not c)) (a (not b) d)))

(defun get-all-vars (clauses)
  (error "not-implemented"))  ;;; Your code here

(defun unsat-clauses (clauses state)
  (error "not-implemented"))  ;;; Your code here
            
(defun flip-var (var state)
  (error "not-implemented"))  ;;; Your code here

(defun get-better-neighbor (clauses state vars max-num-unsat)
  (error "not-implemented"))  ;;; Your code here

(defun simple-hill-climb (clauses state dist unsat)
  (error "not-implemented"))  ;;; Your code here

