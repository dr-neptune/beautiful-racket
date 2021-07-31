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
  ; next-token takes nothing and returns either EOF or a token-structure
  (define (next-token)
    (define jsonic-lexer
      (lexer
       ; add rules
       [(from/to "//" "\n") (next-token)]  ; handles line comments. ignore everything from // to the new line. once we have the match, ignore it by calling next-token
       [(from/to "@$" "$@") (token 'SEXP-TOK (trim-ends "@$" lexeme "$@"))]  ; takes in sexpression tokens
       [any-char (token 'CHAR-TOK lexeme)]  ; handles tokens not processed by the above
       ))
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
   (list (token-struct 'SEXP-TOK " (+ 6 7) " #f #f #f #f #f)))
  (check-equal?
   (apply-tokenizer-maker make-tokenizer "hi")
   (list (token-struct 'CHAR-TOK "h" #f #f #f #f #f)
         (token-struct 'CHAR-TOK "i" #f #f #f #f #f))))
