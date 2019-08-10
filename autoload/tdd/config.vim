

function! tdd#config#clear() abort
    let s:commands = {
        \ 'vim': {
            \ 'name': 'themis',
            \ 'options': [],
        \ }
    \ }
    let s:commands['_'] = s:commands['vim']
endfunction

call tdd#config#clear()

function! tdd#config#command(filetype, name, ...) abort
    let s:commands[a:filetype] = {
        \ 'name': a:name,
        \ 'options': a:000,
    \ }
endfunction

function! tdd#config#get_commands() abort
    return s:commands
endfunction
