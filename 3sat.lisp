; Author: Tyler Bounds
; Email:  tyler.bounds@wsu.edu
; Class:  CS 355 - Language Design
; Date:   3/22/2016
; Description: This program is a solution to the 3-SAT problem. Given a set of 
;              boolean variables and a boolean expression written in conjuctive 
;              normal form with 3 variables per clause, this program utilizes 8 
;              functions to determine if there is some assignment of true and  
;              false for each variable that solves the entire expression.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; EVAL-VAR ;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun eval-var (var state)             ; Evaluates the state of a var (true or nil)
  (cond
    ((null state) nil)                  ; Base case: returns nil when list is empty.
    ((eql var (caar state))             ; If the var is the same...
      (cadar state))                    ; Return the state.
  (t 
    (eval-var var (cdr state))) ) )     ; Recursively call eval-var

(defvar *clause* '(a (not b) c))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; EVAL-CLAUSE ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun eval-clause (clause state)     ; Evaluates the state of a clause (true or nil)
  (cond 
    ((null clause) nil)               ; Base case
    ((atom (car clause))              ; If the first element in the clause is an atom...
      (cond
        ((eval-var (car clause) state) t)       ; If the atom is in the state, evals to true.
      (t 
        (eval-clause (cdr clause) state)) ) )   ; Else, recursively call eval-clause with the rest of clause.
  (t                                            ; If the first element in the clause is a list...
    (cond
      ((not (eval-var (cadar clause) state)) t)     ; If the atom in the list is in the state, evals to true.
    (t 
      (eval-clause (cdr clause) state)) ) ) ) )     ; Else, recursively call eval-clause.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; GET-VARS ;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-vars (clause)            ; Returns just the variables of a clause (excludes 'not' and nested parens)
  (mapcar (lambda (term)
    (cond
      ((atom term) term)
    (t 
      (cadr term)) ) )
  clause) )  


(defvar *clauses* '((a (not b) c) (a (not b) (not c)) (a (not b) d)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; GET-ALL-VARS ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-all-vars (clauses)       ; Returns the variables of clauses (exludes 'not', nested parens, and redundant vars)
  (cond
    ((null clauses) nil)
  (t
    (union (get-vars (car clauses)) (get-all-vars (cdr clauses))) ) ) )  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; UNSAT-CLAUSES ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun unsat-clauses (clauses state)  ; Returns unsatisfied clauses.
  (cond
    ((null clauses) nil)
    ((not (eval-clause (car clauses) state)) 
      (cons (car clauses) (unsat-clauses (cdr clauses) state)) ) 
  (t
    (unsat-clauses (cdr clauses) state) ) ) )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; FLIP-VAR ;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;          
(defun flip-var (var state)         ; Flips the state of a var.
  (cond
    ((null state) nil)
    ((eql var (caar state))
      ; Flips the state and evals
      (cons (cons var (cons (not (cadar state)) nil)) (cdr state)) )
  (t
    ; Continues building cons cell.
    (cons (car state) (flip-var var (cdr state))) ) ) )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; GET-BETTER-NEIGHBOR ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
(defun get-better-neighbor (clauses state vars num-unsat) ; Modifies the state and returns a state that satisfies more clauses than the previous one.
  (cond
    ((null vars) nil) ; Base case: while vars is !empty
    ; If num-unsat > the # of unsatisfied clauses after modifying the state.
    ((> num-unsat (length (unsat-clauses clauses (flip-var (car vars) state))))
      ; Eval to a list of 2 lists. First list: modified state. Second list: unsatisfied clauses given modified state.
      (list (flip-var (car vars) state) (unsat-clauses clauses (flip-var (car vars) state))) ) 
  (t 
    (get-better-neighbor clauses state (cdr vars) num-unsat) ) ) )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; SIMPLE-HILL-CLIMB ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun simple-hill-climb (clauses state dist unsat)
  (cond
    ((<= dist 0) nil)     ; Could not find a solution.
    ((null unsat) state)  ; A solution was found.
  (t
      ; Grab all the vars from clauses. This evals to the same thing, so it is redundant.
      (let ((vars (get-all-vars clauses)))  
        ; Create a list of 2 lists. First list is the modified state. The second list is the unsat-clauses.
        (let ((new_list (get-better-neighbor clauses state vars (length (unsat-clauses clauses state)))))
          (cond
            ((null new_list) state) ; Solution was found is new_list is null.
          (t
            (simple-hill-climb clauses (car new_list) (- dist 1) (cdr new_list)) ) ) ) ) ) ) ) ; Otherwise recurse with modified paramters.