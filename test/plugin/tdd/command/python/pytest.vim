let s:suite = themis#suite('python.pytest')
let s:assert = TddTestAssert()

function! s:suite.before_each()
    call TddTestBeforeEach()
    filetype on
endfunction

function! s:suite.after_each()
    call TddTestAfterEach()
    filetype off
endfunction


function! s:suite.with_init()
    cd ./test/plugin/_test_data/pytest/has_init/test
    edit ./test_main.py

    let test = tdd#main()
    call test.wait(2500)

    call s:assert.status_green()
endfunction

function! s:suite.without_init()
    cd ./test/plugin/_test_data/pytest
    edit ./test_hoge.py

    let test = tdd#main('-target=file')
    call test.wait(2500)

    call s:assert.status_green()
endfunction
