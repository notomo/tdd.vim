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

let s:STATUS = tdd#model#cycle#all_status()

function! s:suite.commands()
    call tdd#command#filetype('_', ['npm', 'make'])

    cd ./test/plugin/_test_data/make

    let test = tdd#main()
    call test.wait(500)

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
    call s:assert.equals(tabpagenr('$'), 2)
endfunction

function! s:suite.error()
    call tdd#command#filetype('_', ['make'])
    call tdd#command#args('make', ['error'])

    cd ./test/plugin/_test_data/make

    let test = tdd#main()
    call test.wait(500)

    call s:assert.equals(tdd#status(), s:STATUS.RED)
endfunction

function! s:suite.command_alias()
    call tdd#command#alias('make_lint', 'make')
    call tdd#command#args('make_lint', ['lint'])
    call tdd#command#filetype('_', ['make_lint'])

    cd ./test/plugin/_test_data/make

    let test = tdd#main()
    call test.wait()

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
endfunction

function! s:suite.has_null_alias()
    call tdd#command#alias('npm_lint', 'npm')
    call tdd#command#args('npm_lint', ['lint'])
    call tdd#command#alias('make_lint', 'make')
    call tdd#command#args('make_lint', ['lint'])
    call tdd#command#filetype('_', ['make_lint'])

    cd ./test/plugin/_test_data/make

    let test = tdd#main('npm_lint', 'make_lint')
    call test.wait()

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
    call s:assert.equals(test.execution.cmd, ['make', 'lint'])
endfunction

function! s:suite.command_args()
    call tdd#command#alias('make_lint', 'make')
    call tdd#command#args('make_lint', ['lint'])

    cd ./test/plugin/_test_data/make

    let test = tdd#main('make_lint')
    call test.wait()

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
endfunction

function! s:suite.layout()
    call tdd#option#set('layout', 'vertical')

    cd ./test/plugin/_test_data/make
    edit test.mk

    let test = tdd#main()
    call test.wait()

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
    call s:assert.equals(tabpagenr('$'), 1)
    call s:assert.equals(tabpagewinnr(tabpagenr(), '$'), 2)

    wincmd w
    call s:assert.equals(expand('%'), 'test.mk')
endfunction

function! s:suite.layout_override()
    call tdd#option#set('layout', 'vertical')

    cd ./test/plugin/_test_data/make

    let test = tdd#main('-layout=tab')
    call test.wait()

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
    call s:assert.equals(tabpagenr('$'), 2)
endfunction

function! s:suite.last_test_not_found()
    call tdd#main('-last')
    call s:assert.equals(tdd#status(), s:STATUS.UNKNOWN)
endfunction

function! s:suite.last_test()
    call tdd#command#filetype('_', ['make'])

    cd ./test/plugin/_test_data/make

    let test = tdd#main()
    call test.wait()

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)

    let test = tdd#main('-last')
    call test.wait()

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
endfunction
