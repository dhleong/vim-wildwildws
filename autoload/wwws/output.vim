" Output buffer/window management

func! wwws#output#EnsureAvailable()
    let params = wwws#_getParams()
    if get(params, 'uri', '') ==# ''
        " nothing to do yet
        return
    endif

    let protocol = matchstr(params['uri'], 'w[s]*')
    let bufname = bufname('%') . ': '
        \ . protocol . '://'
        \ . wwws#util#safename(params['uri'])
    let bufnr = bufnr('%')

    let existing = bufnr(bufname)
    if existing != -1
        if !has_key(b:, '_wwws')
            let b:_wwws = {}
        endif
        let b:_wwws.input_bufnr = bufnr
        let b:_wwws.output_bufnr = existing
        return
    endif

    exe 'silent keepalt below split ' . bufname
    let outputBuf = bufnr('%')
    let b:_wwws = {
        \ 'input_bufnr': bufnr,
        \ 'output_bufnr': outputBuf,
        \ }
    setlocal nomodifiable
    setlocal nomodified
    setlocal nolist
    setlocal noswapfile
    setlocal nobuflisted
    setlocal buftype=nofile
    setlocal bufhidden=wipe
    set filetype=javascript

    " disable linting in the output window
    let b:ale_enabled = 0

    " return to the input window
    exe bufwinnr(bufnr) . 'wincmd w'
    let b:_wwws = {
        \ 'input_bufnr': bufnr,
        \ 'output_bufnr': outputBuf,
        \ }
endfunc
