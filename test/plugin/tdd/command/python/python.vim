let s:helper = TDDTestHelper()
let s:suite = s:helper.suite('python.python')
let s:assert = s:helper.assert()

function! s:suite.python()
    edit ./test/plugin/_test_data/python/run.py

    let test = tdd#main('python/python', '-target=file', '-type=run')
    call test.wait(10000)

    call s:assert.status_green()
    call s:assert.equals(test.execution.cmd, ['python', 'run.py'])
endfunction
