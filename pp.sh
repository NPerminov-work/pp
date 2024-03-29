#!/bin/bash

## - comments for dear employer
# - actual code comments

## Let's make it clear for you, i can run native commands
clear

## I also can set variables, use them as counters or boolean values, etc
address="8.8.8.8"
connected=1
sec=0
break_count=0
break_number=0
permanent=0

## I know that arrays exist too
break_times[0]=$(date +%R:%S)

## I can do functions, too!
there_was_a_break () {
	((break_number++));
	break_times+=( $(date +%R:%S) );
}

show_info () {
## Some formatting, pretty colors, bald text, replacing the line, etc
## Making it easier and friendlier for other users
tput setaf 2; tput cuu 1; tput el; tput bold;

# Show what you've been pinging and for how long
echo -e "You was successfully pinging $address for $sec seconds since ${break_times[0]}"

# Show how many breaks there were
echo -e "\n\nThere were $(tput setaf 1) $break_number $(tput setaf 2) breaks in total"

# Show the time of each break
for index in "${!break_times[@]}"; do
	echo -e "$(($index+1)) break was at ${break_times[ $(( $index+1 )) ]}";
done

# Move one line up and delete it becasue we did "index+1" instead of "index" so last array element is empty
# Gotta be pretty :3
tput cuu 1; tput el;
}

## i can work with arguments, add some interactivity
if [ "$1" != "" ]; then
	case $1 in
		* )
		address=$1;
		;;
	esac

# Optional arguments
	for opt in $@; do
		case $opt in
			-p | --permanent )
				permanent=1;
				;;
			-h | --help )
				echo -e "Usage: ./pp.sh [address] (Default target is 8.8.8.8)\n";
				echo -e "Options:";
				echo -e "-p | --permanent 	don't stop pinging after disconnect";
				echo -e "-h | --help 		show this message";
				exit 0
				;;
		esac
	done
fi

# Show total info about the script running after preemptively closing it
trap "show_info && exit 0" SIGINT;

## And different types of cycles, too
## While, if, for, netsted cycles, you call it
while (( connected == 1 )) ; do
	if
		ping -q -c 1 -W 0 $address &>/dev/null; then
		echo -e "$(tput cuu 1; tput el; tput bold; tput setaf 2)Connected for $sec seconds!";
		
		# If there were any breaks, show how many while it's still going
		if (( break_number > 0 )); then
			echo -e "\n\nThere were $(tput setaf 1) $break_number $(tput setaf 2) breaks so far";
			tput cuu 3;
		fi
	
		((sec++));

		# If there was a break, reset the counter so it doesn't add to the previous one
		# Also it's the best place in the code to pull up the counter
		if (( break_count > 0 )); then
			break_count=0;
			there_was_a_break;

		fi

	else
		echo -e "$(tput cuu 1; tput el; tput bold; tput setaf 1)Disconnected!";
		((sec++));
		
		# This counter is to make sure that you're really not connected and it's not just a stray packet
		((break_count++))
		
		# If disconnect is momentary, don't break the cycle and keep pinging
		# Otherwise, increment the counter because this is the last cycle
		if (( permanent == 0 )) && (( break_count > 4 )); then
			connected=0;
			there_was_a_break;
		fi
	fi
sleep 1;
done

show_info;

## I've prepped this piece specifically for the moment of interview someone asks me to write something, if i'll be too tensed up
## And if we are on interview right now, looking at it, then please, ask me anything about this code rather than asking to write
## (i'm just a nervous junior, hope you understand, it'll go away with experience)
