
function! tdd#config#clear() abort
    let s:commands = {
        \ 'themis': {
            \ 'executable': 'themis',
            \ 'args': [],
        \ },
        \ 'make': {
            \ 'executable': 'make',
            \ 'args': ['test'],
        \ },
        \ 'npm': {
            \ 'executable': 'npm',
            \ 'args': ['run', 'test'],
        \ },
        \ 'go': {
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

function! tdd#config#get_filetype_commands() abort
    return s:filetype_commands
endfunction

function! tdd#config#get_commands() abort
    return s:commands
endfunction
