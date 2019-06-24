func! s:formatUri(uri)
    let uri = a:uri

    if matchstr(uri, '^.*://') ==# ''
        " no protocol? assume non-secure
        let uri = 'ws://' . uri
    endif

    return uri
endfunc

func! wwws#OpenNew(...)

    let openMethod = 'tabedit'
    if bufname(bufnr('%')) ==# ''
        " editing a file? prefer tabe
        let openMethod = 'edit'
    endif

    let uri = ''
    if a:0 == 0
        echom 'You must at least provide a ws:// or wss:// URI'
        return
    elseif a:0 == 1
        let uri = a:1
    elseif a:0 == 2
        let openMethod = a:1
        let uri = a:2
    endif

    let name = wwws#util#safename(uri)
    exe openMethod . ' ' . name . '.wwws'

    call append(0, 'URI: ' . uri)

    set nomodified

    if g:wwws_auto_connect
        " the ftplugin also does this, but that gets called before we
        " get a chance to insert the URI, so let's try now
        call wwws#conn#Open()
    endif
endfunc

func! wwws#_getParams() " {{{
    let headers = {}
    let params = {
        \ 'uri': '',
        \ 'headers': headers,
        \ }

    let lines = getline(1, '$')
    for line in lines
        let matches = matchlist(line, '^\([a-z-A-Z0-9-_]\+\):[ ]*\(.\+\)$')
        if len(matches) == 0
            continue
        endif

        let name = matches[1]
        let value = matches[2]

        if name ==# 'URI'
            let params['uri'] = s:formatUri(value)
        else
            let headers[name] = value
        endif
    endfor

    return params
endfunc " }}} 
