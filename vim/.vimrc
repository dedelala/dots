syntax enable

colorscheme darkblue
" elflord, ron, torte, darkblue

set number
set hlsearch

set colorcolumn=101

" autocompletion
filetype plugin on
set omnifunc=syntaxcomplete#Complete
imap <c-a> <C-X><C-O>
nmap <F5> !ctags -RV .<CR>

" quickfix navigation
"imap <c-/> <esc>:copen<CR>
"nmap <c-/> :copen<CR>
"imap <c-,> <esc>:cprevious<CR>
"nmap <c-,> :cprevious<CR>
"imap <c-.> <esc>:cnext<CR>
"nmap <c-.> :cnext<CR>

norea xml %!xmllint --pretty 0 --noblanks -
norea xmlp %!xmllint --pretty 1 -
norea xmlpp %!xmllint --pretty 2 -

ab q ccl\|q

set backspace=indent,eol,start

function SetTab(t)
    execute "set shiftwidth=".a:t
    execute "set tabstop=".a:t
    set expandtab
endfunction
call SetTab(4)

function HackTheGibson(garbage)
    execute "%!" . a:garbage
    if v:shell_error
        call BufferToQuickFix()
        break
    else
        write
    endif
endfunction

function BufferToQuickFix()
    write .dede.vim.qf
    cfile .dede.vim.qf
    undo
    !rm -f .dede.vim.qf
    copen
    crewind
endfunction

function CommandToQuickFix(garbage)
    execute "!" . a:garbage . " > .dede.vim.qf 2>&1"
    if match(readfile(".dede.vim.qf"), "\w+")
        cfile .dede.vim.qf
        copen
        crewind
    endif
    !rm -f .dede.vim.qf
endfunction-

augroup golang
    autocmd BufNewFile,BufRead *.go :compiler go
    autocmd BufWritePost *.go :call HackTheGibson("gofmt %:p")|call HackTheGibson("goimports %:p")
augroup END

augroup docker
    autocmd BufNewFile,BufRead *Dockerfile* :setf Dockerfile
    autocmd BufWritePost *Dockerfile* :call CommandToQuickFix("hadolint %:p")
augroup END

augroup yaml
    autocmd BufNewFile,BufRead *.yml :call SetTab(2)
    autocmd BufWritePost *.yml :call CommandToQuickFix("yamllint -d ~/.yamllint.yml -f parsable %:p")
augroup END

augroup linting
    autocmd BufWritePost *.sh :call CommandToQuickFix("shellcheck %:p")
    autocmd BufWritePost *.json :call CommandToQuickFix("jsonlint -c -q %:p")
    autocmd BufWritePost *.xml :!xmllint --noout %:p
    autocmd BufWritePost *.html :!xmllint --html --noout %:p
augroup END
