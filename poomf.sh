#!/usr/bin/env bash
#
# poomf.sh - puush-like functionality for pomf.se and uguu.se
#

# by joe - js1 at openmailbox dot org
# refactored by arianon - arianon at openmailbox dot org

## CONFIGURATION

# Colors
N=$(tput sgr0)
R=$(tput setaf 1)
G=$(tput setaf 2)

# Screenshot utility
fscreen='maim --hidecursor'	# command for fullscreen capture
sscreen='maim -s --hidecursor'	# command for selection capture

# Default screenshot name.
FILE='/tmp/screenshot.png'


## FUNCTIONS
function depends {
	if ! command -v curl &> /dev/null; then
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
	    -h         Show this help message.
	    -f         Take a fullscreen screenshot.
	    -g         Use uguu.se to upload.
	               It keeps files for one hour and has a 150MB max upload size.
	    -s         Take a selection screenshot.
	    -u <file>  Upload a file
	HELP
}

## EXIT IF NO ARGUMENTS FOUND
if [[ -z "${1}" ]]; then
	usage
	exit 1
fi

depends

## PARSE OPTIONS
while getopts :fghsu: opt; do
	case "${opt}" in
		f)
			# Take shot.
			${fscreen} "${FILE}" ;;
		g)
			# Change mode to uguu
			uguu=1 ;;
		s)
			# Take shot with selection.
			${sscreen} "${FILE}" ;;
		u)
			# Change $FILE to the specified file with -u
			FILE="${OPTARG}" ;;
		h)
			# Show help and exit with EXIT_SUCCESS
			usage && exit 0 ;;
		*)
			# Ditto, but with EXIT_FAILURE
			usage && exit 1 ;;
	esac
done

## UPLOAD FILE
for (( i = 1; i <= 3; i++ )); do
	echo -n "Try #${i}... "

	# Upload file to selected host
	if [[ "${uguu}" ]]; then
		pomf=$(curl -sf -F file="@${FILE}" "http://uguu.se/api.php?d=upload")
	else
		pomf=$(curl -sf -F files[]="@${FILE}" "https://pomf.se/upload.php?output=gyazo")
	fi

	if (( "${?}" == 0 )); then

		# Copy link to clipboard
		echo -n "${pomf}" | xclip -selection primary
		echo -n "${pomf}" | xclip -selection clipboard

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

# If the program doesn't exit at the for-loop, the upload failed.
echo "File was not uploaded, did you specify a valid filename?"
