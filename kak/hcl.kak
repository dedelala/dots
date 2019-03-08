hook global BufCreate .*\.tf(vars)? %{
    set-option buffer filetype hcl
}

addhl shared/hcl regions
addhl shared/hcl/code default-region group
addhl shared/hcl/string region '"' '"' fill string
addhl shared/hcl/comment region '(?<!\$)#' '$' fill comment
addhl shared/hcl/comment_block region '/\*' '\*/' fill comment
addhl shared/hcl/heredoc region -match-capture '<<-?(\w+)' '^\t*(\w+)$' fill string

evaluate-commands %sh{
    # Grammar
    keywords="data locals module output provider resource terraform variable"

    join() { sep=$2; eval set -- $1; IFS="$sep"; echo "$*"; }

    # Add the language's grammar to the static completion list
    printf %s\\n "hook global WinSetOption filetype=hcl %{
        set-option window static_words $(join "${keywords}" ' ')
    }"

    # Highlight keywords
    printf %s "addhl shared/hcl/code/ regex \b($(join "${keywords}" '|'))\b 0:keyword"
}

hook -group hcl-highlight global WinSetOption filetype=hcl %{
    addhl window/hcl ref hcl
    #hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/hcl }
}

define-command tf-validate %{
    evaluate-commands %sh{
        f=$(mktemp)
        mkfifo "$f"
        printf 'edit -fifo "%s" -debug *tf*;' "$f"
        printf 'set-option buffer filetype make;'
        printf '%s;' "hook -always -once buffer BufCloseFifo .* %{ nop %sh{ rm -r '$dir' } }"
        if terraform validate -no-color -check-variables=false "$(dirname "$kak_buffile")" &>"$f"; then
        printf
            printf 'echo no probs honey;'
            printf 'buffer "%s";' "$kak_bufname"
        fi
    }
}

