
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
let s:jobs = {}

function! tdd#model#job#new(test_command, presenter) abort
    let s:id += 1
    let job = {
       \ 'id': s:id,
       \ 'status': s:STATUS.UNKNOWN,
       \ 'stage': s:STAGE.WAITING,
       \ 'command': a:test_command.command,
       \ 'presenter': a:presenter,
       \ 'STATUS': s:STATUS,
       \ 'STAGE': s:STAGE,
       \ 'exit_code': v:null,
    \ }

    function! job.change_status() abort
        if !has_key(s:STATUS_MAPPER, self.exit_code)
            let self.status = s:STATUS.ERROR
            return
        endif
        let self.status = s:STATUS_MAPPER[self.exit_code]
    endfunction

    function! job.start(event_emitter) abort
        let options = {
            \ 'on_exit': function('s:handle_exit'),
            \ 'on_stdout': function('s:handle_stdout'),
            \ 'event_emitter': a:event_emitter,
            \ 'job': self,
        \ }

        augroup tdd
            execute 'autocmd User TDDJobFinished:' . self.id '++once call s:on_finished(expand("<amatch>"))'
        augroup END

        let self.stage = s:STAGE.RUNNING
        let s:jobs[self.id] = self
        let self.internal_job_id = jobstart(self.command, options)
        if self.internal_job_id <= 0
            let self.status = s:STATUS.ERROR
        endif
    endfunction

    function! job.has_successed() abort
        return self.status == s:STATUS.SUCCESSED
    endfunction

    return job
endfunction

function! s:on_finished(match) abort
    let id = split(a:match, ':')[1]
    let job = s:jobs[id]

    call job.change_status()
    let job.stage = s:STAGE.FINISHED

    call job.presenter.echo_status(job.status)

    call remove(s:jobs, id)
endfunction

function! s:handle_stdout(job_id, data, event) abort dict
endfunction

function! s:handle_exit(job_id, exit_code, event) abort dict
    let self.job.exit_code = a:exit_code
    call self.event_emitter.finish_job(self.job.id)
endfunction
