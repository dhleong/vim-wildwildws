
func! s:intowin(kind)
    let bufnr = b:_wwws[a:kind . '_bufnr']
    exec bufwinnr(bufnr) . 'wincmd w'
endfunc

func! s:appendOutput(lines)
    call s:intowin('output')
    set modifiable
    call append(line('$'), a:lines)
    call s:intowin('input')
endfunc

func! s:isReady()
    return !empty(get(b:, '_wwws', {}))
endfunc

func! wwws#conn#Open() " {{{
    call wwws#EnsureOutput()

    if !s:isReady()
        " not ready yet
        return
    endif

    if type(get(b:_wwws, 'job', 0)) == v:t_job
        echo 'Already connected'
        return
    endif

    " gather connection params
    let params = wwws#_getParams()
    if get(params, 'uri', '') ==# ''
        return
    endif

    let outputBufNr = b:_wwws['output_bufnr']
    call s:intowin('output')
    norm! ggdG
    call s:intowin('input')

    let cmd = ['wildwildws-d', params['uri']]

    for [key, value] in items(params['headers'])
        let cmd = cmd + ['-h', key . ':' . value]
    endfor

    func! OnOutput(channel, msg) closure
        " TODO parse anything?
    endfunc

    func! OnExit(channel, exitCode) closure
        call wwws#conn#Close()
    endfunc

    let job = job_start(cmd, {
        \ 'out_mode': 'nl',
        \ 'out_modifiable': 0,
        \ 'out_io': 'buffer',
        \ 'out_buf': outputBufNr,
        \ 'err_modifiable': 0,
        \ 'err_io': 'buffer',
        \ 'err_buf': outputBufNr,
        \ 'out_cb': 'OnOutput',
        \ 'exit_cb': 'OnExit',
        \ })
    let b:_wwws['job'] = job
endfunc " }}}

func! wwws#conn#Close() " {{{
    if !s:isReady()
        " nothing to do
        return
    endif

    " disconnect; leave the output buffer open
    let job = get(b:_wwws, 'job', 0)
    if type(job) != v:t_job
        return
    endif

    call job_stop(job)
    unlet b:_wwws['job']

    call s:appendOutput(['', '// Disconnected'])
endfunc " }}}

func! wwws#conn#Send(message) " {{{
    " always try to reconnect if disconnected when sending
    call wwws#conn#TryConnect()

    let job = get(b:_wwws, 'job', 0)
    if type(job) != v:t_job
        echo 'Not connected'
        return
    endif

    call ch_sendraw(job, a:message . "\n")
endfunc " }}}

func! wwws#conn#TryConnect() " {{{
    if !g:wwws_connect_on_save
        return
    endif

    call wwws#EnsureOutput()
    if !s:isReady()
        return
    endif

    if type(get(b:_wwws, 'job', 0)) == v:t_job
        " already connected
        return
    endif

    call wwws#conn#Open()
endfunc " }}}

func! wwws#conn#_closed() " {{{
    call wwws#conn#Close()

    let outputBufNr = b:_wwws['output_bufnr']
    exec 'bwipeout ' . outputBufNr

    let b:wwws_init = 0
endfunc " }}}

