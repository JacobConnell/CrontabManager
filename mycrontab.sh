#!/bin/bash

showLogo()
{
	figlet "MyCrontab" #Uses a 3rd-Party module to produce fancy graphics.
}

convertText()
# This function takes the values passed in 
# parts from the CronTab file and attempts 
# to filter the syntax into redable english.
# github.com/inthuriel/human-cron was referenced
# to learn about the methodology of breaking the
# syntax into usable chunks. While the majority
# of the script was irrelivant, the RegEx expressions
# were enlightlending at the start of the project. 
{

			
			MIN=$1
			HR=$2
			DOM=$3
			MON=$4
			DOW=$5
			DATE_str=""
					#Code for Hour Conversion
					if [[ $HR =~ ^\*\/[0-9]{1,2}$ ]]; then #Any hour being */4  
						NUM_HR=`echo "$HR" |cut -d"/" -f2`; #Slices the string and takes the second part
						HR_str="Every $NUM_HR Hours,"; #Sets string
					elif [[ $HR =~ ^[0-9]{1,2}$ ]]; then #Any basic hour integer
						HR_str="On Hour $HR," #Sets string
					elif [[ $HR =~ ^(\*\/[0-9]{1,2},)+(\*\/[0-9]{1,2})$ ]]; then
						HR_str="Every $HR Hours,"
					elif [[ $HR =~ ^[0-9]{1,2}-[0-9]{1,2}$ ]]; then #Any range of hours. 
						HR_str="Between Hours $HR," #Sets string
					elif [[ $HR =~ ^([0-9]{1,2},)+[0-9]{1,2}$ ]]; then #Any list of values 
						HR_str="On Hours $HR," #Sets string
					elif [[ $HR =~ ^[0-9]{1,2}-[0-9]{1,2}\/[0-9]{1,2}$ ]]; then #Any range with an interval marker
						HR_RANGE=`echo "$HR" |cut -d"/" -f1`; #Splits first part to take the range
						NUM_HR=`echo "$HR" |cut -d"/" -f2`; #Splits Second Part to take the interval
						HR_str="Between Hours $HR_RANGE Every $NUM_HR Hours,"
					else 
						HR_str="Every Hour" #Otherwise, there is no hour definition to provide
					
					fi;
					#Same as above, just for Minutes
					if [[ $MIN =~ ^(\*\/[0-9]{1,2})$ ]]; then
						NUM_MIN=`echo "$MIN" |cut -d"/" -f2`
						MIN_str="Every $NUM_MIN Minutes,"
					elif [[ $MIN =~ ^[0-9]{1,2}$ ]]; then				
						MIN_str="In Minute $MIN," 
					elif [[ $MIN =~ ^(\*\/[0-9]{1,2},)+(\*\/[0-9]{1,2})$ ]]; then
						MIN_str="Every $MIN Minutes,"
					elif [[ $MIN =~ ^([0-9]{1,2},)+[0-9]{1,2}$ ]]; then #Any list of values 
						MIN_str="On Minutes $HR," #Sets string
					elif [[ $MIN =~ ^[0-9]{1,2}-[0-9]{1,2}$ ]]; then
						MIN_str="Between $MIN Minutes,"
					elif [[ $MIN =~ ^([0-9],)?[0-9]{1,2}-[0-9]{1,2}\/[0-9]{1,2}$ ]]; then
						NUM_MIN=`echo "$MIN" |cut -d"/" -f2`;
						MIN_RANGE=`echo "$MIN" |cut -d"/" -f1`;
						MIN_str="Between $MIN_RANGE Minutes, Every $NUM_MIN Minutes,"
					else 
						MIN_str="Every Minute"
					fi;
					#Same as above, just for Day of the Month					
					if [[ $DOM =~ ^\*\/[0-9]{1,2}$ ]]; then
						NUM_DOM=`echo "$DOM" |cut -d"/" -f2`
						MON_D_str="Every $NUM_DOM Days,"
					elif [[ $DOM =~ ^[0-9]{1,2}$ ]]; then
						MON_D_str="Day of Month: $DOM"
					elif [[ $DOM =~ ^(\*\/[0-9]{1,2},)+(\*\/[0-9]{1,2})$ ]]; then
						MON_D_str="Every $DOM Days of Month,"
					elif [[ $DOM =~ ^([0-9]{1,2},)+[0-9]{1,2}$ ]]; then #Any list of values 
						MON_D_str="On Days of Month $DOM," #Sets string
					elif [[ $DOM =~ ^[0-9]{1,2}-[0-9]{1,2}$ ]]; then
						MON_D_str="Between Days $DOM of the Month," 						
					elif [[ $DOM =~ ^[0-9]{1,2}-[0-9]{1,2}\/[0-9]{1,2}$ ]]; then
						NUM_DOM=`echo "$DOM" |cut -d"/" -f2`;
						DOM_RANGE=`echo "$DOM" |cut -d"/" -f1`;
						MON_D_str="Between Days $DOM_RANGE of the Month, Every $NUM_DOM Days,"				
					else
						MON_D_str=""
					fi;
					#Same as above, just for Months
					if [[ ! $MON =~ ^\*$ ]]; then
						if [[ $MON =~ ^\*\/[0-9]{1,2}$ ]]; then
							NUM_MON=`echo "$MON" |cut -d"/" -f2`
							MON_str="Every $NUM_MON Months,"
						elif [[ $MON =~ ^[0-9]{1,2}$ ]]; then
							MON_str="Month: $MON,"
						elif [[ $MON =~ ^(\*\/[0-9]{1,2},)+(\*\/[0-9]{1,2})$ ]]; then
							MON_str="Every $MON Months,"
						elif [[ $MON =~ ^([0-9]{1,2},)+[0-9]{1,2}$ ]]; then #Any list of values 
							MON_str="On Hours $MON," #Sets string
						elif [[ $MON =~ ^[0-9]{1,2}-[0-9]{1,2}$ ]]; then
							MON_str="Between Months $MON,"	
						elif [[ $MON =~ ^[0-9]{1,2}-[0-9]{1,2}\/[0-9]{1,2}$ ]]; then
							NUM_MON=`echo "$MON" |cut -d"/" -f2`;
							MON_RANGE=`echo "$MON" |cut -d"/" -f1`;
							MON_str="Between Months $MON_RANGE, Every $NUM_MON Months,"
						fi;						
					else
						MON_str=""
					fi;			
					#Same as above, just for Day of the Week
					if [[ $DOW =~ ^\*\/[0-9]{1,2}$ ]]; then
							NUM_WEEK=`echo "$DOW" |cut -d"/" -f2`
							WEK_str="Every $NUM_WEEK Days of the Week,"
						elif [[ $DOW =~ ^[0-9]{1,2}$ ]]; then
							WEK_str="Day of Week $DOW,"
						elif [[ $DOW =~ ^[0-9]{1,2}-[0-9]{1,2}$ ]]; then
							WEK_str="Between $DOW Days of the Week,"
						elif [[ $DOW =~ ^(\*\/[0-9]{1,2},)+(\*\/[0-9]{1,2})$ ]]; then
							WEK_str="Every $DOW Days of the week,"
						elif [[ $DOW =~ ^([0-9]{1,2},)+[0-9]{1,2}$ ]]; then #Any list of values 
							WEK_str="On Hours $DOW," #Sets string	
						elif [[ $DOW =~ ^[0-9]{1,2}-[0-9]{1,2}\/[0-9]{1,2}$ ]]; then
							DOW_RANGE=`echo "$DOW" |cut -d"/" -f1`;
							NUM_DOW=`echo "$DOW" |cut -d"/" -f2`;
							WEK_str="Between Days $DOW_RANGE, Every $NUM_DOW Days of the Week,"
						elif [[ $DOW =~ ^[0-9]{1,2}-[0-9]{1,2},.+$ ]]; then
							DOW_EXTRA=`echo "$DOW" |cut -d"," -f2`;
							DOW_RANGE=`echo "$DOW" |cut -d"," -f1`;
							WEK_str="Between Days $DOW_RANGE, inc. $DOW_EXTRA"
						else
							WEK_str=""
					fi
			
				DATE_str="$WEK_str $MON_str $MON_D_str" #Comibines the parts into one string
				if [[ $DATE_str = "  " ]]; then #If the string is blank, then the script will run Daily
					DATE_str="Daily"
				fi;	
				if [[ $MIN =~ ^@.+$ ]]; then
					echo "-+ Period -- $1"
				else 
					echo "-+ Period --  $HR_str $MIN_str $DATE_str" #Outputs the period to the user in plain English.
				fi
}

