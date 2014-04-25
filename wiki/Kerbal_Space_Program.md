Kerbal Space Program
====================

Since version 0.19, Kerbal Space Program includes a native Linux
version. However, only Ubuntu 12.04 is officialy supported, so it may
not work on Arch Linux out of the box.

Contents
--------

-   1 Known issues
    -   1.1 Game never progresses past initial loading
    -   1.2 No text display
    -   1.3 Graphics flickering when using primusrun
    -   1.4 Game crashes when accessing settings or saves on 64 bit
        systems on Steam
    -   1.5 Game has garbled graphics when running on x86_64 with all
        lib32 drivers installed
    -   1.6 No audio on 64-bit systems
-   2 See also

Known issues
------------

> Game never progresses past initial loading

To fix this, set:

    LC_ALL=C

This is also relevant if you rocket's parts do not connect.

> No text display

The game requires Arial and Arial Black fonts, provided in the
ttf-ms-fonts AUR package.

> Graphics flickering when using primusrun

Run with PRIMUS_SYNC=2 (but you will get reduced frame rate this way)

> Game crashes when accessing settings or saves on 64 bit systems on Steam

In the properties for Kerbal Space program, set a launch option of:

    LC_ALL=C %command%_64

> Game has garbled graphics when running on x86_64 with all lib32 drivers installed

Steam launches the KSP.x86 executable vs the KSP.x86_64 executable.
Navigate to

    /home/$USER/.local/share/Steam/SteamApps/common/Kerbal\ Space\ Program/ 

Launch with

    ./KSP.x86_64

Alternatively, to launch it from steam, set the following launch option:

     %command%_64

> No audio on 64-bit systems

Run the 64-bit Executable.

Steam launches the KSP.x86 executable vs the KSP.x86_64 executable.
Navigate to

    /home/$USER/.local/share/Steam/SteamApps/common/Kerbal\ Space\ Program/ 

Launch with

    ./KSP.x86_64

Or you can simply right click on Kerbal Space Program on your game list,
click on Properties, click on SET LAUNCH OPTIONS, then add this:

    LD_LIBRARY_PATH="/usr/lib:$LD_LIBRARY_PATH" LC_ALL=C %command%_64

See also
--------

-   http://forum.kerbalspaceprogram.com/showthread.php/24529-The-Linux-compatibility-thread!

Retrieved from
"https://wiki.archlinux.org/index.php?title=Kerbal_Space_Program&oldid=303064"

Category:

-   Gaming

-   This page was last modified on 3 March 2014, at 18:24.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
