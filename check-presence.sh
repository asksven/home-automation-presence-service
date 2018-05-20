#!/bin/bash

source setenv.sh

echo running at `date` >> log

for fn in `cat devices`; do 
	mac=$(echo "$fn" | awk '{split($0,a,"|"); print a[1]}')
	name=$(echo "$fn" | awk '{split($0,a,"|"); print a[2]}')
	
	echo checking API >> log	
	# call the REST endpoint and look if $name is checked-in
	curl -k $CHECKIN_ENDPOINT/checkin/$name | jq '.' | grep $LOCATION
	res=$? # 0 if at location, 1 if not
        if [ "$res" -eq 0 ]; then
		at_location=1
		echo $name is at $LOCATION >> log
	else
		at_location=0
		echo $name is not at $LOCATION >> log
	fi

	echo MAC = $mac
	echo Name = $name

	echo checking presence >> log
	if sudo hcitool info $mac | grep -q 'Device Name'; then
		echo $name is at $LOCATION >> log
		if [ "$at_location" -eq 1 ]; then
			echo $name already checked-in, do nothing >> log
		else
			echo $name arrived at $LOCATION, checking-in >> log
			# call the API and check-in
			curl -skSX POST -d '{"name":"'$name'","location":"'$LOCATION'"}' $CHECKIN_ENDPOINT/checkin
		fi
	else
		echo $name is not at $LOCATION >> log
		if [ "$at_location" -eq 1 ]; then
			echo $name is not at $LOCATION anymore, checking-out >> log
			# call API and check-out
			curl -sSX DELETE -d '{"name":"'$name'"}' $CHECKIN_ENDPOINT/checkin
		else
			echo $name already checked-out, do nothing >> log
		fi	
	fi
done
