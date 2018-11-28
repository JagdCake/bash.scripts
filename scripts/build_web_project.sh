#!/bin/bash

### Description ###
# Minify / optimize a file or all files in a directory, depending on filetype
### ###

filetype=$(echo "$1" | tr '[:upper:]' '[:lower:]')
input="$2"
output_dir="$3"

dependency_check() {
    dependencies=(html-minifier csso terser svgo optipng)

    for dependency in "${dependencies[@]}"; do
        if [ ! $(which "$dependency" 2>/dev/null) ]; then
            echo -e "Dependency: \""$dependency"\" is not installed."
            dependency=false
        fi
    done

    if [ "$dependency" = false ]; then
        exit
    fi
}

get_filename() {
    echo "$input" | awk -F'/' '{ print $NF }'
}

minify_html() {
    # check if the input is a file or a directory
    if [[ -f "$input" ]]; then
        html-minifier "$input" -o "$output_dir"/$(get_filename) --case-sensitive --collapse-whitespace --remove-comments --minify-css
    elif [[ -d "$input" ]]; then
        html-minifier --input-dir "$input" --output-dir "$output_dir"/ --file-ext "$filetype" --case-sensitive --collapse-whitespace --remove-comments --minify-css
    fi
}

minify_css() {
    if [[ -f "$input" ]]; then
        csso "$input" -o "$output_dir"/$(get_filename)
    elif [[ -d "$input" ]]; then
        cat "$input"/*.css | csso -o "$output_dir"/minified.css
    fi
}

minify_js() {
    if [ -f "$input" ]; then
        terser "$input" -o "$output_dir"/min.$(get_filename) --compress --mangle
    elif [ -d "$input" ]; then
        terser "$input" -o "$output_dir" --compress --mangle
    fi
}

optimize_svg() {
    if [ -f "$input" ]; then
        svgo -i "$input" -o "$output_dir"/
    elif [ -d "$input" ]; then
        svgo -f "$input" -o "$output_dir"/
    fi
}

optimize_png() {
    if [ -f "$input" ]; then
        optipng -o5 "$input" -out "$output_dir"/$(get_filename)
    elif [ -d "$input" ]; then
        optipng -o5 "$input"/*.png -dir "$output_dir"/
    fi
}

minify_optimize() {
    if [[ "$filetype" = 'html' || "$filetype" = 'ejs' ]]; then
        minify_html
    elif [[ "$filetype" = 'css' ]]; then
        minify_css
    elif [[ "$filetype" = 'js' ]]; then
        minify_js
    elif [[ "$filetype" = 'svg' ]]; then
        optimize_svg
    elif [[ "$filetype" = 'png' ]]; then
        optimize_png
    else
        echo "Unsupported file format"
        exit
    fi
}

usage() {
  printf "Usage:\n"
  printf "  ./build_web_project.sh [FILETYPE] [INPUT FILE/DIR] [OUTPUT DIR]\n\n"
  printf "Supported filetypes:\n"
  printf "  HTML, EJS, CSS, JS, SVG, PNG\n\n"
  printf "\n"
}

dependency_check

if [ $# -ne 3 ]; then
    usage
else
    minify_optimize
fi

