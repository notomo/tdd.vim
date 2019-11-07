
let s:JOB_FINISHED = 'TddJobFinished'
let s:TEST_FINISHED = 'TddTestFinished'

function! tdd#model#event#service() abort
    let s:job_callbacks = {}
    let s:test_callbacks = {}

    let service = {
        \ 'logger': tdd#logger#new('event'),
    \ }

    function! service.on_job_finished(job_id, callback) abort
        let s:job_callbacks[a:job_id] = a:callback
        execute printf('autocmd User %s:%s:* ++once call s:job_callback(expand("<amatch>"))', s:JOB_FINISHED, a:job_id)
    endfunction

    function! service.on_test_finished(test_id, callback) abort
        let s:test_callbacks[a:test_id] = a:callback
        execute printf('autocmd User %s:%s:* ++once call s:test_callback(expand("<amatch>"))', s:TEST_FINISHED, a:test_id)
    endfunction

    function! service.job_finished(job_id, status) abort
        let event = printf('%s:%s:%s', s:JOB_FINISHED, a:job_id, a:status)
        call self.logger.log(event)
        execute printf('doautocmd User %s', event)
    endfunction

    function! service.test_finished(test_id, status) abort
        let event = printf('%s:%s:%s', s:TEST_FINISHED, a:test_id, a:status)
        call self.logger.log(event)
        execute printf('doautocmd User %s', event)
    endfunction

    return service
endfunction

function! s:job_callback(amatch) abort
    let [_, params] = split(a:amatch, s:JOB_FINISHED . ':', 'keep')
    let [id, status] = split(params, ':', 'keep')
    call s:job_callbacks[id](id, status)
    call remove(s:job_callbacks, id)
endfunction

function! s:test_callback(amatch) abort
    let [_, params] = split(a:amatch, s:TEST_FINISHED . ':', 'keep')
    let [id, status] = split(params, ':', 'keep')
    call s:test_callbacks[id](id, status)
    call remove(s:test_callbacks, id)
endfunction
