# uguush

command-line uploader for various file hosts

![Usage](https://u.teknik.io/WldwN2.png)

## Usage

uguush [options]

Options:

`-d` Delay the screenshot by the specified number of seconds.

`-f` Take a fullscreen screenshot.

`-h` Show this help message.

`-o` Select a host to use. Can be uguu, teknik, 0x0, ptpb, mixtape, lewd or fiery.

`-p <path>` Custom path to save the image to. Saves the image as "%Y-%m-%d %H-%M-%S.png"

`-s` Take a selection screenshot.

`-u <file>` Upload a file.

`-x` Do not notify dbus, update the log, or modify the clipboard.

`-w` Take a screenshot of the current window.

`-S` Select a shortener to use. Can be waaai or 0x0.

`-l` Upload the file at the provided URL.

## Requirements

- curl
- libnotify (for notifications)
- maim (for screenshot)
- slop (for selection capture)
- xclip (for clip-board support)
- xprop (for current window capture)

## Todo

POSIX sh compliance.

## Credit

Big thanks to [neku](https://github.com/nokonoko) for creating pomf and uguu!

Inspired by [onodera-punpun](https://github.com/onodera-punpun)'s pomf.sh.

Original upload functionality by [KittyKatt](https://github.com/KittyKatt).

**New** upload functionality and refactoring by [arianon](https://github.com/arianon).

Various features and help from [DanielFGray](https://github.com/DanielFGray).
