" vim:tw=0:ts=2:sw=2:et:norl:ft=vim
" Author: Landon Bouma <https://tallybark.com/>
" Project: https://github.com/DepoXy/tig-newtons#🍎
" License: MIT. Please find more in the LICENSE file.

" Copyright (c) © 2020-2023 Landon Bouma. All Rights Reserved.

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" COPYD: ~/.vim/.vimrc
"   https://github.com/landonb/dubs-vim#🖖

" ----------------------------------------
"  OS Bootstrap
" ----------------------------------------

" The buck stops here.
"      ... or does it?
" Actually, it does; we're responsible for 
" loading the application's startup script 
" if the user's startup script (this script) 
" exists.
if filereadable($VIMRUNTIME . "/../.vimrc")
  " This is where the startup file lives in 
  " 'nix, but in Cygwin, it's not created by 
  " default (but I can't vouch for other 
  " distributions).
  source $VIMRUNTIME/../.vimrc
elseif filereadable($VIMRUNTIME . "/../_vimrc")
  " This file exists and *must* be sourced 
  " for native Windows gVim to work properly.
  source $VIMRUNTIME/../_vimrc
elseif filereadable($VIMRUNTIME . "/../vimrc")
  " MacVim (Apple Silicon Homebrew).
  source $VIMRUNTIME/../vimrc
else
  " Well, we could complain, but in some
  " distros, the application startup file
  " doesn't exist. So let's not bother the
  " user, i.e., we won't:
  "  call confirm(
  "   \ 'vimrc: Cannot find VIMRUNTIME''s vimrc, '
  "   \ . 'i.e., $VIMRUNTIME/../[\.|_]vimrc', 'OK')
endif

" MAYBE/2023-02-08: How dated is Dubs Vim?
" - There's no .vimrc in my $VIMRUNTIME @linux, just defaults.vim.
" - I added this `source defaults.vim` only to minimal.vimrc:
"   - I do not source defaults.vim from Dubs Vim.
"   - But I probably don't need to: Dubs Vim works like I expect/want, so
"     I bet that my various plugins setup Vim similarly to defaults.vim.
" Source defaults.vim, otherwise when Vim starts: you'll see strange
" phantom control characters on the first line of input; the arrow keys
" won't work (they'll insert As, Bs, Cs, and Ds); Ctrl-s doesn't work;
" and also whatever else is wrong that I didn't notice b/c those three.
if filereadable($VIMRUNTIME . "/defaults.vim")
  " CXREF: ~/.local/share/vim/vim90/defaults.vim
  "   /Applications/MacVim.app/Contents/Resources/vim/runtime/defaults.vim
  "   /usr/share/vim/vim90/defaults.vim
  source $VIMRUNTIME/defaults.vim
endif

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" COPYD: ~/.vim/plugin/dubs_preloads.vim
"   https://github.com/landonb/dubs-vim#🖖

" ------------------------------------------------------
" MacVim Alt-key sequence mapping enablement
" ------------------------------------------------------

" CXREF: /Applications/MacVim.app/Contents/Resources/vim/gvimrc

if has('macunix')
  " Enable Alt-key (aka Meta, aka Option) mappings (e.g., <M-a>).
  set macmeta

  " Don't let MacVim call `colorscheme macvim`.
  " - Dubs Vim sets its own colorscheme (see plugin
  "   ~/.vim/pack/landonb/start/dubs_after_dark/).
  " - CXREF: :h macvim-colorscheme
  let macvim_skip_colorscheme=1

  " Glossary: HIG: Apple's Human interface Guidelines.

  " Disable HIG Cmd and Option (Alt) movement mappings.
  " - Dubs Vim makes its own mappings.
  " - CXREF: :h alt-movement
  let macvim_skip_cmd_opt_movement=1

  " Enable so-called HIG shift movement, which makes Vim a little more like
  " GUI text editors, e.g., holding down Shift + a movement key will extend
  " the selection.
  " - Dubs Vim makes its own mappings.
  " - CXREF: :h macvim-shift-movement
  let macvim_hig_shift_movement=1
endif

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" COPYD: ~/.vim/pack/landonb/start/dubs_edit_juice/plugin/dubs_edit_juice.vim
"   https://github.com/landonb/dubs_edit_juice

" FIXME/2023-02-02 13:40: This is getting ridiculous: Split dubs_edit_juice.vim
" - Move stuff you want in here into, dunno, dubs_edit_juice.vim,
"   or dubs_edit_quick.vim, dubs_edit_juicy.vim ha.

" l. 238
" <Alt-Left>/<Alt-Right> moves cursor to start/end of line
function! s:add_alt_left_alt_right_maps_move_cursor_to_line_beg_line_end()
  " Alt-Left moves the cursor to the beginning of the line.
  noremap <M-Left> <Home>
  inoremap <M-Left> <C-O><Home>
  vnoremap <M-Left> :<C-U> <CR>gvy :execute "normal! 0"<CR>
  " Alt-Right moves the cursor to the end of the line.
  noremap <M-Right> <End>
  inoremap <M-Right> <C-O><End>
  vnoremap <M-Right> :<C-U> <CR>gvy :execute "normal! $"<CR>
