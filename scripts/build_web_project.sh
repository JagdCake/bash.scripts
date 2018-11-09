#!/bin/bash

### Description ###
# Choose between minifying / optimizing static or dynamic website assets
# For static - you can choose between minifying / optimizing a single file or all files in a directory
    # Selecting all files assumes build process for deployment to 'Google Firebase' and the script...
        # creates production branch
        # initializes new firebase project
        # commits all files
# For dynamic - the script creates a production branch and minifies / optimizes all files by file type
### ###

### Usage ###
# You can just create an alias for the script in '.bashrc' and run it from a terminal
    # alias buildwebproject='/path/to/./build_web_project.sh'
    # $ buildwebproject
# You can create a symbolic link to the script from your home directory
    # ~$ ln -s /path/to/build_web_project.sh
    # ~$ ./build_web_project.sh
### ###

filetype=$(echo "$1" | tr '[:upper:]' '[:lower:]')
input="$2"
output_dir="$3"

dependency_check() {
    dependencies=(git html-minifier terser svgo optipng)

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

build_for_vps() {
    choose_project

    cd "$project"

    echo 'Choose file type to minify'
    file=$(ls . | fzf)

    git branch production 2>/dev/null
    git checkout production
    minify_all_dynamic

    echo "Don't forget to commit"
}

usage() {
  printf "Usage:\n"
  printf "  ./build_web_project.sh [FILETYPE] [INPUT FILE/DIR] [OUTPUT DIR]\n\n"
  printf "Supported filetypes:\n"
  printf "  HTML, EJS, JS, SVG, PNG\n\n"
  printf "\n"
}

dependency_check

if [ $# -ne 3 ]; then
    usage
else
    minify_optimize
fi

