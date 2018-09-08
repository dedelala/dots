colorscheme dedelala

set global ui_options ncurses_enable_mouse=false:ncurses_assistant=cat:ncurses_set_title=false

set global indentwidth 8
set global tabstop 8
set global aligntab false
set global scrolloff 4,4

hook global WinCreate .* %{
    addhl window show_matching
    addhl window number_lines -relative -hlcursor -separator " "
    addhl window column 81 white,rgb:2d0040
    addhl window dynregex \h+$ 0:black,rgb:545453
    addhl window dynregex ^\t* 0:black,rgb:2d0040
    addhl window dynregex ^\ * 0:black,rgb:000f40
    addhl window dynregex \ +\t+\ * 0:black,rgb:d22323
    addhl window dynregex \t+\ +\t* 0:black,rgb:d22323
    map window user -docstring "<--" , :buffer-previous<ret>
    map window user -docstring "-->" . :buffer-next<ret>
    map window user -docstring "blame" b :git\ blame<ret>
    map window user -docstring "hide blame" n :git\ hide-blame<ret>
    map window user -docstring "diff" d :git\ diff<ret>
    map window user -docstring "comment" c :comment-line<ret>
    map window user -docstring "lint" l :lint<ret>:buffer\ *lint-output*<ret>
    map window user -docstring "make" m :make<ret>:buffer\ *make*<ret>
}

hook global BufWritePost .* git\ show-diff

hook global WinSetOption filetype=go %{
    set window lintcmd 'sync; gofmt 2>&1 1>/dev/null'
    set window makecmd 'go build'
    set window disabled_hooks .*-indent
    go-enable-autocomplete
    hook buffer BufWritePre .* %{
        go-format -use-goimports
        lint
    }
    map window user -docstring "go doc" ? :go-doc-info<ret>
    map window user -docstring "go jump" / :go-jump<ret>
}

hook global WinSetOption filetype=sh %{
    set window lintcmd 'shellcheck -fgcc -Cnever'
    lint-enable
    hook buffer BufWritePost .* lint
}

hook global WinSetOption filetype=yaml %{
    set window indentwidth 2
    set window tabstop 2
    set window lintcmd 'yamllint -d ~/.yamllint.yml -f parsable "$kak_buffile"'
    lint-enable
    hook buffer BufWritePost .* lint
}
