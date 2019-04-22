#!/bin/bash

# TODO Enhancement:
# extract the colors and color resets into their own variables to clean up the echo messages

### Description ###
# Choose between adding a new topic / notes on a topic, editing notes or displaying all notes on a topic
# If adding a new topic, choose a name and enter a title for the first set of notes
# If adding notes, select a topic from all the added ones and enter a title
# The script will generate markdown-formatted lines of text for the title, date, first note and the source
# The script will then open the notes file in your favorite text editor (default is 'neovim')
# If editing notes, select the title of a set of notes and open in text editor (default is 'neovim') 
# If displaying notes, you can decide to either open the markdown (MD) file in the chosen program (default is the 'less' command) or have the MD converted to a PDF file and then displayed in a PDF file viewer (default is a manually installed version of 'Firefox Developer Edition')
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
character_encoding='UTF-8'

convert_options="--minimum-line-height $line_height --pdf-default-font-size $font_size --pdf-hyphenate --pdf-page-numbers --pdf-standard-font $font --input-encoding $character_encoding --level1-toc //h:h2 --title Notes --authors $(whoami)"

# app for editing notes
app_add() {
    nvim +"normal Gkkka " "$1" 2>/dev/null || gedit "$1"
}

app_edit() {
    nvim +"$1" +"normal jjjw" "$2" 2>/dev/null || gedit "$2"
}

# app for opening .md notes
app_open_md() {
    export BAT_PAGER='less'
    bat --paging always "$1" 2>/dev/null || less "$1"
}

# app for opening .pdf notes
app_open_pdf() {
    ~/firefox/./firefox "$1" 2>/dev/null || xdg-open "$1"
}
### ###

dependency_check() {
    if [ ! "$(which fzf 2>/dev/null)" ]; then
        echo "Dependency: \"fzf\" is not installed."
        exit 1
    elif [ ! "$(which calibre 2>/dev/null)" ]; then
        echo -e "Dependency: \"calibre\" is not installed.\\nYou won't be able to convert notes to PDF.\\n"
    fi
}

# create the notes folder if it doesn't already exist
if [ ! -d "$notes" ]; then
    mkdir -p "$notes"
fi

generate_format() {
    read -p "Enter a title: " title

    title=$(echo "$title" | sed 's/^[ \t]*//;s/[ \t]*$//')

    echo "## $title" >> "$notes/$topic".md
    echo -e "*$(date)*\\n" >> "$notes/$topic".md
    echo -e "- \\n" >> "$notes/$topic".md
    echo -e "Source: <link here>\\n" >> "$notes/$topic".md
}

add_notes() {
    generate_format
    app_add "$notes/$topic".md
}

add_topic() {
    read -p 'Enter a topic name: ' topic

    while [ -z "$topic" ]; do
        echo 'You need a name for the topic'
        add_topic
    done

    # removes tabs, leading and trailing whitespace from the file name
    topic=$(echo "$topic" | sed 's/^[ \t]*//;s/[ \t]*$//')

    # 'touch' doesn't overwrite already existing files
    touch "$notes/$topic".md
}

# use fuzzy search to select a topic
select_topic() {
    topic="$(ls -p "$notes" | # append a slash to directories
        grep -v / | # match files without a slash in the filename
        awk -F'.md' '{ print $1 }' |
        fzf)"
}

edit_notes() {
    number_of_lines=$(cat "$notes/$topic".md | wc -l)

    if [ "$number_of_lines" -ge 7 ]; then
        note_title=$(grep '##' "$notes/$topic".md | awk -F'##' '{ print $2 }' | awk '{$1=$1};1' | fzf)
        if [ $? -eq 0 ]; then
            line=$(grep -n "$note_title" "$notes/$topic".md | awk -F':' '{ print $1 }')
            app_edit "$line" "$notes/$topic".md
        fi
    else
        echo -e "\n\e[48;5;202m \e[38;5;231mFile is either empty or not formatted properly! \e[0m\e[0m\n"
    fi
}

create_pdf() {
    pdf_file="$notes/pdf_notes/$topic.pdf"
    md_file="$notes/$topic.md"

    # create pdf file only if one doesn't already exist or if it's not up to date with the md file
    if [[ -f "$pdf_file" && ! "$md_file" -nt "$pdf_file" ]]; then
        app_open_pdf "$pdf_file"
    else
        echo -e "\e[48;5;231m \e[38;5;25mConversion in progress... \e[0m\e[0m"
        ebook-convert "$md_file" "$pdf_file" $(echo "$convert_options") 2>/dev/null | grep -o '[0-9]\+%'
        app_open_pdf "$pdf_file"
        rm "$notes"/*.html
    fi
}

display_notes() {
    echo "Display notes in:"
    select mode in "Raw markdown" "PDF file converted from md" "Cancel"; do
        case "$mode" in
            "Raw markdown" )
                app_open_md "$notes"/"$topic".md
                break;;
            "PDF file converted from md" )
                create_pdf
                break;;
            "Cancel" )
                return;;
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
        select choice in "Add new topic" "Add notes" "Edit notes" "Show notes" "Quit"; do
            case "$choice" in
                "Add new topic" )
                    add_topic &&
                    add_notes
                    break;;
                "Add notes" )
                    select_topic &&
                    add_notes
                    break;;
                "Edit notes" )
                    select_topic &&
                    edit_notes
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

dependency_check
select_menu

