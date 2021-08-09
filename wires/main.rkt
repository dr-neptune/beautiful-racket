#lang br/quicklang

(module+ reader
  (provide read-syntax))

; the reader
(define (read-syntax path port)
  (define wire-datums
    (for/list ([wire-str (in-lines port)])
      (format-datum '(wire ~a) wire-str)))
  (strip-bindings
   #`(module wires-mod wires/main
       #,@wire-datums)))

; the expander
(provide #%module-begin)

;; our first macro will handle the (wire ...) datums that are emitted from the reader
(define-macro-cases wire
  [(wire ARG -> ID)
   #'(define/display (ID) (val ARG))]
  [(wire OP ARG -> ID)
   #'(wire ARG1 OP ARG2 -> ID)]
  [(wire ARG1 OP ARG2 -> ID)
   #'(wire (OP (val ARG1) (val ARG2)) -> ID)]
  [else #'(void)])

;; now we can write our helper macros
(define-macro (define/display (ID) BODY)
  #'(begin
      (define (ID) BODY)
      (module+ main
        (displayln (format "~a: ~a" 'ID (ID))))))

; if number, pass through. if wire function, call it
(define val
  (let ([val-cache (make-hash)])
    (lambda (num-or-wire)
      (if (number? num-or-wire)
          num-or-wire
          (hash-ref! val-cache num-or-wire num-or-wire)))))

; implement bitwise operations that only operate on 16-bit values
(define (mod-16bit x) (modulo x 65536))
(define-macro (define-16bit ID PROC-ID)
  #'(define ID (compose1 mod-16bit PROC-ID)))

(define-16bit AND bitwise-and)
(define-16bit OR bitwise-ior)
(define-16bit NOT bitwise-not)
(define-16bit LSHIFT arithmetic-shift)
(define (RSHIFT x y) (LSHIFT x (- y)))
(provide AND OR NOT LSHIFT RSHIFT)

#lang br/quicklang

(module+ reader
  (provide read-syntax))

; the reader
(define (read-syntax path port)
  (define wire-datums
    (for/list ([wire-str (in-lines port)])
      (format-datum '(wire ~a) wire-str)))
  (strip-bindings
   #`(module wires-mod wires/main
       #,@wire-datums)))

; the expander
(provide #%module-begin)

;; our first macro will handle the (wire ...) datums that are emitted from the reader
(define-macro-cases wire
  [(wire ARG -> ID)
   #'(define/display (ID) (val ARG))]
  [(wire OP ARG -> ID)
   #'(wire ARG1 OP ARG2 -> ID)]
  [(wire ARG1 OP ARG2 -> ID)
   #'(wire (OP (val ARG1) (val ARG2)) -> ID)]
  [else #'(void)])

;; now we can write our helper macros
(define-macro (define/display (ID) BODY)
  #'(begin
      (define (ID) BODY)
      (module+ main
        (displayln (format "~a: ~a" 'ID (ID))))))

; if number, pass through. if wire function, call it
(define val
  (let ([val-cache (make-hash)])
    (lambda (num-or-wire)
      (if (number? num-or-wire)
          num-or-wire
          (hash-ref! val-cache num-or-wire num-or-wire)))))

; implement bitwise operations that only operate on 16-bit values
(define (mod-16bit x) (modulo x 65536))
(define-macro (define-16bit ID PROC-ID)
  #'(define ID (compose1 mod-16bit PROC-ID)))

(define-16bit AND bitwise-and)
(define-16bit OR bitwise-ior)
(define-16bit NOT bitwise-not)
(define-16bit LSHIFT arithmetic-shift)
(define (RSHIFT x y) (LSHIFT x (- y)))
(provide AND OR NOT LSHIFT RSHIFT)
