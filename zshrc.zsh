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
export HISTFILE=~/.zsh_history
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


# aliases! alii?
alias ls="ls -FGh"
alias diff="diff --color=always"
alias f="grep -sn"
alias m="man"
alias g="git"
alias a="git add"
alias b="git branch"
alias x="git checkout"
alias C="git commit"
alias c="git commit -m"
alias d="git diff"
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
        if make -q; then
            echo "%F{015} %f"
            return
        fi
        echo "%F{208}%B %b%f"
    fi
}

# github/gitlab depending on upstream config, orange = commit(s) to push
ps_git() {
    if git rev-parse --git-dir &>/dev/null; then
        color="015"
        git status |grep "branch is ahead" &>/dev/null && color="208"
        case $(git config --get remote.origin.url) in
        *github.com*)
            echo "%F{$color} %f"
            ;;
        *gitlab.com*)
            echo "%F{$color} %f"
            ;;
        esac
    fi
}

# git branch info, red = unstaged changes
ps_br() {
    if git rev-parse --git-dir &>/dev/null; then
        color="red"
        git status |grep "working tree clean" &>/dev/null && color="green"
        echo "%F{$color} $(git branch |grep \*|tr -d \*\ ) %f"
    fi
}

# host name will only be present if we are remote
if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
    ps_host="%F{magenta} $HOST %f"
fi

export PS1='%(0?;;💔%? )${ps_host}$(ps_git)%F{015}%B%1~%b%f $(ps_br)$(ps_make)$(ps_docker)${ps_emo} '
export PS2='%I %i $ps_emo '

# ❤️ 💛 💚 💙 💜 💔 💖 🐧 🐳 🍌 🐙 🐉 🐈 🎀 🏆 🌟 🔥 🌈 ❄️ 🎲 

# kak initializer
k() {
    active=($(kak -l))

    if [[ $# -eq 0 ]]; then
        echo KAKOUNE SESSION SELECT
        select s in $active; do
            kak -e "rename-client $ps_emo; set global toolsclient $ps_emo; set global docsclient $ps_emo" -c "$s"
            return
        done
    fi

    pickles=("pickle_" "gherkin_" "kimchi_" "cornichon_" "sauerkraut_" "tsukemono_")
    for s in $active; do
        pickles=(${pickles/$s})
    done


    s="$pickles[$(( $RANDOM % ${#pickles[@]} + 1 ))]"
    kak -e "rename-client $ps_emo; set global jumpclient $ps_emo" -s "$s" "$@"
    return
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

H() { pwd |tee $HOME/.wd; }
h() { [[ -e $HOME/.wd ]] && cd $(tee < $HOME/.wd); }


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
