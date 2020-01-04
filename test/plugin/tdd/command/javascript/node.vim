let s:helper = TDDTestHelper()
let s:suite = s:helper.suite('javascript.node')
let s:assert = s:helper.assert()

function! s:suite.run()
    edit ./test/plugin/_test_data/javascript/node.js

    let test = tdd#main('javascript/node', '-target=file', '-type=run')
    call test.wait(500)

    call s:assert.status_green()
endfunction
