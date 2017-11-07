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

export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.zsh_history

export WORDCHARS='*?_-.[]~/&;!#$%^(){}<>' # characters considered to be part of a word (zle)

autoload -U compinit
compinit

export CDPATH=$HOME/go/src:$HOME/src
export PATH=$PATH:/usr/local/opt/go/bin:$HOME/go/bin
export GOPATH=$HOME/go

export EDITOR=kak

export AWS_REGION="ap-southeast-2"
export AWS_DEFAULT_REGION="$AWS_REGION"

export LSCOLORS="gafaBabacaxxxxxxxxxxxx"
alias ls="ls -FGh"
alias diff="diff --color=always"

alias f="man"

alias g="git"
alias a="git add"
alias b="git branch"
alias C="git checkout"
alias c="git commit -m"
alias d="git diff"
alias l="git log --graph"
alias P="git push"
alias p="git pull"
alias s="git status"

alias -g \>X=">/dev/null"

hash gtar &>/dev/null && alias tar="gtar"

tty_emos=(🐧 🐈 🐝 🌸 🌟 🌈 💖 🎀 👻 😱)
ps_emo=$tty_emos[$((1 + $(tty |tr -d a-z/)))]

has_dockerfile() {
    [[ -e Dockerfile ]] && echo "🐳"
}

has_makefile() {
    [[ -e Makefile ]] && echo "🐐"
}

is_github() {
	case $(git config --get remote.origin.url)giturl in
	*github.com*)
        echo " "
		;;
	*gitlab.com*)
		echo " "
		;;
	esac
}

git_branch() {
    if git rev-parse --git-dir &>/dev/null; then
        color="red"
        git status |grep "working tree clean" &>/dev/null && color="green"
        echo "%F{$color}$(git branch |grep \*|tr \*  ) %f"
    fi
}

if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
	host="%F{magenta} $HOST %f"
fi

export PS1='${host}%(0?;;💔%? )$(is_github)$(has_dockerfile)$(has_makefile)%1~ $(git_branch)${ps_emo} '
export PS2='$ps_emo '

# ❤️ 💛 💚 💙 💜 💔 💖 🐧 🐳 🍌 🐙 🐉 🐈 🎀 🏆 🌟 🔥 🌈 ❄️ 🎲 

k() {
    active=($(kak -l))

    if [[ $# -eq 0 ]]; then
        select s in $active; do
            kak -e "rename-client $ps_emo; set global toolsclient $ps_emo; set global docsclient $ps_emo" -c "$s"
            return
        done
    fi

    pickles=("pickle" "gherkin" "kimchi" "cornichon" "sauerkraut" "tsukemono")
    for s in $active; do
        pickles=(${pickles/$s})
    done


    s="$pickles[$(( $RANDOM % ${#pickles[@]} + 1 ))]"
    kak -e "rename-client $ps_emo; set global jumpclient $ps_emo" -s "$s" "$@"
    return
}

w() {
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
        select r in $repos; do
            repo=$r
            break
        done
    fi
    echo "*** Pounces on $(basename $repo)! Rawr! ***"
    base64 --decode <<< "H4sIAJpbt1kAA52SMQ4EIQwD+32FlSYgsUm3HQ85CZ15CI/fwOk+EBcOjUdWApBS4xlsVy6PNQZJ95UG9Cf86WnA6MYPrXsG0LZVYAIlk6+R9X+RBKCUsPV7c08yUyOO4OtwSqt2CyCW2ue8R3CMrrEZYrerPEr/EBUN7ldlQkI6rxeK5CJ9rAIAAA==" |gunzip
    eval "cd $repo" && {
        ls -Fa
        echo
        git status
    }
}

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
