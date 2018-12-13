[[ -r "$HOME/.profile" ]] && . "$HOME/.profile"

if hash tty &>/dev/null && [[ $(tty) == /dev/tty1 ]]; then
        startx
        exit
fi

autoload -U compinit
compinit

repos() {
    local -a repos sauces
    local s p r
    repos=()
    sauces=($HOME/src $HOME/go/src)
    for s in ${sauces[@]}; do
        repos+=($s/**/.git(:h))
    done
    p="$1"
    if [[ -z $p ]]; then
        p="."
    fi
    for r in ${repos[@]}; do
        if [[ $r =~ $p ]]; then
            echo $r
        fi
    done
}
