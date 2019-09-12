
function! tdd#reset() abort
    let s:cycle = tdd#model#cycle#new()
endfunction

call tdd#reset()

function! tdd#main(...) abort
    let [names, options] = tdd#util#parse_args(a:000)
    call extend(options, tdd#config#get_options(), 'keep')

    let status_presenter = tdd#presenter#status()

    let output_type = options['output']
    let layout_type = options['layout']
    let log_type = options['log']
    let output_presenter = tdd#presenter#output(output_type, layout_type, log_type)

    let presenter = tdd#presenter#new(status_presenter, output_presenter)

    if options['last']
        let test = s:cycle.last_test()
        if empty(test)
            echohl ErrorMsg | echo 'last test not found' | echohl None | return
        endif
        let execution = test.execution
    else
        let command = tdd#command#factory(names)
        let execution = tdd#model#execution#from_command(command, options['target'])
    endif

    return tdd#test(execution, presenter)
endfunction

function! tdd#test(execution, presenter) abort
    let event_service = tdd#model#event#service(a:presenter)

    let test = tdd#model#test#new(a:execution, a:presenter, event_service)
    call s:cycle.apply(test, event_service)

    call test.start()

    return test
endfunction

function! tdd#status() abort
    return s:cycle.status()
endfunction
