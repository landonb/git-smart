" vim:tw=0:ts=2:sw=2:et:norl:ft=vim
" Author: Landon Bouma <https://tallybark.com/>
" Project: https://github.com/DepoXy/tig-newtons#🍎
" License: MIT. Please find more in the LICENSE file.

" Copyright (c) © 2015, 2018-2025 Landon Bouma. All Rights Reserved.

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" COPYD: OS Bootstrap and MacVim setup copied from DepoXy
"          ~/.depoxy/ambers/home/.vim/.vimrc
"        https://github.com/DepoXy/depoxy#🍯

" ----------------------------------------
"  Distro Bootstrap
" ----------------------------------------

" Not every Vim distribution includes a vimrc, but if we can find one,
" load it.
" - CALSO: Same with defaults.vim, which we'll source after this.
function! s:SourceDistroVimrc() abort
  if filereadable($VIMRUNTIME . "/../vimrc")
    " - E.g., MacVim:
    "   /Applications/MacVim.app/Contents/Resources/vim/runtime/../vimrc
    "   - CALSO:
    "     /Applications/MacVim.app/Contents/Resources/vim/gvimrc
    source $VIMRUNTIME/../vimrc
  elseif filereadable($VIMRUNTIME . "/../_vimrc")
    " - SAVVY/2009-09-21: For native Windows gVim to work properly.
    "   - HSTRY/2025-01-23: Keeping for historic reasons, but cannot vouch.
    source $VIMRUNTIME/../_vimrc
  elseif filereadable($VIMRUNTIME . "/../.vimrc")
    " - Possibly found on some 'nix distros [author added this block in
    "   2009, when I may have been on Fedora in VM on Windows, and also
    "   using Cygwin, but 2009 Cygwin Vim doesn't include a vimrc file].
    source $VIMRUNTIME/../.vimrc
  else
    " Don't bother complaining. This file doesn't exist everywhere.
    " - E.g., Debian 12 has /usr/share/vim/gvimrc, but no vimrc (and
    "   gvimrc is just comments).
    " - Also, e.g., LM 19.3: Author runs local build, where
    "   $VIMRUNTIME is ~/.local/share/vim/vim82/ but there's nothing
    "   else under ~/.local/share/vim and no vimrc thereunder.
  endif
endfunction

call s:SourceDistroVimrc()

" ***

" You'll likely find a defaults.vim in the runtime path,
" but it's not always necessary to source it.
" - E.g., the author's usual Vim configuration ignores it
"   and runs just fine.
" - But I had issues when I didn't source it for minimal.vim:
"   - There were strange phantom control characters on the first
"     line of input; the arrow keys didn't work (they'd insert
"     As, Bs, Cs, and Ds); Ctrl-s didn't work; and also probably
"     lots more but I quit after noting those three.
"   - DUNNO: I think MacVim vim TUI, but might have been Linux build.
" - So this `source defaults.vim` necessary from minimal.vimrc,
"   but probably not from your normal ~/.vimrc
function! s:SourceDistroDefaults() abort
  if filereadable($VIMRUNTIME . "/defaults.vim")
    " CXREF: Some places you might find this file:
    "   /Applications/MacVim.app/Contents/Resources/vim/runtime/defaults.vim
    "   /usr/share/vim/vim90/defaults.vim
    "   ~/.local/share/vim/vim90/defaults.vim
    source $VIMRUNTIME/defaults.vim
  endif
endfunction

call s:SourceDistroDefaults()

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" CALSO: See also author's more complicated mswin.vim loader,
"        which saves and restores <C-f> and <C-h> bindings.
"
" - Because plugin order is not guaranteed, and author's Vim config
"   calls `behave mswin` from ~/.vim/pack/*/start/*/plugin script,
"   it's possible another plugin sets <C-f> and <C-h> before mswin.vim
"   runs.
"
" CXREF: https://github.com/landonb/dubs_edit_juice#🧃
"
"   https://github.com/landonb/dubs_edit_juice/blob/release/after/plugin/enable-behave-mswin.vim
"
" ALTLY: You can also source that plugin file here, e.g.:
"
"  source ~/.vim/plugs/landonb/start/dubs_edit_juice/after/plugin/enable-behave-mswin.vim

function! s:EnableBehaveMswin() abort
  let s:running_windows = has("win16") || has("win32") || has("win64")

  if !s:running_windows
    if has('nvim')
      " CXREF:
      " /Applications/MacVim.app/Contents/Resources/vim/runtime/mswin.vim
      source $VIMRUNTIME/mswin.vim
    else
      behave mswin
    endif

    return 1
  endif

  return 0
