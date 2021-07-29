#lang br
(require jsonic/parser jsonic/tokenizer brag/support)

; test comment
(parse-to-datum (apply-tokenizer-maker make-tokenizer "// line comment\n"))

; a program with a single sexp between delimiters
(parse-to-datum (apply-tokenizer-maker make-tokenizer "@$ 42 $@"))

; a program without nested delimiters
(parse-to-datum (apply-tokenizer-maker make-tokenizer "hi"))

; a program that contains all of the above
(parse-to-datum (apply-tokenizer-maker make-tokenizer "hi\n// comment\n@$ 42 $@"))

; try a multiline program with a here string
(parse-to-datum (apply-tokenizer-maker make-tokenizer #<<GOGOGO
"foo"
//comment
@$ 42 $@
GOGOGO
                                       ))
