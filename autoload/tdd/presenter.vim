
function! tdd#presenter#new_default(output_type, open_command, log_type) abort
    let status_presenter = {}
    function! status_presenter.echo(status) abort
        echomsg a:status
    endfunction

    let output_presenter = tdd#presenter#output(a:output_type, a:open_command, a:log_type)

    return tdd#presenter#new(status_presenter, output_presenter)
endfunction

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

function! tdd#presenter#output(output_type, open_command, log_type) abort
    let output_presenter = {
        \ 'output_type': a:output_type,
        \ 'open_command': a:open_command,
        \ 'log_type': a:log_type,
    \ }

    function! output_presenter.show(cmd, options) abort
        call self.log('cwd', [a:options.cwd])
        call self.log('cmd', [join(a:cmd, ' ')])
        if self.output_type ==# 'terminal'
            execute self.open_command
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
