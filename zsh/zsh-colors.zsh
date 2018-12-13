#!/bin/zsh

echo -n "                                    "
for i in $(seq -f "%03g" 0 255); do
    s="%K{$i}   %k%F{$i} $i%K{0} $i%K{16} $i%k%f   "
    echo -n ${(%)s}
    if [[ $i -gt 0 ]] && [[ $(( ($i - 3) % 6 )) == 0 ]]; then
        echo
    fi
done
