
let s:id = 0

function! tdd#model#test#new(execution, event_service) abort
    let s:id += 1
    let test = {
       \ 'id': s:id,
       \ 'event_service': a:event_service,
       \ 'execution': a:execution,
       \ 'job': tdd#model#job#factory(a:execution, a:event_service),
    \ }

    function! test.start(output_type, layout_type) abort
        call self.event_service.on_job_finished(self.job.id, {id, status -> self.on_job_finished(id, status)})
        call self.job.start(a:output_type, a:layout_type)
    endfunction

    function! test.wait(...) abort
        if empty(a:000)
            let timeout_msec = 150
        else
            let timeout_msec = a:000[0]
        endif

        return self.job.wait(timeout_msec)
    endfunction

    function! test.on_job_finished(job_id, status) abort
        call tdd#messenger#new().status(a:status)
        call self.event_service.test_finished(self.id, a:status)
    endfunction

    return test
endfunction
