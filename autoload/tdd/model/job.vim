
let s:STATUS = {
    \ 'WAITING': 'waiting',
    \ 'RUNNING': 'running',
    \ 'SUCCESSED': 'successed',
    \ 'FAILED': 'failed',
    \ 'ERROR': 'error',
\ }

let s:STATUS_MAPPER = {
    \ 0 : s:STATUS.SUCCESSED,
    \ 1 : s:STATUS.FAILED,
\ }

let s:id = 0

function! tdd#model#job#new(test_command) abort
    let s:id += 1
    let job = {
       \ 'id': s:id,
       \ 'status': s:STATUS.WAITING,
       \ 'command': a:test_command.command,
       \ 'STATUS': s:STATUS,
    \ }

    function! job.change_status(exit_code) abort
        if !has_key(s:STATUS_MAPPER, a:exit_code)
            let self.status = s:STATUS.ERROR
            return
        endif
        let self.status = s:STATUS_MAPPER[a:exit_code]
    endfunction

    function! job.start() abort
        let options = {
            \ 'on_exit': function('s:handle_exit'),
            \ 'job': self,
        \ }
        let self.status = s:STATUS.RUNNING
        let job_id = jobstart(self.command, options)
        if job_id <= 0
            let self.status = s:STATUS.ERROR
        endif
    endfunction

    function! job.has_done() abort
        return self.status != s:STATUS.WAITING && self.status != s:STATUS.RUNNING
    endfunction

    function! job.has_successed() abort
        return self.status == s:STATUS.SUCCESSED
    endfunction

    return job
endfunction

function! s:handle_exit(job_id, exit_code, event) abort dict
    call self.job.change_status(a:exit_code)
endfunction
