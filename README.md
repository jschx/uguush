poomf
========

command-line uploader for pomf.se and uguu.se

![](http://a.pomf.se/ooiyev.png)

Usage
=====

  poomf [options]
  
Options:

`-d` Delay the screenshot by the specified number of seconds.

`-f` Take a fullscreen screenshot.

`-h` Show this help message.

`-o` Select a host to use. Can be pomf, uguu, teknik, or imgur (images only).
  
`-s` Take a selection screenshot.

`-t` Use HTTPS, if the host supports it.

`-u` <file> Upload a file.

`-w` Take a window screenshot.

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

POSIX sh compliance.

Credit
======

Big thanks to [neku](https://github.com/nokonoko) for creating pomf and uguu!

Inspired by [onodera-punpun](https://github.com/onodera-punpun)'s pomf.sh.

Original upload functionality by [KittyKatt](https://github.com/KittyKatt).

**New** upload functionality and refactoring by [arianon](https://github.com/arianon).

Various features and help from [DanielFGray](https://github.com/DanielFGray).
