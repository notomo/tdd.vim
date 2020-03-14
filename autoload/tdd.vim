doautocmd User TDDSourceLoad

function! tdd#reset() abort
    let s:cycle = tdd#model#cycle#new()
endfunction

call tdd#reset()

function! tdd#main(...) abort
    let [names, options] = tdd#option#parse(a:000)
    return tdd#test(names, options)
endfunction

function! tdd#test(names, options) abort
    call tdd#logger#new('options').log(a:options)

    let messenger = tdd#messenger#new(a:options.silent)

    if a:options['last']
        let test = s:cycle.last_test()
        if empty(test)
            return messenger.error('last test not found')
        endif
        let execution = test.execution
    else
        let [command, err] = tdd#command#factory(a:names, a:options.type, a:options.args)
        if !empty(err)
            return messenger.error(err)
        endif
        let execution = tdd#model#execution#from_command(command, a:options.target, a:options['extra-args'])
    endif

    let event_service = tdd#model#event#service()

    let test = tdd#model#test#new(execution, messenger, event_service)
    call s:cycle.apply(test, event_service)

    call test.start(a:options.output, a:options.layout)

    return test
endfunction

function! tdd#status() abort
    return s:cycle.status()
endfunction

highlight default link TDDSuccessed Search
highlight default link TDDFailed Todo
