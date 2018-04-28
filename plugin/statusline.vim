augroup statusline
  au!
  au TermOpen,VimEnter,WinEnter,BufEnter * call statusline#Active()
  au WinLeave * call statusline#Inactive()
  au BufWritePost * call statusline#BufferState()
  au BufRead * call statusline#BufferState()
augroup end
