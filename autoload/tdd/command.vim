
function! tdd#command#reset() abort
    let s:commands = {
        \ 'themis': { params -> tdd#command#vim#themis#new(params) },
        \ 'make': { params -> tdd#command#make#new(params) },
        \ 'npm': { params -> tdd#command#npm#new(params) },
        \ 'go': { params -> tdd#command#go#go#new(params) },
        \ 'pytest': { params -> tdd#command#python#pytest#new(params) },
    \ }

    let s:options = {}

    let s:filetype_commands = {
        \ 'vim': ['themis'],
        \ 'javascript': ['npm'],
        \ 'typescript': ['npm'],
        \ 'go': ['go'],
        \ 'python': ['pytest'],
        \ '_': ['make'],
    \ }
endfunction

call tdd#command#reset()

function! tdd#command#factory(names) abort
    let filetype = &filetype
    if !empty(a:names)
        let names = a:names
    elseif has_key(s:filetype_commands, filetype)
        let names = s:filetype_commands[filetype]
    else
        let names = s:filetype_commands['_']
    endif

    for name in names
        if has_key(s:options, name)
            let params = {'alias': s:commands[name]({})}
            call extend(params, s:options[name], 'keep')
            let command = tdd#command#alias#new(params)
        elseif has_key(s:commands, name)
            let command = s:commands[name]({})
        else
            throw printf('not found command: %s', name)
        endif

        if !empty(command)
            return command
        endif
    endfor

    throw printf('not found available command: filetype=%s', filetype)
endfunction

function! tdd#command#names() abort
    return keys(s:commands)
endfunction

function! tdd#command#filetype(filetype, command_names) abort
    if type(a:filetype) != v:t_string
        throw printf('filetype must be a string')
    endif
    if type(a:command_names) != v:t_list
        throw printf('command_names must be a list')
    endif
    let s:filetype_commands[a:filetype] = a:command_names
endfunction

function! tdd#command#alias(name, base_name) abort
    if !has_key(s:commands, a:base_name)
        throw printf('not found base command: %s', a:base_name)
    endif
    let s:commands[a:name] = { params -> s:alias(params, a:base_name) }
endfunction

function! s:alias(params, base_name) abort
    let params = a:params
    let params['alias'] = s:commands[a:base_name](params)
    return tdd#command#alias#new(params)
endfunction

function! tdd#command#args(name, args) abort
    if !has_key(s:commands, a:name)
        throw printf('not found command: %s', a:name)
    endif
    if type(a:args) != v:t_list
        throw printf('args must be a list, but actual: %s', a:args)
    endif
    if !has_key(s:options, a:name)
        let s:options[a:name] = {}
    endif
    let s:options[a:name]['args'] = a:args
endfunction
