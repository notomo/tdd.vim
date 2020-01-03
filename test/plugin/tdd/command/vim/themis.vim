let s:helper = TDDTestHelper()
let s:suite = s:helper.suite('vim.themis')
let s:assert = s:helper.assert()

function! s:suite.green()
    edit ./test/plugin/_test_data/themis/green.vim
    cd ./test/plugin/_test_data/themis

    let test = tdd#main('-target=file')
    call s:assert.equals(&buftype, 'terminal')
    call test.wait(500)

    call s:assert.status_green()
endfunction

function! s:suite.red()
    edit ./test/plugin/_test_data/themis/red.vim
    cd ./test/plugin/_test_data/themis

    let test = tdd#main('-target=file')
    call test.wait(500)

    call s:assert.status_red()
endfunction

function! s:suite.directory()
    edit ./test/plugin/_test_data/themis/green.vim
    cd ./test/plugin/_test_data/themis

    let test = tdd#main('-target=directory')
    call test.wait(500)

    call s:assert.status_red()
endfunction

function! s:suite.parent_file()
    cd ./test/plugin/_test_data/themis/another/test/empty

    let test = tdd#main('vim/themis')
    call test.wait(500)

    call s:assert.status_green()
endfunction

function! s:suite.near()
    edit ./test/plugin/_test_data/themis/green.vim
    call search('s:suite.near')
    let file_path = expand('%:p')

    let test = tdd#main('vim/themis', '-target=near')
    call test.wait(500)

    call s:assert.status_green()
    call s:assert.equals(test.execution.cmd, ['themis', '--target', 'near', file_path])
endfunction
