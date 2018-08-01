#!/bin/bash

### Description ###
# Choose the type of web project you're starting (Node.js app, WordPress website, static site, etc.)
# Enter a project name and create a directory of the same name
# Copy template files and folders from a predefined location to the project dir
# Install packages, initialize a git repository, add files / folders to .gitignore
### ###

### Options ###
project_type_options=("Node App" "Static site" "WordPress site")
# paths to template files
option_1_files_dir=~/Documents/web_dev/1_templates/node_app/
option_2_files_dir=~/Documents/web_dev/1_templated/static_site/
option_3_files_dir=~/Documents/web_dev/1_templated/wordpress_site/
# use full paths
option_1_hidden_files=("/home/jagdcake/Documents/web_dev/1_templates/node_app/.eslintrc.json")
option_2_hidden_files=()
option_3_hidden_files=()

# files and folders to (git)ignore
option_1_ignore=("TODO" "config.js" "node_modules/")
option_2_ignore=()
option_3_ignore=()
