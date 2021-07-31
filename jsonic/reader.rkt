#lang br/quicklang
(require "tokenizer.rkt" "parser.rkt" racket/contract)

; takes any for path and a port for port and returns syntax
(define (read-syntax path port)
  (define parse-tree (parse path (make-tokenizer port)))
  (define module-datum `(module jsonic-module jsonic/expander ,parse-tree))
  (datum->syntax #f module-datum))

(provide (contract-out
          [read-syntax (any/c input-port? . -> . syntax?)]))
