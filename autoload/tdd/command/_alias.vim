
function! tdd#command#_alias#new(alias, params) abort
    if type(a:alias) != v:t_dict
        return v:null
    endif
    let command = tdd#command#_default#new(a:params)
    let command.alias = a:alias
    let command.option_args = get(a:params, 'args', v:null)

    function! command.executable() abort
        return self.alias.executable()
    endfunction

    function! command.args() abort
        if type(self.option_args) == v:t_list
            return self.option_args
        endif
        return self.alias.args()
    endfunction

    function! command.cd() abort
        return self.alias.cd()
    endfunction

    if has_key(a:alias, 'args_for_file')
        function! command.args_for_file() abort
            if type(self.option_args) == v:t_list
                return self.option_args
            endif
            return self.alias.args_for_file()
        endfunction
    endif

    if has_key(a:alias, 'args_for_project')
        function! command.args_for_project() abort
            if type(self.option_args) == v:t_list
                return self.option_args
            endif
            return self.alias.args_for_project()
        endfunction
    endif

    if has_key(a:alias, 'cd_for_file')
        function! command.cd_for_file() abort
            return self.alias.cd_for_file()
        endfunction
    endif

    if has_key(a:alias, 'cd_for_project')
        function! command.cd_for_project() abort
            return self.alias.cd_for_project()
        endfunction
    endif

    if has_key(a:alias, 'match_type')
        function! command.match_type(type) abort
            return self.alias.match_type(a:type)
        endfunction
    endif

    if has_key(a:alias, 'job_type')
        function! command.job_type() abort
            return self.alias.job_type()
        endfunction
    endif

    return command
endfunction
