" vim:tw=0:ts=2:sw=2:et:norl:ft=vim
" Author: Landon Bouma <https://tallybark.com/>
" Project: https://github.com/DepoXy/tig-newtons#🍎
" License: MIT. Please find more in the LICENSE file.

" Copyright (c) © 2020-2023 Landon Bouma. All Rights Reserved.

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" COPYD: ~/.vim/.vimrc
" https://github.com/landonb/dubs-vim#🖖

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
" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" COPYD: ~/.vim/plugin/dubs_preloads.vim
" https://github.com/landonb/dubs-vim#🖖

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
" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" 'Defaults everyone can agree on'
" https://github.com/tpope/vim-sensible
" - CXREF:
"   ~/.vim/pack/tpope/opt/vim-sensible/plugin/sensible.vim
packadd vim-sensible

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" SAVVY/2024-12-12: Phew! We can load select plugins at runtime.
" - So far I don't notice a performance difference with these
"   enabled or not!
" - Note that after/plugin/ scripts are *not* loaded.

" ***

" Load a look 'n feel (lots of `set` commands).
" https://github.com/landonb/dubs_appearance#💅
packadd dubs_appearance

" Disable line no. for distraction-free Git commit authoring.
set nonu

" ***

" Load a ton of command maps author is accustomed to.
" https://github.com/landonb/dubs_edit_juice#🧃
packadd dubs_edit_juice

" ***

" Load selection gestures (like <Ctrl-Shift-{Arrow}>).
" https://github.com/landonb/vim-select-mode-stopped-down#🛑
packadd vim-select-mode-stopped-down

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" Close undo sequence on newline.
" - Use case is normally starting a fresh line and messing up the
"   first few words or changing what I'm thinking of writing.
" - Though normally I'll hit <Ctrl-W> to delete back a word,
"   or <Shift-Ctrl-W> to delete the whole line.
" - Really, I don't use undo that often, but when I do, I'm
"   still not used to Vim obliterately everything I've written
"   in insert mode!
" - Note, too, that use <Ctrl-{Arrow}> to jump around will
"   break an undo sequence (e.g., <Ctrl-Left> runs <C-O>b,
"   and the <C-O> naturally ends an undo sequence because
"   it temporary breaks out of insert mode to run a command,
"   which inherently closes the current undo sequence).
"
" REFER: :h i_CTRL-G_u

" Create new undo block at every newline, undoes to end of prev line.
"   inoremap <CR> <C-g>u<CR>
" Create new undo block at every newline, undoes to end of curr line.
inoremap <CR> <CR><C-g>u

" Undoes to start of word that's removed.
"   inoremap <Space> <Space><C-g>u
" Undoes to end of word that's removed.
" - But if you tab and it expands, *every space is an undo!*
" - So I'd say this is too annoying, way too fine-grained.
"   - You're better off <Ctrl-W>'ing to delete the previous
"     word or otherwise normally editing any mistakes on the
"     current line.
"
"   inoremap <Space> <C-g>u<Space>

" You could similar close undo sequences on <Tab>, but author
" almost exclusively expands <Tab>, and this Vimrc is mainly
" for Git commit messages wherein you won't use a real <Tab>.
"
"   inoremap <Tab> <Tab><C-g>u

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

