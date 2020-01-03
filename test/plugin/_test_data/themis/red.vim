let s:suite = s:helper.suite('_test_data.red')
let s:assert = themis#helper('assert')

function! s:suite.test()
    call s:assert.equals(1, 0)
endfunction
