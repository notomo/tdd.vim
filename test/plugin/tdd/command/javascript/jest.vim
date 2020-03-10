let s:helper = TestHelper()
let s:suite = s:helper.suite('javascript.jest')
let s:assert = s:helper.assert

function! s:suite.jest()
    cd ./test/plugin/_test_data/npm/jest
    edit ./main.test.js

    let test = tdd#main('javascript/jest')
    call test.wait(8000)

    call s:assert.status_green()
    call s:assert.equals(test.execution.cmd, ['npx', 'jest'])
endfunction

function! s:suite.file()
    cd ./test/plugin/_test_data/npm/jest
    edit ./main.test.js

    let test = tdd#main('javascript/jest', '-target=file')
    call test.wait(8000)

    call s:assert.status_green()
    call s:assert.equals(test.execution.cmd, ['npx', 'jest', '--', 'jest/main'])
endfunction
