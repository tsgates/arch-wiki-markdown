Lostfiles
=========

Lostfiles is a script for detecting orphaned files (files which are not
owned by any Arch Linux packages).

The script ignores by default a series of directories where packages
should not install files. Some files might appear as removed if they're
placed in those directories which are not checked.

Script source
-------------

    #!/bin/bash

    # LostFiles v0.2
    # License: GPL v2.0 http://www.gnu.org/licenses/gpl.html

    # Initially scripted by the Arch Linux Community
    # Mircea Bardac (dev AT mircea.bardac.net)
    # http://mircea.bardac.net/
    # Modified by Jan Janssen

    # Description:
    # Search for files which are not part of installed Arch Linux packages

    # Usage:
    #  lostfiles > changes
    # changes is a file containing a list of added/removed files

    if [ $UID != "0" ]; then
           echo "You must run this script as root." 1>&2
           exit
    fi
    comm -3 \
    	<(pacman -Qlq | sed -e 's|/$||' | sort -u) \
    	<(find / -not \( \
    		-wholename '/dev' -prune -o \
    		-wholename '/etc/ssl' -prune -o \
    		-wholename '/home' -prune -o \
    		-wholename '/lost+found' -prune -o \
    		-wholename '/media' -prune -o \
    		-wholename '/mnt' -prune -o \
    		-wholename '/proc' -prune -o \
    		-wholename '/root' -prune -o \
    		-wholename '/run' -prune -o \
    		-wholename '/sys' -prune -o \
    		-wholename '/tmp' -prune -o \
    		-wholename '/usr/share/mime/application' -prune -o \
    		-wholename '/usr/share/mime/audio' -prune -o \
    		-wholename '/usr/share/mime/image' -prune -o \
    		-wholename '/usr/share/mime/inode' -prune -o \
    		-wholename '/usr/share/mime/interface' -prune -o \
    		-wholename '/usr/share/mime/message' -prune -o \
    		-wholename '/usr/share/mime/multipart' -prune -o \
    		-wholename '/usr/share/mime/text' -prune -o \
    		-wholename '/usr/share/mime/uri' -prune -o \
    		-wholename '/usr/share/mime/video' -prune -o \
    		-wholename '/usr/share/mime/x-content' -prune -o \
    		-wholename '/var/abs' -prune -o \
    		-wholename '/var/cache' -prune -o \
    		-wholename '/var/lock' -prune -o \
    		-wholename '/var/lib/pacman' -prune -o \
    		-wholename '/var/run' -prune -o \
    		-wholename '/var/tmp' -prune \) | sort -u \
    		-wholename '/var/log' -prune \) | sort -u \
    	) | sed -e 's|^\t||;'

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lostfiles&oldid=253652"

Category:

-   Scripts
