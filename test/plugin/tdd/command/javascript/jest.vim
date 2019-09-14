let s:suite = themis#suite('javascript.jest')
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

function! s:suite.jest()
    cd ./test/plugin/_test_data/npm/jest
    edit ./main.test.js

    let test = tdd#main('jest')
    call test.wait(8000)

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
    call s:assert.equals(test.execution.cmd, ['npx', 'jest'])
endfunction

function! s:suite.file()
    cd ./test/plugin/_test_data/npm/jest
    edit ./main.test.js

    let test = tdd#main('jest', '-target=file')
    call test.wait(8000)

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
    call s:assert.equals(test.execution.cmd, ['npx', 'jest', '--', 'jest/main'])
endfunction
