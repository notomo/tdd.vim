
let s:commands = {
    \ 'themis': {options -> s:themis(options)},
    \ 'make': {options -> s:make(options)},
\ }

function! tdd#command#factory() abort
    let configs = tdd#config#get_commands()

    let config = {}
    let fileytype = &filetype
    if has_key(configs, fileytype)
        let config = configs[fileytype]
    elseif has_key(configs, '_')
        let config = configs['_']
    endif

    if empty(config) || !has_key(s:commands, config.name)
        throw printf('not found command: filetype=%s', fileytype)
    endif

    return s:commands[config.name](config.options)
endfunction

function! s:themis(options) abort
    let executable = 'themis'
    let file_path = expand('%:p')
    return tdd#model#test_command#new([executable, file_path], '.')
endfunction

function! s:make(options) abort
    let executable = 'make'
    let args = a:options
    if empty(args)
        let args = ['test']
    endif

    let makefile_path = notomo#vimrc#search_parent_recursive('Makefile', './')
    if empty(makefile_path)
        throw 'not found Makefile'
    endif

    let cd = fnamemodify(makefile_path, ':h')
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
