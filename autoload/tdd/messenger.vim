
function! tdd#messenger#clear() abort
    let f = {}
    function! f.default(message) abort
        echo a:message
    endfunction

    let s:func = { message -> f.default(message) }
endfunction

call tdd#messenger#clear()


function! tdd#messenger#set_func(func) abort
    let s:func = { message -> a:func(message) }
endfunction

function! tdd#messenger#new() abort
    let messenger = {
        \ 'func': s:func,
    \ }

    function! messenger.warn(message) abort
        echohl WarningMsg
        call self.func('[tdd] ' . a:message)
        echohl None
    endfunction

    function! messenger.error(message) abort
        echohl ErrorMsg
        call self.func('[tdd] ' . a:message)
        echohl None
    endfunction

    function! messenger.status(status) abort
        if a:status ==# 'SUCCESSED'
            echohl TDDSuccessed
        else
            echohl TDDFailed
        endif
        call self.func('[tdd] ' . a:status)
        echohl None
    endfunction

    return messenger
endfunction
