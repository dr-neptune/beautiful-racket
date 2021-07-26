#lang br/quicklang

; reader
(define (read-syntax path port)
  (define src-lines (port->lines port))
  (define src-datums (format-datums '~a src-lines))
  (define module-datum `(module funstacker-mod "funstacker.rkt"
                          (handle-args ,@src-datums)))
  (datum->syntax #f module-datum))
(provide read-syntax)

; expander
(define-macro (funstacker-module-begin HANDLE-ARGS-EXPR)
  #'(#%module-begin
     (display (first HANDLE-ARGS-EXPR))))
(provide (rename-out [funstacker-module-begin #%module-begin]))

; stack replaced by handle-args fn
(define (handle-args . args)                     ; . is a rest argument. Gather the remaining args in a list and assign it this variable
  (for/fold ([stack-acc empty])                  ; basically a for loop with an accumulator. Returns the last value of the accumulator
            ([arg (in-list args)]                ; in-list is a sequence constructor. It is a hint to the compiler that helps it generate more efficient code
             #:unless (void? arg))
    (cond
      [(number? arg) (cons arg stack-acc)]
      [(or (equal? * arg) (equal? + arg))
       (define op-result
         (arg (first stack-acc)
              (second stack-acc)))
       (cons op-result (drop stack-acc 2))])))
(provide handle-args)

(provide + *)
