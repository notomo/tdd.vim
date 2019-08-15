
function! tdd#complete#get(current_arg, line, cursor_position) abort
    let commands = tdd#config#get_commands()
    let command_names = keys(commands)

    let current_options = []
    for factor in split(a:line, '\v\s+')
        let key_value = split(factor, '=', v:true)
        if len(key_value) != 2
            continue
        endif
        let [key, _] = key_value
        call add(current_options, key[1:])
    endfor

    let options = tdd#config#get_options()
    let option_names = keys(options)
    call filter(option_names, {_, v -> count(current_options, v) == 0})
    call map(option_names, {_, v -> printf('-%s=', v)})

    let candidates = command_names + option_names
    return join(candidates, "\n")
endfunction
