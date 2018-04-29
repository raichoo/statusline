augroup statusline
  au!
  au TermOpen,VimEnter,WinEnter,BufEnter * call statusline#Active()
  au WinLeave * call statusline#Inactive()
  au BufRead,BufWritePost * call statusline#BufferState()
augroup end
