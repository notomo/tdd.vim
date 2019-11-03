let s:suite = themis#suite('npm')
let s:assert = TddTestAssert()

function! s:suite.before_each()
    call TddTestBeforeEach()
    filetype on
endfunction

function! s:suite.after_each()
    call TddTestAfterEach()
    filetype off
endfunction


function! s:suite.npm()
    call tdd#command#filetype('_', ['npm'])

    cd ./test/plugin/_test_data/npm

    let test = tdd#main()
    call test.wait(2000)

    call s:assert.status_green()
endfunction
