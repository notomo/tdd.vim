let s:helper = TestHelper()
let s:suite = s:helper.suite('lua.vusted')
let s:assert = s:helper.assert

function! s:suite.run()
    edit ./test/plugin/_test_data/lua/test.lua

    let test = tdd#main('lua/vusted', '-target=file')
    call test.wait(3000)

    call s:assert.status_green()
endfunction
