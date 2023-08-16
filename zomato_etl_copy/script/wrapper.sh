#!/bin/bash

# Author:           Snehal Ukey
# Created:          08th May 2023
# Last Modified:    10th May 2023

# Prerequisites:
# 1) Hadoop services are running
# 2) Your home folder is there on HDFS, Hive warehouse is set on hdfs to /user/hive/warehouse
# 3) Hive metastore and Hiveserver2 services are running
# 4) A setup.sh run successfully (if applicable)

# Description:
# This script is the staring point of the project workflow
# 
# Reference - Project SRS doc

# Usage: 
# 1) ./wrapper.sh - Invokes all modules sequentially

#variable "prop" containing the path of the properties file. 
prop=/home/talentum/zomato_etl_copy/script/script.properties             
source $prop

# bash $SCRIPT_PATH/setup.sh

# bash $SCRIPT_PATH/module1.sh

# bash $SCRIPT_PATH/module2.sh

bash $SCRIPT_PATH/setup.sh
if [ $? -eq 0 ]; then
   bash $SCRIPT_PATH/module1.sh

   if [ $? -eq 0 ]; then
      bash $SCRIPT_PATH/module2.sh

      if [ $? -eq 0 ]; then
         echo "Success at `date +%F_%T`"
         exit 0
      else
         echo "Failed at 2nd Module at this time-stamp `date +%F_%T`"
      fi
   else
      echo "Failed at 1st Module at this time-stamp `date +%F_%T`"
   fi
else
   echo "Failed at Setup at this time-stamp `date +%F_%T`"
fi