let s:suite = themis#suite('plugin.tdd')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
    call TddTestBeforeEach()
endfunction

function! s:suite.after_each()
    call TddTestAfterEach()
endfunction

let s:STATUS = tdd#all_status()

function! s:suite.test_green()
    edit ./test/plugin/_test_data/green.vim

    let test = tdd#default_start_test()
    call test.wait(500)

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
endfunction

function! s:suite.test_red()
    edit ./test/plugin/_test_data/red.vim

    let test = tdd#default_start_test()
    call test.wait(500)

    call s:assert.equals(tdd#status(), s:STATUS.RED)
endfunction
