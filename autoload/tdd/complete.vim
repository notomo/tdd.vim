
function! tdd#complete#get(current_arg, line, cursor_position) abort
    let option_name = s:parse_option_name(a:current_arg)
    if !empty(option_name)
        let option_values = tdd#config#all_options(option_name)
        let option_key_values = map(option_values, {_, v -> printf('-%s=%s', option_name, v)})
        return join(option_key_values, "\n")
    endif

    let command_names = tdd#command#names() + keys(tdd#config#get_commands())

    let current_options = []
    for factor in split(a:line, '\v\s+')
        let key = s:parse_option_name(factor)
        if empty(key)
            continue
        endif
        call add(current_options, key)
    endfor

    let options = tdd#config#get_options()
    let option_names = keys(options)
    call filter(option_names, {_, v -> count(current_options, v) == 0})
    call map(option_names, {_, v -> printf('-%s=', v)})

    let candidates = command_names + option_names
    return join(candidates, "\n")
endfunction

function! s:parse_option_name(factor) abort
    let key_value = split(a:factor, '=', v:true)
    if len(key_value) != 2
        return ''
    endif
    let [key, _] = key_value
    return key[1:]
endfunction
