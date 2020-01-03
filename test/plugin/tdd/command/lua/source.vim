let s:helper = TDDTestHelper()
let s:suite = s:helper.suite('lua.source')
let s:assert = s:helper.assert()

function! s:suite.run()
    edit ./test/plugin/_test_data/lua/run.lua

    let test = tdd#main('lua/source', '-target=file', '-type=run')
    call test.wait(500)

    call s:assert.status_green()
endfunction
