#lang s-exp "stackerizer.rkt"

; instead of making our own reader, we can use Racket's default reader
; which reads S-expressions and thus, is called s-exp
(* 1 2 (+ 3 4 (* 5 6 (+ 7 8 (* 9 10)))))
