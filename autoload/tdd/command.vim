
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

function! tdd#command#factory(target, names) abort
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

    let command = v:null
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
            break
        endif
    endfor

    if empty(command)
        throw printf('not found available command: filetype=%s', filetype)
    endif

    let executable = command.executable() 
    if type(args) == v:t_list
        " use config args
    elseif a:target ==# 'file' && has_key(command, 'args_for_file')
        let args = command.args_for_file()
    elseif a:target ==# 'project'  && has_key(command, 'args_for_project')
        let args = command.args_for_project()
    else
        let args = command.args()
    endif
    let cmd = [executable] + args

    if a:target ==# 'file' && has_key(command, 'cd_for_file')
        let cd = command.cd_for_file()
    elseif a:target ==# 'project'  && has_key(command, 'cd_for_project')
        let cd = command.cd_for_project()
    else
        let cd = command.cd()
    endif

    return tdd#model#test_command#new(cmd, cd)
endfunction

function! tdd#command#names() abort
    return keys(s:funcs)
endfunction
