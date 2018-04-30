hi StatusLineFile guibg=#293739 guifg=#FFFFFF

hi StatusLineModeInsert guifg=#282C34 guibg=#66D9EF gui=bold
hi StatusLineModeInsertBold guifg=#282C34 guibg=#66D9EF gui=bold
hi StatusLineModeNormal guifg=#282C34 guibg=#E6DB74 gui=none
hi StatusLineModeNormalBold guifg=#282C34 guibg=#E6DB74 gui=bold
hi StatusLineModeVisual guifg=#282C34 guibg=#FD971F gui=none
hi StatusLineModeVisualBold guifg=#282C34 guibg=#FD971F gui=bold
hi StatusLineModeVLine guifg=#282C34 guibg=#FD971F gui=none
hi StatusLineModeVLineBold guifg=#282C34 guibg=#FD971F gui=bold
hi StatusLineModeVBlock guifg=#282C34 guibg=#FD971F gui=none
hi StatusLineModeVBlockBold guifg=#282C34 guibg=#FD971F gui=bold
hi StatusLineModeReplace guifg=#282C34 guibg=#EF5939 gui=none
hi StatusLineModeReplaceBold guifg=#282C34 guibg=#EF5939 gui=bold
hi StatusLineModeTerminal guifg=#282C34 guibg=#F92672 gui=none
hi StatusLineModeTerminalBold guifg=#282C34 guibg=#F92672 gui=bold

hi StatusLineErrorsActive guifg=#282C34 guibg=#FD971F gui=bold
hi StatusLineErrorsInactive guifg=#FD971F guibg=#455354 gui=bold

set statusline=%#StatusLineModeNormal#\ %f

function! statusline#Mode()
  let l:mode = mode()

  if l:mode is# 'n'
    hi! link StatusLineMode StatusLineModeNormal
    hi! link StatusLineModeBold StatusLineModeNormalBold
    return 'NORMAL'
  elseif l:mode is# 'i'
    hi! link StatusLineMode StatusLineModeInsert
    hi! link StatusLineModeBold StatusLineModeInsertBold
    return 'INSERT'
  elseif l:mode is# 'v'
    hi! link StatusLineMode StatusLineModeVisual
    hi! link StatusLineModeBold StatusLineModeVisualBold
    return 'VISUAL'
  elseif l:mode is# 'V'
    hi! link StatusLineMode StatusLineModeVLine
    hi! link StatusLineModeBold StatusLineModeVLineBold
    return 'V-LINE'
  elseif l:mode is# ''
    hi! link StatusLineMode StatusLineModeVBlock
    hi! link StatusLineModeBold StatusLineModeVBlockBold
    return 'V-BLOCK'
  elseif l:mode is# 'R'
    hi! link StatusLineMode StatusLineModeReplace
    hi! link StatusLineModeBold StatusLineModeReplaceBold
    return 'REPLACE'
  elseif l:mode is# 't'
    hi! link StatusLineMode StatusLineModeTerminal
    hi! link StatusLineModeBold StatusLineModeTerminalBold
    return 'TERMINAL'
  elseif l:mode is# 'c'
    hi! link StatusLineMode StatusLineModeNormal
    hi! link StatusLineModeBold StatusLineModeNormalBold
    return 'NORMAL'
  else
    return l:mode
  endif
endfunction

function! statusline#ActiveEdit()
  setlocal statusline=%#StatusLineModeBold#\ %{statusline#Mode()}
  setlocal statusline+=\ %#StatusLine#\ %(%m\ %)%<%f\ %R
  setlocal statusline+=%=
  setlocal statusline+=%{&ft}
  setlocal statusline+=%#LanguageHealth#%(\ %{get(g:,'language_health','')}%)
  setlocal statusline+=\ %#StatusLineFile#%(\ %{!&fenc?&fenc:''}[%{!&ff?&ff:''}]\ %)
  setlocal statusline+=%#StatusLineMode#\ %3p%%\ %#StatusLineModeBold#LN\ %3l%#StatusLineMode#:%-3c\  "trailing
  setlocal statusline+=%#StatusLineErrorsActive#%(\ %{get(b:,'statusline_errors','')}\ %)
endfunction

function! statusline#InactiveEdit()
  setlocal statusline=%#StatusLine#\ %(%m\ %)%<%f
  setlocal statusline+=%=
  setlocal statusline+=%#StatusLineErrorsInactive#%(\ %{get(b:,'statusline_errors','')}\ %)
endfunction

function! statusline#ActiveTerm()
  setlocal statusline=%#StatusLineModeBold#\ %{statusline#Mode()}
  setlocal statusline+=\ %#StatusLine#\ %<%{b:term_title}
  setlocal statusline+=%=
  setlocal statusline+=%#StatusLineMode#\ %3p%%\ %#StatusLineModeBold#LN\ %3l%#StatusLineMode#:%-3c\  "trailing
endfunction

function! statusline#InactiveTerm()
  setlocal statusline=%#StatusLine#\ %{b:term_title}
endfunction

function! statusline#QuickfixActive()
    setlocal statusline=%#StatusLineModeNormal#\ %f
    setlocal statusline+=\ %#StatusLine#\ %{w:quickfix_title}
    setlocal statusline+=%=
    setlocal statusline+=%#StatusLineModeNormal#\ %3p%%\ %#StatusLineModeNormalBold#%4l%#StatusLineModeNormal#:%-4L\  "trailing
endfunction

function! statusline#CheckMixed()
  let l:mixed = search('\v(^\t+ +)|(^ +\t+)', 'nw')

  if l:mixed
    return 'mixed[' . l:mixed . ']'
  else
    return ''
  endif
endfunction

function! statusline#CheckTrailing()
  let l:trailing = search('\(\|\s\+\?\)$', 'nw')

  if l:trailing
    return 'trailing[' . l:trailing . ']'
  else
    return ''
  endif
endfunction

function! statusline#CheckEncoding()
  if &fenc isnot# '' && &fenc isnot# 'utf-8'
    return 'encoding'
  else
    return ''
  endif
endfunction

function! statusline#CheckFormat()
  if &ff isnot# 'unix'
    return 'format'
  else
    return ''
  endif
endfunction

function! statusline#BufferState()
  let l:checks = []

  call add(l:checks, statusline#CheckTrailing())
  call add(l:checks, statusline#CheckMixed())
  call add(l:checks, statusline#CheckFormat())
  call add(l:checks, statusline#CheckEncoding())
  call filter(l:checks, 'v:val isnot# ""')

  let b:statusline_errors = join(l:checks, ' ')
endfunction

function! statusline#Active()
  if &buftype == ''
    call statusline#ActiveEdit()
  elseif &buftype == 'terminal'
    call statusline#ActiveTerm()
  elseif &buftype == 'quickfix'
    call statusline#QuickfixActive()
  else
    setlocal statusline=
  endif
endfunction

function! statusline#Inactive()
  if &buftype == ''
    call statusline#InactiveEdit()
  elseif &buftype == 'terminal'
    call statusline#InactiveTerm()
  else
    setlocal statusline=\ %#StatusLine#%f
  endif
endfunction
