setopt auto_menu # use menu completion after two tabs
setopt auto_pushd # cd pushes to the dir stack
setopt extended_glob # always
setopt glob_complete # don't expand globs for completion
setopt glob_star_short # ** = recurse. *** = recurse and follow sym
setopt hist_ignore_all_dups # dups cause older history to be removed
setopt hist_no_functions # function defs not stored
setopt hist_no_store # "history" calls not stored
setopt hist_reduce_blanks # trim pointless whitespace in hist
setopt hist_verify # expand hist in-place
setopt inc_append_history # append history as commands are entered
setopt interactive_comments # allow comments in line editor
setopt list_types # show filetype chars in completion
setopt magic_equal_subst # file completion after =
setopt numeric_glob_sort # sort number filenames by number in completion
setopt pipe_fail # exit code is the left-most non-zero
setopt prompt_subst # do expansions on PS
setopt pushd_ignore_dups # dir stack ignore dups
setopt pushd_minus # +/- swapped on dir stack
setopt rc_expand_param # gooder string/array exansions
# todo job control

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

autoload -U compinit
compinit

export PATH=$PATH:/usr/local/opt/go/bin:$HOME/go/bin
export GOPATH=$HOME/go

export EDITOR=kak

export AWS_REGION="ap-southeast-2"
export AWS_DEFAULT_REGION="$AWS_REGION"
source /usr/local/bin/aws_zsh_completer.sh

export LSCOLORS="gafaBabacaxxxxxxxxxxxx"
alias ls="ls -FG"

tty_emos=(🐈 🐝 🌸 🌟 🌈 💖 🎀 👻 😱 )
ps_emo=$tty_emos[$(tty |tr -d a-z/)]

has_dockerfile() {
    [[ -e Dockerfile ]] && echo "🐳 "
}

has_makefile() {
    [[ -e Makefile ]] && echo "🐐 "
}

is_github() {
    if git config --get remote.origin.url |grep github.com &>/dev/null
    then
        echo " "
    fi
}

git_branch() {
    if git rev-parse --git-dir &>/dev/null
    then
        color="red"
        git status |grep "working tree clean" &>/dev/null && color="green"
        echo "%F{$color}$(git branch |grep \*|tr \*  ) %F{white}"
    fi
}

#git_time_since_fetch() {
    #if [[ -e .git/FETCH_HEAD ]]
    #then
        #seconds=$(( $(date +%s) - $(stat -f %m .git/FETCH_HEAD) ))
    #fi
#}

export PS1='%(0?;;💔 [%?])$(is_github)$(has_dockerfile)$(has_makefile)%~ $(git_branch)$ps_emo  '
export PS2='$ps_emo  '

# ❤️ 💛 💚 💙 💜 💔 💖 🐧 🐳 🍌 🐙 🐉 🐈 🎀 🏆 🌟 🔥 🌈 ❄️ 🎲 

export werkspace=("~/go/src/dedelala" "~/go/src/github.com/MYOB-Technology"    "~/src/github.com/MYOB-Technology" "~/src/github.com/dedelala" "~/src/dedelala")

werkspace() {
    echo "
                       _                             
    __      _____ _ __| | _____ _ __   __ _  ___ ___ 
    \ \ /\ / / _ \ '__| |/ / __| '_ \ / _\` |/ __/ _ \ 
     \ V  V /  __/ |  |   <\__ \ |_) | (_| | (_|  __/ 
      \_/\_/ \___|_|  |_|\_\___/ .__/ \__,_|\___\___| 
                               |_|                    "

    select d in $werkspace
    do
        echo
        echo Werking at $d
        eval "cd $d" && ls -Fa
        break
    done

}

werk() {
    echo "
              _           _                       _    
     ___  ___| | ___  ___| |_  __      _____ _ __| | __ 
    / __|/ _ \ |/ _ \/ __| __| \ \ /\ / / _ \ '__| |/ / 
    \__ \  __/ |  __/ (__| |_   \ V  V /  __/ |  |   < 
    |___/\___|_|\___|\___|\__|   \_/\_/ \___|_|  |_|\_\ 
                                                        "

    werks=()

    for d in $werkspace
    do
        for g in $(eval "find $d -name .git -type d")
        do
            werks=($werks ${$(dirname $g)/$HOME/"~"})
        done
    done

    select w in $werks
    do
        echo
        echo Werking on $(basename $w).
        eval "cd $w" && {
            ls -Fa
            echo
            git status
        }
        break
    done
}

kcname() {
    s=$1
    shift
    n="$@[$(( $RANDOM % ${#@[@]} + 1 ))]"
    ps |grep -E "kak.+$n.+$s" |grep -v grep && n=$(kcname $s "${@/$n}")
    echo $n
}

k() {
    active=($(kak -l))
    names=(😊_ 😇_ 😎_ 😱_ 👻_ 👽_ 😸_)

    if [[ $# -eq 0 ]]
    then
        select s in $active
        do
            n=$(kcname $s $names)
            kak -e "rename-client $n; set global toolsclient $n; set global docsclient $n" -c "$s"
            return
        done
    fi

    pickles=("pickle" "gherkin" "kimchi" "cornichon" "sauerkraut" "tsukemono")
    for s in $active
    do
        pickles=(${pickles/$s})
    done


    s="$pickles[$(( $RANDOM % ${#pickles[@]} + 1 ))]"
    n=$(kcname $s $names)
    kak -e "rename-client $n; set global jumpclient $n" -s "$s" "$@"
    return
}
