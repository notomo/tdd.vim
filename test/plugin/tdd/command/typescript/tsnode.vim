let s:helper = TestHelper()
let s:suite = s:helper.suite('typescript.tsnode')
let s:assert = s:helper.assert

function! s:suite.run()
    edit ./test/plugin/_test_data/typescript/tsnode.ts

    let test = tdd#main('typescript/tsnode', '-target=file', '-type=run')
    call test.wait(10000)

    call s:assert.status_green()
endfunction
