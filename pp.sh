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

## I know that arrays exist too
break_times[0]=$(date +%R:%S)

## I can do functions, too!
there_was_a_break () {
	((break_number++));
	break_times+=( $(date +%R:%S) );
}

## i can work with arguments, add some interactivity
# If you want to test connectivity on something other than 8.8.8.8, write it as an argument
if [ "$1" != "" ]; then
	address=$1;
fi

## And different types of cycles, too
## While, if, for, netsted cycles, you call it
while (( connected == 1 )) ; do
	if
		ping -q -c 1 -W 1 $address &>/dev/null; then
		echo -e "$(tput cuu 1; tput el; tput bold; tput setaf 2)Connected for $sec seconds!";
		
		# If there were any breaks, show how many while it's still going
		if (( break_number > 0 )); then
			echo -e "\n\nThere were $(tput setaf 1) $break_number $(tput setaf 2) breaks so far";
			tput cuu 3;
		fi
	
		sleep 1;
		((sec++));

		# If there was a break, reset the counter so it doesn't add to the previous one
		# Also it's the best place in the code to pull up the counter
		if (( break_count > 0 )); then
			break_count=0;
			there_was_a_break;

		fi

	else
		echo -e "$(tput cuu 1; tput el; tput bold; tput setaf 1)Disconnected!";
		sleep 1;
		
		# This counter is to make sure that you're really not connected and it's not just a stray packet
		((break_count++))
		
		# If disconnect is momentary, don't break the cycle and keep pinging
		# Otherwise, increment the counter because this is the last cycle
		if (( break_count > 5 )); then
			connected=0;
			there_was_a_break;
		fi
	fi
	
done

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

## It was a fun little exercise for me, and gotta say i pulled up the docs numerous times while writing it
## I've prepped this piece specifically for the moment of interview someone asks me to write something if i'll be too tensed up
## And if we are on interview right now, looking at it, rather ask me anything about this code, please (i'm just nervous)
