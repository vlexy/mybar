#!/bin/sh

# Requirements
# - acpi
# - amixer

# Colors
bcolor="#2A2A2A"
fcolor="#F9F2F2"

red="#FC4C4E"
orange="#FF7E5D"
green="#65FF85"
blue="#5CCDFF"

# WiFi
wifi(){
	WIFISTR=$( iwconfig wlp1s0 | grep "Link" | sed 's/ //g' | sed 's/LinkQuality=//g' | sed 's/\/.*//g')

	if [ ! -z $WIFISTR ] ; then
		WIFISTR=$(( ${WIFISTR} * 100 / 70))
		ESSID=$(iwconfig wlp1s0 | grep ESSID | sed 's/ //g' | sed 's/.*://' | cut -d "\"" -f 2)
		if [ $WIFISTR -ge 1 ] ; then
			echo "%{F$fcolor}Connected %{F$blue}$ESSID"
		fi
	fi
}

# Time
clock() {
	# Retieve time in 24 hour format
	TIME=$(date "+%T")

	# Substring Hours:Minutes
	echo "%{F$fcolor}${TIME:0:5}"
}

# Date
calendar() {
	# Retrieve date
	DATE=$(date "+%a %d, %Y")

	echo "%{F$fcolor}$DATE"
}

# Volume
volume() {
	# Retrieve volume
	VOLUME=$(amixer get Master | awk -F'[][]' 'END{ print $4":"$2 }' | sed 's/on://g')

	VOLUME=${VOLUME::-1}

    echo "%{F$fcolor}$VOLUME%"
}

# Battery Status
battery() {
	# Retrieve battery percentage
	BATTACPI=$(acpi --battery)
    BATPERC=$(echo $BATTACPI | cut -d, -f2 | tr -d '[:space:]')

	# Change color according to status
    if [[ $BATTACPI == *"Discharging"* ]]; then
    	BATPERC=${BATPERC::-1}
		echo -n "BATTERY "
    	if [ $BATPERC -le "10" ]; then
    		echo -n "%{F$red}"
		elif [ $BATPERC -le "25" ]; then
    		echo -n "%{F$orange}"
		elif [ $BATPERC -le "99" ]; then
			echo -n "%{F$fcolor}"
		elif [ $BATPERC -le "100" ]; then
			echo -n "%{F$green}"
    	fi
    	echo "$BATPERC%"
    elif [[ $BATTACPI == *"Charging"* && $BATTACPI != *"100%"* ]]; then
    	echo -n "%{F$fcolor}CHARGING %{F$green}$BATPERC"
    elif [[ $BATTACPI == *"Unknown"* ]]; then
		echo ""
	fi
}

# Update every second
while :; do
	echo "%{l} $(wifi)%{c}$(clock)%{r}VOL $(volume) | $(battery) "
	sleep 1
done