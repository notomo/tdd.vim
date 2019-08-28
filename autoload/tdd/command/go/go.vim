
function! tdd#command#go#go#new(params) abort
    let command = {}

    function! command.executable() abort
        return 'go'
    endfunction

    function! command.args() abort
        return ['test', '-v']
    endfunction

    function! command.args_for_near() abort
        let pattern = s:search_pattern()
        if empty(pattern)
           return self.args()
        endif
        return ['test', '-v', '-run', pattern]
    endfunction

    function! command.cd() abort
        return fnamemodify(expand('%:p'), ':h')
    endfunction

    return command
endfunction

function! s:search_pattern() abort
    let line = getline(line('.'))
    let match = matchstr(line, '\vfunc\s+\zs(Test\k+)\ze\(')
    if !empty(match)
        return match
    endif

    let [lnum, col] = searchpos('\vfunc\s+\zsTest', 'bnWc')
    if lnum == 0
        return ''
    endif

    let line = getline(lnum)
    return line[col - 1:match(line, '(') - 1]
endfunction
