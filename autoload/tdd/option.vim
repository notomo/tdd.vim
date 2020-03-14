let s:default_options = {
    \ 'type': 'test',
    \ 'output': 'terminal',
    \ 'layout': 'tab',
    \ 'target': 'project',
    \ 'silent': v:false,
    \ 'last': v:false,
    \ 'args': [],
    \ 'extra-args': [],
\ }

function! tdd#option#default() abort
    return deepcopy(s:default_options)
endfunction

function! tdd#option#clear() abort
    let s:options = tdd#option#default()
endfunction

call tdd#option#clear()

let s:OPTIONS = {
    \ 'type': ['test', 'run'],
    \ 'output': ['terminal', 'buffer', 'no'],
    \ 'layout': ['tab', 'nosplit' ,'vertical', 'horizontal'],
    \ 'target': ['project', 'file', 'directory', 'near'],
    \ 'silent': [],
    \ 'last': [],
    \ 'args': [],
    \ 'extra-args': [],
\ }

function! tdd#option#set(name, value) abort
    let s:options[a:name] = a:value
endfunction

function! tdd#option#parse(args) abort
    let names = []
    let options = deepcopy(s:options)
    for arg in a:args
        let [key, value] = tdd#option#parse_one(arg)
        if empty(value)
            continue
        endif
        if empty(key)
            call add(names, value)
            continue
        endif

        let options[key] = value
    endfor

    return [names, options]
endfunction

function! tdd#option#parse_one(factor) abort
    if a:factor[0] !=# '-' || len(a:factor) <= 1
        return ['', a:factor]
    endif

    let key_value = split(a:factor[1:], '=', v:true)
    if len(key_value) >= 2
        let key = key_value[0]
        if !has_key(s:default_options, key)
            return [v:null, v:null]
        endif

        let value = join(key_value[1:], '=')
        if type(s:default_options[key]) == v:t_list
            return [key, split(value, '\v\s+')]
        endif
        return [key, value]
    endif

    let [key] = key_value
    if !has_key(s:default_options, key)
        return [v:null, v:null]
    endif
    return [key, v:true]
endfunction

function! tdd#option#all() abort
    return deepcopy(s:options)
endfunction

function! tdd#option#list(name) abort
    if !has_key(s:OPTIONS, a:name)
        throw printf('not found option: %s', a:name)
    endif

    return s:OPTIONS[a:name]
endfunction
