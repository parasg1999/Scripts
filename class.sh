#!/bin/bash
SLOT_A_NAME="Data Warehousing and Data Mining"
SLOT_B_NAME="Wireless Sensor Networks"
SLOT_C_NAME="Mobile Computing"
SLOT_D_NAME="Software Project Planning"
SLOT_E_NAME="Big Data Analytics"

SLOT_A_LINK="https://meet.google.com/lookup/e4ovnpsgdc?authuser=1&hs=179"
SLOT_B_LINK="https://meet.google.com/lookup/cjej2m7eze?authuser=1&hs=179"
SLOT_C_LINK="https://meet.google.com/lookup/a6slokefcd?authuser=1&hs=179"
SLOT_D_LINK="https://meet.google.com/lookup/hd5r2rbgmc?authuser=1&hs=179"
SLOT_E_LINK="https://meet.google.com/lookup/bge7siti43?authuser=1&hs=179"

SLOT_C_ATTENDANCE_LINK="https://drive.google.com/open?id=1Ly4sjfkIb00gvdHoX1ztpUOpC4VwO9oxXrPRVls0FXE&authuser=1"

DAY_OF_WEEK=$(date +%u)

HOUR_OF_DAY=$(date +%_H)

OPEN_IN_BROWSER=true
NEXT_CLASS=false

increment() {
	i=0
	while [[ $i -lt $1 ]]
	do
		((HOUR_OF_DAY++))
		if [[ $HOUR_OF_DAY -eq 15 ]]
		then
			HOUR_OF_DAY=9
		elif [[ $HOUR_OF_DAY -eq 13 ]]
		then
			HOUR_OF_DAY=14
		fi
	i=$[$i+1]
	done
}

checkCurrentTime () {
	CURRENT_HOUR=$(date +%_H)
	echo "$CURRENT_HOUR"
	if [[ CURRENT_HOUR -eq 9 && $NEXT_CLASS = false ]]
	then
		echo "Break!"
		exit 0
	elif [[ CURRENT_HOUR -eq 12 && $NEXT_CLASS = true ]]
	then
		echo "Break!"
		exit 0
	elif [[ CURRENT_HOUR -eq 13 && $NEXT_CLASS = false ]]
	then
		echo "Break!"
		exit 0
	elif [[ CURRENT_HOUR -eq 14 && $NEXT_CLASS = true ]]
	then
		echo "You're currently attending the last class of the day!"
		exit 0
	elif [[ CURRENT_HOUR -gt 14 ]]
	then
		echo "End of day!"
		exit 0
	fi
}

getLink () {
	increment $1
	checkCurrentTime
	if [[ $HOUR_OF_DAY -eq 9 ]]
	then
		echo "$SLOT_A_NAME at $SLOT_A_LINK"
		[[ $OPEN_IN_BROWSER = true ]] && google-chrome $SLOT_A_LINK
	elif [[ $HOUR_OF_DAY -eq 10 ]]
	then
		echo "$SLOT_B_NAME at $SLOT_B_LINK"
		[[ $OPEN_IN_BROWSER = true ]] && google-chrome $SLOT_B_LINK
	elif [[ $HOUR_OF_DAY -eq 11 ]]
	then
		echo "$SLOT_C_NAME at $SLOT_C_LINK"
		echo "Mark Attendace at $SLOT_C_ATTENDANCE_LINK"
		[[ $OPEN_IN_BROWSER = true ]] && google-chrome $SLOT_C_LINK
		[[ $OPEN_IN_BROWSER = true ]] && google-chrome $SLOT_C_ATTENDANCE_LINK
	elif [[ $HOUR_OF_DAY -eq 12 ]]
	then
		echo "$SLOT_D_NAME at $SLOT_D_LINK"
		[[ $OPEN_IN_BROWSER = true ]] && google-chrome $SLOT_D_LINK
	elif [[ $HOUR_OF_DAY -eq 13 ]]
	then
		echo "Break!"
	elif [[ $HOUR_OF_DAY -eq 14 ]]
	then
		echo "$SLOT_E_NAME at $SLOT_E_LINK"
		[[ $OPEN_IN_BROWSER = true ]] && google-chrome $SLOT_E_LINK
	fi
} 

searchForClass() {
	if [[ $DAY_OF_WEEK -eq 1 ]]
	then
		getLink 0
	elif [[ $DAY_OF_WEEK -eq 2 ]]
	then
		getLink 1
	elif [[ $DAY_OF_WEEK -eq 3 ]]
	then
		getLink 2
	elif [[ $DAY_OF_WEEK -eq 4 ]]
	then
		getLink 3
	else
		echo "Probably a holiday";
	fi
}

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "$0 [options]"
      echo " "
      echo "options:"
      echo "-h, --help               Show brief help"
      echo "-n, --next       	 Show link for next class (let's say at 10:59)"
      echo "-p, --print       	 Only prints the link and not open it"
      exit 0
      ;;
    -n|--next)
      shift
	  NEXT_CLASS=true
	  increment 1
      ;;
	-p|--print)
	  shift
	  OPEN_IN_BROWSER=false
	  ;;
    *)
      break
      ;;
  esac
done

searchForClass