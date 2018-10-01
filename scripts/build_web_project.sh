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

choose_project() {
    # can't expand tilde (~), use only full or relative paths
    read -e -p "Enter project / file location: " project

    if [ ! -d "$project" ]; then
        echo "Directory doesn't exist!"
        choose_project
    fi
}

minify_single_static() {
    file_extension=$(echo "$file" | awk -F . '{if (NF>1) {print $NF}}')

    if [[ "$file_extension" == 'html' ]]; then
        html-minifier "$file" -o public/"$file" --case-sensitive --collapse-whitespace --remove-comments --minify-css
        sed -i 's/src="js\/all.js"/src="js\/min.all.js"/g' public/"$file"
    elif [[ "$file_extension" == 'js' ]]; then
        terser "$file" -o ../public/js/min."$file" --compress --mangle
        cp "$file" ../public/js/
    elif [[ "$file_extension" == 'svg' ]]; then
        svgo -i "$file" -o ../public/images/
    elif [[ "$file_extension" == 'png' ]]; then
        optipng -o5 "$file" -out ../public/images/"$file"
    else
        echo "Unsupported file format"
        exit
    fi
}

minify_all_static() {
    html-minifier --input-dir ./ --output-dir public/ --file-ext html --case-sensitive --collapse-whitespace --remove-comments --minify-css &&

    html-minifier ./public/404.html -o ./public/ --case-sensitive --collapse-whitespace --remove-comments --minify-css &&

    cp -r js/ images/ public/ &&

    terser public/js/all.js -o public/js/min.all.js --compress --mangle &&

    sed -i 's/src="js\/all.js"/src="js\/min.all.js"/g' public/index.html &&

    svgo -f public/images/ &&

    optipng -o5 public/images/*.png
}

build_for_firebase() {
    what="$1"

    choose_project

    cd "$project"

    if [ "$what" == 'one' ]; then
        echo 'Choose file to minify'
        file=$(ls . | fzf)

        minify_single_static
    elif [ "$what" == 'all' ]; then
        git branch production 2>/dev/null
        git checkout production
        firebase init &&
        minify_all_static

        git add .
        git commit -m "Deploy to firebase"
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

