
let s:funcs = {
    \ 'themis': { params -> tdd#command#vim#themis#new(params) },
    \ 'make': { params -> tdd#command#make#new(params) },
    \ 'npm': { params -> tdd#command#npm#new(params) },
    \ 'go': { params -> tdd#command#go#go#new(params) },
    \ 'pytest': { params -> tdd#command#python#pytest#new(params) },
\ }

let s:filetype_commands = {
    \ 'vim': ['themis'],
    \ 'javascript': ['npm'],
    \ 'typescript': ['npm'],
    \ 'go': ['go'],
    \ 'python': ['pytest'],
    \ '_': ['make'],
\ }

function! tdd#command#factory(names) abort
    let filetype_commands = tdd#config#get_filetype_commands()
    call extend(filetype_commands, s:filetype_commands, 'keep')

    let filetype = &filetype
    if !empty(a:names)
        let names = a:names
    elseif has_key(filetype_commands, filetype)
        let names = filetype_commands[filetype]
    else
        let names = filetype_commands['_']
    endif

    let config_commands = tdd#config#get_commands()

    let args = v:null
    for name in names
        if has_key(config_commands, name) && has_key(s:funcs, config_commands[name].name)
            let config = config_commands[name]
            let command = s:funcs[config.name]({})
            let args = config.args
        elseif has_key(s:funcs, name)
            let command = s:funcs[name]({})
        else
            throw printf('not found command: %s', name)
        endif

        if !empty(command)
            return [command, args]
        endif
    endfor

    throw printf('not found available command: filetype=%s', filetype)
endfunction

function! tdd#command#names() abort
    return keys(s:funcs)
endfunction
