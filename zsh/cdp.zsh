# be makes the cdp be something else
cdp-be() {
        local p
        cdp mk "$1" || return 1
        ln -fsv "$HOME/.cdp/$p" "$HOME/.cdp/.p"
        cdp-cd
}

_cdp-be() {
        compadd $(cdp-ls)
}
compdef _cdp-be cdp-be


# cd changes to and sets the home directory for the active cdp
cdp-cd() {
        if ! [[ -e "$HOME/.cdp/.p/.home" ]]; then return 1; fi
        local h
        if [[ -n "$1" ]]; then
                if ! cd "$1"; then
                        return 1
                fi
                ln -fsv "$PWD" "$HOME/.cdp/.p/.home"
        fi
        cd "$HOME/.cdp/.p/.home"
}

_cdp-cd() {
        compadd $(cdp-has)
        _path_files -/
}
compdef _cdp-cd cdp-cd


# is returns the name of the active cdp, or tries to match it to $1
cdp-is() {
        if ! [[ -e "$HOME/.cdp/.p" ]]; then return 1; fi
        echo "$HOME/.cdp/.p"(:A:t)
}

_cdp-is() {
        compadd "" $(cdp-ls)
}
compdef _cdp-is cdp-is

# has is a shorthand for ls in the active cdp
cdp-has() {
        cdp-ls $(cdp-is)
}

# ln links something into the current cdp
cdp-ln() {
        if ! [[ -e "$HOME/.cdp/.p" ]]; then return 1; fi
        local s d
        s="${1:a}"
        d="$2"
        if [[ -z "$d" ]]; then
                d="${1:a:t}"
        fi
        ln -fsv "$s" "$HOME/.cdp/.p/$d"
}

_cdp-ln() {
        _path_files -/
}
compdef _cdp-ln cdp-ln

# ls enumerates cdp's or the links they contain
cdp-ls() {
        if ! [[ -e "$HOME/.cdp/.p" ]]; then return 1; fi
        if [[ $1 == "-a" ]]; then
                .cdp-ls-a
                return
        fi

        local d
        d="$HOME/.cdp/$1"
        if ! [[ -d "$d" ]]; then
                echo "no cdp $1" >&2
                return 1
        fi
        local -a result
        if result=( "$d"/*(:a:t) ) &>/dev/null; then
                echo "${result[@]}"
        fi
}

_cdp-ls() {
        compadd $(cdp-ls) '-a'
}
compdef _cdp-ls cdp-ls

.cdp-ls-a() {
        local -a result
        result=( $(cdp-ls) )
        for cdp in $(cdp-ls); do
                result=( "${result[@]}" "$cdp"/${^$(cdp-ls "$cdp")} )
        done
        echo "${result[@]}"
}


# mk makes a cdp
cdp-mk() {
        if [[ -n "$1" ]]; then return 1; fi
        local d
        d="$HOME/.cdp/$1"
        if ! [[ -d "$d" ]]; then
                mkdir -pv "$d"
                ln -sv "$HOME" "$d/.home"
        fi
}


# rm removes a cdp
cdp-rm() {
        if [[ -z $1 ]]; then return 1; fi
        rm -rfv "$HOME/.cdp/$1"
}

_cdp-rm() {
        compadd $(.cdp-ls-a)
}
compdef _cdp-rm cdp-rm


# cdp wires up the plumbing
cdp() {
        local c
        c=$1
        shift
        "cdp-$c" "$@"
}

_cdp() {
    local -a args cmds
    cmds=( ${$(whence -m "cdp-*")#cdp-} )
    args=( "1:command:($cmds)" )
    if type "_cdp-$words[2]" &>/dev/null; then
        args+=( ":args:_cdp-$words[2]" )
    fi
    _arguments "${args[@]}"
}
compdef _cdp cdp

