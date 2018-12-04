#!/bin/bash 
# BL 28APR16
# csvit - Exports the SAS dataset from the current location to a CSV file in your desired location 
# The first argument is the dataset
echo -e " See to that you are in the current folder of the dataset you want to convert to csv \n"
echo -n "Enter the dataset name: "
read ds
# The Second  argument for placing you csv file - filepath/filname  
echo -n " Enter the filepath, will create a csv with the dataset name you mentioned above: "
read tgt 
# Find the dataset file in the current directory. Thought giving the option to mention directory is too many Q&A ! 
export pwd=`pwd`
echo $pwd
if [ -f "$ds.sas7bdat" ]
then
export sasdir="$pwd"
echo "$ds.sas7bdat is found.Working to export the $ds into $tgt/$ds.csv"
else
        echo "Dataset: $ds.sas7bdat not found. Exiting."
exit 
fi

sas -STDIO  2>/dev/null <<EOF
%let dir = $sasdir;
%let dsname = $ds;
%let tgt = $tgt ;
options nofmterr ;

libname sasdata "&dir." ;

%macro csvit; 
proc export data =sasdata.&dsname. 
            file = "&tgt./&dsname..csv" 
            dbms = csv
            REPLACE ;
run;

%mend csvit;

%csvit;
EOF

# check to see if the csv file is created or not 
if [ -f "$tgt/$ds.csv" ]
then 
echo " $tgt/$ds.csv is created " 
else 
echo " $tgt/$ds.csv is not created , check your inputs "
exit
fi
