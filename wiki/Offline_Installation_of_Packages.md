Offline Installation of Packages
================================

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

-   1 Normal Method: Pacman
    -   1.1 A slightly contrived example
        -   1.1.1 Generate a list of packages to download
        -   1.1.2 Download the packages and their dependencies
        -   1.1.3 Create a repository database just for these packages
        -   1.1.4 Transfer the packages
        -   1.1.5 Install the packages
        -   1.1.6 Links and sources
-   2 Simpler Method: Powerpill Portable
    -   2.1 Requirements
        -   2.1.1 Unconnected Computer
        -   2.1.2 Connected Computer
    -   2.2 Steps

Normal Method: Pacman
---------------------

This method is based on byte's post from this thread.

Download the package databases on a computer with internet access and
transfer them to your computer.

For i686:

-   ftp://ftp.archlinux.org/core/os/i686/core.db.tar.gz
-   ftp://ftp.archlinux.org/core/os/i686/core.db
-   ftp://ftp.archlinux.org/extra/os/i686/extra.db.tar.gz
-   ftp://ftp.archlinux.org/extra/os/i686/extra.db
-   ftp://ftp.archlinux.org/community/os/i686/community.db.tar.gz
-   ftp://ftp.archlinux.org/community/os/i686/community.db
-   ftp://ftp.archlinux.org/multilib/os/i686/multilib.db.tar.gz

For x86_64:

-   ftp://ftp.archlinux.org/core/os/x86_64/core.db.tar.gz
-   ftp://ftp.archlinux.org/core/os/x86_64/core.db
-   ftp://ftp.archlinux.org/extra/os/x86_64/extra.db.tar.gz
-   ftp://ftp.archlinux.org/extra/os/x86_64/extra.db
-   ftp://ftp.archlinux.org/community/os/x86_64/community.db.tar.gz
-   ftp://ftp.archlinux.org/community/os/x86_64/community.db
-   ftp://ftp.archlinux.org/multilib/os/x86_64/multilib.db.tar.gz
-   ftp://ftp.archlinux.org/multilib/os/x86_64/multilib.db

  
 Following steps will make sure you're working with up-to-date package
lists, as if you ran pacman -Sy.

On offline PC , do the following as root:

    mkdir -p /var/lib/pacman/sync/{core,extra,community}
    rm -r /var/lib/pacman/sync/{core,extra,community}/*
    tar -xzf core.db.tar.gz      -C /var/lib/pacman/sync/core
    tar -xzf extra.db.tar.gz     -C /var/lib/pacman/sync/extra
    tar -xzf community.db.tar.gz -C /var/lib/pacman/sync/community
    tar -xzf multilib.db.tar.gz  -C /var/lib/pacman/sync/multilib
    rm -r /var/lib/pacman/sync/*.db
    cp core.db /var/lib/pacman/sync/
    cp extra.db /var/lib/pacman/sync/
    cp community.db /var/lib/pacman/sync/

    pacman -Sp --noconfirm package-name > pkglist

Tip:Be aware you have enabled at least one of the servers defined in the
/etc/pacman.d/mirrorlist file. Otherwise all what you get is a
misleading error message:

  

error: no database for package: package-name

To update a New Arch Linux base system after installation you may enter

    pacman -Sup --noconfirm > pkglist

Now open that textfile with an editor and delete all lines that are not
URLs. Next, bring that list with you to a place where you have internet
and either download the listed packages manually or do

    wget -nv -i ../pkglist

in an empty directory. Take all the *.pkg.tar.gz files back home, put
them in /var/cache/pacman/pkg and finally run

    pacman -S package-name

> A slightly contrived example

Scenario: you have two Archlinux machines, 'Al' (with internet
connection) and 'Bob' (without internet connection), and you need to
install some nvidia packages and their dependencies on 'Bob'. Let's say
the wanted packages are nvidia, nvidia-utils and xf86-video-nouveau, but
you want to use a dedicated directory instead of /var/cache/pacman/pkg/
and a dedicated repository called nvidia (instead of the usual core,
extra etc...)

Generate a list of packages to download

This can be done on any Archlinux machine which has up-to-date
repository data bases (see above for links to database files); to create
the list of links to the required packages, use:

    pacman -Sp nvidia nvidia-utils xf86-video-nouveau > /path/to/nvidia.list

The file nvidia.list will contain links to the listed packages and any
others which they depend on.

Download the packages and their dependencies

Obviously this requires an internet connection, so on 'Al' create a
directory called /path/to/nvidia for the files and run:

    wget -P /path/to/nvidia/ -i /path/to/nvidia.list

Create a repository database just for these packages

This can be done on either 'Al' or 'Bob' using the repo-add command
which comes with pacman (from version 3?); first, change to the
/path/to/nvidia directory where the packages were downloaded, then
create database file called nvidia.db.tar.gz:

    cd /path/to/nvidia
    repo-add nvidia.db.tar.gz *.pkg.tar.gz

Transfer the packages

Now all the packages have been downloaded, you do not need 'Al' anymore.
Copy the contents of /path/to/nvidia to a the temporary nvidia packages
cache directory on 'Bob', let's say this folder is called
/home/me/nvidia:

    cp /path/to/nvidia/* /home/me/nvidia

Next, pacman must be made aware of this new repository of packages;
simply add the following lines at the bottom of your existing
pacman.conf:

    [nvidia]
    Server = file:///home/me/nvidia

Now, instruct pacman to synchronise with the dedicated nvidia repository
we created:

    pacman -Sy 

This command finds the nvidia.db.tar.gz file in /home/me/nvidia and
expands it to /var/lib/pacman/sync/nvidia to create a database of
packages contained in the nvidia repository.

  

Install the packages

Finally install the packages:

    pacman -S nvidia nvidia-utils xf86-video nouveau

Links and sources

Compiled from the forums, with thanks to Heller_Barbe and byte

Simpler Method: Powerpill Portable
----------------------------------

Powerpill Portable is a tool created by Xyne to simplify offline
updates. It has the following requirements:

Warning:Powerpill development has been officially discontinued: its
latest version does not work with pacman>=3.5. See [1].

> Requirements

Unconnected Computer

-   powerpill
-   rsync

Connected Computer

-   perl
-   aria2

The connected computer does not need to be running Arch or have Pacman
installed.

> Steps

An enumerated list of steps can be found here.

Basically, simply download the Powerpill Portable script and run it on
the unconnected computer. It will create a directory named "portable"
and copy some files into it (the local database and everything needed to
run powerpill-portable on another system, minus perl itself and aria2).
Simply take the directory to the connected computer (e.g. on a USB
stick) and run the "pp" script in it on that system as though it were
pacman, e.g. "pp -Syu foo bar". It will download the databases and
packages into the portable directory. When you're done, bring the
directory back to your unconnected computer, run the "sync" script in
the portable directory, then simply run the same command(s) that you ran
with pp using pacman, e.g. "pacman -Syu foo bar".

Your system is now up-to-date. Simply repeat the steps to keep it that
way.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Offline_Installation_of_Packages&oldid=252758"

Category:

-   Package management

-   This page was last modified on 3 April 2013, at 06:54.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
