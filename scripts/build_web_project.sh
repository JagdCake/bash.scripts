#!/bin/bash

# create a different function for every part of the build process (minify CSS, optimize images, etc.)
    # one function for static and dynamic sites
# select between project types (static_firebase, dynamic_node, dynamic_wordpress)
# choose between building from scratch (run all functions) and building piece by piece (select function to run)

choose_project() {
    read -e -p "Enter project directory: " project_dir

    if [ ! -d "$project_dir" ]; then
        echo "Directory doesn't exist!"
        choose_project
    fi
}

minify_single_html_inline_css() {
    type="$1"

    choose_project

    cd "$project_dir"

    echo 'Choose file to minify'
    file=$(ls . | fzf)

    if [ "$type" == 'static' ]; then
        html-minifier "$file" -o public/"$file" --case-sensitive --collapse-whitespace --remove-comments --minify-css
    elif [ "$type" == 'dynamic' ]; then
        git checkout production &&
        html-minifier "$file" -o views/"$file" --case-sensitive --collapse-whitespace --remove-comments --minify-css
    fi
}

    fi
}


