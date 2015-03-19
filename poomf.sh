#!/usr/bin/env sh
#
# poomf.sh - command-line uploader for pomf.se and uguu.se
#

# by joe - js1 at openmailbox dot org
# refactored by arianon - arianon at openmailbox dot org

## CONFIGURATION

# Colors
N=$(tput sgr0)
R=$(tput setaf 1)
G=$(tput setaf 2)

# Screenshot utility
fshot="maim --hidecursor"
sshot="maim -s --hidecursor"
wshot="maim -i $(xprop -root _NET_ACTIVE_WINDOW | grep -o '0x.*')"

# Default screenshot name.
FILE='/tmp/screenshot.png'

# Default delay.
secs="0"

## FUNCTIONS

function depends {
	if ! type curl &> /dev/null; then
		echo >&2 "Checking for curl... [${R}FAILED${N}]"
		echo "\`curl\` not found."
		exit 1
	fi
}

function usage {
	cat <<-HELP
	poomf.sh - puush-like functionality for pomf.se and uguu.se

	Usage:
	    $(basename "${0}") [options]

	Options:
	    -d         Delay the screenshot by the specified number of seconds.
	    -h         Show this help message.
	    -f         Take a fullscreen screenshot.
	    -g         Use uguu.se to upload.
	               It keeps files for one hour and has a 150MB max upload size.
	    -s         Take a selection screenshot.
	    -t         Use HTTPS, if the host supports it.
	    -u <file>  Upload a file
	    -w         Take a screenshot of the current window.
	HELP
}

function delay {
	for (( i=secs; i > 0; --i )) ; do
		echo "$i..."
		sleep 1
	done
}

function screenshot {
	if [[ "${ful}" ]]; then
		# Take fullscreen shot.
		${fshot} "${FILE}"
	elif [[ "${sel}" ]]; then
		# Take selection shot.
		${sshot} "${FILE}"
	elif [[ "${win}" ]]; then
		# Take window shot.
		${wshot} "${FILE}"
	fi
}

function upload {
	for (( i = 1; i <= 3; i++ )); do
		echo -n "Try #${i}... "

		# Upload file to selected host
		if [[ "${uguu}" ]]; then
			if [[ "${https}" ]]; then
				echo "[${R}FAILED${N}]"
				echo "Uguu.se doesn't support HTTPS yet."
				exit 1
			else
				pomf=$(curl -sf -F file="@${FILE}" "http://uguu.se/api.php?d=upload")
			fi
		else
			if [[ "${https}" ]]; then
				pomf=$(curl -sf -F files[]="@${FILE}" "https://pomf.se/upload.php?output=gyazo")
			else
				pomf=$(curl -sf -F files[]="@${FILE}" "http://pomf.se/upload.php?output=gyazo")
			fi
		fi
		if (( "${?}" == 0 )); then

			# Copy link to clipboard
			xclip -selection primary <<< "${pomf}"
			xclip -selection clipboard <<< "${pomf}"

			# Log url to file
			echo "$(date +"%D %R") | ${pomf}" >> ~/.pomfs.txt

			# Notify user of completion
			notify-send "pomf!" "${pomf}"

			# Output message to term
			echo "[${G}OK${N}]"
			echo "File has been uploaded: ${pomf}"
			exit
		else
			echo "[${R}FAILED${N}]"
		fi
	done
}

## EXIT IF NO ARGUMENTS FOUND
if (( $# < 1 )); then
	usage
	exit 1
fi

## PARSE OPTIONS
while getopts :d:fghstu:w opt; do
	case "${opt}" in
		d)
			# Set delay value.
			secs="${OPTARG}" ;;
                f)
			# Fullscreen.
			ful=1 ;;
		g)
			# Change mode to uguu
			uguu=true ;;
		s)
			# Take shot with selection.
			sel=1 ;;
		t)
			# Use HTTPS
			https=true ;;
		u)
			# Change $FILE to the specified file with -u
			FILE="${OPTARG}" ;;
		w)
			# Take shot of current window.
                        win=1 ;;
		h)
			# Show help and exit with EXIT_SUCCESS
			usage
			exit 0 ;;
		*)
			# Ditto, but with EXIT_FAILURE
			usage
			exit 1 ;;
	esac
done

## EXECUTE FUNCTIONS

depends
delay
screenshot
upload

# If the program doesn't exit at the for-loop, the upload failed.
echo "File was not uploaded, did you specify a valid filename?"
