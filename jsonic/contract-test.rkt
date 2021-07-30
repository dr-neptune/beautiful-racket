(module our-submod br
  (require racket/contract)
  (define (our-div num denom)
    (/ num denom))
  ; contract-out lets us attach a contract to an exported function
  (provide (contract-out
            ; (number? (not/c zero?) . -> . number?) means input must be a number not zero and output must be a number
            [out-div (number? (not/c zero?) . -> . number?)])))

(require (submod "." our-submod))
(our-div 42 0)
