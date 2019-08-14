let s:suite = themis#suite('plugin.tdd.themis')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
    call TddTestBeforeEach()
    filetype on
endfunction

function! s:suite.after_each()
    call TddTestAfterEach()
    filetype off
endfunction

let s:STATUS = tdd#all_status()

function! s:suite.green()
    edit ./test/plugin/_test_data/themis/green.vim
    cd ./test/plugin/_test_data/themis

    let test = tdd#default_test('-target=file')
    call s:assert.equals(&buftype, 'terminal')
    call test.wait(500)

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
endfunction

function! s:suite.red()
    edit ./test/plugin/_test_data/themis/red.vim
    cd ./test/plugin/_test_data/themis

    let test = tdd#default_test('-target=file')
    call test.wait(500)

    call s:assert.equals(tdd#status(), s:STATUS.RED)
endfunction

function! s:suite.directory()
    edit ./test/plugin/_test_data/themis/green.vim
    cd ./test/plugin/_test_data/themis

    let test = tdd#default_test('-target=directory')
    call test.wait(500)

    call s:assert.equals(tdd#status(), s:STATUS.RED)
endfunction

function! s:suite.parent_file()
    cd ./test/plugin/_test_data/themis/another/test/empty

    let test = tdd#default_test('themis')
    call test.wait(500)

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
endfunction
