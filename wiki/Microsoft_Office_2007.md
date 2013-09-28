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

But it is still useful!

Install
-------

(21/3/2012)

Note: To work with JPG images (i.e. in PowerPoint) install lib32-lcsm.

(21/3/2012)

The following worked for me, using wine-1.5.0. The instructions below
and the instructions on WineHQ
(http://appdb.winehq.org/objectManager.php?sClass=version&iId=4992)
didnt.

https://bbs.archlinux.org/viewtopic.php?id=138082

(10.25.11)

This works great:

From forum post: https://bbs.archlinux.org/viewtopic.php?id=86436

Note: You should never run wine commands as root. Run it as your user.

...to get office 2007 working for me I installed bin32-wine, winetricks
and then ran:

    $ WINEARCH=win32 WINEPREFIX=~/win32 winecfg
    and set windows to xp and then ran:

Note: See winetricks section below!!!

    $ WINEPREFIX=~/win32 winetricks msxml3  gdiplus riched20 riched30 vcrun2005sp1 allfonts
    $ WINEPREFIX=~/win32 wine setup.exe
    and then to actually use any of the executables you must cd to the directory. IE:
    $ cd ~/win32/drive_c/Program Files/Microsoft Office/Office12
    $ WINEPREFIX=~/win32 wine ./EXCEL.EXE

You could set WINEPREFIX in your bash_profile, or make 32bit wine your
default (then you only have to do WINEARCH=win32 winecfg). Anyway the
two main problems I had were accidentally emulating 64bit (I know Wine
Is Not Emulation) windows instead of 32 bit. Also I found that the
programs hang if I didn't cd into the directory, probably because the
dlls are linked with the local directory. Anyway everything works this
way.

Note: I did not have to run via command or script like the guy does
though. To execute the software I could just open it from the
applicaiton menu.

> Office 2k7 SP2

Download from:
http://www.microsoft.com/download/en/confirmation.aspx?id=5

Install with:

    WINEPREFIX=~/win32 wine office2007sp2-kb953195-fullfile-en-us.exe

> Winetricks

The droid font downloader in winetricks is broken. The url is part of
the google git project atm. Either the maintainer of winetricks will
update or kernel.org will change. I just chose to remove the droid font
install from the winetricks script. I think you could create a .netrc
file with password information in it but I did not test it or do it this
way.

If you visit:
http://android.git.kernel.org/?p=platform/frameworks/base.git;a=blob_plain;f=data/fonts/
and generate a password in a webbrowser then put it in ~/.netrc , then
run the script without comments...might work.

This is what I did:

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
"https://wiki.archlinux.org/index.php?title=Microsoft_Office_2007&oldid=251876"

Categories:

-   Office
-   Wine
