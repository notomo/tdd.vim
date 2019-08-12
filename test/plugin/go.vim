let s:suite = themis#suite('plugin.tdd.go')
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

function! s:suite.go()
    edit ./test/plugin/_test_data/go/main_test.go

    let test = tdd#default_start_test()
    call test.wait(1500)

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
endfunction