
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

function! tdd#model#job#factory(execution, event_service) abort
    if a:execution.type ==? 'excmd'
        return tdd#model#job#new_excmd(a:execution, a:event_service)
    endif
    return tdd#model#job#new(a:execution, a:event_service)
endfunction

function! tdd#model#job#new(execution, event_service) abort
    let s:id += 1
    let job = {
       \ 'id': s:id,
       \ 'status': s:STATUS.UNKNOWN,
       \ 'execution': a:execution,
       \ 'event_service': a:event_service,
       \ 'logger': tdd#logger#new('job'),
    \ }

    function! job.change_status(exit_code) abort
        let self.status = s:change_status(a:exit_code)
    endfunction

    function! job.on_finished(exit_code) abort
        call self.change_status(a:exit_code)
        call self.event_service.job_finished(self.id, self.status)
    endfunction

    function! job.start(output_type, layout_type) abort
        let options = {
            \ 'on_exit': function('s:handle_exit'),
            \ 'on_stdout': function('s:handle_stdout'),
            \ 'on_stderr': function('s:handle_stderr'),
            \ 'cwd': self.execution.cd,
            \ 'job': self,
        \ }

        call self.logger.label('cwd').log(options.cwd)
        call self.logger.label('%:p').log(expand('%:p'))
        call self.logger.label('cmd').log(join(self.execution.cmd, ' '))

        if a:output_type ==# 'terminal'
            call tdd#window_layout#new(a:layout_type).execute()
            let self.internal_job_id = termopen(self.execution.cmd, options)
            call setpos('.', [0, line('$'), 0, 0])
        else
            let self.internal_job_id = jobstart(self.execution.cmd, options)
        endif
        setlocal filetype=tdd-result
        let b:last_job_cmd = self.execution.cmd

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

function! tdd#model#job#new_excmd(execution, event_service) abort
    let s:id += 1
    let job = {
       \ 'id': s:id,
       \ 'status': s:STATUS.UNKNOWN,
       \ 'execution': a:execution,
       \ 'event_service': a:event_service,
       \ 'logger': tdd#logger#new('job'),
    \ }

    function! job.start(output_type, layout_type) abort
        let cmd = join(self.execution.cmd, ' ')
        call self.logger.label('cmd').log(cmd)

        let status = s:STATUS.SUCCESSED
        try
            if a:output_type ==# 'no'
                execute cmd
            else
                call tdd#window_layout#new(a:layout_type).execute()
                setlocal buftype=nofile noswapfile nonumber filetype=tdd-result
                let b:last_job_cmd = self.execution.cmd
                let output = execute(cmd)
                call setline(1, split(output, "\n"))
                call setpos('.', [0, line('$'), 0, 0])
            endif
        catch
            call setline(line('$'), split(v:exception, "\n"))
            let status = s:STATUS.ERROR
        finally
            call self.logger.buffer_log(bufnr('%'))
        endtry

        let self.status = status
        call self.event_service.job_finished(self.id, self.status)
    endfunction

    function! job.wait(timeout_msec) abort
        " noop
    endfunction

    return job
endfunction

function! s:change_status(exit_code) abort
    if !has_key(s:STATUS_MAPPER, a:exit_code)
        return s:STATUS.ERROR
    endif
    return s:STATUS_MAPPER[a:exit_code]
endfunction