if 0
  " COPYD: ~/.vim/pack/landonb/start/dubs_edit_juice/plugin/dubs_edit_juice.vim
  "   https://github.com/landonb/dubs_edit_juice

  " FIXME/2023-02-02 13:40: This is getting ridiculous: Split dubs_edit_juice.vim
  " - Move stuff you want in here into, dunno, dubs_edit_quick.vim, or
  "   dubs_edit_juicy.vim ha. (Or something akin to tpope's vim-sensible,
  "   vim-minimal, perhaps.)

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
  inoremap <C-T> <C-o>:call <SID>TransposeCharacters()<CR>
  inoremap <M-T> <C-o>:call <SID>TransposeCharacters()<CR>

  " l. 794
  " Tab/Shift-Tab to dedent/indent
  vnoremap <Tab> >gv
  vnoremap <S-Tab> <gv
  "
  func! CursorFriendlyIndent(ind)
    if &sol
      set nostartofline
    endif
    let vcol = virtcol('.')
    if a:ind
      norm! >>
      exe "norm!". (vcol + shiftwidth()) . '|'
    else
      norm! <<
      exe "norm!". (vcol - shiftwidth()) . '|'
    endif
  endfunc
  "
  " CRUMB: <Shift-Ctrl-D> <S-C-D> <Ctrl-Shift-D> <C-S-D>
  inoremap <S-C-D> <C-O>:call CursorFriendlyIndent(1)<CR>
  "
  " Not necessary (builtin <C-D> behaves the same):
  inoremap <C-D> <C-O>:call CursorFriendlyIndent(0)<CR>
  "
  " But we can 'enchance' built-in << and >>:
  nnoremap >> :call CursorFriendlyIndent(1)<cr>
  nnoremap << :call CursorFriendlyIndent(0)<cr>
  "
  " Visual mode is easy, because cursor position doesn't matter.
  vnoremap <S-C-D> >gv
  " For MacVim, where <S-C> input is stripped of the <S> (see comment above).
  vnoremap <S-M-D> >gv

  " l. 1533
  " Insert date abbreviations
  iabbrev <expr> TTT strftime("%Y-%m-%d")
  iabbrev <expr> TTT_ strftime("%Y_%m_%d")
  iabbrev <expr> TTTtt strftime("%Y-%m-%d %H:%M")
  iabbrev <expr> TTTTtt strftime("%Y-%m-%dT%H:%M")
  iabbrev <expr> ttt strftime("%H:%M")
  inoremap <silent> <unique> <Leader>T <C-R>=strftime("/%Y-%m-%d: ")<CR>
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
  " +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

  " COPYD:~/.vim/pack/landonb/start/dubs_edit_juice/autoload/dubs_edit_juice_backspace.vim
  "   https://github.com/landonb/dubs_edit_juice

  function! s:delete_back_line() abort
    " SAVVY: <c-g>u starts a new Undo set, so the deletion can be undone.
    " - REFER: :help undo-break
    " - BWARE: Note that running <c-g>u moves the cursor, e.g., if the
    "   user <S-C-W>'s from the end of a line and this fcn. starts with:
    "     execute "normal i\<C-g>u\<ESC>"
    "   then the final 2 chars from that line are left behind.
    "   - So use the other trick to close the undo block, assign to undolevels:
    let &g:undolevels = &g:undolevels

    " Mimic `d<Home>`, but behave better at end of line.
    let curr_col = col(".")
    let line_nbytes = len(getline(line(".")))
    if l:curr_col == 1
      if line(".") > 1
        normal! k
      endif
      " If the line has leading whitespace, Vim will put the cursor over
      " the first visible character, so ensure cursor finishes on col 1
      " by running `0` after the `dd`.
      normal! dd0
    else
      normal! d0
      if l:curr_col >= l:line_nbytes
        normal! x
      endif
    endif
  endfunction

  " +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
  " +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

  " COPYD: ~/.vim/pack/landonb/start/dubs_edit_juice/plugin/ctrl-backspace.vim
  "   https://github.com/landonb/dubs_edit_juice

  function! s:delete_back_word(mode)
    " Mimic `db`, but behave different at end of line, and at beginning.
    let curr_col = col(".")
    let line_nbytes = len(getline("."))
    if l:curr_col == 1
      let was_ww = &whichwrap
      set whichwrap=h
      normal! dh
      if a:mode == 'i' && l:line_nbytes == 0
        " A `dh` on an empty line deletes the newline but moves the cursor one
        " before the final character (probably because of virtualedit behavior),
        " so jump to the final cursor position.
        normal! $
      endif
      execute "set whichwrap=" . l:was_ww
    else
      let curpos = getcurpos()
      let curswant = curpos[4]
      let last_col = virtcol("$")

      let last_pttrn = @/
      let @/ = "\\(\\(\\_^\\|\\<\\|\\s\\+\\)\\zs\\|\\>\\)"
      normal! dN
      if (a:mode == 'i' && l:curswant >= l:last_col)
        \ || (a:mode == 'n' && (l:curswant + 1) >= l:last_col)
        " The final character escaped the dN motion. Delete it.
        normal! x
        " Weird: I'm seeing getcurpos() report incoorect curswant.
        " E.g., if the line is
        "         foo bar
        " and I C-BS to delete the 'bar' in insert mode, so what's
        " left is 'foo ', and the cursor is after the space, the
        " curswant should be 5, but getcurpos says 4. If I hit
        " '$' though, the cursor does not move, but curswant updates
        " to 5. So ensure curswant is accurate if this function
        " called again.
        normal! $
      endif
      let @/ = l:last_pttrn
    endif
  endfunction

  function! s:free_keys_delete_backwards_c_bs()
    silent! nunmap <C-BS>
    silent! iunmap <C-BS>
  endfunction

  function! s:free_keys_delete_backwards_m_bs()
    silent! nunmap <M-BS>
    silent! iunmap <M-BS>
  endfunction

  function! s:free_keys_delete_backwards_c_s_bs()
    silent! nunmap <C-S-BS>
    silent! iunmap <C-S-BS>
  endfunction

  function! s:free_keys_delete_backwards()
    call s:free_keys_delete_backwards_c_bs()
    call s:free_keys_delete_backwards_m_bs()
    call s:free_keys_delete_backwards_c_s_bs()
  endfunction

  " ***

  function! s:wire_keys_delete_backwards_c_bs()
    nnoremap <C-BS> :<C-U>call <SID>delete_back_word('n')<CR>
    inoremap <C-BS> <C-O>:<C-U>call <SID>delete_back_word('i')<CR>
  endfunction

  function! s:wire_keys_delete_backwards_m_bs()
    nnoremap <M-BS> :<C-U>call <SID>delete_back_word('n')<CR>
    inoremap <M-BS> <C-O>:<C-U>call <SID>delete_back_word('i')<CR>
  endfunction

  function! s:wire_keys_delete_backwards_c_s_bs()
    nnoremap <C-S-BS> :<C-U>call s:delete_back_line()<CR>
    inoremap <C-S-BS> <C-O>:<C-U>call s:delete_back_line()<CR>
    inoremap <c-s-w> <C-O>:<C-U>call s:delete_back_line()<CR>
    inoremap <m-s-w> <C-O>:<C-U>call s:delete_back_line()<CR>
  endfunction

  function! s:wire_keys_delete_backwards()
    call s:wire_keys_delete_backwards_c_bs()
    call s:wire_keys_delete_backwards_m_bs()
    call s:wire_keys_delete_backwards_c_s_bs()
  endfunction

  " ***

  function! s:inject_maps_delete_backwards()
    call <SID>free_keys_delete_backwards()
    call <SID>wire_keys_delete_backwards()
  endfunction

  call <SID>inject_maps_delete_backwards()
