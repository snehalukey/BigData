#! /bin/bash

# Author:           Snehal Ukey
# Created Date:     10-05-2023
# Modified Date:    10-05-2023

# Description:      Drops all Hive tables

# Usage:            ./droptable.sh

source ~/zomato_etl_copy/script/script.properties


beeline -u jdbc:hive2://localhost:10000/ -n hiveuser -p Hive@123 --hivevar dbname=$dbname -f $DDL_PATH/cleanhive.hive