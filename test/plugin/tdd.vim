let s:helper = TestHelper()
let s:suite = s:helper.suite('plugin.tdd')
let s:assert = s:helper.assert

function! s:suite.commands()
    call tdd#command#filetype('_', ['npm', 'make'])

    cd ./test/plugin/_test_data/make

    let messenger = s:helper.messenger()

    let test = tdd#main()
    call test.wait(500)

    call s:assert.status_green()
    call s:assert.tab_count(2)
    call s:assert.true(messenger.called)
    call s:assert.line_number(line('$'))
endfunction

function! s:suite.error()
    call tdd#command#filetype('_', ['make'])
    call tdd#command#args('make', ['error'])

    cd ./test/plugin/_test_data/make

    let test = tdd#main()
    call test.wait(500)

    call s:assert.status_red()
endfunction

function! s:suite.command_alias()
    call tdd#command#alias('make_lint', 'make')
    call tdd#command#args('make_lint', ['lint'])
    call tdd#command#filetype('_', ['make_lint'])

    cd ./test/plugin/_test_data/make

    let test = tdd#main()
    call test.wait()

    call s:assert.status_green()
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

    call s:assert.status_green()
    call s:assert.equals(test.execution.cmd, ['make', 'lint'])
endfunction

function! s:suite.command_args()
    call tdd#command#alias('make_lint', 'make')
    call tdd#command#args('make_lint', ['lint'])

    cd ./test/plugin/_test_data/make

    let test = tdd#main('make_lint')
    call test.wait()

    call s:assert.status_green()
endfunction

function! s:suite.layout()
    call tdd#option#set('layout', 'vertical')

    cd ./test/plugin/_test_data/make
    edit test.mk

    let test = tdd#main()
    call test.wait()

    call s:assert.status_green()
    call s:assert.tab_count(1)
    call s:assert.window_count(2)

    wincmd w
    call s:assert.buffer_name('test.mk')
endfunction

function! s:suite.layout_override()
    call tdd#option#set('layout', 'vertical')

    cd ./test/plugin/_test_data/make

    let test = tdd#main('-layout=tab')
    call test.wait()

    call s:assert.status_green()
    call s:assert.tab_count(2)
endfunction

function! s:suite.last_test_not_found()
    call tdd#main('-last')
    call s:assert.status_unknown()
endfunction

function! s:suite.last_test()
    call tdd#command#filetype('_', ['make'])

    cd ./test/plugin/_test_data/make

    let test = tdd#main()
    call test.wait()

    call s:assert.status_green()

    let test = tdd#main('-last')
    call test.wait()

    call s:assert.status_green()
endfunction

function! s:suite.silent()
    call tdd#command#filetype('_', ['make'])
    cd ./test/plugin/_test_data/make

    let messenger = s:helper.messenger()

    let test = tdd#main('-silent')
    call test.wait()

    call s:assert.status_green()
    call s:assert.false(messenger.called)
endfunction
