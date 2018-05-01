k() {
    if ! kak -l |grep "$(pj is)"; then
        kak -e "rename-client $EMO; set global jumpclient $EMO" \
        -s "$(pj is)" "$@"
        return
    fi
    kak -e "rename-client $EMO; set global toolsclient $EMO; set global docsclient $EMO" \
    -c "$(pj is)" "$@"
}

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

ars() {
    local -a rs
    local x r p
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
        echo region is "$p"
        break
    done
}
