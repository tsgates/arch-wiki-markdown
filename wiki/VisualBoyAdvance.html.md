VisualBoyAdvance
================

VisualBoyAdvance (commonly abbreviated as VBA) is a cross-platform
emulator for the Game Boy, Super Game Boy, Game Boy Color, and Game Boy
Advance game consoles. It is an inactive project superseded by
VisualBoyAdvance-M (known as VBA-M), an improved fork that initially
integrated features from earlier forks.

Installation
------------

Install vbam-gtk from the official repositories or vbam-gtk-svn from the
AUR.

Usage
-----

Run VBA-M with the following.

    gvbam ~/path/to/rom.gba

Tip:Extensions may vary depending on what console the ROM is for. VBA-M
can also open compressed .zip archives containing a ROM.

Default controls are:

     Left          Left Arrow  (0114)
     Right         Right Arrow (0113)
     Up            Up Arrow    (0111)
     Down          Down Arrow  (0112)
     A             Z           (007a)
     B             X           (0078)
     L             A           (0061)
     R             S           (0073)
     Start         ENTER       (000d)
     Select        BACKSPACE   (0008)
     Speed up      SPACE       (0020)
     Capture       F12         (0125)

Issues
------

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: Grammar,         
                           spelling, and            
                           organisation issues      
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

There are a couple known issues during installation When trying to run
VBA after an install you may get this after typing in gvba.

    ~$ Failed to open audio: Fragment size must be a power of two
    Segmentation fault

VBA has been updated to fix this but if you still get this error it may
be fixed by editing /src/vbam/src/common/SoundSDL.cpp and editing the
function

        bool SoundSDL::init(long sampleRate)

Editing the audio sample has helped me before. If you feel this is too
technical, you should contact the developers at the vba forums because
this issue should now be resolved.

If you are getting errors about OpenGL and video output the problem is
most likely that the video output choice is wrong. To fix this edit the
configuration file. In the directory /home/<USER>/.config/gvbam

In the Display Section of the config file changing the line from

    output=1

to

    output=2

or

    output=0

Has been known to fix the problem.

Also the Directories for which VBA will search for the game saves and
ROMs can sometimes revert back to the default setting. If prefer to keep
you saves and ROMs in a specific directory you may want to edit the
config file in /home/$USER/.config/gvbam You may then set the
permissions to read-only to prevent VBA from changing them.Take note
that any time you change a setting and save while the cofig file is on
read-only it will not save. Putting it to read-only effectively "locks"
the file from any annoying changes.

    In the Directories section simply enter in your preferred directory like this.

    [Directories]
    gb_roms=/home/generic/Documents/VBA/ROMs 
    gba_roms=/home/generic/Documents/VBA/ROMs 
    batteries=/home/generic/.config/gvbam 
    saves=/home/generic/Documents/VBA/SAVES 
    captures=/home/generic/Documents/VBA 

Also make sure your new config file is saved as "config" and not
"config~".

Retrieved from
"https://wiki.archlinux.org/index.php?title=VisualBoyAdvance&oldid=305969"

Categories:

-   Gaming
-   Emulators

-   This page was last modified on 20 March 2014, at 17:31.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
