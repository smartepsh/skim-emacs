#!/bin/bash

base_dir=$(readlink -f "$0")
real_dir=$(dirname $base_dir)

library_dir="$HOME/Library/Script Libraries"

mkdir -p "$library_dir"
prefix="eskim"
script_dir="$real_dir/applescripts"

do_setup() {
    find "$script_dir" -type f | while read -r file; do
        filename=$(basename "$file")
        echo "compile $filename and move compiled file to the library"
        compiled_filename="eskim-$filename"
        osacompile -o "$script_dir/$compiled_filename" "$script_dir/$filename"
        mv "$script_dir/$compiled_filename" "$library_dir/$compiled_filename"
    done
}

found_file=$(find "$library_dir" -type f -name "${prefix}*" -print -quit)

if [ -n "$found_file" ]; then
    read -p "Files with prefix '${prefix}' found in library. Do you want to continue? (y/n): " choice

    # Check the choice
    if [ "$choice" == "y" ]; then
        do_setup
    else
        echo "Aborted."
    fi
else
    do_setup
fi
