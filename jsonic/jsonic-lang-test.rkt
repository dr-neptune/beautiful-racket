#lang jsonic

; test passing valid json returns the same json
[
 null,
 42,
 true,
 ["array", "of", "strings"],
 {
  "key-1": null,
  "key-2": false,
  "key-3": {"subkey": 21}
 }
 ]

; test invalid json fails (3/5 not allowed)
[
 null,
 3/5,
 true,
 ["array", "of", "strings"],
 {
  "key-1": null,
  "key-2": false,
  "key-3": {"subkey": 21}
 }
 ]

; test replacing json with racket sexprs
// a line comment
[
 @$ 'null $@,
 @$ (* 6 7) $@,
 @$ (= 2 (+ 1 1)) $@,
 @$ (list "array" "of" "strings") $@,
 @$ (hash 'key-1 'null
          'key-2 (even? 3)
          'key-3 (hash 'subkey 21)) $@

]

; test racket sexprs fail when translating to invalid json
// a line comment
[
 @$ 'null $@,
 @$ (/ 3 5) $@,
 @$ (= 2 (+ 1 1)) $@,
 @$ (list "array" "of" "strings") $@,
 @$ (hash 'key-1 'null
          'key-2 (even? 3)
          'key-3 (hash 'subkey 21)) $@

]
