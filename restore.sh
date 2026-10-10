#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 dir malicious_dir"
    exit 1
fi

dir="$1"
malicious_dir="$2"

if [ ! -d "$dir" ] || [ ! -d "$malicious_dir" ]; then
    echo "Both directories must exist."
    exit 1
fi

while true; do
    files=()

    for file in "$malicious_dir"/*; do
        [ -f "$file" ] || continue
        files+=( "$file" )
    done

    if [ "${#files[@]}" -eq 0 ]; then
        echo "No malicious files to review."
        exit 0
    fi

    echo "Quarantined files:"

    for i in "${!files[@]}"; do
        echo "$((i + 1)). ${files[$i]##*/}"
    done

    echo "0. Exit"

    read -r -p "Choose a file number: " choice

    if [ "$choice" = "0" ]; then
        exit 0
    fi

    if ! [[ "$choice" =~ ^[0-9]+$ ]] ||
       [ "$choice" -lt 1 ] ||
       [ "$choice" -gt "${#files[@]}" ]; then
        echo "Invalid choice."
        continue
    fi

    file="${files[$((choice - 1))]}"
    name="${file##*/}"

    echo "Selected: $name"
    echo "1. Restore this file"
    echo "2. Permanently delete this file"
    echo "3. Leave this file as-is"

    read -r -p "Choose an option: " action

    case "$action" in
        1)
            if [ -e "$dir/$name" ]; then
                echo "A file with this name already exists in $dir."
            elif mv -- "$file" "$dir/$name"; then
                echo "Restored $name to $dir."
            fi
            ;;

        2)
            if rm -- "$file"; then
                echo "$name permanently deleted."
            fi
            ;;

        3)
            echo "File left in quarantine."
            ;;

        *)
            echo "Invalid option."
            ;;
    esac
done
