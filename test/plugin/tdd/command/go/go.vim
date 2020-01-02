let s:suite = themis#suite('go.go')
let s:assert = TddTestAssert()

function! s:suite.before_each()
    call TddTestBeforeEach()
    filetype on
endfunction

function! s:suite.after_each()
    call TddTestAfterEach()
    filetype off
endfunction


function! s:suite.go()
    edit ./test/plugin/_test_data/go/main_test.go

    let test = tdd#main()
    call test.wait(10000)

    call s:assert.status_green()
endfunction

function! s:suite.near()
    edit ./test/plugin/_test_data/go/main_test.go
    call search('TestNear')

    let test = tdd#main('go/go', '-target=near')
    call test.wait(10000)

    call s:assert.status_green()
    call s:assert.equals(test.execution.cmd, ['go', 'test', '-v', '-run', 'TestNear'])
endfunction
