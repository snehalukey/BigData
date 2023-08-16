#! /bin/bash

# Author:           Snehal Ukey
# Created Date:     10-05-2023
# Modified Date:    10-05-2023

# Description:      Unsetting pyspark driver variables in order to suppress Jupyter Notebook.

# Usage:            ./unset.sh

unset PYSPARK_DRIVER_PYTHON
unset PYSPARK_DRIVER_PYTHON_OPTS