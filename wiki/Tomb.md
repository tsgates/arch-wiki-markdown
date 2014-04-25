Tomb
====

Related articles

-   Disk Encryption
-   TrueCrypt
-   Tcplay

From the official website:

Tomb is 100% free and open source software to make strong encryption
easy to use.

A tomb is like a locked folder that can be safely transported and hidden
in a filesystem.

Keys can be kept separate: for instance the tomb on your computer and
the key on a USB stick.

Tomb aims to be a really simple to use software to manage "encrypted
directories", called tombs. A tomb can only be opened if you both have a
keyfile and you know the password. It also has advanced features, like
steganography.

You can install tomb from the Arch User Repository.

Contents
--------

-   1 Installation
    -   1.1 Bleeding edge
-   2 Using tomb
-   3 Tomb Usage
-   4 Advanced features
-   5 See also

Installation
------------

tomb is not present in the official repositories, but has his own (out
of date) repository:

    [crypto]
    SigLevel = Required
    Server=http://tomb.dyne.org/arch_repo/$arch

add these two lines to your /etc/pacman.conf, then

    pacman -Syyu
    pacman -S crypto/tomb

Otherwise, you can install tomb, available in the Arch User Repository.

> Bleeding edge

If you want to check out the development version, you can install
tomb-git from the "crypto" repo (the same as above), or tomb-git from
the Arch User Repository.

Using tomb
----------

Tomb is meant to be used from the console as a single, non-interactive
script. it also provides tomb-open, which is a simple interactive script
to help you create a tomb, open it, retrieve keys from USB.

Its typical usage is something like

    tomb create /path/to/mysecret.tomb -s 200
    tomb open /path/to/mysecret.tomb

This will create a 200MB tombfile, placing the key just next to the tomb
(which is bad for security).

tomb-open is much simpler. Calling it without arguments will launch a
wizard for tomb creation; it will provide a simple way to put the
keyfile on a usb key, to provide effective two-factor authentication.
Calling it with a single argument will try to open the specified tomb:

    $ tomb-open /path/to/mysecret.tomb

Even in this case, support for retrieving the key from USB is
automagical.

Tomb Usage
----------

    Syntax: tomb [options] command [file] [place]

    Commands:
    create     create a new tomb FILE and its keys
    open       open an existing tomb FILE on PLACE
    list       list all open tombs or the one called FILE
    close      close the open tomb called FILE (or all)
    slam       close tomb FILE and kill all pids using it
    passwd     change the password of a tomb key FILE

    Options:
    -s     size of the tomb file when creating one (in MB)
    -k     path to the key to use for opening a tomb
    -n     don't process the hooks found in tomb
    -o     mount options used to open (default: rw,noatime,nodev)
    -h     print this help
    -v     version information for this tool
    -q     run quietly without printing informations
    -D     print debugging information at runtime

Advanced features
-----------------

-   steganography (to hide the key inside a jpeg/wav file)
-   bind hooks: can mount some of its subdirectories as "bind" to some
    other. Suppose, for example, you would like to encrypt your .Mail,
    .firefox and Documents directories. Then you can create a tomb which
    contains these subdirectories (and others too, if you want) and
    create a simple configuration file inside the tomb itself; when you
    run tomb open it will automatically bind that directories into the
    right places. This way you will easily get an encrypted firefox
    profile, or maildir.
-   post hooks: commands that are run when the tomb is open, or closed.
    You can imagine lot of things for this: open files inside the tomb,
    put your computer in a "paranoid" status (for example, disabling
    swap), whatever.

See also
--------

-   manpage
-   home page
-   quickstart
-   advanced features

Retrieved from
"https://wiki.archlinux.org/index.php?title=Tomb&oldid=302169"

Category:

-   Security

-   This page was last modified on 26 February 2014, at 05:22.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
