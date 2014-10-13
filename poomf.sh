#!/bin/bash

# poomfsh - puush-like functionality for pomf.se

## OPTIONS

# Get options
while getopts fhsu: option; do
    case $option in
        f)ful=1;;
        h)hel=1;;
        s)sel=1;;
        u)upl=1;;
        *)exit;;
    esac
done

# Fullscreen
if [[ -z $mul ]]; then
    if [[ ! -z $ful ]]; then
        # Take fullscreen scrot
        file=$(scrot '%Y-%m-%d_scrot.png' -e 'echo -n $f')
    fi
else
    echo "error: please only provide one option"
    exit
fi

# Help
if [[ -z $mul ]]; then
    if [[ ! -z $hel ]]; then
        # Display help
        echo "-f            fullscreen"
        echo "-h            show this message"
        echo "-s            selection"
        echo "-u file       file upload"
        exit
    fi
else
    echo "error: please only provide one option"
    exit
fi

# Selection
if [[ -z $mul ]]; then
    if [[ ! -z $sel ]]; then
        # Take selection scrot
        file=$(scrot -s '%Y-%m-%d_scrot.png' -e 'echo -n $f')
    fi
else
    echo "error: please only provide one option"
    exit
fi

# File
if [[ -z $mul ]]; then
    if [[ ! -z $upl ]]; then
        # Get file
        file=$(echo $2)
        mul=1
    fi
else
    echo "error: please only provide one option"
    exit
fi

## UPLOADING

# Upload it and grab the url
output=$(curl --silent -sf -F files[]="@$file" "http://pomf.se/upload.php")
if [[ ! -z $upl ]]; then
    echo "uploading ${file}..."
    n=0
    while [[ $n -le 3 ]]; do
        printf "\033[37m try #${n}..."
        if [[ "${output}" =~ '"success":true,' ]]; then
            pomffile=$(echo "$output" | grep -Eo '"url":"[A-Za-z0-9]+.*",' | sed 's/"url":"//;s/",//')
            printf '\033[32m done.\n'
            suc=1
            break
        else
            printf '\033[31m failed.\n'
            ((n = n +1))
        fi
    done
    url=http://a.pomf.se/$pomffile
else
    echo "uploading ${file}..."
    n=0
    while [[ $n -le 3 ]]; do
        printf "\033[37m try #${n}..."
        if [[ "${output}" =~ '"success":true,' ]]; then
            pomffile=$(echo "$output" | grep -Eo '"url":"[A-Za-z0-9]+.png",' | sed 's/"url":"//;s/",//')
            printf '\033[32m done.\n'
            suc=1
            break
        else
            printf '\033[31m failed.\n'
            ((n = n +1))
        fi
    done
    url=http://a.pomf.se/$pomffile
    rm -f $file
fi

## OUTPUT
if [[ ! -z $suc ]]; then
    # Copy link to clipboard
    echo -n $url | xclip -selection primary
    echo -n $url | xclip -selection clipboard
    # Log url to file
    echo $url >> ~/pomfs.txt
    # Notify user of completion
    notify-send "pomf!" "$url"
    # Print message to the term
    echo -e "\033[37m file has been uploaded: $url"
else
    echo -e "\033[37m file was not uploaded, did you specify a valid file?"
fi
