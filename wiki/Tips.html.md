Perl Background Rotation/Tips
=============================

  

Here are some tips and tricks to both using the wallpaper script, and
organizing your wallpapers in a sane manner.

Table of Contents
-----------------

1.  Introduction : What this does.
2.  Installation : Getting the basics handled.
3.  Using Extensions : Optional feature setup.
4.  Script Extras : Related Software
5.  Tips and Tricks : Fun for the whole family!
6.  Hacking : How to create your own extensions
7.  Code : Code Walkthrough and some design notes
8.  FAQ : Frequently Asked Questions
9.  Screenshot Gallery : If you use these scripts, show off!
10. Resources : A comprehensive wallpaper list.

Commandline Parameters
----------------------

> --status

Involking status prints the current "run" status of the stript.

The run status can be toggled with the --toggle command.

> --toggle

Involking toggle changes the current "run" status of the script. This
allows you to quickly disable the use of the --next command which is
typically called by a cron job. Executing --toggle again re-enables the
--next command.

You can retrieve the current status with the --status parameter.

> --next

Next commands the daemon to process the next photos in the queue right
away.

This should normally be called by cron, but you might consider binding
this command to a hotkey for quick background generation.

> --photo

Photo preselects the next image to render, and adds it to the queue. It
requires one parameter, the photo to enqueue. Prefix the complete
pathname to the wallpaper with an optional displayname to pick a monitor
render to. For example:

    wallie --photo:/path/to/wallpaper.png
    wallie --photo:0.1:/path/to/wallpaper.png

This command does NOT start a render process. use --next to begin that
process. If you wish to select a wallpaper and render it right away,
try:

    wallie --photo:/path/to/wallpaper.png ; wallie --next

> --photodir

Photodir preselects a random image from a provided directory. This
allows a onetime over-ride of the time-based directory based
randomization selection found in the configuration file. It requries one
parameter, the complete pathname to a directory to pick a random file
for. Prefix the filename with an optional displayname no pick a monitor
to queue for. For example:

    wallie --photodir:/path/to/wallpapers
    wallie --photodir:0.1:/path/to/wallpapers

> --current

Current displays the photograph (with path) that the currently displayed
photo was originally rendered from. This is useful for outside scripts
usually.

A parameter of the display to return a photo for is optional. Otherwise
the current photo for display 0.0 will be returned. For example:

    wallie --current
    wallie --current:0.1

> --scheme

This returns the current color scheme in human readable format. A
parameter of the display to return a scheme for is optional. The default
is to return the color scheme for the 0.0 display. For example:

    wallie --scheme
    wallie --scheme:0.1

> --schemedata

This returns the color scheme, each value delimited by a ":". A
parameter of the display to return a scheme for is optional. The default
is to return the color scheme for the 0.0 display.

    wallie --schemedata
    wallie --schemedata:0.1
                   

For a description of each color returned, try --scheme

> --version

Version shows the current versions of all the pieces which when put
together form this program. The version number is basicly a simple
conversion between the subversion revision number, and a CPAN style
version. So a subversion revision of 350 would result in a module
version of 1.350. When the subversion revision hits 1000, the CPAN
version will roll over to 2.0. This should NOT indicate that any major
functionality has been added.

In general, the version information is useful for debugging purposes
only. If you are experiencing problems, I'll need the version numbers...

> --die

This kills the daemon process. You should use this command to terminate
the daemon rather than just killing it off.

If you wish to restart the daemon because (for example, your
configuration has changed), try:

    wallie die ; wallpaper

  

Prev: Script Extras | Next: Hacking

Retrieved from
"https://wiki.archlinux.org/index.php?title=Perl_Background_Rotation/Tips&oldid=197799"

Category:

-   Perl Background Rotation

-   This page was last modified on 23 April 2012, at 16:20.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
