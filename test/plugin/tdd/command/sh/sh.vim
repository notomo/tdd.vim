let s:helper = TestHelper()
let s:suite = s:helper.suite('sh.sh')
let s:assert = s:helper.assert

function! s:suite.sh()
    edit ./test/plugin/_test_data/sh/run.sh

    let test = tdd#main('shell/sh', '-target=file', '-type=run')
    call test.wait(1000)

    call s:assert.status_green()
    call s:assert.equals(test.execution.cmd, ['sh', 'run.sh'])
endfunction
