
let s:STATUS = {
    \ 'UNKNOWN': 'UNKNOWN',
    \ 'GREEN': 'GREEN',
    \ 'RED': 'RED',
\ }

function! tdd#model#cycle#new() abort
    let cycle = {
        \ 'test': v:null,
        \ 'STATUS': s:STATUS,
    \ }

    function! cycle.apply(test) abort
        let self.test = a:test
    endfunction

    function! cycle.status() abort
        if empty(self.test)
            return s:STATUS.UNKNOWN
        endif

        if self.test.has_successed()
            return s:STATUS.GREEN
        endif

        return s:STATUS.RED
    endfunction

    return cycle
endfunction