displayJobs()
# This function reads in the crontab file,
# putting it through a pipe to then output
# the details to the user in plain English
# with assistance from the function above.

{
echo ""
echo "These are your current jobs: "
echo " "
counter=0 #Keeps tabs on the Job number. 
crontab -l | grep "^[^#;]" | while read -r line ; #Reads each line that does not contain a #
do
	let counter++ #Increments the Job number
	echo "-+ Job -- $counter" #Outputs Job number
	declare -a CurrentLine #Declares a blank array

	IFS=' ' read -r -a CurrentLine <<< "$line" #Converts the line into a segmented Array
	convertText "${CurrentLine[0]}" "${CurrentLine[1]}" "${CurrentLine[2]}" "${CurrentLine[3]}" "${CurrentLine[4]}" #Converted time syntax into plain English
	
	if [[ ${CurrentLine[0]} =~ ^@.+$ ]]; then
	echo "-+ Command -- ${CurrentLine[@]:1:100}"
	else
	echo "-+ Command -- ${CurrentLine[@]:5:100}" #Outputs Crontab Command
	fi
	echo ""
	echo ""
done
}


addLine()
# This function adds a line
# to the temp crontab file.
{
	Line=$1	
        printf '%s\n' "$Line" >>crontab.tmp #Prints to file.
}

