let s:helper = TestHelper()
let s:suite = s:helper.suite('rust.cargo')
let s:assert = s:helper.assert

function! s:suite.cargo()
    cd ./test/plugin/_test_data/rust/hoge/src
    edit ./main.rs

    let test = tdd#main('rust/cargo', '-type=run')
    call test.wait(2000)

    call s:assert.status_green()
endfunction
