#!/bin/bash
# BL MAy2017 
# Quick script to combine all the pdfs in reportlist.txt
# Script for combining the files present in the report directory based on reportlist.txt 
#set -x
## Make sure you create reportlist.txt before you execute this script ##
## Get report directory path ##
echo -n "Enter the full directory path where the pdfs & reportlist.txt are present:"
read rptdir 

## Get the output file name ##
echo -n "Concatenated Output report name:"
read oprpt 

## Change to that directoru and combine the files in reportlist.txt using pdftk ##
cd $rptdir

if [ ! -f reportlist.txt ]; then
   echo "$rptdir/reportlist.txt not available, Please create the text file with the files you want to combine then execute this script"
   exit

else 
 
pdftk  $(xargs < reportlist.txt) cat output $oprpt.pdf

      if [ -f "$oprpt.pdf" ]; then
         echo "Files are combined in $rptdir/$oprpt.pdf"
       else 
         echo "$rptdir/$oprpt.pdf creation unsuccessful"
      exit
      fi
fi
