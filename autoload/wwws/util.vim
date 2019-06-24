
func! wwws#util#safename(uri)
    let name = substitute(a:uri, 'w[s]*://', '', 0)
    let name = substitute(name, '[\/:]', '-', 'g')
    return name
endfunc