removeJob()
# This function allows removal
# of a job by outputing the jobs.
# The users then selects a job
# to remove.
{
echo ""
echo "These are your current jobs: "
echo " "
counter=0 #Starts job counter
crontab -l | grep "^[^#;]" | while read -r line ; #Reads each line that does not contain a #
do
	let counter++ #Increments job number
	echo "-+ Job -- $counter" 
	declare -a CurrentLine #Delares and empty Array

	IFS=' ' read -r -a CurrentLine <<< "$line" #Populates Array with line in segments
	convertText "${CurrentLine[0]}" "${CurrentLine[1]}" "${CurrentLine[2]}" "${CurrentLine[3]}" "${CurrentLine[4]}" #Sends time data to be converted into Enlgish.
	echo "-+ Command -- ${CurrentLine[@]:5:100}" #Outptus command
	echo ""
	echo ""
done
    unset job_to_remove
    while [[ ! ${job_to_remove} =~ ^([1-9]|1[0-9]|2[0-9]|10)$ ]]; do #Validates user input to whole number
        echo "Please enter the number of the job you would like to remove:"
        read job_to_remove #Reads users number to be inputted. 
    done
rm -f crontab.tmp #Clears any old temp file
touch crontab.tmp #Creates a new temp file
crontab -l | grep "^[^#;]" | while read -r line ; #Reads each line of crontab into loop
do
	let counter++
	if [[ $counter != $job_to_remove ]]; then #If not the job to remove
	addLine "$line"; # then it can be appended to the temp file. 
	fi;
done
crontab crontab.tmp && rm -f crontab.tmp #crontab temp is then imported into the file
displayJobs #Outputs the left over jobs to the file
}

removeAllJobs()
# This function removes all jobs
# very simply by replacing the
# entire crontab file. 
{
rm -f crontab.tmp # Clear Temp
touch crontab.tmp # Creates Temp
crontab crontab.tmp # Replace Actual with Temp
rm -f crontab.tmp # Clear Temp
echo "All Crontab Job's have been removed."
}

addJob()
# This function adds a job to the crontab file.
# The task of which is quite simple, however the 
# act of validation was hard. Reference to RegEx
# statements on stackoverflow.com/questions/14203122
# gaves us a starting idea of how to create these complex
# expressions. 

