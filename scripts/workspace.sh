#!/bin/bash

### Description ###
# Choose a workspace from a pre-defined list and switch to it
# Run any specified commands in that new workspace, but only if it's inactive (no running apps)
# Change the background depending on the workspace
### ###

### Options ###
workspace_names=(Home Work Read Movie CTRL)
# if using terminator, it's better to set any custom commands you want to run on launch in the layout options
workspace_commands() {
    if [ $1 -eq 0 ]; then
        terminator -l custom
    elif [ $1 -eq 1 ]; then
        terminator -l neovim
    elif [ $1 -eq 2 ]; then
        terminator -l light_reading
    elif [ $1 -eq 3 ]; then
        terminator -l movie
    elif [ $1 -eq 4 ]; then
        terminator -l default
    fi
}

workspace_1_bg='/home/jagdcake/Pictures/pinecone_desktop.png'
workspace_2_bg='/home/jagdcake/Pictures/blue_feathers.png'
workspace_3_bg='/home/jagdcake/Pictures/david-marcu-2041.jpg'
workspace_4_bg='/home/jagdcake/Pictures/rose_black.png'
workspace_5_bg='/home/jagdcake/Pictures/cubes_gray.png'

# xdotool will look for this app in the selected workspace to determine if the workspace is active, if it is, the script will only switch to it without running 'workspace_commands'
app_to_search_for='terminator'
### ###

workspace_is_active() {
    # Source: https://stackoverflow.com/a/27074039/8980616
    xdotool search --onlyvisible --desktop $1 --class "$app_to_search_for" getwindowname %@ > /dev/null

    if [ $? -eq 0 ]; then
        true
    else
        false
    fi
}

switch_to() {
    workspace_number=$1

    if workspace_is_active $workspace_number; then
        xdotool set_desktop $workspace_number
    else
        xdotool set_desktop $workspace_number 
        workspace_commands $workspace_number 
    fi
}

switch_background() {
    if [ $workspace -eq 0 ]; then
        gsettings set org.gnome.desktop.background picture-uri file://"$workspace_1_bg"
    elif [ $workspace -eq 1 ]; then
        gsettings set org.gnome.desktop.background picture-uri file://"$workspace_2_bg"
    elif [ $workspace -eq 2 ]; then
        gsettings set org.gnome.desktop.background picture-uri file://"$workspace_3_bg"
    elif [ $workspace -eq 3 ]; then 
        gsettings set org.gnome.desktop.background picture-uri file://"$workspace_4_bg"
    elif [ $workspace -eq 4 ]; then
        gsettings set org.gnome.desktop.background picture-uri file://"$workspace_5_bg"
    fi
}

switch_workspace() {
    echo 'Choose a workspace:'
    select workspace_name in ${workspace_names[@]} "Cancel"; do
        case "$workspace_name" in
            ${workspace_names[0]} ) 
                workspace=0
                switch_to $workspace
                break;;
            ${workspace_names[1]} ) 
                workspace=1
                switch_to $workspace
                break;;
            ${workspace_names[2]} )
                workspace=2
                switch_to $workspace
                break;;
            ${workspace_names[3]} )
                workspace=3
                switch_to $workspace
                break;;
            ${workspace_names[4]} )
                workspace=4
                switch_to $workspace
                break;;
            Cancel )
                exit;;
        esac
    done

    switch_background
}

switch_workspace

