Maya
====

How to install Maya8.5-x64 on Arch64.

Contents
--------

-   1 Introduction
-   2 Dependencies
-   3 Installation
    -   3.1 Installing Maya
    -   3.2 Installing License
-   4 Troubleshooting
    -   4.1 Refresh Problems with Nvidia
    -   4.2 Crash with signal 11
    -   4.3 Syntax Error when using any "Edit Mesh" commands
    -   4.4 Other Known Issues
-   5 More Resources

Introduction
------------

This is a step-by-step how-to for installing Maya8.5-x64 on Arch 64.
Though this was done on Arch64, the following should be able to be done
the exact same on Arch32 (with the exception of some name changes
[instead of *-x64*, use *-i686*]).

This was accomplished on Arch64 2.6.24.1-2 with AMD X2 4000+ and Nvidia
7600GT with XFCE4 + Compiz-Fusion 0.6.2-4.

Maya 2008 will most likely be the same, though I have not tested this.

This how-to largely derives from the Gentoo wiki article (no longer
exists).

Dependencies
------------

Install dependencies of Maya8.5-x64:

    pacman -S tcsh fam rpmextract libxp libxpm libxprintapputil libxprintutil

gamin may be used instead of fam

Maya is going to refer to /bin/csh, so create a symlink.

    ln -s /usr/bin/tcsh /bin/csh

Installation
------------

> Installing Maya

Pop in your Maya8.5 DVD and create a directory.

    mkdir ~/maya

Copy the contents of Maya/linux on the DVD to ~/maya

Then change into the directory you created and extract the rpms.

    cd ~/maya
    rpmextract.sh ./AWCommon-10.80-15.x86_64.rpm
    rpmextract.sh ./AWCommon-server-10.80-15.x86_64.rpm
    rpmextract.sh ./Maya64-8.5-159.x86_64.rpm

For i686 use:

    rpmextract.sh ./AWCommon-10.80-15.i686.rpm
    rpmextract.sh ./AWCommon-server-10.80-15.i686.rpm
    rpmextract.sh ./Maya64-8.5-159.i686.rpm

If you have any Service Packs, then extract in the same fashion.

Once extracted you should have a ./usr directory complete with Maya8.5.
You do not need these rpm's any longer.

    rm ./*.rpm

Lets move those files to their correct place: (as root)

    cd ./usr
    cp -R ./autodesk /usr
    cp -R ./aw /usr

And remove that temp directory entirely (as previous user status)

    rm -R ~/maya

Create symlinks to /usr/local/bin (as root again)

    cd /usr/local/bin
    ln -s /usr/autodesk/maya8.5-x64/bin/fcheck fcheck
    ln -s /usr/autodesk/maya8.5-x64/bin/Maya8.5 maya
    ln -s /usr/autodesk/maya8.5-x64/bin/imgcvt imgcvt
    ln -s /usr/autodesk/maya8.5-x64/bin/Render Render

For i686 link to binaries in /usr/autodesk/maya8.5/bin/ instead.

Create symlinks for Maya

    cd /usr/autodesk
    ln -s maya8.5-x64 maya    # ln -s maya8.5 maya  #for Arch32
    cd ./maya8.5-x64/bin      # cd ./maya8.5/bin    #for Arch32
    ln -s Maya8.5 maya

Symlink the menu entries: (optional)

    ln -sf /usr/autodesk/maya8.5-x64/desktop/Autodesk-Maya.desktop /usr/share/applications/Autodesk-Maya.desktop
    ln -sf /usr/autodesk/maya8.5-x64/desktop/Autodesk-Maya.directory /usr/share/desktop-directories/Autodesk-Maya.directory
    ln -sf /usr/autodesk/maya8.5-x64/desktop/Maya.png /usr/share/icons/hicolor/48x48/apps/Maya.png

For Arch 32, just replace maya8.5-x64 from above with maya8.5

> Installing License

I already had an aw.dat license file, and if you do you simply need
copy: (as root)

    mkdir /var/flexlm
    cp /path/to/license/aw.dat /var/flexlm

The license wizard is known to run on my Arch32 2.6.24.1-2 box with
Gnome 2.20 and ATI Radeon 9600XT (catalyst 8.02-1); however, remains
untested on Arch64. If you have tested this and it works, please modify
this page

Troubleshooting
---------------

> Refresh Problems with Nvidia

If you use an Nvidia Card and are having refresh problems then create
/usr/bin/mayastart:

    #!/bin/bash

    export XLIB_SKIP_ARGB_VISUALS=1
    /usr/autodesk/maya/bin/maya

Then give it the correct permissions

    chmod +x /usr/bin/mayastart

> Crash with signal 11

If maya crashes with a message like this:

     maya encountered a fatal error
     
     Signal: 11 (Unknown Signal)

First, try to get more information by setting this environment variable:

     export MAYA_DEBUG_ENABLE_CRASH_REPORTING=1

and start maya again.

Now it produces more output and generates a crash-report with a
backtrace under /usr/tmp. If this report shows something like this:

     [0xb7f96420]
     Tscreen::loadXWindowsScreenInfo(Tscreen::TwhichMonitor, Trect&)
     Tscreen::Tscreen(Tscreen::TwhichMonitor)
     TstartupWnd::unStow(Tevent const&)
     /usr/autodesk/maya2008/bin/maya.bin [0x80594d3]
     /usr/autodesk/maya2008/bin/maya.bin [0x8057258]
     /usr/autodesk/maya2008/bin/maya.bin [0x8054e23]
     /usr/autodesk/maya2008/bin/maya.bin [0x80640d6]
     __libc_start_main
     __gxx_personality_v0

try to enable Xinerama in your xorg.conf file (/etc/X11/xorg.conf) by
installing the appropriate packages and adding the line

     Option "Xinerama" "true"

within the Section "ServerLayout".

> Syntax Error when using any "Edit Mesh" commands

At the moment, there is a bug between the Maya GUI and its commandline
interface. The commandline interface cannot interpret "," as a numeric
separator and therefore all commands parsed under a system locale using
"," instead of "." will fail to run. This could happen if you use
en_DK.utf8 as locale. Fix this by running maya using:

     LC_NUMERIC="C" /usr/autodesk/maya/bin/maya

> Other Known Issues

Maya was not built to be compatible with compositing managers such as
Beryl, Compiz, Compiz-Fusion, etc. You may need to edit your
/etc/X11/xorg.conf and turn off "Composite"

    Section "Extensions"
     Option "Composite" "Disable"
    EndSection

More Resources
--------------

Links that might help you solve another issue:

-   Ubuntu Forums

Retrieved from
"https://wiki.archlinux.org/index.php?title=Maya&oldid=276525"

Categories:

-   Graphics and desktop publishing
-   Arch64

-   This page was last modified on 24 September 2013, at 14:57.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
