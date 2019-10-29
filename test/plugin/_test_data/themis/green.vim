let s:suite = themis#suite('_test_data.green')
let s:assert = themis#helper('assert')

function! s:suite.test()
    call s:assert.equals(1, 1)
endfunction

function! s:suite.near() abort
    call s:assert.equals(1, 1)
endfunction
