#!/bin/bash

# poomfsh - puush-like functionality for pomf.se

## CONFIGURATION

# Colors

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

# Get options
while getopts fhsu: option; do
    case $option in
        f)fullscreen=1;;
        h)help=1;;
        s)selection=1;;
        u)upload=1;;
        *)exit;;
    esac
done

# Fullscreen
if [[ -z $multiple ]]; then
    if [[ ! -z $fullscreen ]]; then
        # Take fullscreen scrot
        file=$(filename=$(date +%Y-%m-%d)_scrot.png ; maim $filename ; echo -n $filename)
    fi
else
    echo "error: please only provide one option"
    exit
fi

# Help
if [[ -z $multiple ]]; then
    if [[ ! -z $help ]]; then
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
if [[ -z $multiple ]]; then
    if [[ ! -z $selection ]]; then
        # Take selection scrot
        file=$(filename=$(date +%Y-%m-%d)_scrot.png ; maim -s $filename ; echo -n $filename)
    fi
else
    echo "error: please only provide one option"
    exit
fi

# File
if [[ -z $multiple ]]; then
    if [[ ! -z $upload ]]; then
        # Get file
        file=$(echo $2)
        multiple=1
    fi
else
    echo "error: please only provide one option"
    exit
fi

## UPLOADING

# Upload it and grab the url

output=$(curl --silent -sf -F files[]="@$file" "http://pomf.se/upload.php")

echo "uploading ${file}..."
n=0

while [[ $n -le 3 ]]; do
  printf "$white try #${n}...$reset"
  if [[ "${output}" =~ '"success":true,' ]]; then
    if [[ ! -z $upload ]]; then
      pomffile=$(echo "$output" | grep -Eo '"url":"[A-Za-z0-9]+.*",' | sed 's/"url":"//;s/",//')
    else
      pomffile=$(echo "$output" | grep -Eo '"url":"[A-Za-z0-9]+.png",' | sed 's/"url":"//;s/",//')
    fi
    printf "$green done.$reset\n"
    success=1
    break
  else
    printf "w$red failed.$reset\n"
    ((n = n +1))
  fi
done

url=http://a.pomf.se/$pomffile

if [[ -z $upload ]]; then
  rm -f $file
fi

## OUTPUT

if [[ ! -z $success ]]; then
    # Copy link to clipboard
    echo -n $url | xclip -selection primary
    echo -n $url | xclip -selection clipboard
    # Log url to file
    echo $url "<<" "$(date +"[%D] | [%H:%M:%S]")" >> ~/.pomfs.txt
    # Notify user of completion
    notify-send "pomf!" "$url"
    # Print message to the term
    printf "$white file has been uploaded: $url$reset\n"
else
    printf "$red file was not uploaded, did you specify a valid file?$reset\n"
fi
