# Handy_shell_scripts-
Quick use bash scripts 

Scripts and Files in the folder:

pb.sh  : Prime - Boost information of a protocol. This data is queried from PDB.

plate.sh : Plate details of a protocol. Intractive script. Fetches plate details from dfschema or qdata depending on the availablility. For RAVE studies u
se raveplate.sh.

logchk.sh : Simple AWK command of SAS error and warning patterns in a saslog . Can add or remove as per convienience .

meanit.sh : Proc means of a sas dataset. Intractive script. Need to be called from the directory where the dataset is present.

content.sh : Proc contents of a sas dataset. Intractive script. Need to be called from the directory where the dataset is present.

printit.sh : Proc print of a sas dataset. Intractive script. Need to be called from the directory where the dataset is present.

csvit.sh : proc export to csv of a sas dataset. Intractive script. Need to be called from the directory where the dataset is present. Need to provide an absolute path for the output csv file when asked.

freqit.sh : Proc freq of a sas dataset. Intractive script. Need to be called from the directory where the dataset is present.

fmt.sh : Opens the format catalog of specic protocols. Works for DNFNET studies. No catalogs for RAVE studies.

pdfmerge.sh : Create a reportlist.txt with all the pdfs you need to combine with full path/filename. Call this script and provide the path of the reportlist.txt file , will combine all the pdf mentioned in that list.  This was a quick basic script to combine all the pdf based on need of that hour. Needs opt
imization.

run_saspgms.sh : To run a series of sas program in a sequence .Need to create a text file with all the sas programs you need to run in succession and enter the project directory and text file information in the script.

raveplate.sh : Pulls the page info from delphi rave_metadata. Similar to plate.sh , but only for studies staged on delphi.

create_tmf_dir.sh : Creates the TMF directory structure as per SOP0079.
