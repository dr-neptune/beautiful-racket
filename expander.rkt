#lang br/quicklang

(define-macro (bf-module-begin PARSE-TREE)
  #'(#%module-begin
     PARSE-TREE))

(provide (rename-out [bf-module-begin #%module-begin]))

(define-macro (bf-program OP-OR-LOOP-ARG ...)
  #'(void OP-OR-LOOP-ARG ...))

(provide bf-program)

(define-macro (bf-loop "[" OP-OR-LOOP-ARG ... "]")
  #'(until (zero? (current-byte))                   ; current-byte will be added in a minute
           OP-OR-LOOP-ARG ...))
(provide bf-loop)

; we haven't made the RHS functions yet, but we will
(define-macro-cases bf-op
  [(bf-op ">") #'(gt)]
  [(bf-op "<") #'(lt)]
  [(bf-op "+") #'(plus)]
  [(bf-op "-") #'(minus)]
  [(bf-op ".") #'(period)]
  [(bf-op ",") #'(comma)])
(provide bf-op)

(define arr (make-vector 30000 0))
(define ptr 0)

; current byte is byte in array at the location indicated by the pointer
(define (current-byte) (vector-ref arr ptr))
(define (set-current-byte! val) (vector-set! arr ptr val))

; operators in our program
(define (gt) (set! ptr (add1 ptr)))
(define (lt) (set! ptr (sub1 ptr)))

(define (plus) (set-current-byte! (add1 (current-byte))))
(define (minus) (set-current-byte! (sub1 (current-byte))))

(define (period) (write-byte (current-byte)))
(define (comma) (write-byte (set-current-byte! (read-byte))))
