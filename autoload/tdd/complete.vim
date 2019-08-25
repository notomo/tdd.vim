
function! tdd#complete#get(current_arg, line, cursor_position) abort
    let option_name = s:parse_option_name(a:current_arg)
    if !empty(option_name)
        let option_values = tdd#config#all_options(option_name)
        let option_key_values = map(option_values, {_, v -> printf('-%s=%s', option_name, v)})
        return join(option_key_values, "\n")
    endif

    let current_options = []
    for factor in split(a:line, '\v\s+')
        let key = s:parse_option_name(factor)
        if empty(key)
            continue
        endif
        call add(current_options, key)
    endfor

    let options = tdd#config#get_options()
    let key_value_options = copy(options)
    call filter(key_value_options, {k, v -> count(current_options, k) == 0 && type(v) != v:t_bool })
    call map(key_value_options, {k, _ -> printf('-%s=', k)})

    let key_options = copy(options)
    call filter(key_options, {k, v -> count(current_options, k) == 0 && type(v) == v:t_bool })
    call map(key_options, {k, _ -> printf('-%s', k)})

    let candidates = tdd#command#names() + values(key_value_options) + values(key_options)
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
