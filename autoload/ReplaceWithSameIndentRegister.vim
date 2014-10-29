" ReplaceWithSameIndentRegister.vim: Replace lines with the contents of a register, keeping the original indent.
"
" DEPENDENCIES:
"   - ingo/msg.vim autoload script
"   - repeat.vim (vimscript #2136) autoload script (optional)
"   - visualrepeat.vim (vimscript #3848) autoload script (optional)
"   - visualrepeat/reapply.vim autoload script (optional)
"
" Copyright: (C) 2013-2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.002	18-Apr-2013	Add ReplaceWithSameIndentRegister#VisualMode()
"				wrapper around
"				visualrepeat#reapply#VisualMode().
"   1.00.001	21-Mar-2013	file creation from ReplaceWithRegister.vim

function! ReplaceWithSameIndentRegister#SetRegister()
    let s:register = v:register
endfunction
function! ReplaceWithSameIndentRegister#IsExprReg()
    return (s:register ==# '=')
endfunction

function! ReplaceWithSameIndentRegister#Visual( repeatMapping )
    if visualmode() !=# 'V'
	call ingo#msg#ErrorMsg('Indent-replace works only with lines')
	return
    endif

    " Using ]p on a visual selection indent-pastes the text after the selection;
    " in contrast to p it does not replace the selection. Therefore,
    " indent-paste before the selection (so the indent is always based on the
    " first selected line), then remove the previously selected lines.
    let l:regtype = getregtype(s:register)
    let l:actualRegister = s:register
    if s:register ==# '='
	" Cannot evaluate the expression register within a function; unscoped
	" variables do not refer to the global scope. Therefore, evaluation
	" happened earlier in the mappings.
	" To get the expression result into the buffer, we temporarily use the
	" unnamed register.
	let [l:save_reg, l:regtype] = [getreg('"'), getregtype('"')]
	let l:actualRegister = '"'
	call setreg(l:actualRegister, g:ReplaceWithSameIndentRegister_expr, 'V')
    elseif l:regtype !=# 'V'
	" We need to paste in linewise mode.
	let l:save_reg = getreg(s:register)
	call setreg(s:register, '', 'aV')
    endif

    try
	execute "normal! g'<\"" . l:actualRegister . '[P'
	let l:save_view = winsaveview()
	    silent '<,'>delete _
	call winrestview(l:save_view)
    finally
	if exists('l:save_reg')
	    call setreg(l:actualRegister, l:save_reg, l:regtype)
	endif
    endtry

    silent! call repeat#set(a:repeatMapping)
    silent! call visualrepeat#set("\<Plug>ReplaceWithSameIndentRegisterVisual")
endfunction


function! ReplaceWithSameIndentRegister#VisualMode()
    let l:keys = "1v\<Esc>"
    silent! let l:keys = visualrepeat#reapply#VisualMode(0)
    return l:keys
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
