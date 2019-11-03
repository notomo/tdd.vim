let s:suite = themis#suite('rust.cargo')
let s:assert = TddTestAssert()

function! s:suite.before_each()
    call TddTestBeforeEach()
    filetype on
endfunction

function! s:suite.after_each()
    call TddTestAfterEach()
    filetype off
endfunction


function! s:suite.cargo()
    cd ./test/plugin/_test_data/rust/hoge/src
    edit ./main.rs

    let test = tdd#main()
    call test.wait(2000)

    call s:assert.status_green()
endfunction
