#lang br/quicklang

; Section: The Reader

;; the reader

;; The reader converts the source code of our language from a string of characters into Racket-style parenthesized forms, aka s-exprs
;; Every reader must export a read-syntax function. (read-syntax path port) path to source file and port for reading data from the file

;; The expander determines how these parenthesized forms correspond to real Racket expressions (which are then evaluated to produce a result)

;; (define (read-syntax path port)
;;   (define src-lines (port->lines port))      ; read source code from the port
;;   (datum->syntax #f '(module lucy br 42)))   ; return code describing a module | a module named lucy, using the expander from br, evaluates the expr 42

;; (provide read-syntax)

;; Currently we're ignoring our input. We'll upgrade our reader to complete 2 new tasks:
;; 1. Wrap each line in a (handle ...) form
;; 2. Insert these new forms into a module we're returning as a syntax object

;; (define (read-syntax path port)
;;   (define src-lines (port->lines port))                                    ; retrieve lines from our input port as a list of strings
;;   (define src-datums (format-datums '(handle ~a) src-lines))               ; takes a list of strings and converts each of them using a format string
;;   (define module-datum `(module stacker-mod "stacker.rkt" ,@src-datums))   ; ,@ unpacks and unquotes a list. ` is quasiquotation (quote + vars)
;;   (datum->syntax #f module-datum))                                         ; convert our datum to a syntax object, passing #f as a context arg

;; (provide read-syntax)

; Section: The Expander

;; To recap - every language in Racket has two essential components:
;; A Reader, which converts source code from a astring of characters into parenthesized s-exprs
;; An Expander, which determines how these s-exprs correspond to real Racket expressions, which are then evaluated to produce a result

(define (read-syntax path port)
  (define src-lines (port->lines port))
  (define src-datums (format-datums '(handle ~a) src-lines))
  (define module-datum `(module stacker-mod "stacker.rkt" ,@src-datums))
  (datum->syntax #f module-datum))

(provide read-syntax)

(define-macro (stacker-module-begin HANDLE-EXPR ...)  ; instead of a function signature, a macro gets defined with a syntax pattern. ... means match each line of the code
  #'(#%module-begin                                   ; #' means make the code into a syntax object
     HANDLE-EXPR ...
     (display (first stack))))                                ; this takes code as input, and wraps it with (#%module-begin)

(provide (rename-out [stacker-module-begin #%module-begin]))

; now we need to implement a stack, with an interface for storing, reading, and doing operations on arguments, that can be used by handle
(define stack empty)

(define (pop-stack!)
  (define arg (first stack))
  (set! stack (rest stack))
  arg)

(define (push-stack! arg)
  (set! stack (cons arg stack)))

; then we need to provide bindings for handle, which figures out what to do with operator arguments
(define (handle [arg #f])                                ; uses a default of #f if not called with an arg
  (cond
    [(number? arg) (push-stack! arg)]
    [(or (equal? + arg) (equal? * arg))
     (define op-result (arg (pop-stack!) (pop-stack!)))
     (push-stack! op-result)]))

(provide handle)
(provide + *)
