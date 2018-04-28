hi StatusLineFileGood guibg=#293739 guifg=#FFFFFF
hi StatusLineFileBad guibg=#293739 guifg=#EF5939

hi! link StatusLineFile StatusLineGood

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

function! statusline#Mode()
  let l:mode = mode()

  if l:mode is# 'i'
    hi! link StatusLineMode StatusLineModeInsert
    hi! link StatusLineModeBold StatusLineModeInsertBold
    return 'INSERT'
  elseif l:mode is# 'n'
    hi! link StatusLineMode StatusLineModeNormal
    hi! link StatusLineModeBold StatusLineModeNormalBold
    return 'NORMAL'
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
  else
    return l:mode
  endif
endfunction

function! statusline#File()
  let l:ret = ''
  if strlen(&fenc) != 0
    if &fenc isnot# 'utf-8'
      hi! link StatusLineFile StatusLineFileBad
    else
      hi! link StatusLineFile StatusLineFileGood
    end
    let l:ret .= &fenc
  endif

  if strlen(&ff)
    if &ff isnot# 'unix'
      hi! link StatusLineFile StatusLineFileBad
    else
      hi! link StatusLineFile StatusLineFileGood
    end
    let l:ret .= '[' . &ff . ']'
  endif

  return l:ret
endfunction

function! statusline#ActiveEdit()
  setlocal statusline=%#StatusLineModeBold#\ %{statusline#Mode()}
  setlocal statusline+=\ %#StatusLine#\ %<%f\ %R
  setlocal statusline+=%=
  setlocal statusline+=%{&ft}
  setlocal statusline+=%#LanguageHealth#%(\ %{get(g:,'language_health','')}%)
  setlocal statusline+=\ %#StatusLineFile#\ %{statusline#File()}
  setlocal statusline+=\ %#StatusLineMode#\ %3p%%\ %#StatusLineModeBold#LN\ %3l%#StatusLineMode#:%-3c
  setlocal statusline+=\  "end
endfunction

function! statusline#InactiveEdit()
  setlocal statusline=%#StatusLine#%f
endfunction

function! statusline#ActiveTerm()
  setlocal statusline=%#StatusLineModeBold#\ %{statusline#Mode()}
  setlocal statusline+=\ %#StatusLine#\ %<%{b:term_title}
  setlocal statusline+=%=
  setlocal statusline+=\ %#StatusLineMode#\ %3p%%\ %#StatusLineModeBold#LN\ %3l%#StatusLineMode#:%-3c
endfunction

function! statusline#InactiveTerm()
  setlocal statusline=%#StatusLine#%{b:term_title}
endfunction

function! statusline#Active()
  if &buftype != 'terminal'
    call statusline#ActiveEdit()
  else
    call statusline#ActiveTerm()
  endif
endfunction

function! statusline#Inactive()
  if &buftype != 'terminal'
    call statusline#InactiveEdit()
  else
    call statusline#InactiveTerm()
  endif
endfunction
