
function! tdd#config#clear() abort
    let s:commands = {
        \ 'themis': {
            \ 'name': 'themis',
            \ 'executable': 'themis',
            \ 'args': [],
        \ },
        \ 'make': {
            \ 'name': 'make',
            \ 'executable': 'make',
            \ 'args': ['test'],
        \ },
        \ 'npm': {
            \ 'name': 'npm',
            \ 'executable': 'npm',
            \ 'args': ['run', 'test'],
        \ },
        \ 'go': {
            \ 'name': 'go',
            \ 'executable': 'go',
            \ 'args': ['test', '-v'],
        \ },
    \ }
    let s:filetype_commands = {
        \ 'vim': ['themis'],
        \ 'javascript': ['npm'],
        \ 'typescript': ['npm'],
        \ 'go': ['go'],
        \ '_': ['make'],
    \ }
    let s:options = {
        \ 'buffer': 'terminal'
    \ }
endfunction

call tdd#config#clear()

function! tdd#config#filetype_commands(filetype, commands) abort
    let s:filetype_commands[a:filetype] = a:commands
endfunction

function! tdd#config#command(name, args) abort
    if !has_key(s:commands, a:name)
        throw printf('not found command: %s', a:name)
    endif
    if type(a:args) != v:t_list
        throw printf('args must be a list, but actual: %s', a:args)
    endif
    let s:commands[a:name]['args'] = a:args
endfunction

function! tdd#config#command_alias(base_name, name) abort
    if !has_key(s:commands, a:base_name)
        throw printf('not found command: %s', a:base_name)
    endif
    let s:commands[a:name] = copy(s:commands[a:base_name])
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
