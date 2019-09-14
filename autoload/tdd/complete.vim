
function! tdd#complete#get(current_arg, line, cursor_position) abort
    let options = tdd#option#all()

    let [option_name, _] = tdd#option#parse_one(a:current_arg)
    if !empty(option_name) && has_key(options, option_name)
        let option_values = tdd#option#list(option_name)
        let option_key_values = map(option_values, {_, v -> printf('-%s=%s', option_name, v)})
        return join(option_key_values, "\n")
    endif

    let [_, current_options] = tdd#option#parse(split(a:line, '\v\s+'))
    let defaults = tdd#option#default()
    call filter(current_options, {k, v -> !has_key(defaults, k) || defaults[k] != v})

    let current_option_keys = keys(current_options)

    let key_value_options = copy(options)
    call filter(key_value_options, {k, v -> count(current_option_keys, k) == 0 && type(v) != v:t_bool })
    call map(key_value_options, {k, _ -> printf('-%s=', k)})

    let key_options = copy(options)
    call filter(key_options, {k, v -> count(current_option_keys, k) == 0 && type(v) == v:t_bool })
    call map(key_options, {k, _ -> printf('-%s', k)})

    let candidates = tdd#command#names() + values(key_value_options) + values(key_options)
    return join(candidates, "\n")
endfunction
