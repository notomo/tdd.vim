
function! tdd#reset() abort
    let s:cycle = tdd#model#cycle#new()
endfunction

call tdd#reset()

function! tdd#default_start_test() abort
    let options = tdd#config#get_options()
    let buffer_type = options['buffer']
    let presenter = tdd#presenter#new_default(buffer_type)
    return tdd#start_test(function('tdd#command#factory'), presenter)
endfunction

function! tdd#start_test(test_command_factory, presenter) abort
    let test_command = a:test_command_factory()
    let test = tdd#model#test#new(test_command, a:presenter)
    call test.start()

    call s:cycle.apply(test)

    return test
endfunction

function! tdd#status() abort
    return s:cycle.status()
endfunction

function! tdd#all_status() abort
    return s:cycle.STATUS
endfunction
