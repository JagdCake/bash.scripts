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

# messages to show after project creation
option_1_message="Don't forget to update config.js"
option_2_message=""
option_3_message=""

#!!! Options for option 1 - 'Node App', only !!!
package_manager='yarn'
verb='add'
packages_to_install=('express' 'ejs' 'pg-promise' 'body-parser')
### ###

name_the_project() {
	read -p "Enter project name: " project_name

	while [ -z "$project_name" ]; do
		echo "Please enter a project name."
		name_the_project
	done
}

copy_template_over() {
	template_dir="$1"

	cp -r "$template_dir"* .

	if [ ! -z "$2" ]; then
		# Source: https://stackoverflow.com/questions/16461656/how-to-pass-array-as-an-argument-to-a-function-in-bash#16461878<Paste>
		array_argument_2=$2[@]
		hidden_files=("${!array_argument_2}")

		for hidden_file in "${hidden_files[@]}"; do
			cp -r "$hidden_file" .
		done
	fi
}

init_git_and_message() {

	git init && 
	if [ ! -z "$1" ]; then
		array_argument_1=$1[@]
		files_to_ignore=("${!array_argument_1}")

		for file in "${files_to_ignore[@]}"; do
			echo "$file" >> .gitignore 
		done
	fi

	git add . && git commit -am "Initial commit"
	
	if [ ! -z "$2" ]; then
		message="$2"
		echo -e "\n${message}"
	fi
}

generate_project() {
	name_the_project	

	mkdir "$project_name" 

	cd "$project_name"

	if [ $choice -eq 1 ]; then
		copy_template_over "$option_1_files_dir" option_1_hidden_files
		$package_manager init && $package_manager $verb "${packages_to_install[@]}"
		init_git_and_message option_1_ignore "$option_1_message"
	elif [ $choice -eq 2 ]; then
		copy_template_over "$option_2_files_dir" option_2_hidden_files
		init_git_and_message option_2_ignore "$option_2_message"
	elif [ $choice -eq 3 ]; then
		copy_template_over "$option_3_files_dir" option_3_hidden_files
		init_git_and_message option_3_ignore "$option_3_message"
	fi
}

select project in "${project_type_options[@]}" "Cancel"; do
	case "$project" in
		"${project_type_options[0]}" )
			choice=1
			generate_project
			exit;;
		"${project_type_options[1]}" )
			choice=2
			generate_project
			exit;;
		"${project_type_options[2]}" )
			choice=3
			generate_project
			exit;;
		Cancel )
			exit;;
	esac
done			

