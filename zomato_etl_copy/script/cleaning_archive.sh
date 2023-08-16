#! /bin/bash

# Author:           Snehal Ukey
# Created Date:     10-05-2023
# Modified Date:    10-05-2023

# Description:      Cleaning Archive folder

# Usage:            ./cleaning_archive.sh

prop=/home/talentum/zomato_etl_copy/script/script.properties
source $prop

echo "Clearing json files from Archive"
# directory path of archieved files 

# Check if there are any files in the archive directory
if [[ $(ls $ARCHIVE_PATH) ]];then
    rm -rf $ARCHIVE_PATH/*
    echo "Cleared"
else 
    echo "No files in Archive Folder"
fi
exit 0