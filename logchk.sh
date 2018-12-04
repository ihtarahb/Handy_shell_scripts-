#!/bin/sh
# BL-APR2016 
# Very simple quick listing of below mentioned sas  warnings/errors from the sas log 
# Can add-in more patterns to look up.
#Call : logchk.sh <file.log> to look into specific log file
#Call : logchk.sh *.log for checking all the logs in the directory 
#Call : logchk.sh *.log > filename.txt to route the listings to an external file 
#set -x 
while [ $# -gt 0 ]
do
awk '{if ( index($0,"ERROR") == 1 \
|| index($0,"stopped") > 0 \
|| index($0,"WARNING") == 1 \
|| index($0,"uninitialized") > 0  \
|| index($0,"incomplete") > 0  \
|| index($0,"Format not found") > 0  \
|| index($0,"Missing values were generated") > 0  \
|| index($0,"MERGE statement") > 0  \
|| index($0,"W.D format") > 0  \
|| index($0,"truncated ") > 0  \
|| index($0,"Invalid data for") > 0  \
|| index($0,"values have been converted") > 0  \
|| index($0," 0 observations and ") > 0  \
|| index($0,"outside the axis range") > 0 \
&& index($0,"Errors printed on") == 0 ) \
{printf "%-30s %-80s\n","'$1'",$0}}' $1
shift
done
