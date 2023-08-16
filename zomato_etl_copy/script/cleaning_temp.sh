#! /bin/bash

# Author:           Snehal Ukey
# Created Date:     10-05-2023
# Modified Date:    10-05-2023

# Description:      Cleaning temp folder

# Usage:            ./cleaning_temp.sh


prop=/home/talentum/zomato_etl_copy/script/script.properties
source $prop


echo "Clearing files from temp folder"

# directory path of temp files 
temp=$PROJECT_PATH/tmp

# Check if there are any files in the temp directory
if [ $(ls -A $temp) ];then
    rm -rf "$temp"/*
echo "Cleared"
else 
    echo "No files in temp Folder"

fi 
