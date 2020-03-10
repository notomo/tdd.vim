let s:helper = TestHelper()
let s:suite = s:helper.suite('autoload.tdd.complete')
let s:assert = s:helper.assert

let s:_cursor_position = 8888

function! s:suite.get()
    let got = tdd#complete#get('', 'TDDTest -target=file ', s:_cursor_position)
    let names = split(got, "\n")

    call themis#log('[log] ' . string(names))

    call s:assert.contains(names, 'make')
    call s:assert.contains(names, '-layout=')
    call s:assert.not_contains(names, '-target=file')
    call s:assert.not_contains(names, '_alias')
    call s:assert.not_contains(names, '_default')
    call s:assert.contains(names, '-last')
endfunction

function! s:suite.option_key()
    let got = tdd#complete#get('-la', 'TDDTest -la', s:_cursor_position)
    let names = split(got, "\n")

    call themis#log('[log] ' . string(names))

    call s:assert.contains(names, '-last')
endfunction

function! s:suite.key_option_already_exists()
    let got = tdd#complete#get('', 'TDDTest -last ', s:_cursor_position)
    let names = split(got, "\n")

    call themis#log('[log] ' . string(names))

    call s:assert.not_contains(names, '-last')
endfunction

function! s:suite.get_option_values()
    let got = tdd#complete#get('-target=', 'TDDTest -target=', s:_cursor_position)
    let names = split(got, "\n")

    call themis#log('[log] ' . string(names))

    call s:assert.contains(names, '-target=file')
endfunction

function! s:suite.get_with_option_prefix()
    let got = tdd#complete#get('-', 'TDDTest -', s:_cursor_position)
    let names = split(got, "\n")

    call themis#log('[log] ' . string(names))

    call s:assert.contains(names, 'make')
    call s:assert.contains(names, '-layout=')
endfunction

function! s:suite.get_with_invalid_key_value()
    let got = tdd#complete#get('-=', 'TDDTest -=', s:_cursor_position)
    let names = split(got, "\n")

    call themis#log('[log] ' . string(names))

    call s:assert.contains(names, 'make')
endfunction

function! s:suite.get_with_multiple_equals()
    let got = tdd#complete#get('-key=v=v', 'TDDTest -key=v=v', s:_cursor_position)
    let names = split(got, "\n")

    call themis#log('[log] ' . string(names))

    call s:assert.contains(names, 'make')
endfunction
