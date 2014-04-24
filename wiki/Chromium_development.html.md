Chromium development
====================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: bad practises     
                           described, see ArchWiki  
                           talk:Reports#Chromium    
                           development (Discuss)    
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Introduction
-   2 Install prerequisite packages
-   3 Initial setup
    -   3.1 Setup environment
    -   3.2 Install Depot Tools
-   4 Download chromium code
-   5 Generate ninja build files
-   6 Build
    -   6.1 Build and install chromium sandbox
    -   6.2 Build Content shell
    -   6.3 Build Chromium
    -   6.4 Run Chromium

Introduction
------------

This article assumes that you are building Chromium from source in a
64-bit Arch Linux.

Install prerequisite packages
-----------------------------

    ~ $ yaourt -Sy --needed python python2 perl gcc gcc-libs bison flex gperf pkgconfig nss alsa-lib gconf glib2 gtk2 nspr ttf-ms-fonts freetype2 cairo dbus libgnome-keyring git vim ccache distcc bash

Initial setup
-------------

> Setup environment

Add the following lines into your ~/.bashrc

    alias cd='cd -P'

    # NaCl (Native Client) requires 32-bit libraries so it won't work in a pure 64-bit Arch Linux
    # werror= will prevent the build from stopping when a warning occurs
    # Using shared libraries will reduce the LINK time
    export GYP_DEFINES="disable_nacl=1 werror= component=shared_library"

    export CCACHE_BASEDIR="${HOME}/src"
    export CCACHE_SLOPPINESS="include_file_mtime"
    export CHROME_DEVEL_SANDBOX="${HOME}/bin/chrome-devel-sandbox"
    export PATH="${HOME}/bin:${PATH}"

Create ~/bin/python with the following content. Make the file executable
with chmod +x ~/bin/python This Bash script will blacklist depot_tools
and chromium from running python3 and will ensure they use python2
instead.

    #!/bin/bash
    script=`readlink -f -- "$1"`
    case "$script" in (${HOME}/src/depot_tools/*|${HOME}/src/chromium/*)
        exec python2 "$@"
        ;;
    esac
    exec python3 "$@"

> Install Depot Tools

This will clone the depot tools git repository

    ~ $ cd src
    ~/src $ git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git

Add the following line to your ~/.bashrc

    export PATH="${PATH}:${HOME}/src/depot_tools"

Download chromium code
----------------------

This will use the depot tools to download the chromium project from
several repositories. It will take a while so be patient.

    ~ $ mkdir src/chromium
    ~ $ cd src/chromium
    ~/src/chromium $ fetch --nohooks chromium --nosvn=True

Edit ~/src/chromium/.gclient and set safesync_url's value to
https://chromium-status.appspot.com/git-lkgr

Generate ninja build files
--------------------------

Ninja is a type of meta-build tool that precomputes all dependencies
ahead of time so it doesn't need to process dependencies during the
actual build. This allows the developer to rebuild the project much
faster because the dependencies are computed only once.

    ~ $ cd src/chromium
    ~/src/chromium $ gclient sync

Build
-----

> Build and install chromium sandbox

    ~ $ cd src/chromium/src
    ~/src/chromium/src $ ninja -C out/Release chrome_sandbox
    ~/src/chromium/src $ cp out/Release/chrome_sandbox ${HOME}/bin/chrome-devel-sandbox
    ~/src/chromium/src $ cd ${HOME}/bin
    ~/bin $ sudo chown root:root chrome-devel-sandbox
    ~/bin $ sudo chmod 4755 chrome-devel-sandbox

> Build Content shell

The content shell is a lightweight version of the Chromium browser and
it builds much faster than the full browser. It uses all the
multithreaded/multiprocess code paths that is used by the Chromium
browser so it's a good way to test code changes.

    ~ $ cd src/chromium/src
    ~/src/chromium/src $ ninja -j10 -C out/Debug content_shell

> Build Chromium

This will build the full chromium browser

    ~ $ cd src/chromium/src
    ~/src/chromium/src $ ninja -j10 -C out/Debug chrome

> Run Chromium

    ~ $ cd src/chromium/src/out/Debug
    ~/src/chromium/src/out/Debug $ ./chrome

Retrieved from
"https://wiki.archlinux.org/index.php?title=Chromium_development&oldid=303654"

-   This page was last modified on 8 March 2014, at 21:52.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
