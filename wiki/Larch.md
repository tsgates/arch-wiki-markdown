Larch
=====

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Larch is a live CD construction kit for Arch Linux created in early 2006
by gradgrind (Michael Towers). Targeted at those who prefer the DIY
approach, the aim is to produce an easily customizable custom
installation/rescue CD that is more like a desktop environment than the
stock Arch installation CD. The latest version is 8. Interesting
features are the creation of USB sticks with ext4 with no journaling and
a root overlay for maximum customization.

Full documentation is available on the project's website (see #External
Resources below).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Project Setup                                                      |
| -   3 Install Tab                                                        |
| -   4 Adding AUR packages                                                |
| -   5 Larchify                                                           |
| -   6 Make medium                                                        |
| -   7 Pro-tips                                                           |
| -   8 External Resources                                                 |
+--------------------------------------------------------------------------+

Installation
------------

Install the larch package which is found in the AUR.

Next step is to download the install script. Put this script in its own
directory, and then chmod +x it and then run it. It should automatically
download the rest of larch. Running ./larch will now launch the GUI
version of larch.

Note:AUFS2 is no longer a part of Arch. This breaks larch horribly.
Still working on a fix, stay tuned (please update this page if you find
one).

Project Setup
-------------

There are four tabs that you can use to customize your larch CD with,
meant to be used in order. The first tab is "Project Settings". With
"browse for Profile" you can load a saved project from a disk, Generally
projects are saved as directories in ~/.config/larch/profiles/.

The "installation path" text box lets you customize the location of
where you want a copy of the live CD installed when you are working on
it. This is, in a sense, a full copy of an Arch Linux installation to be
the basis of your live CD/USB stick. If you need to adapt an install
guide from elsewhere on the wiki, chroot into this location.

Install Tab
-----------

This tab uses its own version of pacman to install an Arch system on
your hard disk in the location specified previously, maintain it.
"addedpacks" is a text file list of all packages you want installed.
These packages HAVE to be in the official repositories and not in the
AUR. "vetopacks" is a list of packages that will be prevented from being
installed. There is also a button to edit local /etc/pacman.conf options
and repositories lists. When you have everything set, you may hit the
install button in the lower right corner.

Adding AUR packages
-------------------

Find a machine running Arch Linux, download the AUR package, and build
it. Now bring it to the machine larch is running on, and install it with
the button that says "Update / Add packages -U". Done AFTER install.

Larchify
--------

Once you have installed you are going to want to configure, tune, tweak
and customize your install. The edit root overlay will open a root
overlay (part of your profile in ~/.config/larch/profiles/) to add
config files. You will probably want to adapt things from here
Beginners' Guide. Make sure all packages you need are added in the
installation tab.

Tip:You probably do not want to use a desktop manager, and instead go
right to a desktop. Everything you want in /home/$user on your live CD
should go in /etc/skel/ in root the overlay.

Note:After every change, you need to hit the "Larchify" button for it to
be re-rolled into a new squash file. Caution, this may take some time.

Make medium
-----------

Either make an ISO, or directly write to a flash disk. For a USB disk,
select "writable medium", and then select a valid partition on a block
device. This will format the partition with ext4, with no journal, make
a master boot record (MBR) and make the partition bootable.

From this tab you may also edit the boot menu entries (extlinux4), and
any files you want to add to the CD root (not in the squash file, such
as your own boot menu image). in the options line using "nw" will
prevent any writes to the medium, if possible when running the live CD.
Arbitrary, non-defined options can be passed on to scripts via
/proc/cmdline.

Pro-tips
--------

-   Version 8 ships with a now outdated version of pacman, but this is
    able to be fixed. To fix this, go download the package via
    archlinux.org website, unzip the package, and take pacman from
    usr/bin/ and everything in usr/lib/ in the package root and copy it
    to $INSTALLDIR/larch0/lib/

-   To get the best results, make a "dev-stick", get an otherwise unused
    USB flash drive, format it with two paritions—the first that will
    contain your live OS and the second will contain an empty FAT
    partition. Install larch on the boot partition, do a preliminary
    boot, test everything out, configure settings to your liking, then
    copy everything in /home/$USER to the FAT partition, boot back into
    your normal OS, and then copy it into the root overlay in /etc/skel.
    Now your settings are saved, forever and ever.

External Resources
------------------

-   larch home - Official project website
-   Larch Documentation
-   Arch Linux Forums - The original Larch thread

Retrieved from
"https://wiki.archlinux.org/index.php?title=Larch&oldid=205728"

Category:

-   Live Arch systems
