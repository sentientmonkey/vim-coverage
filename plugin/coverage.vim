" File:        coverage.vim
" Description: Code Coverage display in vim
" Author:      Scott Windsor <swindsor@gmail.com>
" Licence:     MIT
" Version:     0.0.1

" color settings
hi MissLine ctermbg=125
hi HitLine ctermbg=23
hi MissSign ctermfg=125 ctermbg=235
hi HitSign ctermfg=23 ctermbg=235
sign define hit  linehl=HitLine  texthl=HitSign  text=+
sign define miss linehl=MissLine texthl=MissSign text=-

let g:simplecov_enable=0

function! ShowCoverage()
for line in readfile('coverage.txt')
    let coverage = split(line, '\t')
    if expand('%:p') == coverage[0]
        let covered_lines = split(coverage[1], ',')
        let current_line = 0
        for covered_line in covered_lines
            let current_line += 1
            if covered_line > 0
                exe ":sign place ". current_line ." line=".current_line." name=hit file=".coverage[0]
            elseif covered_line != '' && covered_line == 0
                exe ":sign place ". current_line ." line=".current_line." name=miss file=".coverage[0]
            endif
        endfor
    end
endfor
endfunction

function! ClearCoverage()
    exe ":sign unplace *"
endfunction

function! ToggleCoverage()
    if g:simplecov_enable
        call ClearCoverage()
        autocmd! BufReadPost,BufWritePost,FileReadPost,FileWritePost *.rb
        let g:simplecov_enable=0
    else
        call ShowCoverage()
        autocmd! BufReadPost,BufWritePost,FileReadPost,FileWritePost *.rb call ShowCoverage()
        let g:simplecov_enable=1
    endif
endfunction

map ,c :call ToggleCoverage()<cr>
