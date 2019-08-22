
function! tdd#config#clear() abort
    let s:commands = {}
    let s:filetype_commands = {}

    let s:options = {
        \ 'output': 'terminal',
        \ 'layout': 'tab',
        \ 'target': 'project',
        \ 'log': '',
    \ }
endfunction

call tdd#config#clear()

let s:OPTIONS = {
    \ 'output': ['terminal'],
    \ 'layout': ['tab', 'nosplit' ,'vertical', 'horizontal'],
    \ 'target': ['project', 'file', 'directory'],
    \ 'log': ['themis'],
\ }

function! tdd#config#filetype_commands(filetype, commands) abort
    let s:filetype_commands[a:filetype] = a:commands
endfunction

function! tdd#config#command(name, args) abort
    if type(a:args) != v:t_list
        throw printf('args must be a list, but actual: %s', a:args)
    endif

    if !has_key(s:commands, a:name)
        let s:commands[a:name] = {}
        let s:commands[a:name]['name'] = a:name
    endif
    let s:commands[a:name]['args'] = a:args
endfunction

function! tdd#config#command_alias(name, base_name) abort
    let s:commands[a:name] = {'name': a:base_name}
endfunction

function! tdd#config#option(name, value) abort
    let s:options[a:name] = a:value
endfunction

function! tdd#config#get_filetype_commands() abort
    return s:filetype_commands
endfunction

function! tdd#config#get_commands() abort
    return s:commands
endfunction

function! tdd#config#get_options() abort
    return s:options
endfunction

function! tdd#config#all_options(name) abort
    if !has_key(s:OPTIONS, a:name)
        throw printf('not found option: %s', a:name)
    endif

    return s:OPTIONS[a:name]
endfunction
