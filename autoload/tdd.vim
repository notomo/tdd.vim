
function! tdd#reset() abort
    let s:cycle = tdd#model#cycle#new()
endfunction

call tdd#reset()

function! tdd#default_test(...) abort
    let [names, options] = s:parse_args(a:000)
    call extend(options, tdd#config#get_options(), 'keep')

    let buffer_type = options['buffer']
    let open = options['open']
    let presenter = tdd#presenter#new_default(buffer_type, open)

    let target = options['target']
    let Test_command_factory = { -> tdd#command#factory(target, names)}

    return tdd#test(Test_command_factory, presenter)
endfunction

function! tdd#test(test_command_factory, presenter) abort
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

function! s:parse_args(args) abort
    let names = []
    let options = {}
    for arg in a:args
        if arg[0] !=# '-'
            call add(names, arg)
            continue
        endif

        let key_value = split(arg[1:], '=', v:true)
        if len(key_value) == 2
            let [key, value] = key_value
            let options[key] = value
        endif
    endfor

    return [names, options]
endfunction
