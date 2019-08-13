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
    cd ./test/plugin/_test_data/

    let test = tdd#default_test('-target=file')
    call s:assert.equals(&buftype, 'terminal')
    call test.wait(500)

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
endfunction

function! s:suite.test_red()
    edit ./test/plugin/_test_data/red.vim
    cd ./test/plugin/_test_data/

    let test = tdd#default_test('-target=file')
    call test.wait(500)

    call s:assert.equals(tdd#status(), s:STATUS.RED)
endfunction

function! s:suite.commands()
    call tdd#config#filetype_commands('_', ['npm', 'make'])

    cd ./test/plugin/_test_data

    let test = tdd#default_test()
    call test.wait(500)

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
endfunction

function! s:suite.command_alias()
    call tdd#config#command_alias('make_lint', 'make')
    call tdd#config#command('make_lint', ['lint'])
    call tdd#config#filetype_commands('_', ['make_lint'])

    cd ./test/plugin/_test_data

    let test = tdd#default_test()
    call test.wait()

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
endfunction

function! s:suite.command_args()
    call tdd#config#command_alias('make_lint', 'make')
    call tdd#config#command('make_lint', ['lint'])

    cd ./test/plugin/_test_data

    let test = tdd#default_test('make_lint')
    call test.wait()

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
endfunction

function! s:suite.open_command()
    call tdd#config#option('open', 'vsplit')

    cd ./test/plugin/_test_data

    let test = tdd#default_test()
    call test.wait()

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
    call s:assert.equals(tabpagenr('$'), 1)
    call s:assert.equals(tabpagewinnr(tabpagenr(), '$'), 2)
endfunction

function! s:suite.open_command_override()
    call tdd#config#option('open', 'vsplit')

    cd ./test/plugin/_test_data

    let test = tdd#default_test('-open=tabedit')
    call test.wait()

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
    call s:assert.equals(tabpagenr('$'), 2)
endfunction
