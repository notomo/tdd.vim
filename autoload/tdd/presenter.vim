
function! tdd#presenter#new_default() abort
    let status_presenter = {}

    function! status_presenter.echo(status) abort
        echomsg a:status
    endfunction

    return tdd#presenter#new(status_presenter)
endfunction

function! tdd#presenter#new(status_presenter) abort
    let presenter = {
        \ 'status': a:status_presenter,
    \ }

    function! presenter.echo_status(status) abort
        return self.status.echo(a:status)
    endfunction

    return presenter
endfunction
