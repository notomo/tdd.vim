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

let s:STATUS = tdd#model#cycle#all_status()

function! s:suite.go()
    edit ./test/plugin/_test_data/go/main_test.go

    let test = tdd#main()
    call test.wait(5000)

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
endfunction

function! s:suite.near()
    edit ./test/plugin/_test_data/go/main_test.go
    call search('TestNear')

    let test = tdd#main('go', '-target=near')
    call test.wait(5000)

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
    call s:assert.equals(test.execution.cmd, ['go', 'test', '-v', '-run', 'TestNear'])
endfunction
