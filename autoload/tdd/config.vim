
function! tdd#config#clear() abort
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

function! tdd#config#option(name, value) abort
    let s:options[a:name] = a:value
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
