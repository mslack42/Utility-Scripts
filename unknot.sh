#!/bin/bash
###################################################
#                                                 #
#   unknot.sh - For untangling log files with     #
#               many sources                      #
#                                                 #
#   Created by mslack42, 16/12/2021               #
#                                                 #
###################################################
filename=""
outputDir="./unknotted"
idRegex="^\[([0-9A-Za-z\-_ ]+)\]"

# Display error and script usage
fail_and_display_error () {
    echo "$1"
    echo ""
    display_usage
    kill -INT $$
}

# Display script usage
display_usage () {
    echo "Usage: unknot.sh [logsfile] [?identifierRegex]"
    echo ""
    echo "If identifierRegex isn't provided, a default regex is used."
    echo "A directory ./unknotted will be produced containing split-out logs files."
    echo "      - File name = Regex match"
    echo "      - Contents  = The matching lines (in their original order)"
}

# Create output directory if needed
initialise () {
    if [ ! -d "$outputDir" ]
    then
        mkdir "$outputDir"
    fi
}

# Parse command-line arguments to variables
parse_arguments () {
    if [ "$#" -gt 2 ] || [ "$#" -eq 0 ]
    then
        fail_and_display_error "Wrong number of arguments supplied"
    fi
    filename="$1"
    if [ ! -z "$2" ]
    then 
        idRegex="$2"
    fi
}

# Read input file and extract output files
read_knot () {
    while read -r line; do
        idMatch=$(echo "$line" | egrep -oh "$idRegex")
        if [ ! -z "$idMatch" ]
        then
            write_unknot "$line" "$idMatch"
        fi
    done < "$1"
}

# Write line to correct output file
write_unknot () {
    if [ ! -f "$outputDir/$2.log" ]
    then
        touch "$outputDir/$2.log"
    fi
    echo "$1" >> "$outputDir/$2.log"
}

# Main method
run () {
    initialise
    parse_arguments "$@"
    read_knot "$filename"
}

run "$@"
