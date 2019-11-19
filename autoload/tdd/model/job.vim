
let s:STATUS = {
    \ 'SUCCESSED': 'SUCCESSED',
    \ 'FAILED': 'FAILED',
    \ 'ERROR': 'ERROR',
    \ 'UNKNOWN': 'UNKNOWN',
\ }

let s:STATUS_MAPPER = {
    \ 0 : s:STATUS.SUCCESSED,
    \ 1 : s:STATUS.FAILED,
\ }

let s:id = 0

function! tdd#model#job#new(execution, presenter, event_service) abort
    let s:id += 1
    let job = {
       \ 'id': s:id,
       \ 'status': s:STATUS.UNKNOWN,
       \ 'execution': a:execution,
       \ 'presenter': a:presenter,
       \ 'event_service': a:event_service,
       \ 'logger': tdd#logger#new('job'),
    \ }

    function! job.change_status(exit_code) abort
        if !has_key(s:STATUS_MAPPER, a:exit_code)
            let self.status = s:STATUS.ERROR
            return
        endif
        let self.status = s:STATUS_MAPPER[a:exit_code]
    endfunction

    function! job.on_finished(exit_code) abort
        call self.change_status(a:exit_code)
        call self.event_service.job_finished(self.id, self.status)
    endfunction

    function! job.start() abort
        let options = {
            \ 'on_exit': function('s:handle_exit'),
            \ 'on_stdout': function('s:handle_stdout'),
            \ 'on_stderr': function('s:handle_stderr'),
            \ 'cwd': self.execution.cd,
            \ 'job': self,
        \ }

        let self.internal_job_id = self.presenter.show_output(self.execution.cmd, options)
        if self.internal_job_id <= 0
            call self.logger.label('error').log('internal_job_id=' . self.internal_job_id)
            let self.status = s:STATUS.ERROR
            call self.on_finished(v:null)
        endif
    endfunction

    function! job.wait(timeout_msec) abort
        let result = jobwait([self.internal_job_id], a:timeout_msec)
        if result[0] != -1
            return v:true
        endif

        call jobstop(self.internal_job_id)
        throw printf('has not done in %d ms.', a:timeout_msec)
    endfunction

    return job
endfunction

function! s:handle_stderr(job_id, data, event) abort dict
    call self.job.logger.label('stderr').logs(a:data)
endfunction

function! s:handle_stdout(job_id, data, event) abort dict
    call self.job.logger.label('stdout').logs(a:data)
endfunction

function! s:handle_exit(job_id, exit_code, event) abort dict
    call self.job.on_finished(a:exit_code)
endfunction
