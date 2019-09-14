let s:default_options = {
    \ 'output': 'terminal',
    \ 'layout': 'tab',
    \ 'target': 'project',
    \ 'log': '',
    \ 'last': v:false,
\ }

function! tdd#option#default() abort
    return deepcopy(s:default_options)
endfunction

function! tdd#option#clear() abort
    let s:options = tdd#option#default()
endfunction

call tdd#option#clear()

let s:OPTIONS = {
    \ 'output': ['terminal'],
    \ 'layout': ['tab', 'nosplit' ,'vertical', 'horizontal'],
    \ 'target': ['project', 'file', 'directory', 'near'],
    \ 'log': ['themis'],
    \ 'last': [],
\ }

function! tdd#option#set(name, value) abort
    let s:options[a:name] = a:value
endfunction

function! tdd#option#parse(args) abort
    let names = []
    let options = deepcopy(s:options)
    for arg in a:args
        let [key, value] = tdd#option#parse_one(arg)
        if empty(key)
            call add(names, value)
            continue
        endif

        let options[key] = value
    endfor

    return [names, options]
endfunction

function! tdd#option#parse_one(factor) abort
    if a:factor[0] !=# '-'
        return ['', a:factor]
    endif

    let key_value = split(a:factor[1:], '=')
    if len(key_value) == 2
        return key_value
    endif

    let [key] = key_value
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