endfunction

" DEVEL: Enable this to test bare mswin Vim.
if 0 && s:EnableBehaveMswin()

  finish
endif

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" ------------------------------------------------------
" Preemptive MacVim configuration
" ------------------------------------------------------

" Disable features from MacVim gvimrc, and enable Alt-key sequences.
"
" CXREF:
" /Applications/MacVim.app/Contents/Resources/vim/gvimrc

" SAVVY: Because scope, do not call `let` from within fcn.
"
" - E.g., this won't work:
"
"     function! s:ConfigureMacVim() abort
"       let macvim_skip_colorscheme=1
"       ...
"
"   because macvim_skip_colorscheme won't be visiable outside
"   that function.

" Note that MacVim also sets 'gui_macvim' for terminal Vim.
if has('macunix') && has('gui_macvim')
  " ISOFF: For broader compatibility throughout macOS (n)vim instances,
  " be they GUIs or TUIs, prefer using literal <Option> key map sequences,
  " and not control sequences.
  " - E.g., while this binds <Shift-Alt-3> on Linux and in MacVim with
  "   |macmeta| enabled:
  "     nnoremap <M-#> :Foobar<CR>
  "   It doesn't work in Neovide or terminal Vim.
  " - So use literal characters instead, e.g.:
  "     nnoremap ‹ :Foobar<CR>
  "   though note you'll want to avoid 2-character macOS accent-generator
  "   bindings, like <Option-e>, <Option-i>, etc.
  "
  "  " Enable Alt-key (aka Meta, aka Option) mappings (e.g., <M-a>).
  "  set macmeta

  " Don't let MacVim call `colorscheme macvim`.
  " - See our `colorscheme` call elsewhere in this file.
  " - CXREF:
  "   ~/.vim/plugs/landonb/start/dubs_after_dark/
  " - REFER: |macvim-colorscheme|
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

" USAGE: Set TIGNEWTONS_VIM_PLUGS if your plugins are not under ~/.vim/pack
"
" - Note that |packadd| scans the |packpath| directories to locate
"   plugin scripts — at {packpath}/pack/*/opt/{plugin-name}/plugin/
"
"     - And also at {packpath}/pack/*/start/{plugin-name}/plugin/
"       if --noplugins or noloadplugins in effect.
"
" - Because ~/.vim is the first path on &packpath, ~/.vim/pack is
"   commonly used for storing plugins, at least if the user is
"   relying on built-in |packloadall| behavior.
"
" - But if user is using a plugin manager, e.g., vim-plug, then they're
"   likely *not* using ~/.vim/pack, so that Vim does not automatically
"   load any plugins.
"
"   - In this case, there is no conventional plugins path.
"
"   - Furthermore, plugin managers don't expact the packpath layout.
"
"     - E.g., you'd call just `Plug '~/path/to/my/plugin` to register
"       a plugin with vim-plug (and later vim-plug calls `source` on
"       the individual plugin/ and after/ files).
"
" - Note that DepoXy stores plugins under the arbitrarily-picked
"   ~/.vim/plugs (which you'll see refereneced in comments throughout
"   this file).
"
"   - But ~/.vim/plugs doesn't itself have a pack/ subdirectory.
"
"   - If we wanted to use |packadd|, we'd need that pack/ directory:
"
"     - We could stuff everything under ~/.vim/plugs/pack/
"
"     - Or we could create an intermediate directory, e.g.,
"
"         mkdir ~/.vim/foo
"         ln -s ~/.vim/plugs ~/.vim/foo/pack
"         TIGNEWTONS_VIM_PACKPATH=~/.vim/foo \
"           vim -u minimal.vimrc --noplugin
"
"       - And then herein: set packpath+=$TIGNEWTONS_VIM_PACKPATH
"
"   - Because of this (minor) issue, use vim-plug and don't worry 'bout
"     the intermediate pack/ directory.

" ----------------------------------------
"  Plugin declarations
" ----------------------------------------

