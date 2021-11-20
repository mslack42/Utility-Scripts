#!/bin/bash
###################################################
#                                                 #
#   ft.sh - The Fast Travel commandline script!   #
#                                                 #
#   Use this script to save shortcuts ("camps")   #
#   in the commandline for later re-use, across   #
#   multiple sessions.                            #
#                                                 #
#   Installation:                                 #
#   Add the following to your .bashrc             #
#       alias ft=". your/path/to/ft.sh"           #
#   Configured camps will be stored at            #
#       ${FT_STORE_LOCATION}/.ftstore             #
#   $FT_STORE_LOCATION is $HOME by default.       #
#                                                 #
#   Created by mslack42, 20/11/2021               #
#                                                 #
###################################################

# Set up global variables
Command=""
Destination=""
if [ -z "$FT_STORE_LOCATION" ]
then
    StoreLocation="$HOME/.ftstore/"
else
    StoreLocation="${FT_STORE_LOCATION}/.ftstore/"
fi

# Display error message and script usage
fail_and_display_error () {
    echo "$1"
    echo ""
    display_usage
    kill -INT $$
}

# Display script usage
display_usage () {
    echo "Usage: . ft.sh [COMMAND] [CAMP_NAME]"
    echo "Commands include:"
    echo "      --set-camp, -s:   save the current directory under the specified CAMP_NAME"
    echo "      --list-camps, -l: lists all the available camps"
    echo "      --clear-camp, -c: removes CAMP_NAME from the list of available camps."
    echo "Specifying a CAMP_NAME alone has the effect of changing directory to that camp."
}

# Display suggested instructions for installation of script
display_installation_guidance () {
    echo "Suggested Installation Guidance:"
    echo ""
    echo "Configure an alias in your .bashrc that sources the script, e.g."
    echo "      alias ft='. your/path/to/ft.sh'"
    echo "The script will not be able to change directories for you if not run in this manner."
    echo "With this in place, the script can be used from anywhere just by executing e.g."
    echo "      ft CAMP_NAME"
    echo ""
    echo "Configured camps will be stored at"
    echo "      \${FT_STORE_LOCATION}/.ftstore"
    echo "\$FT_STORE_LOCATION is \$HOME by default, but can be overwritten."
}

# Display help and exit
help () {
    echo "ft.sh - The Fast Travel commandline script!"
    echo ""
    echo "Use this script to save shortcuts ('camps') in the commandline for later re-use, across multiple sessions."
    echo ""
    display_usage
    echo ""
    display_installation_guidance
    kill -INT $$
}

# Creates persistent storage if not present
initialise () {
    if [ ! -d $StoreLocation ]
    then 
        mkdir $StoreLocation
    fi
}

# Validate and parse provided argumnets
parse_arguments () {
    if [ "$#" -gt 2 ] || [ "$#" -eq 0 ]
    then
        fail_and_display_error "Wrong number of arguments supplied"
    fi

    for arg in "$@"
    do
        case "$arg" in
            --help|-h)
                help
                ;;
            --set-camp|--list-camps|--clear-camp|-s|-l|-c)
                if [ -z $Command ]
                then 
                    Command="$arg"
                else
                    fail_and_display_error "Duplicate command supplied"
                fi
                ;;
            -*)
                fail_and_display_error "Unrecognised command supplied"
                ;;
            *)
                if [ -z $Destination ] && [ "$Command" != "-list-camps" ]
                    then 
                    Destination="$arg"
                else
                    fail_and_display_error "Multiple destinations supplied"
                fi
                ;;
        esac
    done

    map_command_argument_to_command $Command
}

# Convert parsed command argument into command
map_command_argument_to_command () {
    case $1 in
        --set-camp|-s)
            Command="--set-camp"
            ;;
        --list-camps|-l)
            Command="--list-camps"
            ;;
        --clear-camp|-c)
            Command="--clear-camp"
            ;;
        *)
            Command="--go-to-camp"
            ;;
    esac
}

# Execute the command corresponding to set variable values
execute_command () {
    case "$Command" in
        --set-camp)
            set_camp "$Destination"
            ;;
        --list-camps)
            list_camps
            ;;
        --clear-camp)
            clear_camp "$Destination"
            ;;
        --go-to-camp)
            go_to_camp "$Destination"
            ;;
    esac
}

# Add camp to store
set_camp () {
    echo $PWD > "$StoreLocation${1}"
}

# List all camps in store
list_camps () {
    printf "%20s %40s \n" "Key" "Location"
    if [ -z "$(ls -A $StoreLocation)" ]
    then
        return
    fi
    for f in "$StoreLocation"/*
    do
        local CampKey=`basename $f`
        local CampLocation=`cat $f`
        printf "%20s %40s \n" $CampKey $CampLocation
    done
}

# Remove camp from store
clear_camp () {
    rm -f "$StoreLocation${1}"
}

# Change directory to camp
go_to_camp () {
    if [ ! -f "$StoreLocation${1}" ]
    then
        fail_and_display_error "No such camp exists"
    fi
    StoredPath=`cat $StoreLocation${1}`
    echo $StoredPath
    cd $StoredPath
}

# Main method
run () {
    initialise
    parse_arguments "$@"
    execute_command "$Command" "$Destination"
}

run "$@"
