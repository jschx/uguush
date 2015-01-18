#!/bin/bash

# poomf.sh - puush-like functionality for pomf.se

## CONFIGURATION

# colors

reset=$(tput sgr0)
black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)

## OPTIONS

# get options
while getopts fhsu: option; do
	case $option in
		f)fullscreen=1;;
		h)help=1;;
		s)selection=1;;
		u)upload=1;;
		*)exit;;
	esac
done

# take fullscreen picture
if [[ $fullscreen ]]; then
	file=$(filename=/tmp/screenshot.png ; maim --hidecursor $filename ; printf $filename)
fi

# display help
if [[ $help ]]; then
	printf "%s\t\t%s\n" "-f" "fullscreen"
	printf "%s\t\t%s\n" "-h" "show this message"
	printf "%s\t\t%s\n" "-s" "selection"
	printf "%s\t\t%s\n" "-u file" "file upload"
	exit
fi

# take selection picture
if [[ $selection ]]; then
	file=$(filename=/tmp/screenshot.png ; maim -s --hidecursor $filename ; printf $filename)
fi

# get file
if [[ $upload ]]; then
	file=$(printf $2)
fi

## UPLOADING

# upload it and grab the url
output=$(curl --silent -sf -F files[]="@$file" "http://pomf.se/upload.php")

printf "%s\n" "uploading ${file}..."

n=0
while [[ $n -le 3 ]]; do
	printf "$white try #${n}...$reset"
	if [[ "${output}" =~ '"success":true,' ]]; then
		if [[ ! -z $upload ]]; then
			pomffile=$(printf $output | grep -Eo '"url":"[A-Za-z0-9]+.*",' | sed 's/"url":"//;s/",//')
		else
			pomffile=$(printf $output | grep -Eo '"url":"[A-Za-z0-9]+.png",' | sed 's/"url":"//;s/",//')
		fi
		printf "$green done.$reset\n"
		success=1
		break
	else
		printf "$red failed.$reset\n"
		((n = n +1))
	fi
done

url=http://a.pomf.se/$pomffile

# remove temporary file

if [[ -z $upload ]]; then
	rm -f $file
fi

## OUTPUT

if [[ $success ]]; then
	# copy link to clipboard
	printf $url | xclip -selection primary
	printf $url | xclip -selection clipboard
	# log url to file
	echo "$(date +"%D %H:%M:%S") | $url" >> ~/.pomfs.txt
	# notify user of completion
	notify-send "pomf!" "$url"
	# output message to term
	printf "%s\n" "file has been uploaded: $url"
else
	printf "%s\n" "file was not uploaded, did you specify a valid filename?"
fi
