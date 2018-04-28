augroup statusline
  au!
  au TermOpen,VimEnter,WinEnter,BufEnter * call statusline#Active()
  au WinLeave * call statusline#Inactive()
augroup end
