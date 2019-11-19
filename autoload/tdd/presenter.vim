
function! tdd#presenter#new(output_presenter) abort
    let presenter = {
        \ 'output': a:output_presenter,
    \ }

    function! presenter.show_output(cmd, options) abort
        return self.output.show(a:cmd, a:options)
    endfunction

    return presenter
endfunction

function! tdd#presenter#output(output_type, layout_type) abort
    let output_presenter = {
        \ 'output_type': a:output_type,
        \ 'window_layout': tdd#window_layout#new(a:layout_type),
        \ 'logger': tdd#logger#new('presenter'),
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
