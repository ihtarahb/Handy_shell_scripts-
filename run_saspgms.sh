# BL JAN2018
#!/bin/bash
###
# Running all the codes in sequence from a external text file with list of pgms with absolute path  
# The consecutive code is run only when the previous one finishes fine. If not it notifies about the failure and stops. 
###
# Procedure 
# 1. Create a text file with list of programs you want to run in sequence. 
# 2. Please make sure you mention the full absolute path of the program. It can be sas programs from different directory.
# 3. Mention the path of the text file in "pjt" below
# 4. Mention the file name in "file" below
# 5. Run the script 
# 6. You can uncomment "set -x" if you need to see every execution step 

#set -x
export pjt=<Dir where the external text file list is placed>
export file=<list file name.txt>

#Depending on the type of SAS engine you need to use mention $sas or $sasu8 below 
export sas=/usr/local/apps/bin/sas
export sasu8=/usr/local/sas-9.4/SASFoundation/9.4/bin/sas_u8

# Get the number of lines in the text file , which is the number of programs we are going to run 
x=$(cat $pjt/$file | wc -l)
echo "Number of programs in $file is: $x"

#Loop while counter is < x +1 
x=$((x+1))

COUNTER=1
  while [  $COUNTER -lt $x ]; do
      pgmpath=$(sed -n "${COUNTER}p" "$pjt/$file")
      pgmdir=`dirname "$pgmpath"`
      #Need filename without the extention so not using basepath
      saspgm=`basename "$pgmpath"`
      pgm="${saspgm%.*}"

      #Change directory to run code in that directory
      cd $pgmdir

      echo "Running $pgmdir/$pgm.sas"
      echo " "
      #Run the SAS program 
      $sas -sysin $pgmdir/$pgm.sas -log $pgmdir/$pgm.log  -print $pgmdir/$pgm.lst

      ## Capture ERROR code , if successful run the next program if not EXIT
      ERRCODE=$?
      if [ "$ERRCODE" = "0" ] || [ "$ERRCODE" = "1" ] ; then
      echo "$pgmdir/$pgm.sas ran successfully"
      echo " "
      else
      echo "Stopped. $pgmdir/$pgm.sas failed, please check $pgmdir/$pgm.log and re-run the script" 
      exit
      fi
  let COUNTER=COUNTER+1
#Close the while loop for programs 
done
