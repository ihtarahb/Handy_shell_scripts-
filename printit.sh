#!/bin/bash 
# BL 22AUG14
# printit - prints out all or part of a SAS dataset using PROC PRINT in an interactive mode
# Note : It will lookup datasets from the current directory, i.e where ever you are calling this script 
# The first argument is the dataset
echo -e "\n"
echo -e "Make sure you are calling this script in the current directory where the dataset is present \n" 
echo -n " Enter the dataset name: "
read dataset
# The second argument for setting condition to subset the data
echo -n " Enter the subset condition: "
read condition
# The third  argument for setting variables to display
echo -n " Enter the variables to be displayed : "
read vars
echo " the variables are : $vars"
# Find the dataset file in the current directory. Thought giving the option to mention directory is too many Q&A ! 
export pwd=`pwd`
echo $pwd
if [ -f "$dataset.sas7bdat" ]
then
export sasdir="$pwd"
echo "$dataset.sas7bdat is  found."
else
        echo "Dataset: $dataset.sas7bdat not found. Exiting."
exit 
fi

set -x;

sas -STDIO  2>/dev/null<<EOF | less
%let dir = $sasdir;
%let dsname = $dataset;
%let cnd = $condition ;
%let varz = $vars ;
options nofmterr ;

libname sasdata "&dir." ;

%put _user_;
%macro printit; 
proc print data =sasdata.&dsname. ;
%if &cnd. ne   %then %do ; 
where &cnd. ; 
%end;
%if &varz. ne   %then %do ;
VAR &varz. ; 
%end;
run;
%mend printit;

%printit;
EOF
