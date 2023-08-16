#! /bin/bash

prop=/home/talentum/zomato_etl_copy/script/script.properties
source $prop

beeline -u jdbc:hive2://localhost:10000/ -n hiveuser -p Hive@123 --hivevar dbname=$dbname --hivevar tablename=$logtablename --hivevar user=$HDFS_LOGS -f $DDL_PATH/createLogTable.hive

exit 0