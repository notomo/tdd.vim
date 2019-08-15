
let s:suite = themis#suite('autoload.tdd.complete')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
    call TddTestBeforeEach()
endfunction

function! s:suite.after_each()
    call TddTestAfterEach()
endfunction

function! s:suite.get()
    let got = tdd#complete#get('', 'TDDTest -log=themis ', 20)
    let names = split(got, "\n")

    call themis#log('[log] ' . string(names))
    call s:assert.not_equals(count(names, 'make'), 0, '`make` must be in the candidates')
    call s:assert.not_equals(count(names, '-open='), 0, '`-open=` must be in the candidates')
    call s:assert.equals(count(names, '-log='), 0, '`-log=` must not be in the candidates')
endfunction
