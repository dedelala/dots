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
}

hook global WinSetOption filetype=go %{
    set window formatcmd 'goimports'
    set window lintcmd 'golint'
    #set window makecmd 'go build'
    lint-enable
    go-enable-autocomplete
    hook buffer BufWritePre .* %{ format }
    hook buffer BufWritePost .* lint
}

hook global WinSetOption filetype=sh %{
    #set window formatcmd 'shfmt -i 4'
    set window lintcmd 'shellcheck -fgcc -Cnever'
    lint-enable
    #hook buffer BufWritePre .* %{ format }
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