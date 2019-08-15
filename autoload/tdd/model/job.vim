
let s:STATUS = {
    \ 'SUCCESSED': 'successed',
    \ 'FAILED': 'failed',
    \ 'ERROR': 'error',
    \ 'UNKNOWN': 'unknown',
\ }

let s:STATUS_MAPPER = {
    \ 0 : s:STATUS.SUCCESSED,
    \ 1 : s:STATUS.FAILED,
\ }

let s:STAGE = {
    \ 'WAITING': 'waiting',
    \ 'RUNNING': 'running',
    \ 'FINISHED': 'finished',
\ }

let s:id = 0

function! tdd#model#job#new(test_command, presenter) abort
    let s:id += 1
    let job = {
       \ 'id': s:id,
       \ 'status': s:STATUS.UNKNOWN,
       \ 'stage': s:STAGE.WAITING,
       \ 'test_command': a:test_command,
       \ 'presenter': a:presenter,
       \ 'STATUS': s:STATUS,
       \ 'STAGE': s:STAGE,
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
        let self.stage = s:STAGE.FINISHED
        call self.presenter.echo_status(self.status)
    endfunction

    function! job.start() abort
        let options = {
            \ 'on_exit': function('s:handle_exit'),
            \ 'on_stdout': function('s:handle_stdout'),
            \ 'on_stderr': function('s:handle_stderr'),
            \ 'cwd': self.test_command.cd,
            \ 'job': self,
        \ }

        let self.stage = s:STAGE.RUNNING
        let self.internal_job_id = self.presenter.show_output(self.test_command.command, options)
        if self.internal_job_id <= 0
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

    function! job.has_successed() abort
        return self.status == s:STATUS.SUCCESSED
    endfunction

    return job
endfunction

function! s:handle_stderr(job_id, data, event) abort dict
    call self.job.presenter.log('stderr', a:data)
endfunction

function! s:handle_stdout(job_id, data, event) abort dict
    call self.job.presenter.log('stdout', a:data)
endfunction

function! s:handle_exit(job_id, exit_code, event) abort dict
    call self.job.on_finished(a:exit_code)
endfunction
