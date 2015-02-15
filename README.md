poomf.sh
========

puush-like functionality for pomf.se and uguu.se

![](http://a.pomf.se/knezlh.png)

Usage
=====

`-f` for fullscreen capture, `-s` for a selection rectangle, and `-u <file>` to upload a file.

`-g` to use uguu.se rather than pomf. Files will be kept for one hour and there is a max upload size of 150MB.

For best results, bind each operation to a hotkey using `sxhkd` or `xbindkeys`.

Requirements
============

- curl
- libnotify (for notifications)
- maim (for screenshot)
- slop (for selection capture)
- xclip (for clip-board support)

Credit
======

Big thanks to [neku](https://github.com/nokonoko) for creating pomf and uguu!

Inspired by [onodera-punpun](https://github.com/onodera-punpun)'s pomf.sh.

Original upload functionality by [KittyKatt](https://github.com/KittyKatt).

**New** upload functionality and refactoring by [arianon](https://github.com/arianon).
