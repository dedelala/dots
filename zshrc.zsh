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


# set some things that may or may not make sense
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=$HOME/.zsh_history
export WORDCHARS='*?_-.[]~;!#$%^(){}<>' # characters considered to be part of a word (zle)
export CDPATH=$HOME/go/src:$HOME/src
export PATH=$PATH:/usr/local/opt/go/bin:$HOME/go/bin
export GOPATH=$HOME/go
export EDITOR=kak
export DOCKER_ID_USER="dedelala"
export LSCOLORS="gafaBabacaxxxxxxxxxxxx"


# init completions
autoload -U compinit
compinit
autoload -U bashcompinit
bashcompinit


# load helm completions if helm is around
hash helm 2>/dev/null && source <(helm completion zsh)

# on darwin gnu tar will be gtar and bsd tar is a nonse monkey
hash gtar &>/dev/null && alias tar="gtar"
# on darwin the latest make will be called gmake... osx srsly
hash gmake &>/dev/null && alias make="gmake"


# aliases! alii?
alias tree="tree -aI 'vendor|.git'"
alias ls="ls -FGh"
alias diff="diff --color=always"
alias f="grep -Hsn"
alias m="man"
alias g="git"
alias a="git add"
alias b="git branch"
alias x="git checkout"
alias C="git commit"
alias c="git commit -m"
alias d="PAGER= git diff"
alias l="git log --graph"
alias P="git push"
alias p="git pull"
alias s="git status"
alias rs="git reset"


# each terminal gets an emoji indexed by the tty number, on linux this starts from 0, on darwin from 1
tty_emos=(🐧 🐈 💖 🌈 🎀 🐉 🍄 👻 👒 👀 🌼 🎪 🍌 😱 🚧)
ps_emo=$tty_emos[$((1 + $(tty |tr -d a-z/)))]

# whale = dockerfile
ps_docker() {
    [[ -e Dockerfile ]] && echo "🐳"
}

# gears = makefile, orange = has targets to make
ps_make() {
    if [[ -e Makefile ]]; then
        if make -q &>/dev/null; then
            echo "%F{015} %f"
            return
        fi
        echo "%F{208}%B %b%f"
    fi
}

ps_git() {
    if dir=$(dirname $(git rev-parse --absolute-git-dir)) 2>/dev/null; then
        s=$(git status 2>/dev/null)
        if [[ "$s" =~ "branch is ahead" ]]; then
            color="208"
        elif [[ "$s" =~ "branch is behind" ]]; then
            color="045"
        elif ! git branch --remotes |grep "origin/$(git branch |grep \*|tr -d \*\ )" &>/dev/null; then
            color="196"
        else
            color="015"
        fi

        case $(git config --get remote.origin.url) in
        *github.com*)
            s=" "
            ;;
        *gitlab.com*)
            s=" "
            ;;
        *)
            s=" "
            ;;
        esac
        echo -n "%F{${color}}${s}%f"

        if [[ $dir != $(pwd) ]]; then
            echo -n "%F{250}$(dirname ${$(pwd)#$(dirname $dir)/})/%f"
        fi

        echo
    fi
}

ps_br() {
    if git rev-parse --git-dir &>/dev/null; then
        color="196"
        git status |grep "working tree clean" &>/dev/null && color="green"
        echo "%F{$color} $(git branch |grep \*|tr -d \*\ ) %f"
    fi
}

if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
    ps_host="%F{129} $HOST %f"
fi

ps_dir='%F{015}%B%1~%b%f '
ps_sesh='%F{201}${SESH}%f '

export PS1='%(0?;;💔%? )${ps_emo}${ps_host}${(e)ps_sesh}$(ps_git)${ps_dir}$(ps_br)$(ps_make)$(ps_docker)%B %b'
export PS2='$ps_emo%B %b'

#❤️ 💛💚💙💜💔💖🐧🐳🍌🐙🐉🐈🎀🏆🌟🔥🌈❄️ 🎲

# kak
k() {
if ! kak -l |grep "$SESH"; then
    kak -e "rename-client $ps_emo; set global jumpclient $ps_emo" -s "$SESH" "$@"
    return
fi
kak -e "rename-client $ps_emo; set global toolsclient $ps_emo; set global docsclient $ps_emo" -c "$SESH" "$@"
}


