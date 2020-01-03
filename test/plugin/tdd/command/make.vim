let s:helper = TDDTestHelper()
let s:suite = s:helper.suite('make')
let s:assert = s:helper.assert()

function! s:suite.make()
    cd ./test/plugin/_test_data/make

    let test = tdd#main()
    call test.wait(500)

    call s:assert.status_green()
endfunction

function! s:suite.args()
    call tdd#command#args('make', ['-f', 'test.mk', '_test'])

    cd ./test/plugin/_test_data/make

    let test = tdd#main()
    call test.wait(500)

    call s:assert.status_green()
endfunction

function! s:suite.parent_file()
    cd ./test/plugin/_test_data/make/empty

    let test = tdd#main()
    call test.wait(500)

    call s:assert.status_green()
endfunction
