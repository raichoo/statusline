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
hi StatusLineModeCommand guifg=#282C34 guibg=#B8E673 gui=none
hi StatusLineModeCommandBold guifg=#282C34 guibg=#B8E673 gui=bold

hi StatusLineErrorsActive guifg=#282C34 guibg=#FD971F gui=bold
hi StatusLineErrorsInactive guifg=#FD971F guibg=#455354 gui=bold

set statusline=%#StatusLineModeNormal#\ %f

let g:statusline_mode = ' '
let g:statusline_modename = ' '
let g:statusline_counter = 0

function! statusline#Modename(mode)
  if a:mode is# 'n'
    return 'NORMAL'
  elseif a:mode is# 'i'
    return "INSERT"
  elseif a:mode is# 'v'
    return "VISUAL"
  elseif a:mode is# 'V'
    return "V-LINE"
  elseif a:mode is# ''
    return "V-BLOCK"
  elseif a:mode is# 'R'
    return "REPLACE"
  elseif a:mode is# 't'
    return "TERMINAL"
  elseif a:mode is# 'c'
    return "COMMAND"
  else
    return a:mode
  endif
endfunction

function! statusline#Mode()
  let l:mode = mode()

  if l:mode is# g:statusline_mode
    let g:statusline_counter += 1
    return g:statusline_modename
  else
    let g:statusline_mode = l:mode
    let g:statusline_modename = statusline#Modename(l:mode)
    if l:mode is# 'n'
      hi! link StatusLineMode StatusLineModeNormal
      hi! link StatusLineModeBold StatusLineModeNormalBold
    elseif l:mode is# 'i'
      hi! link StatusLineMode StatusLineModeInsert
      hi! link StatusLineModeBold StatusLineModeInsertBold
    elseif l:mode is# 'v'
      hi! link StatusLineMode StatusLineModeVisual
      hi! link StatusLineModeBold StatusLineModeVisualBold
    elseif l:mode is# 'V'
      hi! link StatusLineMode StatusLineModeVLine
      hi! link StatusLineModeBold StatusLineModeVLineBold
    elseif l:mode is# ''
      hi! link StatusLineMode StatusLineModeVBlock
      hi! link StatusLineModeBold StatusLineModeVBlockBold
    elseif l:mode is# 'R'
      hi! link StatusLineMode StatusLineModeReplace
      hi! link StatusLineModeBold StatusLineModeReplaceBold
    elseif l:mode is# 't'
      hi! link StatusLineMode StatusLineModeTerminal
      hi! link StatusLineModeBold StatusLineModeTerminalBold
    elseif l:mode is# 'c'
      hi! link StatusLineMode StatusLineModeCommand
      hi! link StatusLineModeBold StatusLineModeCommandBold
    endif
    return g:statusline_modename
  endif
endfunction

function! statusline#ActiveEdit()
  setlocal statusline=%#StatusLineModeBold#\ %{statusline#Mode()}
  setlocal statusline+=\ %#StatusLine#\ %<%f\ %m\ %R
  setlocal statusline+=%=
  setlocal statusline+=%{&ft}
  setlocal statusline+=%#LanguageHealth#%(\ %{get(g:,'language_health','')}%)
  setlocal statusline+=\ %#StatusLineFile#%(\ %{!&fenc?&fenc:''}[%{!&ff?&ff:''}]\ %)
  setlocal statusline+=%#StatusLineMode#\ %3p%%\ %#StatusLineModeBold#LN\ %3l%#StatusLineMode#:%-3c\  "trailing
  setlocal statusline+=%#StatusLineErrorsActive#%(\ %{get(b:,'statusline_errors','')}\ %)
endfunction

function! statusline#InactiveEdit()
  setlocal statusline=%#StatusLine#\ %<%f\ %m
  setlocal statusline+=%=
  setlocal statusline+=%#StatusLineErrorsInactive#%(\ %{get(b:,'statusline_errors','')}\ %)
endfunction

function! statusline#ActiveTerm()
  setlocal statusline=%#StatusLineModeBold#\ %{statusline#Mode()}
  setlocal statusline+=\ %#StatusLine#\ %<%{b:term_title}
  setlocal statusline+=%=
  setlocal statusline+=%#StatusLineMode#\ %3p%%\ %#StatusLineModeBold#PID\ %{b:terminal_job_pid}%#StatusLineMode#:%{b:terminal_job_id}\  "trailing
endfunction

function! statusline#InactiveTerm()
  setlocal statusline=%#StatusLine#\ %<%{b:term_title}
  setlocal statusline+=%=
  setlocal statusline+=PID\ %{b:terminal_job_pid}:%{b:terminal_job_id}\  "trailing
endfunction

function! statusline#QuickfixActive()
    setlocal statusline=%#StatusLineModeNormal#\ %f
    setlocal statusline+=\ %#StatusLine#\ %<%{w:quickfix_title}
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

function! statusline#CheckNewline()
  let l:newline = search('\n\%$', 'nw')

  if l:newline
    return 'newline'
  else
    return ''
  endif
endfunction

function! statusline#BufferState()
  let l:checks = []

  call add(l:checks, statusline#CheckTrailing())
  call add(l:checks, statusline#CheckNewline())
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
    setlocal statusline=%#StatusLineModeBold#\ %{statusline#Mode()}\ %#StatusLine#\ %f
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
