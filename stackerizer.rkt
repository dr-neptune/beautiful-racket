#lang br/quicklang

; This is a way to convert Racket code into code for another language
; as a demo, we'll make stackerizer, a language that converts certain Racket sexps into a stacker program

; we will be using s-exp for a reader, so we can skip the reader
; we cannot skip the expander however

; the expander

;; simplifying a variadic function
; in stackerizer, our + and * operations will take any # of args (variadic), whereas in stacker they only take 2 args (dyadic)
; our first challenge is to figure out how to decompose a call to a variadic function into some combination of calls to a dyadic function

(provide + *)

(define-macro (stackerizer-mb EXPR)
  #'(#%module-begin
     (for-each displayln (reverse (flatten EXPR)))))
(provide (rename-out [stackerizer-mb #%module-begin]))

;; (define-macro-cases +                                       ; like a macro but with cond clauses
;;   [(+ FIRST) #'FIRST]                                       ; handles single argument addition
;;   [(+ FIRST NEXT ...) #'(list '+ FIRST (+ NEXT ...))])      ; (+ 1 2 3 ...) -> (+ 1 (+ 2 (+ 3 (+ ...))))

; make a macro that makes macros
;; (define-macro (define-op OP)
;;   #'(define-macro-cases OP
;;       [(OP FIRST) #'FIRST]
;;       [(OP FIRST NEXT (... ...))
;;        #'(list 'OP FIRST (OP NEXT (... ...)))]))               ; the double ... escapes the ... (... pat) escapes all ellipses that appear within pat

;; (define-op +)
;; (define-op *)

(define-macro (define-ops OP ...)
  #'(begin                                                     ; the (begin ...) form is a way to group multiple expressions into one
      (define-macro-cases OP  ; `OP` from `OP ...`
        [(OP FIRST) #'FIRST]
        [(OPO FIRST NEXT (... ...))
         #'(list 'OP FIRST (OP NEXT (... ...)))])
      ...))  ; `...` from `OP ...`

(define-ops + *)
