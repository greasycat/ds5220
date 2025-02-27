#!/bin/bash

# if an argument is passed use it as the assignment number
if [ $# -eq 1 ]; then
    # check if the argument is a number
    if ! [[ $1 =~ ^[0-9]+$ ]]; then
        echo "Error: Argument is not a number"
        exit 1
    fi

    new_number=$1
    echo "Assignment $new_number will be created"
    new_folder="assignment$new_number"
else
    # find all the folders in the current directory start with "assignment"
    folders=$(find . -maxdepth 1 -type d -name "assignment*")

    # sort the folders by name
    sorted_folders=$(echo "$folders" | sort)

    # get the last folder name
    last_folder=$(echo "$sorted_folders" | tail -n 1)

    # get the number from the last folder name
    last_number=$(echo "$last_folder" | grep -o '[0-9]*$')
    # increment the number by 1
    new_number=$((last_number + 1))

    echo "Assignment $new_number will be created"

    # create the new folder
    new_folder="assignment$new_number"

    mkdir "$new_folder"

    # end if
fi

# create src subfolder
mkdir -p "$new_folder/src"

# check if main.tex exists
if [ -f "main.tex" ]; then
    touch "$new_folder/main.tex"
fi