#lang br
(require brag/support)

(define-lex-abbrev digits (:+ (char-set "0123456789")))

(define-lex-abbrev reserved-terms (:or "print" "goto" "end" "+" ":" ";" "let"
                                       "=" "input" "-" "*" "/" "^" "mod" "(" ")"
                                       "if" "then" "else" "<" ">" "<>" "and" "or" "not"))

(define basic-lexer
  (lexer-srcloc
   ["\n" (token 'NEWLINE lexeme)]                       ; handle newlines
   [whitespace (token lexeme #:skip? #t)]               ; handle whitespace
   [(from/stop-before "rem" "\n") (token 'REM lexeme)]  ; handle comments "rem"
   [reserved-terms (token lexeme lexeme)]
   [(:seq alphabetic (:* (:or alphabetic numeric "$")))
    (token 'ID (string->symbol lexeme))]
   [digits (token 'INTEGER (string->number lexeme))]    ; handle a single digit
   [(:or (:seq (:? digits) "." digits)                  ; handle compound digit expressions
         (:seq digits "."))
    (token 'DECIMAL (string->number lexeme))]
   [(:or (from/to "\""  "\"") (from/to "'" "'"))        ; handle strings
    (token 'STRING
           (substring lexeme
                      1 (sub1 (string-length lexeme))))]))

(provide basic-lexer)
