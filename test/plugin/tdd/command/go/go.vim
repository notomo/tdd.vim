let s:helper = TestHelper()
let s:suite = s:helper.suite('go.go')
let s:assert = s:helper.assert

function! s:suite.go()
    edit ./test/plugin/_test_data/go/main.go

    let test = tdd#main('go/go', '-target=file', '-type=run')
    call test.wait(10000)

    call s:assert.status_green()
    call s:assert.equals(test.execution.cmd, ['go', 'run', 'main.go'])
endfunction
