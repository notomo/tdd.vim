
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

function! s:test_presenter() abort
    let status_presenter = TddTestMock()
    call status_presenter.add_fn('echo')
    let presenter = tdd#presenter#new(status_presenter)
    return presenter
endfunction

function! s:test_emitter() abort
    let emitter = TddTestMock()
    call emitter.add_fn('finish_job')
    return emitter
endfunction

function! s:suite.test_error()
    let Test_command_factory = s:test_command_factory(['hoge'])

    let emitter = s:test_emitter()
    let presenter = s:test_presenter()

    let test = tdd#start_test(Test_command_factory, emitter, presenter)
    call TddWait(test, s:assert)

    call s:assert.equals(tdd#status(), s:STATUS.RED)
    call s:assert.true(presenter.status.called('echo'))
endfunction

function! s:suite.test_fail()
    let Test_command_factory = s:test_command_factory(['test', '-e', 'hoge'])

    let emitter = s:test_emitter()
    let presenter = s:test_presenter()

    let test = tdd#start_test(Test_command_factory, emitter, presenter)
    call TddWait(test, s:assert)

    call s:assert.equals(tdd#status(), s:STATUS.RED)
endfunction

function! s:suite.test_success()
    let Test_command_factory = s:test_command_factory(['echo'])

    let emitter = s:test_emitter()
    let presenter = s:test_presenter()

    let test = tdd#start_test(Test_command_factory, emitter, presenter)
    call TddWait(test, s:assert)

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
endfunction

function! s:suite.test_unknown()
    call s:assert.equals(tdd#status(), s:STATUS.UNKNOWN)
endfunction
