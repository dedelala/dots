ps-docker() {
    [[ -e Dockerfile ]] && echo "🐳"
}

ps-make() {
    if [[ -e Makefile ]]; then
        if make -q &>/dev/null; then
            echo "%F{015} %f"
            return
        fi
        echo "%F{208}%B %b%f"
    fi
}

ps-git() {
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

ps-br() {
    if git rev-parse --git-dir &>/dev/null; then
        color="196"
        git status |grep "working tree clean" &>/dev/null && color="green"
        echo "%F{$color} $(git branch |grep \*|tr -d \*\ ) %f"
    fi
}

ps-host() {
    if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
        echo "%F{129} $HOST %f"
    fi
}

ps-id() {
    echo "${EMO}@[%F{201}$(pj is)%f]"
}
