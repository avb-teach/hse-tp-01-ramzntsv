#!/bin/bash

declare -A count_files
mkdir "$2"
copy_file(){
    local name=$(basename "$1")
    local count=${count_files["$name"]:-0}

    local newname="$name"
    while [[ -e "$2/$newname" ]]; do
        ((count++))
        newname="${name%.*}$count.${name##*.}"
    done

    cp "$1" "$2/$newname"
    count_files["$name"]=$((count+1))
}
find "$1" -type f| while read -r path; do
    copy_file "$path" "$2"
done