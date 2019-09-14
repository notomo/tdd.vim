let s:suite = themis#suite('vim.themis')
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

function! s:suite.green()
    edit ./test/plugin/_test_data/themis/green.vim
    cd ./test/plugin/_test_data/themis

    let test = tdd#main('-target=file')
    call s:assert.equals(&buftype, 'terminal')
    call test.wait(500)

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
endfunction

function! s:suite.red()
    edit ./test/plugin/_test_data/themis/red.vim
    cd ./test/plugin/_test_data/themis

    let test = tdd#main('-target=file')
    call test.wait(500)

    call s:assert.equals(tdd#status(), s:STATUS.RED)
endfunction

function! s:suite.directory()
    edit ./test/plugin/_test_data/themis/green.vim
    cd ./test/plugin/_test_data/themis

    let test = tdd#main('-target=directory')
    call test.wait(500)

    call s:assert.equals(tdd#status(), s:STATUS.RED)
endfunction

function! s:suite.parent_file()
    cd ./test/plugin/_test_data/themis/another/test/empty

    let test = tdd#main('themis')
    call test.wait(500)

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
endfunction

function! s:suite.near()
    edit ./test/plugin/_test_data/themis/green.vim
    call search('s:suite.near')
    let file_path = expand('%:p')

    let test = tdd#main('themis', '-target=near')
    call test.wait(500)

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
    call s:assert.equals(test.execution.cmd, ['themis', '--target', 'near', file_path])
endfunction
