let s:helper = TestHelper()
let s:suite = s:helper.suite('lua.busted')
let s:assert = s:helper.assert

function! s:suite.run()
    edit ./test/plugin/_test_data/lua/test.lua

    let test = tdd#main('lua/busted', '-target=file')
    call test.wait(1000)

    call s:assert.status_green()
endfunction

function! s:suite.near()
    edit ./test/plugin/_test_data/lua/test.lua
    call search('near')
    let path = expand('%:p:h')

    let test = tdd#main('lua/busted', '-target=near')
    call test.wait(1000)

    call s:assert.status_green()
    call s:assert.equals(test.execution.cmd, ['busted', '--filter=^test near it$', '--pattern=^test', path])
endfunction
