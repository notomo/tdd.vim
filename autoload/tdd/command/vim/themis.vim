
function! tdd#command#vim#themis#new(params) abort
    let command = tdd#command#_default#new(a:params)

    function! command.executable() abort
        return 'themis'
    endfunction

    function! command.args() abort
        return [expand('%:p:h')]
    endfunction

    function! command.args_for_file() abort
        return [expand('%:p')]
    endfunction

    function! command.args_for_project() abort
        return ['.']
    endfunction

    function! command.args_for_near() abort
        let pattern = s:search_pattern()
        if empty(pattern)
           return self.args_for_file()
        endif
        return ['--target', pattern, expand('%:p')]
    endfunction

    function! command.cd() abort
        let themisrc_path = tdd#util#search_parent_recursive('\.themisrc', './')
        if !empty(themisrc_path)
            return fnamemodify(themisrc_path, ':h:h')
        endif
        return '.'
    endfunction

    return command
endfunction

function! s:search_pattern() abort
    let lnum = search('suite\.\zs', 'nW', line('.'))
    if lnum != 0
        let line = getline(lnum)
        return matchstr(line, '\vsuite\.\zs\k+\ze')
    endif

    let lnum = search('suite\.\zs', 'bnW')
    if lnum == 0
        return ''
    endif

    let line = getline(lnum)
    return matchstr(line, '\vsuite\.\zs\k+\ze')
endfunction
