let s:helper = TDDTestHelper()
let s:suite = s:helper.suite('npm')
let s:assert = s:helper.assert()

function! s:suite.npm()
    call tdd#command#filetype('_', ['npm'])

    cd ./test/plugin/_test_data/npm

    let test = tdd#main()
    call test.wait(2000)

    call s:assert.status_green()
endfunction
