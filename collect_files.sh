#!/bin/bash

declare -A count_files
mkdir "$2"
copy_file(){
    local name=$(basename "$1")
    local count=${count_files["$name"]:-0}

    local newname="$name"
    while [[-e "$2/$newname"]]; do
        ((count++))
        newname="${name%.*}$count.${name##*.}"
    done

    cp "$1" "$2/$newname"
    count_files["$name"]=$((count+1))
}

if [-n "$3"]; then
    find "$1" -type f | while read -r path; do
        depth=$(echo "$(dirname "$path")" | tr -cd '/' | wc -c)
        if [["$depth" -le "$3"]]; then
            target_dir="$2/$(dirname "$path" | cut -d/ -f2-)"
            mkdir -p "$target_dir"
            copy_file "$path" "$target_dir"
        else
            target_dir="$2/$(dirname "$path" | cut -d/ -f2- | cut -d/ -f1)"
            mkdir -p "$target_dir"
            copy_file "$path" "$target_dir"
        fi
    done
else
    find "$1" -type f| while read -r path; do
        copy_file "$path" "$2"
    done
fi 