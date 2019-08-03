
let s:suite = themis#suite('autoload.tdd')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
    call TddTestBeforeEach()
endfunction

function! s:suite.after_each()
    call TddTestAfterEach()
endfunction

let s:STATUS = tdd#all_status()

function! s:test_command_factory(command) abort
    return {-> tdd#model#test_command#new(a:command)}
endfunction

function! s:suite.test_error()
    let Test_command_factory = s:test_command_factory(['hoge'])

    let test = tdd#start_test(Test_command_factory)
    call TddWait(test, s:assert)

    call s:assert.equals(tdd#status(), s:STATUS.RED)
endfunction

function! s:suite.test_fail()
    let Test_command_factory = s:test_command_factory(['test', '-e', 'hoge'])

    let test = tdd#start_test(Test_command_factory)
    call TddWait(test, s:assert)

    call s:assert.equals(tdd#status(), s:STATUS.RED)
endfunction

function! s:suite.test_success()
    let Test_command_factory = s:test_command_factory(['echo'])

    let test = tdd#start_test(Test_command_factory)
    call TddWait(test, s:assert)

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
endfunction

function! s:suite.test_unknown()
    call s:assert.equals(tdd#status(), s:STATUS.UNKNOWN)
endfunction
