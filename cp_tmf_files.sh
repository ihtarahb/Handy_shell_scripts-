#!/bin/bash
#BL JAN2018
#Script to copy files based on the input fname
#set -x
#First parameter is protocol number 
#Second parameter is project folder 
#Using the same script for 703 & 704 

#Script call : cptest.sh 704 2020_11 ( 1st param protocol number , 2nd param dsmb folder name)

#Protocol number
export pnum=$1

#Project folder name like 2018_11,2017_11 , whatever
export prj=$2

#Reading from a CSV file 
export IFS=","

#CSV file with folder information to copy 
export fname="/trials/vaccine/p$pnum/analysis/smb/TMF_copyfile.csv"

#TMF directory name
export tmf=/trials/vaccine/p$pnum/TMF

#The group permission for the copied files
export grpperm=vtnstat

#set -x
#Do loop the records in the csv file 
i=1
while read d1 d2 d3 src fl
do
test $i -eq 1 && ((i=i+1)) && continue
tmfdir=$tmf/$d1/$d2
#Replace the project string with the assigned prj ($2) and pnum with ($1)
tgtdir=$(echo $d3 | sed "s/project/${prj}/g")
srcdir=$(echo $src | sed "s/project/${prj}/g" | sed "s/pnum/${pnum}/g")

#Check if the tmf dir exist 
if [ -d "$tmfdir" ]; then

   #check if project dir in TMF folder , iof not create one 
   if [[ ! -d "$tmfdir/$tgtdir" ]]; then 
   mkdir -p $tmfdir/$tgtdir  
   fi

   #check if the source dir exist 
   if [ -d "$srcdir" ]; then
      echo "Copying $srcdir/* to $tmfdir/$tgtdir"
      #cp -pr  $srcdir/*  $tmfdir/$tgtdir
      rsync -rtp --exclude="archive"  $srcdir/* $tmfdir/$tgtdir
      chgrp -R $grpperm $tmfdir/$tgtdir 
      #chmod -R 444 $tmfdir/$tgtdir 
      echo "Copied!"
   else 
       echo "$srcdir doesnt exist, Check with SRA"
   fi
   
else
   echo "$tmfdir doesnt exist, create the TMF structure or update the control file"
   exit
fi

done < $fname 
