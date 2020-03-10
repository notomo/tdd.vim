let s:helper = TestHelper()
let s:suite = s:helper.suite('vim.execute')
let s:assert = s:helper.assert

function! s:suite.run()
    call tdd#command#alias('messages', 'vim/execute')
    call tdd#command#args('messages', ['messages'])

    " add to message history
    echomsg 'run'

    let test = tdd#main('messages', '-target=file', '-type=run')
    call test.wait(500)

    call s:assert.status_green()
    call s:assert.equals(test.execution.cmd, ['messages'])
endfunction

function! s:suite.red()
    call tdd#command#alias('invalid', 'vim/execute')
    call tdd#command#args('invalid', ['invalid_command'])

    let test = tdd#main('invalid', '-target=file', '-type=run')
    call test.wait(500)

    call s:assert.status_red()
endfunction
