Remmina
=======

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: Installation     
                           instructions. Sparse     
                           writing. (Discuss)       
  ------------------------ ------------------------ ------------------------

Remmina is a remote desktop client written in GTK+. It supports:

-   SSH
-   VNC
-   RDP
-   NX
-   SFTP
-   XDMCP

Installation
------------

    # pacman -S remmina freerdp

Application menu shortcut/icon
------------------------------

    ~/.local/share/applications/remmina.desktop

    [Desktop Entry]
    Version=1.0
    Encoding=UTF-8
    Name=Remmina
    Comment=A remote desktop client
    Exec=remmina
    Icon=remmina
    Terminal=false
    Type=Application
    Categories=Application;Network;

Using from command line
-----------------------

You can do

    $ remmina -c ~/.remmina/file-name.remmina

to open previously saved connection profile.

Here is the script, which renames connection profile files basing on
name= property to make it human readable.

    #!/bin/bash
    cd ~/.remmina
    ls -1 *.remmina | while read a; do
           N=`grep '^name=' $a | cut -f2 -d=`;
           [ "$a" == "$N.remmina" ] || mv $a "$N".remmina;
    done

Retrieved from
"https://wiki.archlinux.org/index.php?title=Remmina&oldid=282549"

Category:

-   Remote Desktop

-   This page was last modified on 13 November 2013, at 07:44.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
