
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
        \ 'pytest': {
            \ 'name': 'pytest',
            \ 'executable': 'pytest',
            \ 'args': [],
        \ },
    \ }

    let s:filetype_commands = {
        \ 'vim': ['themis'],
        \ 'javascript': ['npm'],
        \ 'typescript': ['npm'],
        \ 'go': ['go'],
        \ 'python': ['pytest'],
        \ '_': ['make'],
    \ }

    let s:options = {
        \ 'output': 'terminal',
        \ 'open': 'tab',
        \ 'target': 'project',
        \ 'log': '',
    \ }
endfunction

call tdd#config#clear()

let s:OPTIONS = {
    \ 'output': ['terminal'],
    \ 'open': ['tab', 'nosplit' ,'vertical', 'horizontal'],
    \ 'target': ['project', 'file', 'directory'],
    \ 'log': ['themis'],
\ }

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

function! tdd#config#command_alias(name, base_name) abort
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

function! tdd#config#all_options(name) abort
    if !has_key(s:OPTIONS, a:name)
        throw printf('not found option: %s', a:name)
    endif

    return s:OPTIONS[a:name]
endfunction
