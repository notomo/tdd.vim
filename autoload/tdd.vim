
function! tdd#reset() abort
    let s:cycle = tdd#model#cycle#new()
endfunction

call tdd#reset()

function! tdd#default_test(...) abort
    let [names, options] = s:parse_args(a:000)
    call extend(options, tdd#config#get_options(), 'keep')

    let status_presenter = tdd#presenter#status()

    let output_type = options['output']
    let layout_type = options['layout']
    let log_type = options['log']
    let output_presenter = tdd#presenter#output(output_type, layout_type, log_type)

    let presenter = tdd#presenter#new(status_presenter, output_presenter)

    let [command, args] = tdd#command#factory(names)
    let execution = tdd#model#execution#from_command(command, args, options['target'])

    return tdd#test(execution, presenter)
endfunction

function! tdd#test(execution, presenter) abort
    let test = tdd#model#test#new(a:execution, a:presenter)
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
