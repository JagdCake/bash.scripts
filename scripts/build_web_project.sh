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

filetype="$1"
input="$2"
output_dir="$3"

dependency_check() {
    dependencies=(git html-minifier terser svgo optipng fzf)

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
        html-minifier "$input" -o "$output_dir"/"$input" --case-sensitive --collapse-whitespace --remove-comments --minify-css
    elif [[ -d "$input" ]]; then
        html-minifier --input-dir "$input" --output-dir "$output_dir"/ --file-ext "$file_extension" --case-sensitive --collapse-whitespace --remove-comments --minify-css
    fi
}

minify_js() {
    if [ -f "$input" ]; then
        terser "$input" -o "$output_dir"/min."$input" --compress --mangle
    elif [ -d "$input" ]; then
        terser "$input" -o "$output_dir" --compress --mangle
    fi
}

minify_svg() {
    if [ -f "$input" ]; then
        svgo -i "$input" -o "$output_dir"/
    elif [ -d "$input" ]; then
        svgo -f "$input" -o "$output_dir"/
    fi
}

minify_all_dynamic() {
    file_extension=$(echo "$file" | awk -F . '{if (NF>1) {print $NF}}')

    if [[ "$file_extension" == 'ejs' ]]; then
        html-minifier --input-dir ./ --output-dir ./ --case-sensitive --collapse-whitespace --remove-comments --minify-css
    elif [[ "$file_extension" == 'js' ]]; then
        terser "$file" -o min."$file" --compress --mangle
        sed -i 's/src="js\/all.js"/src="js\/min.all.js"/g' ../../views/partials/footer.ejs
    elif [[ "$file_extension" == 'svg' ]]; then
        svgo -f .
    elif [[ "$file_extension" == 'png' ]]; then
        optipng -o5 ./*.png
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

choose_how_many_files() {
    echo "Choose how many files to minify / optimize:"
    select choice in "One file" "All files" "Cancel"; do
        case "$choice" in
            "One file" )
                build_for_firebase one
                break;;
            "All files" )
                build_for_firebase all
                exit;;
            "Cancel" )
                exit;;
        esac
    done

    choose_how_many_files
}

main_menu() {
    select option in "Build static website" "Build dynamic website" "Quit"; do
        case "$option" in
            "Build static website" )
                choose_how_many_files
                exit;;
            "Build dynamic website" )
                build_for_vps
                break;;
            "Quit" )
                exit;;
        esac
    done

    main_menu
}

dependency_check
main_menu

