let s:suite = themis#suite('python.python')
let s:assert = TddTestAssert()

function! s:suite.before_each()
    call TddTestBeforeEach()
    filetype on
endfunction

function! s:suite.after_each()
    call TddTestAfterEach()
    filetype off
endfunction

function! s:suite.python()
    edit ./test/plugin/_test_data/python/run.py

    let test = tdd#main('python/python', '-target=file', '-type=run')
    call test.wait(10000)

    call s:assert.status_green()
    call s:assert.equals(test.execution.cmd, ['python', 'run.py'])
endfunction
