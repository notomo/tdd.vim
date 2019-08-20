let s:suite = themis#suite('plugin.tdd.pytest')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
    call TddTestBeforeEach()
    filetype on
endfunction

function! s:suite.after_each()
    call TddTestAfterEach()
    filetype off
endfunction

let s:STATUS = tdd#all_status()

function! s:suite.pytest()
    edit ./test/plugin/_test_data/pytest/test/test_main.py

    let test = tdd#default_test()
    call test.wait(2500)

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
endfunction
