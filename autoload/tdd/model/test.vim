
let s:id = 0

function! tdd#model#test#new(execution, presenter) abort
    let s:id += 1
    let test = {
       \ 'id': s:id,
       \ 'job': tdd#model#job#new(a:execution, a:presenter),
    \ }

    function! test.start() abort
        call self.job.start()
    endfunction

    function! test.wait(...) abort
        if empty(a:000)
            let timeout_msec = 150
        else
            let timeout_msec = a:000[0]
        endif

        return self.job.wait(timeout_msec)
    endfunction

    function! test.has_successed() abort
        return self.job.has_successed()
    endfunction

    return test
endfunction
