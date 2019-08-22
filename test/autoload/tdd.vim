
let s:suite = themis#suite('autoload.tdd')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
    call TddTestBeforeEach()
endfunction

function! s:suite.after_each()
    call TddTestAfterEach()
endfunction

let s:STATUS = tdd#all_status()

function! s:command(command, cd) abort
    return tdd#model#test_command#new(a:command, a:cd)
endfunction

function! s:presenter() abort
    let status_presenter = TddTestMock()
    call status_presenter.add_fn('echo')
    let output_presenter = tdd#presenter#output('', '', 'themis')
    return tdd#presenter#new(status_presenter, output_presenter)
endfunction

function! s:suite.test_error()
    let command = s:command(['hoge'], '.')

    let presenter = s:presenter()

    let test = tdd#test(command, presenter)
    call test.wait()

    call s:assert.equals(tdd#status(), s:STATUS.RED)
    call s:assert.true(presenter.status.called('echo'))
endfunction

function! s:suite.test_fail()
    let command = s:command(['test', '-e', 'hoge'], '.')

    let presenter = s:presenter()

    let test = tdd#test(command, presenter)
    call test.wait()

    call s:assert.equals(tdd#status(), s:STATUS.RED)
    call s:assert.true(presenter.status.called('echo'))
endfunction

function! s:suite.test_success()
    let command = s:command(['echo'], '.')

    let presenter = s:presenter()

    let test = tdd#test(command, presenter)
    call test.wait()

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
    call s:assert.true(presenter.status.called('echo'))
endfunction

function! s:suite.test_cd()
    let command = s:command(['test', '-e', '.themisrc'], './test')

    let presenter = s:presenter()

    let test = tdd#test(command, presenter)
    call test.wait()

    call s:assert.equals(tdd#status(), s:STATUS.GREEN)
    call s:assert.true(presenter.status.called('echo'))
endfunction

function! s:suite.test_unknown()
    call s:assert.equals(tdd#status(), s:STATUS.UNKNOWN)
endfunction
