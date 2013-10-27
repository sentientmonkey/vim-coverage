" vi:sw=2 ts=2
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
let g:coverage_filename='coverage.txt'

function! PlaceLines(filename,covered_lines)
  let current_line = 0
  for covered_line in a:covered_lines
    let current_line += 1
    if covered_line > 0
      exe ":sign place ". current_line ." line=".current_line." name=hit file=".a:filename
    elseif covered_line != '' && covered_line == 0
      exe ":sign place ". current_line ." line=".current_line." name=miss file=".a:filename
    endif
  endfor
endfunction

function! ShowCoverage()
  for line in readfile(g:coverage_filename)
    let coverage = split(line, '\t')
    let covered_file = coverage[0]
    if expand('%:p') == covered_file
      let covered_lines = split(coverage[1], ',')
      call PlaceLines(covered_file,covered_lines)
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

" map <leader>c :call ToggleCoverage()<cr>
