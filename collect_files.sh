#!/bin/bash

input_dir="$1"
output_dir="$2"
declare -A count_files
mkdir "$output_dir"

copy_file_no_maxdepth(){
    local name=$(basename "$1")
    local count=${count_files["$name"]:-0}

    local newname="$name"
    while [[ -e "$output_dir/$newname" ]]; do
        ((count++))
        newname="${name%.*}$count.${name##*.}"
    done

    cp "$1" "$output_dir/$newname"
    count_files["$name"]=$((count+1))
}
copy_dir_max_depth(){
    local path="$1"
    local max_depth="$2"
    local new_path="${path#$input_dir/}"
    local depth=$(echo "$new_path" | grep -o "/" | wc -l)
    local target_dir
    if (( depth > "$max_depth" )); then
        local cut_path=$(echo "$new_path" | cut -d'/' -f1-"$max_depth")
        target_dir="$output_dir/$(dirname "$cut_path")"

    else
        target_dir="$output_dir/$(dirname "$new_path")"
    fi

    mkdir -p "$target_dir"
    cp "$1" "$target_dir/"
}

find "$input_dir" -type f | while read -r path; do
    if [ -n "$3" ]; then
        max_depth="$3"
        copy_dir_max_depth "$path" "$max_depth"

    else
        copy_file_no_maxdepth "$path" 
    fi
done