{
get_approval=0 #Sets loop for flat

while [[ ! ${get_approval} = 1 ]]; do # This script will loop until the user is happy with the job to create. 

#Clears user input memory holds
get_min=NULL
get_hour=NULL
get_month=NULL
get_daymonth=NULL
get_dayweek=NULL  
get_command=NULL

	while [[ ! ${get_min} =~ ^(\*+(\/+([1-5]([0-9])?)))|(([1-5]([0-9])?),)+([1-5]([0-9])?)|(([1-5]([0-9])?)+(-)+([1-5]([0-9])?),)+(([1-5]([0-9])?)(-)+([1-5]([0-9])?))|(([1-5]([0-9])?)+(\/|-)([1-5]([0-9])?)+((\/)+([1-5]([0-9])?))?)|([1-5]([0-9])?)|\*$ ]]; do #Validates user input to crontab syntax for minute
		echo "
Which Minute would you like you job to run?

Enter in one of the formats below:
	'*' for every minute.
	'x' for a specific minute(x).
	'x, y, z' to list specific minutes (x, y, z).
	'x-y' for a specific range (from minute x to minute y).
	'x-y, z-n' to list specific ranges (from x to y and from z to n).
	'*/x' every given (x) minutes.
	
Which minute would you like the job to run on? (1-12)"
		read get_min #Reads user input
	    done


	while [[ ! ${get_hour} =~ ^(\*+(\/+([2][0-3]|([1])?([0-9]))))|(([2][0-3]|([1])?([0-9])),)+([2][0-3]|([1])?([0-9]))+|(([2][0-3]|([1])?([0-9]))+(-)+([2][0-3]|([1])?([0-9]))+,)+(([2][0-3]|([1])?([0-9]))+(-)+([2][0-3]|([1])?([0-9]))+)|(([2][0-3]|([1])?([0-9]))+(\/|-)([2][0-3]|([1])?([0-9]))+((\/|-)([2][0-3]|([1])?([0-9]))?))|([2][0-3]|([1])?([0-9]))|\*$ ]]; do #Validates user input to crontab syntax for hours
		echo "
Which Hour would you like you job to run?

Enter in one of the formats below:
	'*' for every hour.
	'x' for a specific hours(x).
	'x, y, z' to list specific hours (x, y, z).
	'x-y' for a specific range (from hour x to hour y).
	'x-y, z-n' to list specific ranges (from x to y and from z to n).
	'*/x' every given (x) hours.
	
Which Hour would you like the job to run on? (1-12)"
		read get_hour
	    done



	while [[ ! ${get_month} =~ ^(\*+(\/+([1][1-2]|[1-9])))|(([1][1-2]|[1-9]),)+([1][1-2]|[1-9])+|(([1][1-2]|[1-9])+(-)+([1][1-2]|[1-9])+,)+([1][1-2]|[1-9])+(-)+(([1][1-2]|[1-9])+)|(([1][1-2]|[1-9])+(\/|-)([1][1-2]|[1-9])+((\/|-)([1][1-2]|[1-9])?))|([1][1-2]|[1-9])|\*$ ]]; do #Validates user input to crontab syntax for month
		echo "
Which Month would you like you job to run?

Enter in one of the formats below:
	'*' for every month.
	'x' for a specific month(x).
	'x, y, z' to list specific months (x, y, z).
	'x-y' for a specific range (from month x to month y).
	'x-y, z-n' to list specific ranges (from x to y and from z to n).
	'*/x' every given (x) months.
	
Which Month would you like the job to run on? (1-12)"
		read get_month
	    done


	while [[ ! ${get_daymonth} =~ ^(\*+(\/+([3][0-1]|([1-2])?([0-9]))))|(([3][0-1]|([1-2])?([0-9])),)+([3][0-1]|([1-2])?([0-9]))+|(([3][0-1]|([1-2])?([0-9]))+(-)+([3][0-1]|([1-2])?([0-9]))+,)+(([3][0-1]|([1-2]))?([0-9]))+(-)+(([3][0-1]|([1-2])?([0-9]))+)|(([3][0-1]|([1-2])?([0-9]))+(\/|-)([3][0-1]|([1-2])?([0-9]))+((\/|-)([3][0-1]|([1-2])?([0-9]))?))|([3][0-1]|([1-2])?([0-9]))|\*$ ]]; do #Validates user input to crontab syntax for Day of Month
		echo "
Which Day of the Month would you like you job to run?

Enter in one of the formats below:
	'*' for everyday.
	'x' for a specific day(x).
	'x, y, z' to list specific days (x, y, z).
	'x-y' for a specific range (from day x to day y).
	'x-y, z-n' to list specific ranges (from x to y and from z to n).
	'*/x' every given (x) days.
	
Which day of the month would you like the job to run on? (1-31)"
		read get_daymonth
	    done



	while [[ ! ${get_dayweek} =~ ^(\*+(\/+([1-7])))|(([1-7]),)+([1-7])+|(([1-7])+(-)+([1-7])+,)+([1-7])+(-)+(([1-7])+)|(([1-7])+(\/|-)([1-7])+((\/|-)([1-7])?))|([1-7])|\*$ ]]; do #Validates user input to crontab syntax for Day of the Week
		echo "
Which Day of the Week would you like you job to run?

Enter in one of the formats below:
	'*' for everyday.
	'x' for a specific day(x).
	'x, y, z' to list specific days (x, y, z).
	'x-y' for a specific range (from day x to day y).
	'x-y, z-n' to list specific ranges (from x to y and from z to n).
	'*/x' every given (x) days.
	
Which day of the Week would you like the job to run on? (1-7)"
		read get_dayweek
	    done


	echo "Please type the command you want to run: "
	read get_command

#Outputs the new job to the user. 
	echo "

Min: ${get_min}
Hour: ${get_hour} 
Month: ${get_month} 
Day of Month: ${get_daymonth} 
Day of Week: ${get_dayweek} 
Command: ${get_command}" 


echo "
If you are happy with this command, enter 1:"
	read get_approval #Confirms the user is happy with the new job. 

done
rm -f crontab.tmp #Clear Temp file
	touch crontab.tmp #Create temp file
crontab -l | grep "^[^#;]" | while read -r line ; 
do
	addLine "$line"; #Adds each line of Crontab to temp file
done

addLine "${get_min} ${get_hour} ${get_month} ${get_daymonth} ${get_dayweek} ${get_command}" #Adds new jobs line to temp file
crontab crontab.tmp && rm -f crontab.tmp #Replaces crontab file with temp then removes.
}

