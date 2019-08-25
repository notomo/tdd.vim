
let s:STATUS = {
    \ 'UNKNOWN': 'UNKNOWN',
    \ 'GREEN': 'GREEN',
    \ 'RED': 'RED',
\ }

function! tdd#model#cycle#new() abort
    let cycle = {
        \ 'test': v:null,
        \ 'cycle_status': s:STATUS.UNKNOWN,
    \ }

    function! cycle.apply(test, event_service) abort
        let self.test = a:test
        call a:event_service.on_test_finished(self.test.id, {id, status -> self.on_test_finished(id, status)})
    endfunction

    function! cycle.status() abort
        return self.cycle_status
    endfunction

    function! cycle.last_test() abort
        return self.test
    endfunction

    function! cycle.on_test_finished(test_id, status) abort
        if a:status ==? 'SUCCESSED'
            let self.cycle_status = s:STATUS.GREEN
        else
            let self.cycle_status = s:STATUS.RED
        endif
    endfunction

    return cycle
endfunction

function! tdd#model#cycle#all_status() abort
    return s:STATUS
endfunction
