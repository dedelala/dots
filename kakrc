colorscheme dedelala

set global ui_options ncurses_enable_mouse=false:ncurses_assistant=cat:ncurses_set_title=false

set global indentwidth 4
set global tabstop 4
set global aligntab false
set global scrolloff 4,4

hook global WinCreate .* %{
    addhl window show_matching
    addhl window number_lines -relative -hlcursor -separator " "
    addhl window column 101 white,rgb:101010
    addhl window dynregex \h+$ 0:black,rgb:006600
    addhl window dynregex ^\t* 0:black,rgb:330066
    addhl window dynregex ^\ * 0:black,rgb:003344
    addhl window dynregex \ +\t+\ * 0:black,rgb:990000
    addhl window dynregex \t+\ +\t* 0:black,rgb:990000
    map window user , :buffer-previous<ret>
    map window user b :git\ blame<ret>
    map window user n :git\ hide-blame<ret>
    map window user d :git\ diff<ret>
    map window user c :comment-line<ret>
    map window user l :buffer\ *lint-output*<ret>
    map window user m :buffer\ *make*<ret>
}

hook global BufWritePost .* git\ show-diff
#hook global BufOpenFile .* git\ show-diff
#hook global BufWritePost .* "echo -debug BufWrite"
#hook global BufOpenFile .* "echo -debug BufOpen"

hook global WinSetOption filetype=go %{
    set window lintcmd 'sync; gofmt 2>&1 1>/dev/null'
    set window makecmd 'vgo build'
    set global disabled_hooks .*-indent
    go-enable-autocomplete
    hook buffer BufWritePre .* %{
        go-format -use-goimports
        lint
    }
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