editJob()
# This function allows the user to select a 
# job, edit it and then replace the origional job.
{

#Ouptuts the users current jobs for selection
echo ""
echo "These are your current jobs: "
echo " "
counter=0
crontab -l | grep "^[^#;]" | while read -r line ; 
do
	let counter++
	echo "-+ Job -- $counter"
	declare -a CurrentLine

	IFS=' ' read -r -a CurrentLine <<< "$line"
	convertText "${CurrentLine[0]}" "${CurrentLine[1]}" "${CurrentLine[2]}" "${CurrentLine[3]}" "${CurrentLine[4]}"
	echo "-+ Command -- ${CurrentLine[@]:5:100}"
	echo ""
	echo ""
done
    unset job_to_edit
    while [[ ! ${job_to_edit} =~ ^([1-9]|1[0-9]|2[0-9]|10)$ ]]; do
        echo "Please enter the number of the job you would like to edit:"
        read job_to_edit # Allows the user to select the job to edit from the list.
    done #By this point the user has selected their job to edit.

rm -f crontab.tmp 
rm -f editcronjob.txt
touch crontab.tmp
touch editcronjob.txt
counter=0
crontab -l | grep "^[^#;]" | while read -r line ; 
do
	let counter++
	if [[ $counter != $job_to_edit ]]; then
	printf '%s\n' "$line" >>crontab.tmp #Jobs placed into temp file. 		
	fi;

	if [[ $counter = $job_to_edit ]]; then
	printf '%s\n' "$line" >>editcronjob.txt #Jobs to edit placed in temp file		
	fi;
done

crontab crontab.tmp && rm -f crontab.tmp #Replaced crontab with temp file

output="NONE"
while read -r line;
do 
	output=$line #Takes the line to edit out of the temp file
done < editcronjob.txt
echo $line

IFS=' ' read -r -a CurrentLine <<< "$output" #Takes the edit line and allows it to be split out the user


		# This section is similar to the 
		# insert jobs code but subs in the 
		# the current job that is being edited.
		get_approval=0
		while [[ ! ${get_approval} = 1 ]]; do

		get_min=NULL
		get_hour=NULL
		get_month=NULL
		get_daymonth=NULL
		get_dayweek=NULL  
		get_command=NULL

			while [[ ! ${get_min} =~ ^(\*+(\/+([1-5]([0-9])?)))|(([1-5]([0-9])?),)+([1-5]([0-9])?)|(([1-5]([0-9])?)+(-)+([1-5]([0-9])?),)+(([1-5]([0-9])?)(-)+([1-5]([0-9])?))|(([1-5]([0-9])?)+(\/|-)([1-5]([0-9])?)+((\/)+([1-5]([0-9])?))?)|([1-5]([0-9])?)|\*$ ]]; do
				echo "
		Which Minute would you like you job to run?

		Enter in one of the formats below:
			'*' for every minute.
			'x' for a specific minute(x).
			'x, y, z' to list specific minutes (x, y, z).
			'x-y' for a specific range (from minute x to minute y).
			'x-y, z-n' to list specific ranges (from x to y and from z to n).
			'*/x' every given (x) minutes.
			
		Which minute would you like the job to run on? (1-12)
		or Re-enter ${CurrentLine[0]}"
				read get_min
			    done


			while [[ ! ${get_hour} =~ ^(\*+(\/+([2][0-3]|([1])?([0-9]))))|(([2][0-3]|([1])?([0-9])),)+([2][0-3]|([1])?([0-9]))+|(([2][0-3]|([1])?([0-9]))+(-)+([2][0-3]|([1])?([0-9]))+,)+(([2][0-3]|([1])?([0-9]))+(-)+([2][0-3]|([1])?([0-9]))+)|(([2][0-3]|([1])?([0-9]))+(\/|-)([2][0-3]|([1])?([0-9]))+((\/|-)([2][0-3]|([1])?([0-9]))?))|([2][0-3]|([1])?([0-9]))|\*$ ]]; do
				echo "
		Which Hour would you like you job to run?

		Enter in one of the formats below:
			'*' for every hour.
			'x' for a specific hours(x).
			'x, y, z' to list specific hours (x, y, z).
			'x-y' for a specific range (from hour x to hour y).
			'x-y, z-n' to list specific ranges (from x to y and from z to n).
			'*/x' every given (x) hours.
			
		Which Hour would you like the job to run on? (1-12)
or Re-enter ${CurrentLine[1]}"
				read get_hour
			    done



			while [[ ! ${get_month} =~ ^(\*+(\/+([1][1-2]|[1-9])))|(([1][1-2]|[1-9]),)+([1][1-2]|[1-9])+|(([1][1-2]|[1-9])+(-)+([1][1-2]|[1-9])+,)+([1][1-2]|[1-9])+(-)+(([1][1-2]|[1-9])+)|(([1][1-2]|[1-9])+(\/|-)([1][1-2]|[1-9])+((\/|-)([1][1-2]|[1-9])?))|([1][1-2]|[1-9])|\*$ ]]; do
				echo "
		Which Month would you like you job to run?

		Enter in one of the formats below:
			'*' for every month.
			'x' for a specific month(x).
			'x, y, z' to list specific months (x, y, z).
			'x-y' for a specific range (from month x to month y).
			'x-y, z-n' to list specific ranges (from x to y and from z to n).
			'*/x' every given (x) months.
			
		Which Month would you like the job to run on? (1-12)
or Re-enter ${CurrentLine[2]}"
				read get_month
			    done


			while [[ ! ${get_daymonth} =~ ^(\*+(\/+([3][0-1]|([1-2])?([0-9]))))|(([3][0-1]|([1-2])?([0-9])),)+([3][0-1]|([1-2])?([0-9]))+|(([3][0-1]|([1-2])?([0-9]))+(-)+([3][0-1]|([1-2])?([0-9]))+,)+(([3][0-1]|([1-2]))?([0-9]))+(-)+(([3][0-1]|([1-2])?([0-9]))+)|(([3][0-1]|([1-2])?([0-9]))+(\/|-)([3][0-1]|([1-2])?([0-9]))+((\/|-)([3][0-1]|([1-2])?([0-9]))?))|([3][0-1]|([1-2])?([0-9]))|\*$ ]]; do
				echo "
		Which Day of the Month would you like you job to run?

		Enter in one of the formats below:
			'*' for everyday.
			'x' for a specific day(x).
			'x, y, z' to list specific days (x, y, z).
			'x-y' for a specific range (from day x to day y).
			'x-y, z-n' to list specific ranges (from x to y and from z to n).
			'*/x' every given (x) days.
			
		Which day of the month would you like the job to run on? (1-31)
or Re-enter ${CurrentLine[3]}"
				read get_daymonth
			    done



			while [[ ! ${get_dayweek} =~ ^(\*+(\/+([1-7])))|(([1-7]),)+([1-7])+|(([1-7])+(-)+([1-7])+,)+([1-7])+(-)+(([1-7])+)|(([1-7])+(\/|-)([1-7])+((\/|-)([1-7])?))|([1-7])|\*$ ]]; do
				echo "
		Which Day of the Week would you like you job to run?

		Enter in one of the formats below:
			'*' for everyday.
			'x' for a specific day(x).
			'x, y, z' to list specific days (x, y, z).
			'x-y' for a specific range (from day x to day y).
			'x-y, z-n' to list specific ranges (from x to y and from z to n).
			'*/x' every given (x) days.
			
		Which day of the Week would you like the job to run on? (1-7)
or Re-enter ${CurrentLine[4]}"
				read get_dayweek
			    done


			echo "Please type the command you want to run: 
or Re-enter ${CurrentLine[@]:5:100}"
			read get_command

			echo "

		Min: ${get_min}
		Hour: ${get_hour} 
		Month: ${get_month} 
		Day of Month: ${get_daymonth} 
		Day of Week: ${get_dayweek} 
		Command: ${get_command}" 

		echo "
		If you are happy with this command, enter 1:"
			read get_approval

		done

rm -f crontab.tmp
touch crontab.tmp
crontab -l | grep "^[^#;]" | while read -r line ; #Takes crontab file a puts it in temp.
do
	addLine "$line";
done

addLine "${get_min} ${get_hour} ${get_month} ${get_daymonth} ${get_dayweek} ${get_command}" #Adds edited job to temp.
crontab crontab.tmp && rm -f crontab.tmp #Subs temp in to the live crontab file
}

getInput()
# This function is the main menu
# it will loop and validate until
# a correct input is selected.
{
PS3='
Please enter your choice: '  
options=("Display Crontab Jobs" "Insert a Job" "Edit a Job" "Remove a Job" "Remove all Jobs" "" "" "" "Exit")
select opt in "${options[@]}"
do
    case $opt in
        "Display Crontab Jobs")
            echo ""
		echo "Loading Your Jobs..."
		echo ""
		sleep 1
		displayJobs
            ;;
        "Insert a Job")
            echo ""
		echo "Getting Ready to Insert a Job..."
		echo ""
		sleep 1
		addJob
            ;;
        "Edit a Job")
                echo ""
		echo "Getting Ready to Edit a Job..."
		echo ""
		sleep 1
		editJob

            ;;
	"Remove a Job")
                echo ""
		echo "Getting Ready to Remove a Job..."
		echo ""
		sleep 1
		removeJob
            ;;
	"Remove all Jobs")
            	echo ""
		echo "Getting Ready to Remove ALL Jobs..."
		echo ""
		sleep 1
		removeAllJobs
            ;;
        "Exit")
            break
            ;;
        *) echo invalid option;;
    esac
sleep 1
done
}


#Main Program
showLogo 
getInput


