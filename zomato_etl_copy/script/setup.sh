#! /bin/bash

# Author:           Snehal Ukey
# Created Date:     10-05-2023
# Modified Date:    10-05-2023

# Description:
# This script sets up the project environment, this includes
# 	1) Dropping all the project related Hive tables if exists
# 	2) Setting up HDFS file system paths for zomato_etl project 
#   3) Copy json files from ~/proj_zomato/zomato_raw_files/file{1..3}.json to ~/proj_zomato/zomato_etl/source/json
#   4) Deleting files achieved into ~/proj_zomato/zomato_etl/archieve
#   5) Deleting ~/proj_zomato/zomato_etl/temp/_INPROGRESS folder if exists, which abstracts the running  instance of an application. Else create the one.

# Reference:        Project SRS doc

# Usage:            ./setup.sh

source ~/zomato_etl_copy/script/script.properties

echo -e "\nStarting Setup\n"

echo -e '\nCleaning Archieve\n'
bash $SCRIPT_PATH/cleaning_archive.sh
echo -e '\nArchive has been Cleaned\n'

echo -e '\nCleaning Temp\n'
bash $SCRIPT_PATH/cleaning_temp.sh
echo -e '\nTemp has been Cleaned\n'

echo -e '\nCleaning source/csv\n'
bash $SCRIPT_PATH/cleansourcecsv.sh
echo -e '\nCleaned source/csv\n'

echo -e '\nDropping Tables\n'
bash $SCRIPT_PATH/droptable.sh
echo -e '\nTables Dropped\n'

echo -e '\nCreating a Directory Structure for the Project\n'
bash $SCRIPT_PATH/dirtree.sh
echo -e '\nDirectory Structure Created\n'

echo -e "creating log table"
bash $SCRIPT_PATH/log_table_creation.sh
echo -e "log table created"

echo -e '\nLoading Data From Staging To Source\n'
bash $SCRIPT_PATH/loader.sh

if [ $? -eq 0 ]; then
    echo -e '\nData Has Been Loaded Successfully\n'
    echo -e "\nSetup Completed Successfully\n"
    exit 0
else
    echo -e "\nSetup Incomplete\n"
    exit 1
fi
# echo -e '\nClearing hdfs directory structure\n'
# hdfs dfs -rm -r -f /user/$USER/zomato_etl_$USER
# echo -e '\nCleared diectory structure\n'
