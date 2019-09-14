
function! tdd#presenter#new(status_presenter, output_presenter) abort
    let presenter = {
        \ 'status': a:status_presenter,
        \ 'output': a:output_presenter,
    \ }

    function! presenter.echo_status(status) abort
        return self.status.echo(a:status)
    endfunction

    function! presenter.show_output(cmd, options) abort
        return self.output.show(a:cmd, a:options)
    endfunction

    function! presenter.show_error(message) abort
        echohl ErrorMsg
        echo '[tdd] ' . a:message
        echohl None
    endfunction

    return presenter
endfunction

function! tdd#presenter#status() abort
    let status_presenter = {}

    function! status_presenter.echo(status) abort
        echomsg a:status
    endfunction

    return status_presenter
endfunction

function! tdd#presenter#output(output_type, layout_type) abort
    let output_presenter = {
        \ 'output_type': a:output_type,
        \ 'window_layout': tdd#window_layout#new(a:layout_type),
        \ 'logger': tdd#logger#new(),
    \ }

    function! output_presenter.show(cmd, options) abort
        call self.logger.label('cwd').log(a:options.cwd)
        call self.logger.label('%:p').log(expand('%:p'))
        call self.logger.label('cmd').log(join(a:cmd, ' '))

        if self.output_type ==# 'terminal'
            call self.window_layout.execute()
            return termopen(a:cmd, a:options)
        endif
        return jobstart(a:cmd, a:options)
    endfunction

    return output_presenter
endfunction
