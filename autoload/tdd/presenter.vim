
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

    function! presenter.log(label, messages) abort
        return self.output.log(a:label, a:messages)
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

function! tdd#presenter#output(output_type, open_type, log_type) abort
    let output_presenter = {
        \ 'output_type': a:output_type,
        \ 'open_type': a:open_type,
        \ 'open_command': tdd#open_command#new(a:open_type),
        \ 'log_type': a:log_type,
    \ }

    function! output_presenter.show(cmd, options) abort
        call self.log('cwd', [a:options.cwd])
        call self.log('%:p', [expand('%:p')])
        call self.log('cmd', [join(a:cmd, ' ')])
        if self.output_type ==# 'terminal'
            call self.open_command.execute()
            return termopen(a:cmd, a:options)
        endif
        return jobstart(a:cmd, a:options)
    endfunction

    function! output_presenter.log(label, messages) abort
        if self.log_type ==# 'themis'
            let label = printf('[%s] ', a:label)
            for msg in a:messages
                call themis#log(label . msg)
            endfor
        endif
    endfunction

    return output_presenter
endfunction
