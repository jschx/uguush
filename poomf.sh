#!/bin/bash

# poomf.sh - puush-like functionality for pomf.se
# for best results, bind each operation to a hotkey using sxhkd or xbindkeys
# inspired by onodera-punpun's pomf.sh (https://github.com/onodera-punpun)
# upload functionality by kittykatt (https://github.com/KittyKatt)
# clipboard, file upload, help, logging, notify-send, and selection functionality by joe (https://github.com/JSchilli1)
# requires scrot, curl, xclip (for auto-copy), and libnotify (for notifications)

# Get options
while getopts fsu: option; do
    case $option in
        f)ful=1 opt=1;;
        s)sel=1 opt=1;;
        u)upl=1 opt=1;;
        *)exit;;
    esac
done

# Helpful error if no options are passed
if [[ -z $opt ]]; then
    echo "please provide an option:"
    echo "-f            fullscreen"
    echo "-s            selection"
    echo "-u file       file upload"
    exit
fi

# Capture fullscreen
if [[ ! -z $ful ]]; then
    file=$(scrot '%Y-%m-%d_scrot.png' -e 'echo -n $f')
fi

# Provide a selection rectangle for capture
if [[ ! -z $sel ]]; then
    file=$(scrot '%Y-%m-%d_scrot.png' -s -e 'echo -n $f')
fi

# Set the file to equal the option specified
if [[ ! -z $upl ]]; then
    file=$(echo $2)
fi

# Upload it and grab the url
echo "uploading ${file}..."
output=$(curl --silent -sf -F files[]="@$file" "http://pomf.se/upload.php")
n=0
while [[ $n -le 3 ]]; do
    printf "try #${n}..."
    if [[ "${output}" =~ '"success":true,' ]]; then
        pomffile=$(echo "$output" | grep -Eo '"url":"[A-Za-z0-9]+.*",' | sed 's/"url":"//;s/",//')
        printf 'done.\n'
        break
    else
        printf 'failed.\n'
        ((n = n +1))
    fi
done

url=http://a.pomf.se/$pomffile

# Remove temporary files
if [[ -z $upl ]]; then
rm -f $file
fi

# Copy url to all clipboards
echo $url | xclip -selection primary
echo $url | xclip -selection secondary
echo $url | xclip -selection clip-board

# Write the url to a file
echo $url >> ~/pomfs.txt

# Display notification
notify-send "pomf!" "$url"

