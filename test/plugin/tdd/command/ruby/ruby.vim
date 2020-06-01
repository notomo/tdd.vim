let s:helper = TestHelper()
let s:suite = s:helper.suite('ruby.ruby')
let s:assert = s:helper.assert

function! s:suite.ruby()
    edit ./test/plugin/_test_data/ruby/run.rb

    let test = tdd#main('ruby/ruby', '-target=file', '-type=run')
    call test.wait(10000)

    call s:assert.status_green()
    call s:assert.equals(test.execution.cmd, ['ruby', 'run.rb'])
endfunction
