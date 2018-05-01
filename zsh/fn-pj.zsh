# be makes the pj be something else
pj-be() {
    local p
    p="$(.pj-sane "$1")"
    pj mk "$p"
    rm -f "$HOME/.pj/.p" && ln -s "$HOME/.pj/$p" "$HOME/.pj/.p"
    pj-cd
}

_pj-be() {
    compadd $(pj-ls)
}
compdef _pj-be pj-be


# cd changes to and sets the home directory for the active pj
pj-cd() {
    local h
    h="$HOME/.pj/.p/.home"
    if [[ -n "$1" ]]; then
        if ! cd "$1"; then
            return 1
        fi
        rm -f "$h" && ln -s "$(pwd)" "$h"
    fi
    cd "$h"
}

_pj-cd() {
    compadd $(pj-has)
    _path_files -/
}
compdef _pj-cd pj-cd


# is returns the name of the active pj, or tries to match it to $1
pj-is() {
    local -a p
    p=( "$HOME/.pj/.p"(:A:t) )
    if [[ -n "$1" ]]; then
        [[ "$1" == "$p" ]]
        return
    fi
    echo "$p"
}

_pj-is() {
    compadd "" $(pj-ls)
}
compdef _pj-is pj-is

# has is a shorthand for ls in the active pj
pj-has() {
    pj-ls $(pj-is)
}

# ln links something into the current pj
pj-ln() {
    ln -s "${1:a}" "$HOME/.pj/.p/${1:a:t}"
}

_pj-ln() {
    _path_files -/
}
compdef _pj-ln pj-ln

# ls enumerates pj's or the links they contain
pj-ls() {
    if [[ $1 == "-a" ]]; then
        .pj-ls-a
        return
    fi

    local d
    d="$HOME/.pj/$1"
    if ! [[ -d "$d" ]]; then
        echo "no pj $1" >&2
        return 1
    fi
    local -a result
    if result=( "$d"/*(:a:t) ) &>/dev/null; then
        echo "${result[@]}"
    fi
}

_pj-ls() {
    compadd $(pj-ls) '-a'
}
compdef _pj-ls pj-ls

.pj-ls-a() {
    local -a result
    result=( $(pj-ls) )
    for pj in $(pj-ls); do
        result=( "${result[@]}" "$pj"/${^$(pj-ls "$pj")} )
    done
    echo "${result[@]}"
}


# mk makes a pj
pj-mk() {
    local d
    d="$HOME/.pj/$(.pj-sane "$1")"
    if ! [[ -d "$d" ]]; then
        mkdir -p "$d"
        ln -s "$HOME" "$d/.home"
    fi
}


# rm removes a pj
pj-rm() {
    rm -rf "$HOME/.pj/$1"
}

_pj-rm() {
    compadd $(.pj-ls-a)
}
compdef _pj-rm pj-rm

.pj-sane() {
    if [[ -z "$1" ]]; then
        echo ".std"
    fi
    echo "$1"
}


# pj wires up the plumbing
pj() {
    local c
    c=$1
    shift
    "pj-$c" "$@"
}

_pj() {
    local -a args cmds
    cmds=( ${$(whence -m "pj-*")#pj-} )
    args=( "1:command:($cmds)" )
    if type "_pj-$words[2]" &>/dev/null; then
        args+=( ":args:_pj-$words[2]" )
    fi
    _arguments "${args[@]}"
}
compdef _pj pj

