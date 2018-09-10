#!/bin/bash

# create a different function for every part of the build process (minify CSS, optimize images, etc.)
    # one function for static and dynamic sites
# select between project types (static_firebase, dynamic_node, dynamic_wordpress)
# choose between building from scratch (run all functions) and building piece by piece (select function to run)

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
        firebase init &&
        minify_all_static
        git branch production 2>/dev/null
        git checkout production
        git add .
        git commit -m "Deploy to firebase"

        echo 'Link to js/min.all.js instead of js/all.js'
    fi
}

minify_all_dynamic() {
    file_extension=$(echo "$file" | awk -F . '{if (NF>1) {print $NF}}')

    if [[ "$file_extension" == 'ejs' ]]; then
        html-minifier --input-dir ./ --output-dir ./ --case-sensitive --collapse-whitespace --remove-comments --minify-css
    elif [[ "$file_extension" == 'js' ]]; then
        terser "$file" -o min."$file" --compress --mangle
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