endfunction
"
call <SID>add_alt_left_alt_right_maps_move_cursor_to_line_beg_line_end()
"
function! s:add_cmd_left_cmd_right_maps_move_cursor_to_line_beg_line_end()
  " Cmd-Left moves the cursor to the beginning of the line.
  noremap <D-Left> <Home>
  inoremap <D-Left> <C-O><Home>
  vnoremap <D-Left> :<C-U> <CR>gvy :execute "normal! 0"<CR>
  " Cmd-Right moves the cursor to the end of the line.
  noremap <D-Right> <End>
  inoremap <D-Right> <C-O><End>
  vnoremap <D-Right> :<C-U> <CR>gvy :execute "normal! $"<CR>
endfunction
"
call <SID>add_cmd_left_cmd_right_maps_move_cursor_to_line_beg_line_end()

" l. 731
" <Ctrl-Z>/<Ctrl-Y> undo/redo
vnoremap <C-Z> :<C-U> :undo<CR>
vnoremap <C-Y> :<C-U> :redo<CR>

" l. 753
" <Alt-T> transpose characters
function! s:TransposeCharacters()
  let cursorCol = col('.')
  if 1 == cursorCol
    execute 'normal ' . 'xp'
  else
    execute 'normal ' . 'Xp'
  endif
endfunction
"
inoremap <M-T> <C-o>:call <SID>TransposeCharacters()<CR>

" l. 794
" Tab/Shift-Tab to dedent/indent
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" l. 1533
" Insert date abbreviations
iabbrev <expr> TTT strftime("%Y-%m-%d")
iabbrev <expr> TTT_ strftime("%Y_%m_%d")
iabbrev <expr> TTTtt strftime("%Y-%m-%d %H:%M")
iabbrev <expr> TTTTtt strftime("%Y-%m-%dT%H:%M")
iabbrev <expr> ttt strftime("%H:%M")
inoremap <silent> <unique> <Leader>t <C-R>=strftime("/%Y-%m-%d: ")<CR>
inoremap <F12> <C-R>=strftime("/%Y-%m-%d %H:%M: ")<CR>

" l. 1830
" Delete word under cursor
imap <M-d> <C-o>diw
nmap <M-d> diw

" l. 1849
" https://vim.fandom.com/wiki/Change_cursor_shape_in_different_modes
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" CXREF: ~/.vim/pack/landonb/start/dubs_web_hatch/plugin/dubs_web_hatch.vim
"   https://github.com/landonb/dubs_web_hatch

" Load optional web opener plugin, and define commands:
" - <Leader>D — define selected word ('define:<term>') in new browser window
"                 using URL https://www.google.com/search?q=define+<term>
" - <Leader>W — search selected word in new browser window
"                 using URL https://www.google.com/search?q=<term>
" - <Leader>T, or Normal mode `gW` — open URL under cursor in browser
let s:web_hatch_plug = $HOME . "/.vim/pack/landonb/start/dubs_web_hatch/plugin/dubs_web_hatch.vim"
if filereadable(s:web_hatch_plug)
  exec "source " . s:web_hatch_plug
endif

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" COPYD: ~/.vim/pack/landonb/start/dubs_edit_juice/after/plugin/dubs_after_juice.vim
"   https://github.com/landonb/dubs_edit_juice

" See what OS we're on
let s:running_windows = has("win16") || has("win32") || has("win64")

if !s:running_windows
  " Map <Ctrl-V>, <Ctrl-X>, and <Ctrl-C> keys.
  " - Also sets `:behave mswin` (at least MacVim).
  source $VIMRUNTIME/mswin.vim
endif

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" Ctrl-s to save and exit from any mode.
noremap <C-s> :wq<CR>
vnoremap <C-s> <Esc>:wq<CR>
inoremap <C-s> <Esc>:wq<CR>

" Access digraphs at <Ctrl-l>, just like in Dubs Vim:
"   https://github.com/landonb/dubs_edit_juice
"     ~/.vim/pack/landonb/start/dubs_edit_juice/after/plugin/dubs_after_juice.vim
" - Dubs Vim uses Ctrl-l because Ctrl-j/Ctrl-k are used for buffer
"   ring navigation, so Dubs Vim remaps built-in Ctrl-k to Ctrl-l).
"     https://github.com/landonb/vim-buffer-ring
inoremap <C-l> <C-k>

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" Vim defaults textwidth=72 and wraps once you type past that boundary.

autocmd FileType gitcommit setlocal textwidth=0 shiftwidth=2 tabstop=2 expandtab

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" Optional color-scheme (coupled to author's favorite colorscheme).
" CXREF: ~/.vim/pack/landonb/start/dubs_after_dark/colors/after-dark.vim
silent! color after-dark

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

