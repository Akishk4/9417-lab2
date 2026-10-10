#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 dir malicious_dir interval-secs"
    exit 1
fi

dir="$1"
malicious_dir="$2"
interval="$3"

if [ ! -d "$dir" ]; then
    echo "Source directory does not exist."
    exit 1
fi

if ! [[ "$interval" =~ ^[0-9]+$ ]] || [ "$interval" -lt 1 ]; then
    echo "Interval must be a positive integer."
    exit 1
fi

mkdir -p "$malicious_dir"

extensions=( ".exe" ".bat" ".vbs" ".scr" ".ps1" )
keywords=( "virus" "trojan" "malware" "worm" "ransomware" )

scan_dir() {
    for file in "$dir"/*; do
        [ -f "$file" ] || continue

        name="${file##*/}"
        ext="${name##*.}"
        ext=".$ext"
        bad=0

        for item in "${extensions[@]}"; do
            if [ "$ext" = "$item" ]; then
                bad=1
                break
            fi
        done

        if [ "$bad" -eq 0 ]; then
            for word in "${keywords[@]}"; do
                if grep -qiF -- "$word" "$file" 2>/dev/null; then
                    bad=1
                    break
                fi
            done
        fi

        if [ "$bad" -eq 1 ]; then
            echo "$name is malicious and it is DELETED"

            if cp -- "$file" "$malicious_dir/$name"; then
                rm -- "$file"
            fi
        fi
    done
}

scan_dir

ls -l "$dir" > directory-info.last

while true; do
    sleep "$interval"

    ls -l "$dir" > directory-info.new

    if ! cmp -s directory-info.last directory-info.new; then
        scan_dir

        ls -l "$dir" > directory-info.last
    fi
done
