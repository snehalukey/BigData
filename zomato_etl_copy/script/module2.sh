#! /bin/bash

# Author:           Snehal Ukey
# Created Date:     11-05-2023
# Modified Date:    11-05-2023

# Description:      Srcipt to run Module 2

# Usage:            ./module2.sh


prop=/home/talentum/zomato_etl_copy/script/script.properties
source $prop

jobid="id_$(date +"%H%M%S")_module"
jobstep="Module 2"
spark_submit_cmd=""
error=0

echo -e "\n-----------------------------Starting Module 2-----------------------------\n"

start=`date +"%F %H:%M:%S"`
declare filename=log_$(date +%Y%m%d_%H%M%S).log

if [ -d $PROJECT_PATH/tmp/module_2_INPROGRESS ]; then

    echo -e "\nCannot execute, this application is running in some another instance"

    declare filename="log_$(date +%Y%m%d_%H%M%S).log"

    echo -en "$jobid,$jobstep,$spark_submit_cmd,$start,`date +\"%F %H:%M:%S\"`,failure" > $LOG_PATH/$filename

    echo "Status: Failed" | mail --subject="Module 2" snehalpukey123@gmail.com

    exit 1

else

    mkdir -p $PROJECT_PATH/tmp/module_2_INPROGRESS

fi

if [[ $? -eq 0 ]]; then
    echo -e "\n\nStarting Process: Creating Tables $rawtablename and $zomatotablename\n\n"

    /home/talentum/hive/bin/beeline -u jdbc:hive2://localhost:10000/ -n hiveuser -p Hive@123 --hivevar dbname=$dbname --hivevar rawname=$rawtablename --hivevar loc=$HDFS_ZOMATO --hivevar tablename=$zomatotablename -f $DDL_PATH/createZomato.hive
    
    if [[ $? -eq 0 ]]; then
        echo -e "\n\nTables Created Successfully\n\n"
        flag_ddl1=1
    else
        error=1
        echo -en "\n\nTable Creation Failed\n\n"
    fi
fi

if [[ $? -eq 0 ]]; then
    echo -e "\n\nStarting Process: Creating Table $dimtablename\n\n"

    /home/talentum/hive/bin/beeline -u jdbc:hive2://localhost:10000/ -n hiveuser -p Hive@123 --hivevar dbname=$dbname --hivevar dimname=$dimtablename --hivevar loc=$HDFS_DIM -f $DDL_PATH/createCountry.hive
    
    if [[ $? -eq 0 ]]; then
        echo -e "\n\nTable dim_country Created Successfully\n\n"
        flag_ddl2=2
    else
        error=1
        echo -en "\n\nTable Creation Failed\n\n"
    fi
fi

if [[ $flag_ddl1 -eq 1 ]]; then

    echo -e "\n\nStarting Process: Loading Data into $rawtablename\n\n"

    # beeline -u jdbc:hive2://localhost:10000/$dbname -n hiveuser -p Hive@123 --hivevar dbname=$dbname --hivevar rawname=$rawtablename --hivevar path="$CSV_PATH/zomato*.csv" -f $DML_PATH/loadIntoRaw.hive

    /home/talentum/hive/bin/beeline -u jdbc:hive2://localhost:10000/group7 -n hiveuser -p Hive@123 --hivevar dbname="group7" --hivevar rawname="raw_zomato" --hivevar path="/home/talentum/zomato_etl/source/csv/zomato*.csv" -f "/home/talentum/zomato_etl/hive/dml/loadIntoRaw.hive"


    if [[ $? -eq 0 ]]; then
        echo -e "\n\nData Loaded Successfully in $rawtablename\n\n"
    else
        error=1
        echo -en "\n\nData Loading Failed\n\n"
    fi
fi

# if [[ $? -eq 0 ]]; then
#     echo -e "\n\nStarting Process: Copying country_codes.csv from Staging to csv folder\n\n"

#     #cp $STAGING_PATH/country_code.csv $CSV_PATH/
#     tree $CSV_PATH

#     if [[ $? -eq 0 ]]; then
#         echo -e "\n\ncsv file copied successfully\n\n"
#     else
#         error=1
#         echo -en "\n\nCopying Failed\n\n"
#     fi
# fi

if [[ $flag_ddl2 -eq 2 ]]; then

    echo -e "\n\nStarting Process: Loading Data into $dimtablename\n\n"

    /home/talentum/hive/bin/beeline -u jdbc:hive2://localhost:10000/ -n hiveuser -p Hive@123 --hivevar dbname=$dbname --hivevar dimname=$dimtablename --hivevar path=$STAGING_PATH/country_code.csv -f $DML_PATH/dim_country_dml.hive
    # beeline -u jdbc:hive2://localhost:10000/ -n hiveuser -p Hive@123 -f $DML_PATH/dim_country_dml.hive
    
    if [[ $? -eq 0 ]]; then
        echo -e "\n\nData Loaded Successfully in $dimtablename\n\n"
    else
        error=1
        echo -en "\n\nData Loading Failed\n\n"
    fi
fi

if [[ $? -eq 0 ]]; then

    echo -e "\n\nStarting Process: Inserting Data from $rawtablename to $zomatotablename\n\n"

    /home/talentum/hive/bin/beeline -u jdbc:hive2://localhost:10000/ -n hiveuser -p Hive@123 --hivevar dbname=$dbname --hivevar zomatotablename=$zomatotablename --hivevar rawtablename=$rawtablename -f $DML_PATH/rawtozomato.hive

    if [[ $? -eq 0 ]]; then
        echo -e "\n\nData Inserted Successfully from $rawtablename to $zomatotablename\n\n"
    else
        error=1
        echo -en "\n\nData Insertion Failed\n\n"
    fi
fi

echo -e "\nUpdating status of application\n"
rmdir $PROJECT_PATH/tmp/module_2_INPROGRESS
echo -e "\nCan run another command\n"
tree $CSV_PATH

echo -e "\n\nAdding log to log table\n\n"
if [[ $error -eq 0 ]]; then
    echo -en "$jobid,$jobstep,$spark_submit_cmd,$start,`date +\"%F %H:%M:%S\"`,success" > $LOG_PATH/$filename
else
    echo -en "$jobid,$jobstep,$spark_submit_cmd,$start,`date +\"%F %H:%M:%S\"`,failure" > $LOG_PATH/$filename
fi

/home/talentum/hive/bin/beeline -u jdbc:hive2://localhost:10000/ -n hiveuser -p Hive@123 --hivevar tablename=$logtablename --hivevar dbname=$dbname --hivevar filepath=${LOG_PATH}/${filename} -f $DML_PATH/loadIntoLog.hive
echo -e "\n\nLog added to table\n\n"

echo -e "\n-----------------------------Stopping Module 2-----------------------------\n"

exit 0
