
function! tdd#command#alias#new(params) abort
    let alias = a:params.alias
    let command = {
        \ 'alias': alias,
        \ 'option_args': a:params.args,
    \ }

    function! command.executable() abort
        return self.alias.executable()
    endfunction

    function! command.args() abort
        return self.option_args
    endfunction

    function! command.cd() abort
        return self.alias.cd()
    endfunction

    if has_key(alias, 'args_for_file')
        function! command.args_for_file() abort
            return self.option_args
        endfunction
    endif

    if has_key(alias, 'args_for_project')
        function! command.args_for_project() abort
            return self.option_args
        endfunction
    endif

    if has_key(alias, 'cd_for_file')
        function! command.cd_for_file() abort
            return self.alias.cd_for_file()
        endfunction
    endif

    if has_key(alias, 'cd_for_project')
        function! command.cd_for_project() abort
            return self.alias.cd_for_project()
        endfunction
    endif

    return command
endfunction