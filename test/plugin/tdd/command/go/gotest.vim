let s:helper = TestHelper()
let s:suite = s:helper.suite('go.gotest')
let s:assert = s:helper.assert

function! s:suite.go()
    edit ./test/plugin/_test_data/go/main_test.go

    let test = tdd#main()
    call test.wait(10000)

    call s:assert.status_green()
endfunction

function! s:suite.near()
    edit ./test/plugin/_test_data/go/main_test.go
    call search('TestNear')

    let test = tdd#main('go/gotest', '-target=near')
    call test.wait(10000)

    call s:assert.status_green()
    call s:assert.equals(test.execution.cmd, ['go', 'test', '-v', '-run', 'TestNear'])
endfunction
