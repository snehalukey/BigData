#! /bin/bash

# Author:           Snehal Ukey
# Created Date:     09-05-2023
# Modified Date:    09-05-2023

# Description:      run the first module of project

# Usage:            ./module1.sh

# Prerequisites:
# 1) Hadoop services are running
# 2) Your home folder is there on HDFS, Hive ware house is set on hdfs to /user/hive/warehouse
# 3) Hive metastore and Hiveserver2 services are running
# 4) A setLocalPath.sh runs successfully
# 5) A setupEnv.sh runs successfully


prop=/home/talentum/zomato_etl_copy/script/script.properties
source $prop


jobid="id_$(date +"%H%M%S")_module"
jobstep="Module 1"
spark_submit_cmd="spark-submit --master yarn --deploy-mode cluster --driver-memory 2g --num-executors 2 --executor-memory 1g $PROJECT_PATH/spark/py/spark_final_ver.py"
flag=true

echo -e "\n-----------------------------Starting Module 1-----------------------------\n"
start=`date +"%F %H:%M:%S"`
if [ -d $PROJECT_PATH/tmp/module_1_INPROGRESS ]; then
    echo -e "\nCannot execute, this application is running in some another instance"
    declare filename="log_$(date +%Y%m%d_%H%M%S).log"
    echo -en "$jobid,$jobstep,$spark_submit_cmd,$start,`date +\"%F %H:%M:%S\"`,failure" > $LOG_PATH/$filename
    echo "Status: Failed" | mail --subject="Module 1" snehalpukey123@gmail.com
    exit 1
else
    mkdir -p $PROJECT_PATH/tmp/module_1_INPROGRESS
fi

if [[ $? -eq 0 ]]; then
    echo -e "\nStarting Process: Running spark application.\n"
    echo -e "\nStarting JSON to CSV conversion\n"
    declare filename=log_$(date +%Y%m%d_%H%M%S).log 
    source $SCRIPT_PATH/unset.sh
    $spark_submit_cmd
    if [[ $? -eq 0 ]]; then
        echo -e "\nSpark script completed without error\n"
        echo -en "$jobid,$jobstep,$spark_submit_cmd,$start,`date +\"%F %H:%M:%S\"`,success" > $LOG_PATH/$filename        
        echo -e "\nUpdating status of application\n"
        rmdir $PROJECT_PATH/tmp/module_1_INPROGRESS
        echo -e "\nCan run another command\n"
        tree $CSV_PATH
        echo -e "\ntaking backup\n"
        mv $JSON_PATH/* $ARCHIVE_PATH/
    else
        echo -en "\n\nSpark job failed\n\n"
        echo -en "$jobid,$jobstep,$spark_submit_cmd,$start,`date +\"%F %H:%M:%S\"`,failure" > $LOG_PATH/$filename
        echo "Status: Failed" | mail --subject="Module 1" snehalpukey123@gmail.com
        flag=false
        echo -e "\nUpdating status of application\n"
        rmdir $PROJECT_PATH/tmp/module_1_INPROGRESS
        echo -e "\nCan run another command\n"
        echo -e "\nSpark Command Failed: Backup could not be done.\n"
        tree $CSV_PATH
    fi
fi

echo -e "\n\nAdding log to log table\n\n"
/home/talentum/hive/bin/beeline -u jdbc:hive2://localhost:10000/ -n hiveuser -p Hive@123 --hivevar tablename=$logtablename --hivevar dbname=$dbname --hivevar filepath=${LOG_PATH}/${filename} -f $DML_PATH/loadIntoLog.hive
echo -e "\n\nLog added to table\n\n"

echo "-----------------------------Stoping Module 1-----------------------------"

if [ flag ]; then
    exit 0
else
    exit 1
fi