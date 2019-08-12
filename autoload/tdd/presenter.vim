
function! tdd#presenter#new_default(buffer_type) abort
    let status_presenter = {}
    function! status_presenter.echo(status) abort
        echomsg a:status
    endfunction

    let buffer_presenter = tdd#presenter#buffer(a:buffer_type)

    return tdd#presenter#new(status_presenter, buffer_presenter)
endfunction

function! tdd#presenter#new(status_presenter, buffer_presenter) abort
    let presenter = {
        \ 'status': a:status_presenter,
        \ 'buffer': a:buffer_presenter,
    \ }

    function! presenter.echo_status(status) abort
        return self.status.echo(a:status)
    endfunction

    function! presenter.show_buffer(cmd, options) abort
        return self.buffer.show(a:cmd, a:options)
    endfunction

    return presenter
endfunction

function! tdd#presenter#buffer(buffer_type) abort
    let buffer_presenter = {
        \ 'type': a:buffer_type,
    \ }

    function! buffer_presenter.show(cmd, options) abort
        if self.type ==# 'terminal'
            tabedit
            return termopen(a:cmd, a:options)
        endif
        return jobstart(a:cmd, a:options)
    endfunction

    return buffer_presenter
endfunction
