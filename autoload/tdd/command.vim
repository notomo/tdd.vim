
let s:funcs = {
    \ 'themis': {config -> s:themis(config)},
    \ 'make': {config -> s:make(config)},
    \ 'npm': {config -> s:npm(config)},
    \ 'go': {config -> s:go(config)},
\ }

function! tdd#command#factory() abort
    let filetype_commands = tdd#config#get_filetype_commands()
    let configs = tdd#config#get_commands()

    let filetype = &filetype
    if has_key(filetype_commands, filetype)
        let names = filetype_commands[filetype]
    else
        let names = filetype_commands['_']
    endif

    for name in names
        let config = configs[name]
        if !has_key(s:funcs, config.name)
            throw printf('not found command: %s', name)
        endif
        let result = s:funcs[config.name](config)
        if !empty(result)
            return result
        endif
    endfor

    throw printf('not found available command: filetype=%s', filetype)
endfunction

function! s:themis(config) abort
    let executable = a:config.executable
    let args = a:config.args
    let file_path = expand('%:p')
    return tdd#model#test_command#new([executable, file_path] + args, '.')
endfunction

function! s:make(config) abort
    let executable = a:config.executable
    let args = a:config.args

    let makefile_path = notomo#vimrc#search_parent_recursive('Makefile', './')
    if empty(makefile_path)
        return v:null
    endif

    let cd = fnamemodify(makefile_path, ':h')
    return tdd#model#test_command#new([executable] + args, cd)
endfunction

function! s:npm(config) abort
    let executable = a:config.executable
    let args = a:config.args

    let package_json_path = notomo#vimrc#search_parent_recursive('package.json', './')
    if empty(package_json_path)
        return v:null
    endif

    let cd = fnamemodify(package_json_path, ':h')
    return tdd#model#test_command#new([executable] + args, cd)
endfunction

function! s:go(config) abort
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
