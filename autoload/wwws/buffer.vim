
func! wwws#buffer#SendParagraph()
    let reg = '"'

    let cursor = getcurpos()
    let sel_save = &selection
    let &selection = "inclusive"
    let cb_save  = &clipboard
    set clipboard-=unnamed clipboard-=unnamedplus
    let reg_save = getreg(reg)
    let reg_type = getregtype(reg)

    " select the paragraph and get its text
    silent exe 'normal! "' . reg . 'yap'
    let toSend = getreg(reg)

    " restore settings
    call setreg(reg, reg_save, reg_type)
    let &clipboard = cb_save
    let &selection = sel_save
    call setpos('.', cursor)

    " send the value
    call wwws#conn#Send(toSend)
endfunc
