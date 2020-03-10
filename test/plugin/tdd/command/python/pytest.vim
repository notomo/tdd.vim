let s:helper = TestHelper()
let s:suite = s:helper.suite('python.pytest')
let s:assert = s:helper.assert

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