endif
" FIXME/2024-12-12 02:43: DELETE TO HERE

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" COPYD: ~/.vim/pack/landonb/start/dubs_edit_juice/after/plugin/dubs_after_juice.vim
"   https://github.com/landonb/dubs_edit_juice

" SAVVY: :packadd does not source after/plugin/ scripts.
" - So we copy what we want here.
" FIXME/2024-12-12 02:23: Split that script in two so we can source it.
" - Note this works fine, but <Ctrl-J> et al return 'Not an editor command'
"   errors because buffer ring plugin is not loaded. Which we don't want
"   anyway.
"   - So thinking you should just split that file in two.
"     - Makes sense to move buffer ring stuff to its own
"       file, anyway.
if 0
  let s:dubs_after_juice = $HOME . "/.vim/pack/landonb/start/dubs_edit_juice/after/plugin/dubs_after_juice.vim"
  if filereadable(s:dubs_after_juice)
    exec "source " . s:dubs_after_juice
  endif
endif

if 1
  " See what OS we're on
  let s:running_windows = has("win16") || has("win32") || has("win64")

  if !s:running_windows
    " Map <Ctrl-V>, <Ctrl-X>, and <Ctrl-C> keys, and insert mode <Ctrl-Z>.
    " - Also sets `:behave mswin` (at least MacVim).
    source $VIMRUNTIME/mswin.vim
  endif

  " Ctrl-H Hides Highlighting
  noremap <C-h> :nohlsearch<CR>
  inoremap <C-h> <C-O>:nohlsearch<CR>
  cnoremap <C-h> <C-C>:nohlsearch<CR>
  onoremap <C-h> <C-C>:nohlsearch<CR>

  " Access digraphs at <Ctrl-l>, just like in Dubs Vim:
  " - Dubs Vim uses Ctrl-l because Ctrl-j/Ctrl-k are used for buffer
  "   ring navigation, so Dubs Vim remaps built-in Ctrl-k to Ctrl-l.
  "     https://github.com/landonb/vim-buffer-ring
  inoremap <C-l> <C-k>

  nnoremap n nzz
  nnoremap N Nzz
  nnoremap <M-n> nzz
  nnoremap <M-N> Nzz
  nnoremap * *zz
  nnoremap # #zz
  nnoremap g* g*zz
  nnoremap g# g#zz

  " Ctrl-s to save and exit from any mode.
  noremap <C-s> :wq<CR>
  vnoremap <C-s> <Esc>:wq<CR>
  inoremap <C-s> <Esc>:wq<CR>
