#! /bin/bash

# Author:           Group 7
# Created Date:     05-05-2023
# Modified Date:    09-05-2023

# Description:      Creates the directory tree in hdfs for the project.

# Usage:            ./dirtree.sh

# Prerequisites:    Need hdfs and yarn running on the machine.
#                   Create a new staging area where you need to put all the json files
#                   and other data that you want to put.
#                   Need a BigDataProject directory in your home of linux where the 
#                   directory structure exists. The files will be loaded in this script.
#                   
#                   
#                   

updater=0

echo "Checking for running services"
if [[ $(jps | grep -wi namenode) && $(jps | grep -wi nodemanager) ]]; then
    echo "Services Found: Found Hadoop services running."
    exit 0
    if [[ $? -eq 0 ]];then 
        echo "Creating HDFS directory structure required for the project."
        hdfs dfs -mkdir -p /user/$USER/zomato_etl_$USER/{log,zomato_ext/{zomato,dim_country}}
        hdfs dfs -ls -R /user/$USER/zomato_etl_$USER
        if [[ $? -eq 0 ]]; then
            echo "Created the required directory structure in HDFS."
        else
            echo "Directory structure already exists."
        fi
        exit 0
    else
        updater=updater+1
        echo "Error count ${updater}: Could not create directory structure."
        exit 1
    fi
else
    updater=updater+1
    echo "Error count ${updater}:"
    echo "Services Not Found: Please start all the services as specified in prerequisite."
    exit 1
fi

# if [[ $? -eq 0 ]];then
#     echo "Creating HDFS directory structure required for the project."
#     hdfs dfs -mkdir -p /user/$USER/zomato_etl_$USER/{log,zomato_ext/{zomato,dim_country}}
#     echo "Created the required directory structure in HDFS."
#     exit 0
# else
#     updater=updater+1
#     echo "Error count ${updater}:"
#     echo "Previous command did not run properly. Start the required services."
#     exit 1
# fi