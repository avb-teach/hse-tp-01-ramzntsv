#!/bin/bash

declare -A count_files
mkdir "$2"

if [ -n "$3" ]; then
    find "$1" -maxdepth "$3" -type f
else
    find "$1" -type f
fi | while read -r path; do
    name=$(basename "$path")
    count=${count_files["$name"]:-0}

    newname="$name"
    while [[ -e "$2/$newname" ]]; do
        ((count++))
        newname="${name%.*}$count.${name##*.}"
    done
        count_files["$name"]=$((count+1))
        cp "$path" "$2/$newname"
done