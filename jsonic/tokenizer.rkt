#lang br/quicklang
(require brag/support)

(define (make-tokenizer port)
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
(provide make-tokenizer)
