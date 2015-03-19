poomf.sh
========

command-line uploader for pomf.se and uguu.se

![](http://a.pomf.se/knezlh.png)

Usage
=====

  poomf.sh [options]
  
Options:

`-d` Delay the screenshot by the specified number of seconds.

`-h` Show this help message.

`-f` Take a fullscreen screenshot.

`-g` Use uguu.se to upload. It keeps files for one hour and has a 150MB max upload size.
  
`-s` Take a selection screenshot.

`-t` Use HTTPS, if the host supports it.

`-u` <file> Upload a file.

`-w` Take a screenshot of the current window.

Requirements
============

- curl
- libnotify (for notifications)
- maim (for screenshot)
- slop (for selection capture)
- xclip (for clip-board support)
- xprop (for current window capture)

Todo
====

Add support for more hosts. Teknik, maybe imgur?

Credit
======

Big thanks to [neku](https://github.com/nokonoko) for creating pomf and uguu!

Inspired by [onodera-punpun](https://github.com/onodera-punpun)'s pomf.sh.

Original upload functionality by [KittyKatt](https://github.com/KittyKatt).

**New** upload functionality and refactoring by [arianon](https://github.com/arianon).

Various features and help from [DanielFGray](https://github.com/DanielFGray).
