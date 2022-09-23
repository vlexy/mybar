#!/bin/bash

# Requirements
# - acpi

# Colors


# Time
clock() {
	# Retieve time in 24 hour format
	TIME=$(date "+%T")

	# Substring Hours:Minutes
	echo "${TIME:0:5}"
}

# Date
date() {
	# Retrieve date
	DATE=$(date, "+%a %d, %Y")

	echo "${DATE}"
}

# Battery Status
battery() {

	BATTERY=$(acpi --battery | cut -d, -f2)

	echo "${BATTERY}"

}

while :; do

	echo "${clock}%{r}${battery}"

	sleep 1
done