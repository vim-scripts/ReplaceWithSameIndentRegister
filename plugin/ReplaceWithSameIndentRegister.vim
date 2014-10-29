" ReplaceWithSameIndentRegister.vim: Replace lines with the contents of a register, keeping the original indent.
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher.
"   - ReplaceWithSameIndentRegister.vim autoload script
"
" Copyright: (C) 2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.003	18-Apr-2013	Use optional visualrepeat#reapply#VisualMode()
"				for normal mode repeat of a visual mapping.
"				When supplying a [count] on such repeat of a
"				previous linewise selection, now [count] number
"				of lines instead of [count] times the original
"				selection is used.
"   1.00.002	22-Mar-2013	Change default mappings from gri / gi to grR /
"				gR because of ambiguity of e.g. gri" (replace
"				inner quoted string). R is no motion, so grR is
"				fine. Likewise, gR in visual mode is not useful
"				and seems to do the same as v_c.
"   1.00.001	21-Mar-2013	file creation from ReplaceWithRegister.vim

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_ReplaceWithSameIndentRegister') || (v:version < 700)
    finish
endif
let g:loaded_ReplaceWithSameIndentRegister = 1

let s:save_cpo = &cpo
set cpo&vim

" This mapping needs repeat.vim to be repeatable, because it consists of
" multiple steps (]p and deletion of selected lines inside
" ReplaceWithSameIndentRegister#Visual).
nnoremap <silent> <Plug>ReplaceWithSameIndentRegisterLine
\ :<C-u>call setline('.', getline('.'))<Bar>
\execute 'silent! call repeat#setreg("\<lt>Plug>ReplaceWithSameIndentRegisterLine", v:register)'<Bar>
\call ReplaceWithSameIndentRegister#SetRegister()<Bar>
\if ReplaceWithSameIndentRegister#IsExprReg()<Bar>
\    let g:ReplaceWithSameIndentRegister_expr = getreg('=')<Bar>
\endif<Bar>
\execute 'normal! V' . v:count1 . "_\<lt>Esc>"<Bar>
\call ReplaceWithSameIndentRegister#Visual("\<lt>Plug>ReplaceWithSameIndentRegisterLine")<CR>

" Repeat not defined in visual mode, but enabled through visualrepeat.vim.
vnoremap <silent> <Plug>ReplaceWithSameIndentRegisterVisual
\ :<C-u>call setline('.', getline('.'))<Bar>
\execute 'silent! call repeat#setreg("\<lt>Plug>ReplaceWithSameIndentRegisterVisual", v:register)'<Bar>
\call ReplaceWithSameIndentRegister#SetRegister()<Bar>
\if ReplaceWithSameIndentRegister#IsExprReg()<Bar>
\    let g:ReplaceWithSameIndentRegister_expr = getreg('=')<Bar>
\endif<Bar>
\call ReplaceWithSameIndentRegister#Visual("\<lt>Plug>ReplaceWithSameIndentRegisterVisual")<CR>

" A normal-mode repeat of the visual mapping is triggered by repeat.vim. It
" establishes a new selection at the cursor position, of the same mode and size
" as the last selection.
"   If [count] is given, that number of lines is used / the original size is
"   multiplied accordingly. This has the side effect that a repeat with [count]
"   will persist the expanded size, which is different from what the normal-mode
"   repeat does (it keeps the scope of the original command).
" First of all, the register must be handled, though.
nnoremap <silent> <Plug>ReplaceWithSameIndentRegisterVisual
\ :<C-u>call setline('.', getline('.'))<Bar>
\execute 'silent! call repeat#setreg("\<lt>Plug>ReplaceWithSameIndentRegisterVisual", v:register)'<Bar>
\call ReplaceWithSameIndentRegister#SetRegister()<Bar>
\if ReplaceWithSameIndentRegister#IsExprReg()<Bar>
\    let g:ReplaceWithSameIndentRegister_expr = getreg('=')<Bar>
\endif<Bar>
\execute 'normal!' ReplaceWithSameIndentRegister#VisualMode()<Bar>
\call ReplaceWithSameIndentRegister#Visual("\<lt>Plug>ReplaceWithSameIndentRegisterVisual")<CR>


if ! hasmapto('<Plug>ReplaceWithSameIndentRegisterLine', 'n')
    nmap grR <Plug>ReplaceWithSameIndentRegisterLine
endif
if ! hasmapto('<Plug>ReplaceWithSameIndentRegisterVisual', 'x')
    xmap gR <Plug>ReplaceWithSameIndentRegisterVisual
endif

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
