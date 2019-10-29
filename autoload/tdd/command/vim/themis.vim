
function! tdd#command#vim#themis#new(params) abort
    let command = {}

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
    let lnum = search('s:suite\.\zs', 'nW', line('.'))
    if lnum != 0
        let line = getline(lnum)
        let name = split(line,  '\v\s')[1]
        return name[len('s:suite.'):-len('()') - 1]
    endif

    let lnum = search('s:suite\.\zs', 'bnW')
    if lnum == 0
        return ''
    endif

    let line = getline(lnum)
    let name = split(line,  '\v\s')[1]
    return name[len('s:suite.'):-len('()') - 1]
endfunction
