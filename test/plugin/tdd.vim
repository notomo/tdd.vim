let s:suite = themis#suite('plugin.tdd')
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

function! s:suite.test_green()
    edit ./test/plugin/_test_data/green.vim

    let test = tdd#default_start_test()
    call test.wait(500)

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
endfunction

function! s:suite.test_red()
    edit ./test/plugin/_test_data/red.vim

    let test = tdd#default_start_test()
    call test.wait(500)

    call s:assert.equals(tdd#status(), s:STATUS.RED)
endfunction

function! s:suite.make_default()
    cd ./test/plugin/_test_data

    let test = tdd#default_start_test()
    call test.wait(500)

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
endfunction

function! s:suite.make_args()
    call tdd#config#command('make', ['-f', 'test.mk', '_test'])

    cd ./test/plugin/_test_data

    let test = tdd#default_start_test()
    call test.wait(500)

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
endfunction

function! s:suite.parent_makefile()
    cd ./test/plugin/_test_data/sub

    let test = tdd#default_start_test()
    call test.wait(500)

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
endfunction

function! s:suite.commands()
    call tdd#config#filetype_commands('_', ['npm', 'make'])

    cd ./test/plugin/_test_data

    let test = tdd#default_start_test()
    call test.wait(500)

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
endfunction

function! s:suite.npm()
    call tdd#config#filetype_commands('_', ['npm'])

    cd ./test/plugin/_test_data/npm

    let test = tdd#default_start_test()
    call test.wait(1000)

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
endfunction