endif

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" COPYD: ~/.vim/pack/landonb/start/dubs_ftype_mess/plugin/dubs_ftype_mess.vim
"   https://github.com/landonb/dubs_ftype_mess

" Vim defaults textwidth=72 and wraps once you type past that boundary.
autocmd FileType gitcommit setlocal textwidth=0 shiftwidth=2 tabstop=2 expandtab

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" CXREF: ~/.vim/pack/embrace-vim/start/vim-web-hatch/plugin/vim-web-hatch.vim
"   https://github.com/embrace-vim/vim-web-hatch#🐣

" Huh, not necessary for autoload fcns:
"
"   packadd vim-web-hatch

let g:vim_web_hatch_maps =
  \ {
  \   "open":
  \     {
  \       "nmap": [ "<Leader>T", "gW" ],
  \       "imap": "<Leader>T",
  \       "vmap": "<Leader>T",
  \     },
  \   "define": "<Leader>D",
  \   "search": "<Leader>W",
  \   "incognito": { "nmap": "g!" },
  \ }

call embrace#vim_web_hatch#create_maps()

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" COPYD: ~/.depoxy/ambers/home/.vim/pack/DepoXy/start/vim-depoxy/plugin/vim-shift-ctrl-bindings.vim
" https://github.com/DepoXy/depoxy#🍯
"
" - CXREF: See Alacritty substitutions for terminal `vim`:
"     ~/.depoxy/ambers/home/.config/alacritty/alacritty.toml
" - CXREF: See Hammerspoon substitution for MacVim:
"     ~/.depoxy/ambers/home/.hammerspoon/depoxy-hs.lua
"
" These each call a dubs_edit_juice function.

" DUNNO/2024-12-12 03:01: Now that I've added these, and so :packadd's
" above, if I disable these, they still work!

" Enable <Shift-Ctrl-D>
inoremap  <C-O>:call CursorFriendlyIndent(1)<CR>

" Enable <Shift-Ctrl-W>
inoremap  <C-O>:<C-U>call dubs_edit_juice_backspace#delete_back_line()<CR>

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" Author's (favorite) colorscheme (won't error if not installed).
" CXREF: ~/.vim/pack/landonb/start/dubs_after_dark/colors/after-dark.vim
silent! colorscheme after-dark

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

