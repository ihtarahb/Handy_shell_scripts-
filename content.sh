#!/bin/bash
# BL 22AUG14
# content.sh - prints out the content of the SAS dataset using PROC CONTENTS. C shell :)  
# BL 19OCT15
# Removed echo statements creating temporary sas file in home directory , and using STDIO
# for SAS System to take its input from standard input (stdin) and to write its output to standard output (stdout).  
###################################################################################################################
# The first argument is the dataset
export dataset="$1"
# Confirmt the existence of dataset in the current directory 
export pwd=`pwd`
echo "$dataset.sas7bdat"

if [ -f "$dataset.sas7bdat" ]
then
export sasdir="$pwd"
echo "$dataset.sas7bdat is found."
else
        echo "Dataset: $dataset.sas7bdat not found. Exiting."
exit
fi

sas -STDIO  2>/dev/null <<EOF
x echo -e  "Running proc contents on dataset: $dataset ($sasdir)";
options nofmterr;
libname sasdata '$sasdir' ;
proc contents data =sasdata.$dataset ;
run;
EOF
