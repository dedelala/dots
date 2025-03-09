[[ -r "$HOME/.profile" ]] && . "$HOME/.profile"

if hash tty &>/dev/null && [[ $(tty) == /dev/tty1 ]]; then
        startx
        exit
fi

autoload -U compinit
compinit

setopt auto_menu               # use menu completion after two tabs
setopt auto_pushd              # cd pushes to the dir stack
setopt chase_links             # cd resolves symlinks
setopt extended_glob           # always
setopt glob_complete           # don't expand globs for completion
setopt glob_star_short         # ** = recurse. *** = recurse and follow sym
setopt hist_ignore_all_dups    # dups cause older history to be removed
setopt hist_no_functions       # function defs not stored
setopt hist_no_store           # "history" calls not stored
setopt hist_reduce_blanks      # trim pointless whitespace in hist
setopt hist_verify             # expand hist in-place
setopt inc_append_history      # append history as commands are entered
setopt interactive_comments    # allow comments in line editor
setopt list_types              # show filetype chars in completion
setopt magic_equal_subst       # file completion after =
setopt numeric_glob_sort       # sort number filenames by number in completion
setopt pipe_fail               # exit code is the left-most non-zero
setopt prompt_subst            # do expansions on PS
setopt pushd_ignore_dups       # dir stack ignore dups
setopt pushd_minus             # +/- swapped on dir stack
setopt rc_expand_param         # gooder string/array expansions

export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=$HOME/.zsh_history
export WORDCHARS='*?_-.[]~;!#$%^(){}<>' # characters considered to be part of a word (zle)

alias hc="herbstclient"

k() {
        kak -c 8 "$@" || kak -s 8 "$@"
}

win_title(){
        echo -ne "\033]0;$WIN_TITLE_PREFIX ${PWD/$HOME/~} $*\007"
}

preexec(){
        win_title "$1"
}

precmd(){
        win_title
}

WIN_TITLE_PREFIX="${TTY#/dev/}"
unset psvar
if [[ -n $SSH_TTY ]]; then
        WIN_TITLE_PREFIX="$HOST $WIN_TITLE_PREFIX"
        psvar[1]=1
fi
export PS1="%K{3}%F{0}8%f%k%(0?,,%F{1}?%?%f)%(1j,%F{6}&%j%f,)%(1v,%m,)%F{3}>%f "
export PS2="%F{3}^%f "

