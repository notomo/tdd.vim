let s:helper = TDDTestHelper()
let s:suite = s:helper.suite('rust.cargotest')
let s:assert = s:helper.assert()

function! s:suite.cargo()
    cd ./test/plugin/_test_data/rust/hoge/src
    edit ./main.rs

    let test = tdd#main()
    call test.wait(2000)

    call s:assert.status_green()
endfunction
