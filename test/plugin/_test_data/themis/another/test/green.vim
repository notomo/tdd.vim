let s:suite = themis#suite('_test_data.green')
let s:assert = TddTestAssert()

function! s:suite.test()
    call s:assert.equals(1, 1)
endfunction
