#lang br/quicklang
(require brag/support racket/contract)

(module+ test
  (require rackunit))

(define (jsonic-token? x)
  (or (eof-object? x)
      (token-struct? x)))

(module+ test
  (check-true (jsonic-token? eof))
  (check-true (jsonic-token? (token 'A-TOKEN-STRUCT "hi")))
  (check-false (jsonic-token? 42)))

; make-tokenizer takes an input-port
(define (make-tokenizer port)
  (port-count-lines! port)  ; turn on line and column counting
  ; next-token takes nothing and returns either EOF or a token-structure
  (define (next-token)
    (define jsonic-lexer
      (lexer
       ; add rules
       [(from/to "//" "\n") (next-token)]  ; handles line comments. ignore everything from // to the new line. once we have the match, ignore it by calling next-token
       [(from/to "@$" "$@")
        (token 'SEXP-TOK (trim-ends "@$" lexeme "$@")  ; takes in sexpression tokens
               #:position (+ (pos lexeme-start) 2)  ; adjust to account for delimiter spacing
               #:line (line lexeme-start)
               #:column (+ (col lexeme-start) 2)
               #:span (- (pos lexeme-end)
                         (pos lexeme-start) 4))]
       [any-char (token 'CHAR-TOK lexeme ; handles tokens not processed by the above
                        #:position (pos lexeme-start)
                        #:line (line lexeme-start)
                        #:column (col lexeme-start)
                        #:span (- (pos lexeme-end)
                                  (pos lexeme-start)))]))
    (jsonic-lexer port))
  next-token)

(provide (contract-out
          [make-tokenizer (input-port? . -> . (-> jsonic-token?))]))

(module+ test
  (check-equal?
   (apply-tokenizer-maker make-tokenizer "// comment\n")
   empty)
  (check-equal?
   (apply-tokenizer-maker make-tokenizer "@$ (+ 6 7) $@")
   (list (token'SEXP-TOK " (+ 6 7) "
                         #:position 3
                         #:line 1
                         #:column 2
                         #:span 9)))
  (check-equal?
   (apply-tokenizer-maker make-tokenizer "hi")
   (list (token 'CHAR-TOK "h"
                       #:position 1
                       #:line 1
                       #:column 0
                       #:span 1)
         (token 'CHAR-TOK "i"
                #:position 2
                #:line 1
                #:column 1
                #:span 1))))
