Arch Handbook
=============

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

-   1 Notice
-   2 Getting Started
    -   2.1 Introduction
    -   2.2 Installing Arch Linux
    -   2.3 Linux Basics
    -   2.4 Installing, removing, updating and managing software: pacman
    -   2.5 Graphical Desktop Environments
-   3 Common Tasks
    -   3.1 Desktop Applications
    -   3.2 Multimedia
    -   3.3 Printing
-   4 System Administration
    -   4.1 Configuration and Tuning
    -   4.2 Users and Basic Account Management
-   5 Networking
    -   5.1 Network Configuration
    -   5.2 Servers
    -   5.3 Firewalls

Notice
------

This handbook has only just been started. It's currently a rather bare
outline. Please edit it and make it better! Look at the FreeBSD Handbook
as a style guide.

Most sections should be a summary, with a link to the main article on
the subject.

Getting Started
---------------

> Introduction

Arch linux is a lightweight and flexible linux distribution that tries
to Keep It Simple. There are official packages optimized for the i686
and x86-64 architectures. There is also a community-operated package
repository. See the pages in this category

> Installing Arch Linux

The full install guide is here and the install CDs are available here.
If you would like a more detailed installation guide, please see the
Beginners' guide.

> Linux Basics

A few basics on the file system and command line, for people starting
Unix/Linux with Arch.

How to change directory:

    cd /name/of/directory

e.g.

    cd /etc/pacman.d

How to make a directory:

    mkdir /path/to/new/directory

e.g.

    mkdir /home/archuser/newfolder

How to remove an empty directory:

    rmdir /path/to/empty/directory

How to remove a directory and all its content:

    rm -r /path/to/directory

How to list files in a directory:

All files: (except hidden files)

    ls

All files: (including hidden files)

    ls -a

All files, hidden files and their properties:

    ls -la

Files with the .avi file extension only:

    ls *.avi

How to move a file:

    mv /path/to/old/file.ext /path/to/new/file.ext

e.g.

    mv /home/archuser/compressed.zip /home/archuser/myfiles/compressed2.zip

How to copy a file:

    cp /path/to/file.txt /path/to/copied/file.txt

How to remove a file:

    rm /path/to/file.txt

e.g.

    rm /home/archuser/file.txt

How to show the contents of a file:

    cat /path/to/file.txt

How to make a file executable:

    chmod +x /path/to/script.sh

How to (search the entire filesystem for) a file called euwfh.avi

    cd /

    find -name euwfh.avi

How to mount a partition:

    mount /dev/sdX1 /media/mountpoint

e.g.

    mount /dev/sda1 /media/folder

  
 How to show how much space is left/used on (all mounted) partitions:

    df -h

How to show all running processes:

    ps -A

How to stop an annoying process called "EvilTrojan":

    killall EvilTrojan

How to show an unintelligible manual for a program "ultracompressor"

    man ultracompressor

> Installing, removing, updating and managing software: pacman

See pacman.

> Graphical Desktop Environments

See Desktop environment.

Common Tasks
------------

> Desktop Applications

Web browsers, office suites, etc.

> Multimedia

Video players, music jukeboxes, photo management, how to get codecs.

> Printing

CUPS installation and configuration, finding drivers.

System Administration
---------------------

> Configuration and Tuning

Systemd is used for most administrative tasks.

> Users and Basic Account Management

Creating and managing users with command-line utilities.

Users are created with useradd. See Users and groups for more
information.

Networking
----------

> Network Configuration

How networks are set up in Arch.

> Servers

Mail, web, SSH server installation and configuration.

> Firewalls

See Firewalls, iptables, Simple stateful firewall.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Arch_Handbook&oldid=302035"

Categories:

-   Getting and installing Arch
-   System administration

-   This page was last modified on 25 February 2014, at 13:04.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
