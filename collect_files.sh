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

find "$input_dir" -type f | while read -r path; do
    copy_file_no_maxdepth "$path" 
done

