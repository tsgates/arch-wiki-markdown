Microsoft Office 2007
=====================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Install
    -   1.1 Office 2007 SP3
    -   1.2 Office 2007 Fonts
    -   1.3 Winetricks

Install
-------

Note: To work with JPG images (i.e. in PowerPoint) install lib32-lcms.

The following has been reported to work, using wine-1.5.0. See these
forum posts for details:

-   https://bbs.archlinux.org/viewtopic.php?id=138082
-   https://bbs.archlinux.org/viewtopic.php?id=86436

Or have a look at the install instructions on Wine's Application
Database

-   http://appdb.winehq.org/objectManager.php?sClass=version&iId=4992

Warning: You should never run Wine commands as root. Only run Wine as
your user.

To get office 2007 working, install bin32-wine, winetricks. This is
necessary if you are running a x64 Arch, but are using a 32bit Office
installer

    # pacman -S wine winetricks wine_gecko wine-mono

Then run:

    $ WINEARCH=win32 WINEPREFIX=~/win32 winecfg

A pop up will appear, set it to Windows XP, then run: (this download is
~1gb so be prepared)

    $ WINEPREFIX=~/win32 winetricks msxml3  gdiplus riched20 riched30 vcrun2005sp1 allfonts

Mount the installation image, then run:

    $ WINEPREFIX=~/win32 wine /path/to/office2007image/setup.exe

  
 To actually use any of the executables you must cd to the directory.
IE:

    $ cd ~/win32/drive_c/Program Files/Microsoft Office/Office12
    $ WINEPREFIX=~/win32 wine ./EXCEL.EXE

You could set WINEPREFIX in your .bash_profile, or make 32bit wine your
default (then you only have to do WINEARCH=win32 winecfg). Two reported
issues are accidentally emulating 64bit Windows instead of 32 bit and
that the programs hang if you don't cd into the directory, probably
because the dlls are linked with the local directory.

> Office 2007 SP3

To upgrade to Service Pack 3

Download from:
http://www.microsoft.com/en-us/download/details.aspx?id=27838

Install with:

    WINEPREFIX=~/win32 wine office2007sp3-kb2526086-fullfile-en-us.exe

> Office 2007 Fonts

To install the Office 2007 Fonts, (this probably isn't necessary)

First download ttf-office-2007-fonts from the AUR

Change to the directory you will be building the package, then run

    $ cabextract --filter *.TTF /path/to/office2007image/Enterprise.WW/EnterWW.cab

Then proceed to install the package as usual.

See MS Fonts for more details

> Winetricks

The droid font downloader in winetricks is broken. The URL is part of
the google git project. Either the maintainer of winetricks will update
or kernel.org will change. You can elect to remove the droid font
install from the winetricks script.

    sudo nano -w /usr/bin/winetricks

Search for: do_droid You should see this:

    do_droid() {
        w_download ${DROID_URL}$1';hb=HEAD'   $3  $1
        w_try cp -f "$W_CACHE"/droid/$1 "$W_FONTSDIR_UNIX"
        w_register_font $1 "$2"
    }

    load_droid()
    {
        # See http://en.wikipedia.org/wiki/Droid_(font)
        DROID_URL='http://android.git.kernel.org/?p=platform/frameworks/base.git;a=blob_plain;f=data/fonts/'
        do_droid DroidSans-Bold.ttf        "Droid Sans Bold"         560e4bcafdebaf29645fbf92633a2ae0d2f9801f
        do_droid DroidSansFallback.ttf     "Droid Sans Fallback"     64de2fde75868ab8d4c6714add08c8f08b3fae1e
        do_droid DroidSansJapanese.ttf     "Droid Sans Japanese"     b3a248c11692aa88a30eb25df425b8910fe05dc5
        do_droid DroidSansMono.ttf         "Droid Sans Mono"         133fb6cf26ea073b456fb557b94ce8c46143b117
        do_droid DroidSans.ttf             "Droid Sans"              62f2841f61e4be66a0303cd1567ed2d300b4e31c
        do_droid DroidSerif-BoldItalic.ttf "Droid Serif Bold Italic" b7f2d37c3a062be671774ff52f4fd95cbef813ce
        do_droid DroidSerif-Bold.ttf       "Droid Serif Bold"        294fa99ceaf6077ab633b5a7c7db761e2f76cf8c
        do_droid DroidSerif-Italic.ttf     "Droid Serif Italic"      bdd8aad5e6ac546d11e7378bdfabeac7ccbdadfc
        do_droid DroidSerif-Regular.ttf    "Droid Serif"             805c5f975e02f488fa1dd1dd0d44ed4f93b0fab4
    }

Comment it out with:

    #do_droid() {
    #    w_download ${DROID_URL}$1';hb=HEAD'   $3  $1
    #    w_try cp -f "$W_CACHE"/droid/$1 "$W_FONTSDIR_UNIX"
    #    w_register_font $1 "$2"
    #}

    #load_droid()
    #{
    #    # See http://en.wikipedia.org/wiki/Droid_(font)
    #    DROID_URL='http://android.git.kernel.org/?p=platform/frameworks/base.git;a=blob_plain;f=data/fonts/'
    #
    #    do_droid DroidSans-Bold.ttf        "Droid Sans Bold"         560e4bcafdebaf29645fbf92633a2ae0d2f9801f
    #    do_droid DroidSansFallback.ttf     "Droid Sans Fallback"     64de2fde75868ab8d4c6714add08c8f08b3fae1e
    #    do_droid DroidSansJapanese.ttf     "Droid Sans Japanese"     b3a248c11692aa88a30eb25df425b8910fe05dc5
    #    do_droid DroidSansMono.ttf         "Droid Sans Mono"         133fb6cf26ea073b456fb557b94ce8c46143b117
    #    do_droid DroidSans.ttf             "Droid Sans"              62f2841f61e4be66a0303cd1567ed2d300b4e31c
    #    do_droid DroidSerif-BoldItalic.ttf "Droid Serif Bold Italic" b7f2d37c3a062be671774ff52f4fd95cbef813ce
    #    do_droid DroidSerif-Bold.ttf       "Droid Serif Bold"        294fa99ceaf6077ab633b5a7c7db761e2f76cf8c
    #    do_droid DroidSerif-Italic.ttf     "Droid Serif Italic"      bdd8aad5e6ac546d11e7378bdfabeac7ccbdadfc
    #    do_droid DroidSerif-Regular.ttf    "Droid Serif"             805c5f975e02f488fa1dd1dd0d44ed4f93b0fab4
    #}

Save then execute the command from the installation section.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Microsoft_Office_2007&oldid=303126"

Categories:

-   Office
-   Wine

-   This page was last modified on 4 March 2014, at 08:19.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
