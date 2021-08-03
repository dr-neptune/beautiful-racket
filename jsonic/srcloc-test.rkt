#lang racket

(define stx #'foobar)
(syntax-position stx)
(syntax-line stx)
(syntax-column stx)
(syntax-span stx)
