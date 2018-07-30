#!/bin/bash

### Description ###
# Choose a workspace from a pre-defined list and switch to it
# Run any specified commands in that new workspace, but only if it's inactive (no running apps)
# Change the background depending on the workspace
### ###

### Options ###
workspace_names=(Home Work Read Movie CTRL)
workspace_commands() {
    if [ $1 -eq 0 ]; then
        terminator -l custom
    elif [ $1 -eq 1 ]; then
        terminator -l neovim
    elif [ $1 -eq 2 ]; then
        terminator -l light_reading -e "neovim -u ~/.config/nvim/reader.vim"
    elif [ $1 -eq 3 ]; then
        terminator -l movie
    elif [ $1 -eq 4 ]; then
        terminator -l default
    fi
}
### ###

switch_to() {
    workspace_number=$1

    xdotool set_desktop $workspace_number 
    workspace_commands $workspace_number 
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
}

switch_workspace

