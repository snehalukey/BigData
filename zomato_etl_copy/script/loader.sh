#! /bin/bash

# Author:           Snehal Ukey
# Created Date:     08-05-2023
# Modified Date:    09-05-2023

# Description:      Load data from staging to project site.

# Usage:            ./loader.sh

# Prerequisite:     Directory Structure in local file system should exist.

prop=/home/talentum/zomato_etl_copy/script/script.properties
source $prop

echo -n ""
if [[ $? -eq 0 ]]; then
    echo "Loading data from staging to source folder for transformation."
    cp -r ~/zomato_raw_files/file{1,2,3}.json $JSON_PATH
    if [ $? -eq 0 ]; then
        echo "Data is Loaded see here:"
        tree $JSON_PATH
        exit 0
    else
        echo "Data is not Loaded"
        exit 1
    fi
fi