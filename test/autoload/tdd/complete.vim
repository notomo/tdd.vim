
let s:suite = themis#suite('autoload.tdd.complete')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
    call TddTestBeforeEach()
endfunction

function! s:suite.after_each()
    call TddTestAfterEach()
endfunction

function! s:suite.get()
    let got = tdd#complete#get('', 'TDDStart ', 10)
    let names = split(got, "\n")

    call s:assert.not_equals(count(names, 'make'), 0, '`make` must be in the candidates')
endfunction
