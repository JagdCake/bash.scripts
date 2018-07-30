#!/bin/bash

### Description ###
# Choose a workspace from a pre-defined list and switch to it
# Run any specified commands in that new workspace, but only if it's inactive (no running apps)
# Change the background depending on the workspace
### ###

### Options ###
workspace_names=(Home Work Read Movie CTRL)
### ###

switch_workspace() {
    echo 'Choose a workspace:'
    select workspace_name in ${workspace_names[@]} "Cancel"; do
        case "$workspace_name" in
            ${workspace_names[0]} ) 
                workspace=0
                xdotool set_desktop $workspace
                break;;
            ${workspace_names[1]} ) 
                workspace=1
                xdotool set_desktop $workspace
                break;;
            ${workspace_names[2]} )
                workspace=2
                xdotool set_desktop $workspace
                break;;
            ${workspace_names[3]} )
                workspace=3
                xdotool set_desktop $workspace
                break;;
            ${workspace_names[4]} )
                workspace=4
                xdotool set_desktop $workspace
                break;;
            Cancel )
                exit;;
        esac
    done
}

switch_workspace

