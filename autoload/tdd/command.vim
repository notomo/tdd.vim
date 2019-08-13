
let s:funcs = {
    \ 'themis': {target, config -> s:themis(target, config)},
    \ 'make': {target, config -> s:make(target, config)},
    \ 'npm': {target, config -> s:npm(target, config)},
    \ 'go': {target, config -> s:go(target, config)},
\ }

function! tdd#command#factory(target, names) abort
    let filetype_commands = tdd#config#get_filetype_commands()
    let configs = tdd#config#get_commands()

    let filetype = &filetype
    if !empty(a:names)
        let names = a:names
    elseif has_key(filetype_commands, filetype)
        let names = filetype_commands[filetype]
    else
        let names = filetype_commands['_']
    endif

    for name in names
        let config = configs[name]
        if !has_key(s:funcs, config.name)
            throw printf('not found command: %s', name)
        endif
        let command = s:funcs[config.name](a:target, config)
        if !empty(command)
            return command
        endif
    endfor

    throw printf('not found available command: filetype=%s', filetype)
endfunction

function! s:themis(target, config) abort
    let executable = a:config.executable
    let args = a:config.args

    let themisrc_path = notomo#vimrc#search_parent_recursive('\.themisrc', './')
    if empty(themisrc_path)
        return v:null
    endif
    let cd = fnamemodify(themisrc_path, ':h:h')

    let cmd = [executable] + args
    if a:target ==# 'file'
        call add(cmd, expand('%:p'))
    endif
    return tdd#model#test_command#new(cmd, cd)
endfunction

function! s:make(target, config) abort
    let executable = a:config.executable
    let args = a:config.args

    let makefile_path = notomo#vimrc#search_parent_recursive('Makefile', './')
    if empty(makefile_path)
        return v:null
    endif

    let cd = fnamemodify(makefile_path, ':h')
    return tdd#model#test_command#new([executable] + args, cd)
endfunction

function! s:npm(target, config) abort
    let executable = a:config.executable
    let args = a:config.args

    let package_json_path = notomo#vimrc#search_parent_recursive('package.json', './')
    if empty(package_json_path)
        return v:null
    endif

    let cd = fnamemodify(package_json_path, ':h')
    return tdd#model#test_command#new([executable] + args, cd)
endfunction

function! s:go(target, config) abort
    let executable = a:config.executable
    let args = a:config.args
    let cd = fnamemodify(expand('%:p'), ':h')
    return tdd#model#test_command#new([executable] + args, cd)
endfunction

function! s:search_parent_recursive(file_name_pattern, start_path) abort
    let path = fnamemodify(a:start_path, ':p')
    while path !=? '//'
        let files = glob(path . a:file_name_pattern, v:false, v:true)
        if !empty(files)
            let file = files[0]
            return isdirectory(file) ? file . '/' : file
        endif
        let path = fnamemodify(path, ':h:h') . '/'
    endwhile
    return ''
endfunction
