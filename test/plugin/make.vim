let s:suite = themis#suite('plugin.tdd.make')
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

function! s:suite.make()
    cd ./test/plugin/_test_data

    let test = tdd#default_start_test()
    call test.wait(500)

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
endfunction

function! s:suite.args()
    call tdd#config#command('make', ['-f', 'test.mk', '_test'])

    cd ./test/plugin/_test_data

    let test = tdd#default_start_test()
    call test.wait(500)

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
endfunction

function! s:suite.parent_file()
    cd ./test/plugin/_test_data/empty

    let test = tdd#default_start_test()
    call test.wait(500)

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
endfunction
