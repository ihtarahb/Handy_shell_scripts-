#!/bin/bash 
# BL 08DEC16  rewriting the script.
# BL 25JUL16 script archived becasue of persmission issues  
# BL 16JUN17 script now runs sas & r program from the list of prgms updated in saslist.txt and rlist.txt placed in the code folder.
#            Using the R 3.3.2 version as f_cuminc_dropout.R uses a package that is not validated.
#            Writing status of a program only if it fails. 
# Run the SAS program , and send the status of execution to recipient  
# Using mailx 
#####################################################################################################################
#set -x
#SAS program to check upload dates  
export now="$(date)"
export pnum=704
export pjt=/trials/vaccine/p$pnum/analysis/crons
export open=/trials/vaccine/p$pnum/analysis/dsmb/live/open
export close=/trials/vaccine/p$pnum/analysis/dsmb/live/closed

#Files with the list of programs to run  
export file=saslist.txt
export rfile=rlist.txt

#Depending on the need the hour set the R engine to 3.3.2 or validated 3.2.3 
export valR=/usr/local/apps/R/R-3.2.3-validated/bin/R
export R=/usr/local/apps/bin/R

## Update mailto and ccto with the mail ids "," to whom the updates needs to be sent
export sendto=kashah@scharp.org
#export ccto=blakshmi@scharp.org

## A temporary file to write the status and mail the consolidated status to the receipient
export status=lt_status.txt

## Running Open and closed codes simultanoeously 
codes=($close $open)
#codes=($open)
for foldr in ${codes[@]};do

## Libraries of code & output 
export code=$foldr/code 
export adata=$foldr/adata
export tables=$foldr/tables
export graphs=$foldr/graphs
export report=$foldr/report
export qdata=$foldr/qdata


#Make the file content NULL to start writing status afresh
cat /dev/null>$code/$status

#Change the directory to the code location
#Not necessary as the pgms are called and output are redirected with an absolute path, still doing it just incase within the pgm, developer might have called relative to the current directory.  
cd $code
#################################################
# Run the SAS programs from the sas program list 
#################################################

# Get the number of lines in the text file , which is the number of programs we are going to run 
x=$(cat $code/$file | wc -l)
#echo "Number of programs in $file is: $x"

#Loop while counter is < x +1 
x=$((x+1))

  COUNTER=1
  while [  $COUNTER -lt $x ]; do
      pgm=$(sed -n "${COUNTER}p" "$file")
      ## Mail message Body 
      echo " " >>$code/$status
      #echo "SASCODE: $code/$pgm.sas ">>$code/$status
      #echo "SASLOG: $code/$pgm.log">>$code/$status
      #echo "RUNTIME: $now">>$code/$status
      
      ## Run the SAS program , capture the ERROR CODE and send Mail updates
      /usr/local/apps/bin/sas -sysin $code/$pgm.sas -log $code/$pgm.log  -print $code/$pgm.lst    
    
      ## Capture ERROR code , if successful run the next program if not EXIT 
      ERRCODE=$?
      if [ "$ERRCODE" = "0" ] || [ "$ERRCODE" = "1" ] ; then 
         echo " ">>$code/$status
         #echo "$code/$pgm.sas STATUS:Successful" 
         #echo "STATUS:Successful" >>$code/$status
         #let COUNTER=COUNTER+1

       else
         echo " ">>$code/$status
         echo "SASCODE: $code/$pgm.sas ">>$code/$status
         echo "SASLOG: $code/$pgm.log">>$code/$status
         echo "RUNTIME: $now">>$code/$status
         echo "CRON:weekdays" >>$code/$status
         echo "STATUS:Failed" >>$code/$status
         #cat $code/$status|mailx -s "HVTN$pnum $pgm.sas" -c "$ccto" "$sendto"
         #exit
      fi 
     let COUNTER=COUNTER+1
  #Close the while loop for programs 
  done 

###################################
#Run R programs from the Rlist.txt 
###################################
# Get the number of lines in the text file , which is the number of programs we are going to run 
y=$(cat $code/$rfile | wc -l)
#echo "Number of programs in $rfile is: $y"

##Loop while counter is < x +1 
y=$((y+1))

  COUNTER=1
  while [  $COUNTER -lt $y ]; do
      rpgm=$(sed -n "${COUNTER}p" "$rfile")

      ## Run the R program , capture the ERROR CODE and send Mail updates
       $R CMD BATCH --vanilla $code/$rpgm.R $code/$rpgm.Rout 

      ## Capture ERROR code , if successful run the next program if not EXIT 
      ERRCODE=$?
      if [ "$ERRCODE" = "0" ] ; then
         echo " " >>$code/$status
         #echo " $code/$rpgm.R STATUS:Successful"
         #echo "STATUS:Successful" >>$code/$status
         #let COUNTER=COUNTER+1

       else
         echo " " >>$code/$status
         echo "RCODE: $code/$rpgm.R ">>$code/$status
         echo "RLOG: $code/$rpgm.Rout">>$code/$status
         echo "RUNTIME: $now">>$code/$status
         echo "CRON:weekdays" >>$code/$status
         echo "STATUS:Failed" >>$code/$status
         #cat $code/$status|mailx -s "HVTN$pnum $pgm.sas" -c "$ccto" "$sendto"
         #exit
      fi
     let COUNTER=COUNTER+1
  #Close the while loop for programs 
  done
###########################
## Running pdf merge atlast 
###########################

    /usr/local/apps/bin/sas -sysin $code/pdfmerge.sas -log $code/pdfmerge.log  -print $code/pdfmerge.lst
    ERRCODE=$?
      if [ "$ERRCODE" = "0" ] || [ "$ERRCODE" = "1" ] ; then
         echo " " >>$code/$status
         #echo "$code/pdfmerge.sas STATUS:Successful" 
         #echo "STATUS:Successful" >>$code/$status
         #let COUNTER=COUNTER+1

       else
         echo " " >>$code/$status
         echo "SASCODE: $code/pdfmerge.sas ">>$code/$status
         echo "SASLOG: $code/pdfmerge.log">>$code/$status
         echo "RUNTIME: $now">>$code/$status
         echo "CRON:weekdays" >>$code/$status
         echo "STATUS:Failed" >>$code/$status
         #cat $code/$status|mailx -s "HVTN$pnum $pgm.sas" -c "$ccto" "$sendto"
         #exit
      fi

# Set proper permissions in the folders 
chmod 774 $code/*.log $code/*lst $code/*.Rout $adata/*.* $tables/*.* $graphs/*.* $report/*.* $code/*png $qdata/*.*

echo "All the pgms in $code saslist.txt & rlist.txt has been run.">>$code/$status
echo "Necessary permissions to code,adata,tables & graphs has been set">>$code/$status

#If everything in the above pgm list ran successfully MAIL the run result to the recipients 
#cat $code/$status|mailx -s "HVTN$pnum Live Run: $foldr" -c "$ccto" "$sendto"
rm $code/$status

#Close the for loop for open & closed 
done

exit
