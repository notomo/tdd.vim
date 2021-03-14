
function! tdd#command#lua#busted#new(params) abort
    let command = tdd#command#_default#new(a:params)

    function! command.executable() abort
        return 'busted'
    endfunction

    function! command.args_for_file() abort
        let pattern = printf('^%s', expand('%:t:r'))
        return ['--pattern=' .. pattern, expand('%:p:h')]
    endfunction

    function! command.cd() abort
        let git_path = tdd#util#search_parent_recursive('.git', './')
        return fnamemodify(git_path, ':h:h')
    endfunction

    function! command.args_for_near() abort
        let pattern = s:search_pattern()
        let args = self.args_for_file()
        if empty(pattern)
           return args
        endif
        return ['--filter=' .. pattern] + args
    endfunction

    return command
endfunction

function! s:search_pattern() abort
    let [describe, describe_lnum] = s:describe()
    if empty(describe)
        return ''
    endif

    let [it, it_lnum] = s:it()
    if empty(it) || describe_lnum > it_lnum
        return '^' .. s:escape(describe)
    endif
    return '^' .. s:escape(describe) .. ' ' .. s:escape(it) .. '$'
endfunction

function! s:escape(str) abort
    let str = substitute(a:str, '-', '%-', 'g')
    let str = substitute(str, '(', '%(', 'g')
    let str = substitute(str, ')', '%)', 'g')
    return str
endfunction

function! s:it() abort
    let lnum = search('\v^\s*it\(', 'bnW')
    if lnum == 0
        return ['', -1]
    endif

    let line = getline(lnum)
    let matched = matchstr(line, '\vit\("\zs.*\ze"')
    if !empty(matched)
        return [matched, lnum]
    endif

    return [matchstr(line, '\vit\(''\zs.*\ze'''), lnum]
endfunction

function! s:describe() abort
    let lnum = search('\v^\s*describe\(', 'bnW')
    if lnum == 0
        return ['', -1]
    endif

    let line = getline(lnum)
    let matched = matchstr(line, '\vdescribe\("\zs.*\ze"')
    if !empty(matched)
        return [matched, lnum]
    endif

    return [matchstr(line, '\vdescribe\(''\zs.*\ze'''), lnum]
endfunction
