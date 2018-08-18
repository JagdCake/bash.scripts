#!/bin/bash

### Description ###
# Choose between adding a new topic / notes on a topic or displaying all notes on a topic
# If adding a new topic, choose a name and enter a title for the first set of notes
# If adding notes, select a topic from all the added ones and enter a title
# The script will generate formatted lines of text for the title, date, first note and the source
# The script will then open the notes file in your favorite text editor (default is 'neovim')
# If displaying notes, the script will open the file in the chosen program (default is 'less')
### ###

### Usage ###
# You can just create an alias for the script in '.bashrc' and run it from a terminal
    # alias take_notes='/path/to/./take_notes.sh'
    # $ take_notes
# You can create a symbolic link to the script from your home directory
    # ~$ ln -s /path/to/take_notes.sh
    # ~$ ./take_notes.sh
### ###

### Options ###
# path to notes folder
notes=~/Documents/text_files/notes/

# PDF notes conversion options
font='sans' # options are 'serif', 'sans', 'mono'
font_size='20' # in pts (probably)
line_height='150' # percentage of the font size, default is '120', for double spaced text use '240'

convert_options="--minimum-line-height "$line_height" --pdf-default-font-size "$font_size" --pdf-hyphenate --pdf-page-numbers --pdf-standard-font "$font""

# app for editing notes
app_edit() {
    nvim +"normal Gkkka " "$1"
}

# app for opening .md notes
app_open_md() {
    less "$1"
}

# app for opening .pdf notes
app_open_pdf() {
    ~/firefox/./firefox "$1"
}
### ###

# create the notes folder if it doesn't already exist
if [ ! -d "$notes" ]; then
    mkdir -p "$notes"
fi

generate_format() {
    # TODO Enhancement:
    # sanitize the title variable
    read -p "Enter a title: " title

    echo "## "$title"" >> "$notes"/"$topic".md
    echo -e "*$(date)*\n" >> "$notes"/"$topic".md
    echo -e "- \n" >> "$notes"/"$topic".md
    echo -e "Source: <link here>\n" >> "$notes"/"$topic".md
}

add_notes() {
    generate_format
    app_edit "$notes"/"$topic".md
}

# TODO Enhancement:
# add a function for note editing, use grep to find the line number of a title (?) selected with fzf

add_topic() {
    read -p 'Enter a topic name: ' topic

    while [ -z "$topic" ]; do
        echo 'You need a name for the topic'
        add_topic
    done

    # removes tabs, leading and trailing whitespace from the file name
    topic=$(echo "$topic" | sed 's/^[ \t]*//;s/[ \t]*$//')

    # 'touch' doesn't overwrite already existing files
    touch "$notes"/"$topic".md
}

select_topic() {
    # use fuzzy search to select a topic
    topic="$(ls -p "$notes" | grep -v / | awk -F'.md' '{ print $1 }' | fzf)"
}

display_notes() {
    echo "Display notes in:"
    select mode in "Raw markdown" "PDF file converted from md" "Cancel"; do
        case "$mode" in
            "Raw markdown" )
                app_open_md "$notes"/"$topic".md
                break;;
            "PDF file converted from md" )
                ebook-convert "$notes"/"$topic".md "$notes"/pdf_notes/"$topic".pdf $(echo "$convert_options") > /dev/null 2>&1
                app_open_pdf "$notes"/pdf_notes/"$topic".pdf
                rm "$notes"/*.html
                break;;
            "Cancel" )
                exit;;
        esac
    done
}

select_menu() {
    topics="$(ls -A "$notes")"

    # check to see of there are any topics in the notes folder
    if [ -z "$topics" ]; then
        add_topic &&
        add_notes
        select_menu
    else
        select choice in "Add new topic" "Add notes" "Show notes" "Quit"; do
            case "$choice" in
                "Add new topic" )
                    add_topic &&
                    add_notes
                    break;;
                "Add notes" )
                    select_topic &&
                    add_notes
                    break;;
                "Show notes" )
                    select_topic &&
                    display_notes
                    break;;
                "Quit" )
                    exit;;
            esac
        done

        select_menu
    fi
}

select_menu

