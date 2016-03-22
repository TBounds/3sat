Common Lisp 3SAT solver using simple hill climbing.

Name: Tyler Bounds
Email: tyler.bounds@wsu.edu

Description:
    This program is a solution to the 3-SAT problem. Given a set of boolean 
    variables and a boolean expression written in conjuctive normal form with 3 
    variables per clause, this program utilizes 8 functions to determine if there 
    is some assignment of true and false for each variable that solves the entire 
    expression.

README.txt ........... This file.
3sat.lisp ............ Lisp functions required by the project.
t/00-readme.t ........ Checks README for name, email, etc
t/01-3sat.t .......... Checks 3sat.lisp for correctness
.gitlab-ci.yml ....... Contains metadata for GitLab CI
.proverc ............. Configuration file for tests
lib/quicklisp.lisp ... Package manager (used in tests)