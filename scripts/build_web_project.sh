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

    if [[ "$file_extension" == 'html' || "$file_extension" == 'ejs' ]]; then
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

minify_type() {
    type="$1"

    choose_project

    cd "$project"

    echo 'Choose file to minify'
    file=$(ls . | fzf)

    if [ "$type" == 'static' ]; then
        minify_static
    elif [ "$type" == 'dynamic' ]; then
        git checkout production &&
        html-minifier "$file" -o views/"$file" --case-sensitive --collapse-whitespace --remove-comments --minify-css
    fi
}

    fi
}


