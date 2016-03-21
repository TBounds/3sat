;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; EVAL-VAR ;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun eval-var (var state)             ; Evaluates the state of a var (true or nil)
  (cond
    ((null state) nil)                  ; Base case: returns nil when list is empty.
    ((eql var (caar state))             ; If the var is the same...
      (cadar state))                    ; Return the state.
  (t 
    (eval-var var (cdr state))) ) )  ; Recursively call eval-var

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
        (eval-clause (cdr clause) state)) ) )  ; Else, recursively call eval-clause with the rest of clause.
  (t                                          ; If the first element in the clause is a list...
    (cond
      ((not (eval-var (cadar clause) state)) t)     ; If the atom in the list is in the state, evals to true.
    (t 
      (eval-clause (cdr clause) state)) ) ) ) )    ; Else, recursively call eval-clause.

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
(defun get-better-neighbor (clauses state vars num-unsat)
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
    ((null unsat) nil)  ; Base case 1: unsat !empty
    ((<= 0 dist ) nil)  ; Base case 2: dist > 0
  (t
    (let (list vars) (get-all-vars clauses))                                                                       ; Get all the vars of clauses and save them.
    (let (list new_state) (car (get-better-neighbor clauses state vars (length (unsat-clauses clauses state)))))   ; Find a better neighbor and save the state.
    (let (list new_unsat) (unsat-clauses clauses new_state))                                                       ; Find the unsatisfied clauses given the new_state and save them.
    (cond
      ((> unsat length(new_unsat)) simple-hill-climb clauses new_state (dist-1) new_unsat)
      ((null new_unsat) new_state) ) ) ) )