let s:helper = TestHelper()
let s:suite = s:helper.suite('vim.vim')
let s:assert = s:helper.assert

function! s:suite.run()
    edit ./test/plugin/_test_data/vim/run.vim

    let test = tdd#main('vim/vim', '-target=file', '-type=run')
    call test.wait(500)

    call s:assert.status_green()
endfunction