function! s:PlugBootstrap() abort
  if has('nvim')
    " Unnecessary check: Neovim doesn't source this file unless you source it.
    echom "ALERT: Don't source ~/.vimrc from Neovim, eh"

    return 0
  endif

  " ***

  " Check if plugin dir for vim-plug, e.g., ~/.vim/plugs
  let s:plugins_dir = $TIGNEWTONS_VIM_PLUGS

  " Fallback ~/.vim/pack and |packadd|
  if s:plugins_dir == ''
      \ || fnamemodify(s:plugins_dir, ':p') == fnamemodify($HOME . '/.vim/pack', ':p')
    let s:plugins_dir = ''

    " REFER: |loadplugins| aka |lpl| is unnecessary here if caller
    " used --noplugin, but setting here means they don't have to.
    " - E.g., these both work:
    "     vim -u /path/to/editor-vim-0-0-insert-minimal.vimrc --noplugin
    "     vim -u /path/to/editor-vim-0-0-insert-minimal.vimrc
    " - BWARE: But don't use with vim-plug or nothing loads.
    set noloadplugins
  endif

  " ***

  if s:plugins_dir != ''
    try
      call plug#begin()
    catch /^Vim\%((\a\+)\)\=:E117:/
      " E.g., E117: Unknown function: foo#bar#baz
      echom "ERROR: Missing autoload/plug.vim from:"
      echom "  https://github.com/junegunn/vim-plug"

      return 0
    endtry
  endif

  " ***

  " vim-sensible — 'Defaults everyone can agree on'
  " https://github.com/tpope/vim-sensible
  " - CXREF:
  "   ~/.vim/plugs/tpope/opt/vim-sensible/plugin/sensible.vim
  call s:PlugsRegister(s:plugins_dir, 'tpope/opt/vim-sensible')

  " +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
  " +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

  " SAVVY/2024-12-12: Load select plugins at runtime.
  " - So far I don't notice a performance difference
  "   with these enabled or not.
  " - Note that after/plugin/ scripts are *not* loaded by |packadd|
  "   (if ~/.vim/pack exists), but they are by vim-plug (if using
  "   user-provided plugins path).

  call s:SourcePluginsPre()

  " ***

  " Load a look 'n feel (lots of `set` commands).
  " https://github.com/landonb/dubs_appearance#💅
  call s:PlugsRegister(s:plugins_dir, 'landonb/start/dubs_appearance')

  " ***

  " Load a ton of command maps to which author is accustomed.
  " https://github.com/landonb/dubs_edit_juice#🧃
  call s:PlugsRegister(s:plugins_dir, 'landonb/start/dubs_edit_juice')

  " ***

  " Load selection gestures (like <Ctrl-Shift-{Arrow}>).
  " https://github.com/landonb/vim-select-mode-stopped-down#🛑
  call s:PlugsRegister(s:plugins_dir, 'landonb/start/vim-select-mode-stopped-down')

  " ***

  if s:plugins_dir != ''
    call s:PlugsRegister(s:plugins_dir, 'embrace-vim/start/vim-async-map')

    call s:PlugsRegister(s:plugins_dir, 'embrace-vim/start/vim-webopen')

    call s:PlugsRegister(s:plugins_dir, 'landonb/start/dubs_after_dark')
  endif

  " ***

  " Update &runtimepath and initialize the plugin system.
  " - Also runs `filetype plugin indent on` and `syntax enable`.
  if s:plugins_dir != ''
    call plug#end()
  endif

  " ***

  au VimEnter * call s:SourcePluginsPost()

  " Author's (favorite) colorscheme (won't error if not installed).
  " CXREF: ~/.vim/plugs/landonb/start/dubs_after_dark/colors/after-dark.vim
  " - Should be found on &rtp now because plug#end().
  silent! colorscheme after-dark

  return 1
endfunction

" ***

function! s:PlugsRegister(plugins_dir, subdir) abort
  if a:plugins_dir != ''
    " Using arbitrary plugins path, and bootstrapping with vim-plug.
    call s:PlugsRegister_Vimplug(a:plugins_dir, a:subdir)
  else
    " Using conventional ~/.vim/pack path, and relying on |packadd|.
    call s:PlugsRegister_Packpath(a:subdir)
  endif
endfunction

" SAVVY: Note that 'Plug' will source files under after/, but when
" using |packadd|, Vim will not source files under after/.
" - See below: s:LoadDubsAfterJuiceCommands()
"   which manually sources after/ scripts when using |packadd|
" - Otherwise just FYI: |Plug| sources all after/ scripts.
function! s:PlugsRegister_Vimplug(plugins_dir, subdir) abort
  let l:project_path = a:plugins_dir .. '/' .. a:subdir

  if isdirectory(l:project_path)
    Plug l:project_path
  else
    echom 'ALERT: Missing vim-plug plugin: ' .. l:project_path
  endif
endfunction

