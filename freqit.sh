#!/bin/bash 
# BL 22AUG14
# BL 07OCT16 , updated the handling of special characters in the cross tables detail capture
# FREQ - prints out the FREQUENCY of a variable from a SASdataset using PROC FREQ in an interactive mode
# The first argument is the dataset
#set -x
echo -e "Make sure you are calling this script in the current directory where the dataset is present \n"
echo -n " proc freq data =  "
read dataset
# The second argument is for setting condition to subset the data
echo -n  "tables"
read tab
# The third option is for WHERE statement incase there is a filter condition 
echo -n " Any WHERE clause in mind ? "
read whr

#The * wasnt being read as string , it was misinterpreted as a unix command 
tables=$(echo "${tab}" | sed 's,*,\*\ ,g')

# confirm the existence of  dataset in the current directory
export pwd=`pwd`
echo $pwd
echo "$dataset.sas7bdat"
if [ -f "$dataset.sas7bdat" ]
then
export sasdir="$pwd"
#echo "$dataset.sas7bdat is found."
else
        echo "Dataset: $dataset.sas7bdat not found. Exiting."
exit
fi

sas -STDIO  2>/dev/null<<EOF | less
%let dir = $sasdir;
%let dsname = $dataset;
%let cnd = $whr ;
%let varz = $tables ;
options nofmterr ;

libname sasdata "&dir." ;

%put _user_;
%macro freqit; 
proc freq data =sasdata.&dsname. ;
%if &cnd. ne   %then %do ; 
where &cnd. ; 
%end;
%if "&varz." ne " "  %then %do ;
tables &varz. ; 
%end;
run;
%mend freqit;

%freqit;
EOF
