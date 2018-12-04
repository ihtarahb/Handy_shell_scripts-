#!/bin/bash 
# BL 20MAR15
# Meanit does proc means on the  a SAS dataset with interactive inputs like other procs 
# The first argument is the dataset
echo -n " Enter the dataset name: "
read dataset
echo -n " The arithmatics to compute :" 
read ops 
# The second argument is for setting condition to subset the data
echo -n " Any BY variable (optional) : "
read bye 
# The third  argument is for setting variables to display
echo -n " Any CLASS variable (optional): "
read clas 
echo -n  "Var:  "
read var 

echo " Running proc means on $var "

# Find the dataset file
export pwd=`pwd`
echo $pwd
echo "$dataset.sas7bdat"
if [ -f "$dataset.sas7bdat" ]
then
export sasdir="$pwd"
echo "$dataset.sas7bdat is  found."
else
        echo "Dataset: $dataset.sas7bdat not found. Exiting."
exit 
fi
sas -STDIO  2>/dev/null<<EOF | less

%let dir = $sasdir;
%let dsname = $dataset;
%let srt = $bye ;
%let varz = $var ;
%let clas = $clas ;
%let ops = $ops ;
options nofmterr ;

libname sasdata "&dir." ; 
options nofmterr;

%macro meanit; 

%if &srt. ne   %then %do ;
proc sort data = sasdata.&dsname. out = &dsname. ;
by &srt. ;
run;
%end;
%else %do;
data &dsname. ;
set sasdata.&dsname. ;
run;
%end;

proc means data = &dsname. &ops. ;
%if &srt. ne  %then %do;
BY &srt. ;
%end;

%if &clas. ne  %then %do;
CLASS  &clas.;
%end;

%if &varz. ne  %then %do;
VAR &varz. ;
%end;

run;
%mend meanit;

%meanit;
EOF