function! s:PlugsRegister_Packpath(subdir) abort
  let l:plugin_name = fnamemodify(a:subdir, ':t')

  try
    exec 'packadd ' .. l:plugin_name
  catch /^Vim\%((\a\+)\)\=:E919:/
    " E.g., E919: Directory not found in 'packpath': "pack/*/opt/foo"
    echom 'ALERT: Missing packpath plugin: ' .. l:plugin_name
  endtry
endfunction

" ***

" REFER: See comment below re: dubs_edit_juice
" - <C-s> saves and quits (:wq).
"   ~/.vim/plugs/landonb/start/dubs_edit_juice/after/plugin/ctrl-s-save-command.vim
function! s:SourcePluginsPre() abort
  let $VIM_EDIT_JUICE_EXIT_ON_SAVE = 1
endfunction

function! s:SourcePluginsPost() abort
  " Disable line no. for distraction-free Git commit authoring.
  " - CXREF:
  "   ~/.vim/plugs/landonb/start/dubs_appearance/plugin/line_numbers_show.vim
  set nonu
endfunction

" ***

if ! s:PlugBootstrap()

  finish
endif

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
"   ~/.vim/plugs/landonb/start/dubs_edit_juice/after/plugin/enable-behave-mswin.vim
"
" - <C-h> hides search highlight (:nohlsearch)
"   ~/.vim/plugs/landonb/start/dubs_edit_juice/after/plugin/hide-highlights.vim
"
" - Center cursor on search jump (n, N, <M-n>, <M-N>, *, #, g*, g#)
"   ~/.vim/plugs/landonb/start/dubs_edit_juice/after/plugin/center-cursor-on-highlight-next-search-match.vim
"
" - <C-s> saves and quits (:wq).
"   ~/.vim/plugs/landonb/start/dubs_edit_juice/after/plugin/ctrl-s-save-command.vim
"
"     let $VIM_EDIT_JUICE_EXIT_ON_SAVE = 1
"
"   - CXREF: See above: s:SourcePluginsPre()

function! s:LoadDubsAfterJuiceCommands() abort
  " Check if custom plugin path, e.g., ~/.vim/plugs
  if s:plugins_dir != ''
    " Unnecessary when using vim-plug, which sources after/ files.

    return
  endif

  call s:SourcePluginsPre()

  " Conventional ~/.vim/pack path
  let l:pack_dir = $HOME . '/.vim/pack'

  for l:sourcep in [
    \ l:pack_dir . '/landonb/start/dubs_edit_juice/after/plugin/enable-behave-mswin.vim',
    \ l:pack_dir . '/landonb/start/dubs_edit_juice/after/plugin/hide-highlights.vim',
    \ l:pack_dir . '/landonb/start/dubs_edit_juice/after/plugin/center-cursor-on-highlight-next-search-match.vim',
    \ l:pack_dir . '/landonb/start/dubs_edit_juice/after/plugin/ctrl-s-save-command.vim',
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
"   ~/.vim/plugs/DepoXy/start/vim-depoxy/plugin/vim-save-close-quit-maps.vim

noremap <Leader>dQ :wq<CR>
inoremap <Leader>dQ <C-o>:wq<CR>

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" COPYD: ~/.vim/plugs/landonb/start/dubs_ftype_mess/plugin/dubs_ftype_mess.vim
"   https://github.com/landonb/dubs_ftype_mess

" SAVVY: Vim defaults textwidth=72 and wraps once you type past that boundary.

" SAVVY: Even with spellcheck on, Vim ignores spell errors below the diff line.
" - E.g.:
"    # Please enter the commit message for your changes. Lines starting
"    # with '#' will be ignored, and an empty message aborts the commit.
"    ...
"    SpellingError <--Spell checked
"    diff --git foo foo
"    SpellingError <-- Not spelled checked

autocmd FileType gitcommit setlocal textwidth=0 shiftwidth=2 tabstop=2 expandtab spell

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" CXREF: ~/.vim/plugs/embrace-vim/start/vim-webopen/autoload/embrace/vim_webopen.vim
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
" ~/.vim/plugs/embrace-vim/start/vim-async-map/autoload/embrace/async_map.vim
"
" COPYD/2024-12-14:
" ~/.vim/plugs/landonb/start/vim-ovm-easyescape-kj-jk/plugin/vim_ovm_easyescape_kj_jk.vim

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

" COPYD: ~/.vim/plugs/DepoXy/start/vim-depoxy/plugin/vim-shift-ctrl-bindings.vim
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

