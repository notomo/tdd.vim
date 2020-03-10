let s:helper = TestHelper()
let s:suite = s:helper.suite('tree_sitter.cli')
let s:assert = s:helper.assert

function! s:suite.tree_sitter()
    cd ./test/plugin/_test_data/npm/

    call tdd#command#args('tree_sitter/cli', ['help'])

    let test = tdd#main('tree_sitter/cli', '-target=file', '-type=run')
    call test.wait(1000)

    call s:assert.status_green()
endfunction
