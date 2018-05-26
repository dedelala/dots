# options
setopt auto_menu # use menu completion after two tabs
setopt auto_pushd # cd pushes to the dir stack
setopt chase_links # cd resolves symlinks
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


# exports
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=$HOME/.zsh_history
export WORDCHARS='*?_-.[]~;!#$%^(){}<>' # characters considered to be part of a word (zle)
export CDPATH=$HOME/.pj/.p
export PATH=$PATH:/usr/local/opt/go/bin:$HOME/go/bin
export GOPATH=$HOME/go
export EDITOR=kak
export DOCKER_ID_USER="dedelala"
export LSCOLORS="gafaBabacaxxxxxxxxxxxx"
export AWS_DEFAULT_REGION="ap-southeast-2"
export AWS_REGION="ap-southeast-2"

# aliases
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


# conditional aliases
hash gtar &>/dev/null && alias tar="gtar"
hash gmake &>/dev/null && alias make="gmake"


# prompt
export EMOS=(🐧 🐈 💖 🌈 🎀 🐉 🍄 👻 👒 👀 🌼 🎪 🍌 😱 🚧)
export EMO=$EMOS[$((1 + $(tty |tr -d a-z/)))]

export PS1='%(0?;;💔%?)$(ps-host)$(ps-git)%F{015}%B%1~%b%f$(ps-br)$(ps-make)$(ps-docker)%B%{%2G%}%b'
export RPS1='$(ps-id)'

export PS2='%B%{%2G%}%b'
export RPS2='$(ps-id)'


# el crujido
pj cd
motd