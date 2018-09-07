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

choose_file() {
    read -e -p "Enter path to file: " file

    if [ ! -f "$file" ]; then
        echo "File doesn't exist!"
        choose_file
    fi
}


