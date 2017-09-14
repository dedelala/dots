colorscheme dedelala

set global ui_options ncurses_enable_mouse=false:ncurses_assistant=cat:ncurses_set_title=false

set global indentwidth 4
set global tabstop 4
set global aligntab false
set global scrolloff 10,10

hook global WinCreate .* %{
    addhl show_matching
    addhl number_lines -relative -hlcursor -separator "  "
    addhl column 101 white,rgb:222200
    addhl dynregex \h+$ 0:black,rgb:000099
    map window user , :buffer-previous<ret>
    map window user b :git\ blame<ret>
    map window user n :git\ hide-blame<ret>
    map window user d :git\ diff<ret>
    map window user c :comment-line<ret>
}

hook global BufWritePost .* git\ show-diff
hook global BufOpenFile .* git\ show-diff
hook global BufWritePost .* "echo -debug BufWrite"
hook global BufOpenFile .* "echo -debug BufOpen"

hook global WinSetOption filetype=go %{
    go-enable-autocomplete
    hook buffer BufWritePre .* %{ go-format -use-goimports }
    map window user . :go-doc-info<ret>
    map window user / :go-jump<ret>
}

hook global WinSetOption filetype=sh %{
    set window lintcmd 'shellcheck -fgcc -Cnever'
    lint-enable
    hook buffer BufWritePost .* lint
}

hook global WinSetOption filetype=python %{
    set window formatcmd 'autopep8 -'
    set window lintcmd 'flake8 --format="%(path)s:%(row)d:%(col)d: error: %(text)s"'
    lint-enable
    hook buffer BufWritePost .* lint
}

hook global WinSetOption filetype=yaml %{
    set global indentwidth 2
    set global tabstop 2
    set window lintcmd 'yamllint -d ~/.yamllint.yml -f parsable "$kak_buffile"'
    lint-enable
    hook buffer BufWritePost .* lint
}