# repo switcher
j() {
    base64 --decode <<< "H4sIAL1at1kAA41QMQ4DIQzb+wozJZEudLuhah9SKSr5/ysKFAJVl8IAxo4TA3wWe75gLoEEYPAiDLbAF8pKgGuYXCcRvjy90YUFR7uVWdDeDwpvzqZK0dqivkuH+2pfeSs8OvfzfoJPPP7eKaUtZxERG0N7nRX59pRStvBE1Nv2LJlcVV+tapOMD2hZKzGh+48kiDeBdLlpjgEAAA==" |gunzip
    [[ -z "$1" ]] && 1=".*"
    repos=()
    for d in ${=CDPATH/:/ }; do
        for g in $(eval "find $d -name .git -type d |grep -i '$1'"); do
            repos=($repos ${$(dirname $g)/$d\//})
        done
    done

    if [[ $(wc -w <<< "$repos") -eq 1 ]]; then
        repo=$repos
    else
        echo REPO SELECT
        select r in $repos; do
            repo=$r
            break
        done
    fi
    eval "cd $repo" && {
        ls -Fa
        echo
        git status
    }
    H
}

_j() {
    repos=()
    for d in ${=CDPATH/:/ }; do
        for g in $(eval "find $d -name .git -type d |grep -i '$1'"); do
            repos=($repos ${$(dirname $g)/$d\//})
        done
    done
    _alternative "repo:repos:($repos)"
}
compdef _j j



# make computer say nice things to me.
motd() {
    m="Login: $(date +"%a %b %d at %H:%M") on $(basename $(tty)). Good"
    h=$(date +%H)
    case $h in
    0[0-9]|1[0-1])
        m="$m morning"
        ;;
    1[2-7])
        m="$m afternoon"
        ;;
    1[8-9]|2[0-3])
        m="$m evening"
        ;;
    esac

    case $(uname -a) in
        Darwin*)
            name=" $(id -F)"
            ;;
        Linux*)
            name=" $USER"
            ;;
    esac

    hash fortune >/dev/null && { echo; fortune; echo; }
    c=$(( $(tty |tr -d a-z/) % 6 + 1 ))
    echo "\e[3${c}m$m$name!\e[0m"
}
motd


# AWS
export AWS_REGION="ap-southeast-2"
export AWS_DEFAULT_REGION="$AWS_REGION"

ars() {
    echo AMAZON REGION SELECT
    rs=(
    "us-east-1      - US East (N. Virginia)"
    "us-east-2      - US East (Ohio)"
    "us-west-1      - US West (N. California)"
    "us-west-2      - US West (Oregon)"
    "ca-central-1   - Canada (Central)"
    "eu-central-1   - EU (Frankfurt)"
    "eu-west-1      - EU (Ireland)"
    "eu-west-2      - EU (London)"
    "eu-west-3      - EU (Paris)"
    "ap-northeast-1 - Asia Pacific (Tokyo)"
    "ap-northeast-2 - Asia Pacific (Seoul)"
    "ap-southeast-1 - Asia Pacific (Singapore)"
    "ap-southeast-2 - Asia Pacific (Sydney)"
    "ap-south-1     - Asia Pacific (Mumbai)"
    "sa-east-1      - South America (São Paulo)"
    )
    select x in "${rs[@]}"; do
        read -r r _ p <<< "$x"
        export AWS_REGION="$r"
        export AWS_DEFAULT_REGION="$r"
        echo Set region to "$p"
        break
    done
}

# fang fangs it
fang() {
    cmd="$1"
    shift
    for arg in $*; do
        echo "--> $cmd $arg"
        eval "$cmd $arg"
    done
}


sesh_init() {
    rc="$HOME/.sesh"
    if [[ -e "$rc" ]]; then
        return
    fi

    cat >"$rc" <<< "SESHES=(jalapeno habanero cayenne serrano guajillo poblano ghost)"
    source "$rc"

    if [[ -z "${SESHES[*]}" ]]; then
        echo "$0 fail: no seshes"
        return 1
    fi

    cat >>"$rc" <<< "SESH=${SESHES[1]}"

    for s in "${SESHES[@]}"; do
        cat >>"$rc" <<< "SESH_$s=$(pwd)"
    done
}

sesh_set() {
    rc="$HOME/.sesh"
    if ! [[ -e "$rc" ]]; then
        echo "$0: not init'ed"
        return 1
    fi

    source "$rc"
    if [[ -n "$SESH" ]]; then
        s="SESH_$SESH"
        if [[ -n "$s" ]]; then
            cd "${(P)s}"
        fi
    fi
}

sesh() {
    rc="$HOME/.sesh"
    if ! [[ -e "$rc" ]]; then
        echo "$0: not init'ed"
        return 1
    fi

    source "$rc"
    sel=()
    for s in "${SESHES[@]}"; do
        t="SESH_$s"
        sel+=("$s -> $(basename ${(P)t})")
    done

    select s in "${sel[@]}"; do
        read -r s _ <<< "$s"
        sed -i -e "s/^SESH=.*$/SESH=$s/" "$rc"
        break
    done

    sesh_set
}

H() {
    rc="$HOME/.sesh"
    sed -i -e "s;^SESH_$SESH=.*$;SESH_$SESH=$(pwd);" "$rc"
    source "$rc"
}
alias h="sesh_set"
sesh_set
