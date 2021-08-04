#lang scribble/manual
@(require (for-label json))

@title{jsonic: because JSON is boring}
@author{Roxy Lexington}

@defmodulelang[jsonic]

@section{Introduction}

This is a domain specific language that relies on the @racketmodname[json] library.
In particular, the @racket[jsexpr->string] function.
