
function! tdd#reset() abort
    let s:cycle = tdd#model#cycle#new()
endfunction

call tdd#reset()

function! tdd#main(...) abort
    let [names, options] = tdd#option#parse(a:000)

    let status_presenter = tdd#presenter#status()

    let output_type = options['output']
    let layout_type = options['layout']
    let output_presenter = tdd#presenter#output(output_type, layout_type)

    let presenter = tdd#presenter#new(status_presenter, output_presenter)

    return tdd#test(names, presenter, options)
endfunction

function! tdd#test(names, presenter, options) abort
    call tdd#logger#new().label('options').log(string(a:options))

    if a:options['last']
        let test = s:cycle.last_test()
        if empty(test)
            return a:presenter.show_error('last test not found')
        endif
        let execution = test.execution
    else
        let [command, err] = tdd#command#factory(a:names)
        if !empty(err)
            return a:presenter.show_error(err)
        endif
        let execution = tdd#model#execution#from_command(command, a:options['target'])
    endif

    let event_service = tdd#model#event#service()

    let test = tdd#model#test#new(execution, a:presenter, event_service)
    call s:cycle.apply(test, event_service)

    call test.start()

    return test
endfunction

function! tdd#status() abort
    return s:cycle.status()
endfunction
