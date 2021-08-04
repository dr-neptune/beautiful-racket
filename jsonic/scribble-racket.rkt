#lang scribble/text

@(define (greet . words)
   (format "Good morning, ~a" (string-append* words)))
@(define surname "Diop")
@greet{Mr. @surname}! How are you?
