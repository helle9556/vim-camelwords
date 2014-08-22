" Regular expression {{{

let s:or = '\|'

" Define uppercase as usual
let s:upper = '\u'

" Define lowercase as a non-uppercase, non-digit, non-underscore keyword char
let s:lower = '\%\(\%(\u\|\d\|_\)\@!\k\)'

" Define numbers as any number of digits
let s:number = '\d\+'

" Define camelhumps as one uppercase followed by any number of lowercase chars
let s:camelhump = s:upper.s:lower.'\+'

" Define lowercase words as any number of lowercase chars.
let s:lower_word = s:lower.'\+'

" Define uppercase words as any number of uppercase chars. For camelhumps to
" take precedence (so that ABCDef is one uppercase word ABC and a camelhump
" Def), we have to specify that a camelhump, a number, an underscore, or a
" keyword-end (that is, a non keyword char) comes after.
let s:upper_word = s:upper.'\+'.
            \ '\ze\%('.s:camelhump.s:or.s:number.s:or.'_'.s:or.'\>\)'

" Define non-keywords to be any number of non-keyword, non-whitespace chars
let s:non_keyword = '\%(\k\@!\S\)\+'

" Define empty lines, beginnings of files and ends of files
let s:empty_line = '^$'
let s:begin_file = '\%^'
let s:end_file = '\%$'

" Put together our regular expression
let s:regex  = s:number.s:or
let s:regex .= s:camelhump.s:or
let s:regex .= s:upper_word.s:or
let s:regex .= s:lower_word.s:or
let s:regex .= s:non_keyword.s:or
let s:regex .= s:empty_line.s:or
let s:regex .= s:begin_file.s:or
let s:regex .= s:end_file

" }}}
" Motions {{{

function! camelwords#motion(motion, count, mode)
    if a:mode ==# 'v'
        normal! gv
    endif

    let l:i = 0
    while l:i < a:count
        let l:search_flags = 'W'

        if a:motion ==# 'b' || a:motion ==# 'ge'
            let l:search_flags .= 'b'
        endif

        if a:motion ==# 'e' || a:motion ==# 'ge'
            let l:search_flags .= 'e'
        endif

        call search(s:regex, l:search_flags)

        let l:i += 1
    endwhile

    if a:motion ==# 'w' && a:mode ==# 'c' &&
                \ getline('.')[col('.')-2] =~ '\s\|[-_]'
        normal! h
    endif

    if a:motion ==# 'e' && a:mode ==# 'o'
        let l:whichwrap = &whichwrap
        set whichwrap+=l
        normal! l
        let &whichwrap = l:whichwrap
    endif

    if a:motion ==# 'e' && (a:mode ==# 'v' || a:mode ==# 'iv') &&
                \ &selection ==# 'exclusive'
        normal! l
    endif
endfunction

" }}}
" Text objects {{{

function! camelwords#inside(count)
    let l:inside_regex = '\%(\s\|_\)\+' . s:or . s:regex

    call search(l:inside_regex, 'Wbc')
    normal! v
    call search(l:inside_regex, 'Wec')

    let l:i = 1
    while l:i < a:count
        call search(l:inside_regex, 'We')
        let l:i += 1
    endwhile

    if &selection ==# 'exclusive'
        normal! l
    endif
endfunction

function! camelwords#nonword_under_cursor()
    return getline('.')[col('.')-1] =~ '\s\|[-_]'
endfunction

function! camelwords#around(count)
    if camelwords#nonword_under_cursor()
        let l:forward_space = 0
    else
        normal! h
        call camelwords#motion('e', a:count, 'n')
        normal! l
        let l:forward_space = camelwords#nonword_under_cursor()
        call camelwords#motion('b', a:count, 'n')
    end

    if !l:forward_space
        call camelwords#motion('ge', 1, 'n')
        normal! l
    endif

    normal! v
    call camelwords#motion('e', a:count, 'iv')
    if l:forward_space
        call camelwords#motion('w', 1, 'iv')
        normal! h
    endif
endfunction

" }}}
" Mappings {{{

if (exists("g:camelwords_mapping_w"))
    exec "nnoremap <silent> " . g:camelwords_mapping_w .
                \ "  :<c-u>call camelwords#motion('w', v:count1, 'n')<cr>"
    exec "onoremap <silent> " . g:camelwords_mapping_w .
                \ "  :<c-u>call camelwords#motion('w', v:count1, 'o')<cr>"
    exec "xnoremap <silent> " . g:camelwords_mapping_w .
                \ "  :<c-u>call camelwords#motion('w', v:count1, 'v')<cr>"

    exec "nnoremap <silent> c" . g:camelwords_mapping_w .
                \ " c:<c-u>call camelwords#motion('w', v:count1, 'c')<cr>"

    exec "onoremap <silent> i" . g:camelwords_mapping_w .
                \ " :<c-u>call camelwords#inside(v:count1)<cr>"
    exec "vnoremap <silent> i" . g:camelwords_mapping_w .
                \ " :<c-u>call camelwords#inside(v:count1)<cr>"

    exec "onoremap <silent> a" . g:camelwords_mapping_w .
                \ " :<c-u>call camelwords#around(v:count1)<cr>"
    exec "vnoremap <silent> a" . g:camelwords_mapping_w .
                \ " :<c-u>call camelwords#around(v:count1)<cr>"
endif

if (exists("g:camelwords_mapping_b"))
    exec "nnoremap <silent> " . g:camelwords_mapping_b .
                \ "  :<c-u>call camelwords#motion('b', v:count1, 'n')<cr>"
    exec "onoremap <silent> " . g:camelwords_mapping_b .
                \ "  :<c-u>call camelwords#motion('b', v:count1, 'o')<cr>"
    exec "xnoremap <silent> " . g:camelwords_mapping_b .
                \ "  :<c-u>call camelwords#motion('b', v:count1, 'v')<cr>"
endif

if (exists("g:camelwords_mapping_e"))
    exec "nnoremap <silent> " . g:camelwords_mapping_e .
                \ "  :<c-u>call camelwords#motion('e', v:count1, 'n')<cr>"
    exec "onoremap <silent> " . g:camelwords_mapping_e .
                \ "  :<c-u>call camelwords#motion('e', v:count1, 'o')<cr>"
    exec "xnoremap <silent> " . g:camelwords_mapping_e .
                \ "  :<c-u>call camelwords#motion('e', v:count1, 'v')<cr>"

    exec "nnoremap <silent> g" . g:camelwords_mapping_e .
                \ " :<c-u>call camelwords#motion('ge', v:count1, 'n')<cr>"
    exec "onoremap <silent> g" . g:camelwords_mapping_e .
                \ " :<c-u>call camelwords#motion('ge', v:count1, 'o')<cr>"
    exec "xnoremap <silent> g" . g:camelwords_mapping_e .
                \ " :<c-u>call camelwords#motion('ge', v:count1, 'v')<cr>"
endif

" }}}

" vim:foldmethod=marker
