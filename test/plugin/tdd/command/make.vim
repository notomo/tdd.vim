let s:suite = themis#suite('make')
let s:assert = TddTestAssert()

function! s:suite.before_each()
    call TddTestBeforeEach()
    filetype on
endfunction

function! s:suite.after_each()
    call TddTestAfterEach()
    filetype off
endfunction


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
