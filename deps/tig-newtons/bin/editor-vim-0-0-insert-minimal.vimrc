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

" PRIVY: Enable to test bare mswin Vim.
if 0
  source ~/.vim/pack/landonb/start/dubs_edit_juice/after/plugin/enable-behave-mswin.vim

  finish
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
" - Note, too, that using <Ctrl-{Arrow}> to jump around will
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

" SAVVY: :packadd does not source after/plugin/ scripts.

" CXREF: https://github.com/landonb/dubs_edit_juice
"
" - <C-c> copy, etc.
"   ~/.vim/pack/landonb/start/dubs_edit_juice/after/plugin/enable-behave-mswin.vim
"
" - <C-h> hides search highlight (:nohlsearch)
"   ~/.vim/pack/landonb/start/dubs_edit_juice/after/plugin/hide-highlights.vim
"
" - Center cursor on search jump (n, N, <M-n>, <M-N>, *, #, g*, g#)
"   ~/.vim/pack/landonb/start/dubs_edit_juice/after/plugin/center-cursor-on-highlight-next-search-match.vim
"
" - <C-s> saves and quits (:wq).
"   ~/.vim/pack/landonb/start/dubs_edit_juice/after/plugin/ctrl-s-save-command.vim
let $VIM_EDIT_JUICE_EXIT_ON_SAVE = 1

function! s:LoadDubsAfterJuiceCommands() abort
  for l:sourcep in [
    \ $HOME . "/.vim/pack/landonb/start/dubs_edit_juice/after/plugin/enable-behave-mswin.vim",
    \ $HOME . "/.vim/pack/landonb/start/dubs_edit_juice/after/plugin/hide-highlights.vim",
    \ $HOME . "/.vim/pack/landonb/start/dubs_edit_juice/after/plugin/center-cursor-on-highlight-next-search-match.vim",
    \ $HOME . "/.vim/pack/landonb/start/dubs_edit_juice/after/plugin/ctrl-s-save-command.vim",
  \ ]
    if filereadable(l:sourcep)
      exec "source " . l:sourcep
    endif
  endfor
endfunction

call s:LoadDubsAfterJuiceCommands()

" Access digraphs at <Ctrl-l>, just like in Dubs Vim:
" - Dubs Vim uses Ctrl-l because Ctrl-j/Ctrl-k are used for buffer
"   ring navigation, so Dubs Vim remaps built-in Ctrl-k to Ctrl-l.
"     https://github.com/landonb/vim-buffer-ring#💍
inoremap <C-l> <C-k>

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" CXREF: Most for parity, so I'm not suprised if this doesn't work.
" - But generally I <C-s> to save and quit a Git commit message
"   EDITOR session.
" - This is not exactly COPYD, but a much simpler impl. of Dubs Vim's
"   it's same as <C-s> ctrl-s-save-command.vim sourced above.
" CXREF: https://github.com/DepoXy/vim-depoxy#🤙
"   ~/.vim/pack/DepoXy/start/vim-depoxy/plugin/vim-save-close-quit-maps.vim

noremap <Leader>dQ :wq<CR>
inoremap <Leader>dQ <C-o>:wq<CR>

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" COPYD: ~/.vim/pack/landonb/start/dubs_ftype_mess/plugin/dubs_ftype_mess.vim
"   https://github.com/landonb/dubs_ftype_mess

" Vim defaults textwidth=72 and wraps once you type past that boundary.
autocmd FileType gitcommit setlocal textwidth=0 shiftwidth=2 tabstop=2 expandtab

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" CXREF: ~/.vim/pack/embrace-vim/start/vim-webopen/autoload/embrace/vim_webopen.vim
"   https://github.com/embrace-vim/vim-webopen#🐣

" Huh, not necessary for autoload fcns:
"
"   packadd vim-webopen

function! s:Webopen_CreateMaps() abort
  let g:vim_webopen_maps =
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

  try
    call g:embrace#webopen#CreateMaps()
	catch /^Vim\%((\a\+)\)\=:E117:/
    " E.g., E117: Unknown function: foo#bar#baz

    echom "ALERT: Please install embrace-vim/vim-webopen to enable browser open commands"
  endtry
endfunction

call s:Webopen_CreateMaps()

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" OHMEH: I don't really <Esc> when writing a Git commit message. I normally
" scribble it out and <C-s> to save and quit.
" - Nonetheless this doesn't seem to affect startup time or performance.
"   So, whatever, adding it.

" CXREF/2024-12-14:
" ~/.vim/pack/embrace-vim/start/vim-async-map/autoload/embrace/async_map.vim
"
" COPYD/2024-12-14:
" ~/.vim/pack/landonb/start/vim-ovm-easyescape-kj-jk/plugin/vim_ovm_easyescape_kj_jk.vim

function! s:AsyncMap_CreateMaps_kj_jk() abort
  try
    " SAVVY: Timeout defaults 100 msec.
    call g:embrace#async_map#RegisterInsertModeMap("kj", "\<ESC>")
    call g:embrace#async_map#RegisterInsertModeMap("jk", "\<ESC>")

    " SAVVY: These don't work at all or as intended when the line above
    " and/or below is missing... oh, well, don't really care that much.
    " - For Git commit message template where there's no line above
    "   but there are below, `kj` start insert mode but on line below;
    "   but `jk` works correctly.
    call g:embrace#async_map#RegisterNormalModeMap("kj", "ji")
    call g:embrace#async_map#RegisterNormalModeMap("jk", "ki")
	catch /^Vim\%((\a\+)\)\=:E117:/
    " E.g., E117: Unknown function: foo#bar#baz

    echom "ALERT: Please install embrace-vim/vim-async-map to enable "
      \ .. "`kj`/`jk` insert and normal mode maps"
  endtry
endfunction

call s:AsyncMap_CreateMaps_kj_jk()

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" COPYD: ~/.vim/pack/DepoXy/start/vim-depoxy/plugin/vim-shift-ctrl-bindings.vim
"   https://github.com/DepoXy/vim-depoxy#🤙
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

