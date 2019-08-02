
function! tdd#reset() abort
    let s:cycle = tdd#model#cycle#new()
endfunction

call tdd#reset()

function! tdd#default_start_test() abort
    let executable = 'themis'
    let file_path = expand('%:p')
    return tdd#start_test({-> tdd#model#test_command#new([executable, file_path])})
endfunction

function! tdd#start_test(test_command_factory) abort
    let test_command = a:test_command_factory()
    let test = tdd#model#test#new(test_command)
    call test.start()

    call s:cycle.apply(test)

    return test
endfunction

function! tdd#status() abort
    return s:cycle.status()
endfunction

function! tdd#all_cycle_status() abort
    return s:cycle.STATUS
endfunction
