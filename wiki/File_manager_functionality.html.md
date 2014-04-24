File manager functionality
==========================

Related articles

-   PCManFM
-   Thunar
-   Window manager
-   Desktop environment

This article outlines the additional software packages necessary to
expand the features and functionality of file managers, particularly
where using a window manager such as Openbox. The ability to access
partitions and removable media without a password - if affected - has
also been provided.

Contents
--------

-   1 Overview
-   2 Additional Features and Functionality
    -   2.1 Internal Partitions
    -   2.2 Removable Media
    -   2.3 Auto-Mount Removable Media
        -   2.3.1 File Manager Daemon
        -   2.3.2 Udiskie
        -   2.3.3 udevil/devmon
    -   2.4 Networks
        -   2.4.1 Windows access
        -   2.4.2 Apple access
    -   2.5 Thumbnail Previews
        -   2.5.1 File managers other than Dolphin and Konquerer
        -   2.5.2 Dolphin and Konquerer (KDE)
    -   2.6 Archive Files
    -   2.7 NTFS read/write support
    -   2.8 Desktop Notifications
-   3 Troubleshooting
    -   3.1 Password required to access partitions and removable Media

Overview
--------

Note:When installed, the software packages listed below will
automatically be sourced by all installed - and capable - file managers,
and within all desktop environments and/or window managers.

A file manager alone will not provide the features and functionality
that users of full desktop environments such as XFCE or KDE will be
accustomed to. This is because additional software packages will be
required to enable a given file manager to:

-   Display and access other partitions
-   Display, mount, and access removable media (e.g. USB sticks, optical
    discs, and digital cameras)
-   Enable networking / shared networks with other installed operating
    systems
-   Enable thumbnailing
-   Archive and extract compressed files
-   Automatically mount removable media

When a file manager has been installed as part of a full desktop
environment, most of these packages will usually have been installed
automatically. Consequently, where a file manager has been installed for
a standalone window manager then - as is the case with the window
manager itself - only a basic foundation will be provided. The user must
then determine the nature and extent of the features and functionality
to be added.

Additional Features and Functionality
-------------------------------------

Particularly where using - or intending to use - a lightweight
environment, it should be noted that more file manager features and
functions will usually mean the use of more memory.

> Internal Partitions

Install one of the following two packages to allow your file manager to
mount and browse internal partitions:

-   gvfs: The Gnome Virtual File System provides mounting and trash
    functionality. GVFS uses the newer udisks2 for mounting
    functionality and is the recommended solution for most file
    managers.
-   udiskie: Udiskie is a wrapper for the older udisks package. It
    provides mounting functionality however it does not provide support
    for a trash. See the Udiskie section for more details.

Tip:For some file managers it may be useful to have the package gamin
installed. Gamin is a file and directory monitoring system.

> Removable Media

Other Gnome Virtual File System software packages are required to ensure
that removable media such as USB sticks, CDs/DVDs, and cameras can be
accessed:

-   gvfs-afc: Removable media (e.g. optical disks, USB data sticks, and
    cameras)
-   gvfs-gphoto2: Automatically transfer content from many digital
    cameras

> Auto-Mount Removable Media

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Udisks.     
                           Notes: The purpose is to 
                           avoid duplications.      
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

There are two options available to automatically mount removable media
when interted, discussed below.

File Manager Daemon

The first is to simply autostart or run the installed file manager in
daemon mode (i.e. as a background process). For example, when using
PCManFM in Openbox, the following command would be added to the
~/.config/openbox/autostart file:

    pcmanfm -d &

It will also be necessary to configure the file manager itself in
respect to volume management (e.g. what it will do and what applications
will be launched when certain file types are detected upon mounting).

Tip:Most desktop environments will start the file manager in daemon mode
by default so manual intervention will not be required in these use
cases.

Udiskie

The other option is to install udiskie, a program designed solely to
mount and unmount devices. The advantages of using this are:

-   Less memory may be required to run as a background / daemon process
    than a file manager
-   It is not file manager specific, allowing them to be freely added,
    removed, and switched
-   The Gnome Virtual File System package (gvfs) may not have to be
    installed for mounting, lessening memory use. However, trash and
    other functionality related to this package will also be lost.

Udiskie may be run as and when required to mount removable media
on-the-fly (e.g. attaching the command to a keybind), or it may be run
as a background processs. In the latter instance, again using Openbox as
an example, the following command would be added to the
~/.config/openbox/autostart file:

    udiskie &

udevil/devmon

Another alternative is udevil which provides the devmon daemon to
automatically mount removable media. The advantage is that it only
depends on udev and glib but not on udisks, gvfs, fuse, policykit,
consolekit, etc. (although it can coexist with any of these). Udevil can
be configured through /etc/udevil/udevil.conf and started through:

    devmon &

> Networks

Note:It will also be necessary to enable Bluetooth and/or networking
with Windows to enable the relevant file manager functionality in turn.

-   obexfs: Bluetooth device mounting and file transfers (see Bluetooth)
-   gvfs-smb: Windows File and printer sharing for Non-KDE desktops (see
    Samba)
-   kdenetwork-filesharing: Windows File and printer sharing for KDE
    (see Samba#KDE)
-   gvfs-afp: Apple file and printer sharing
-   sshfs: FUSE client based on the SSH File Transfer Protocol

Windows access

If using gvfs-smb, to access Windows/CIFS/Samba file shares first open
the file manager, and enter the following into the path name, changing
<sever name> and <share name> as appropriate:

    smb://<server name>/<share name>

Apple access

If using gvfs-afc, to access AFP files first open the file manager, and
enter the following into the path name, changing <sever name> and <share
name> as appropriate:

    afp://<server name>/<share name>

> Thumbnail Previews

Some file managers may not support thumbnailing, even when the packages
listed have been installed. Check the documentation for the relevant
file manager.

File managers other than Dolphin and Konquerer

These packages apply to most file managers, such as PCManFM, spacefm,
Thunar and xfe. The exceptions are Dolphin and Konqueror, used in the
KDE desktop environment.

-   tumbler: Image files. This must also be installed to expand
    thumbnailing capabilities to other file types
-   poppler-glib: Adobe .pdf files
-   ffmpegthumbnailer: Video files
-   freetype2: Font files
-   libgsf: .odf files
-   raw-thumbnailer: .raw files

Dolphin and Konquerer (KDE)

Different (and additional) packages are available for the Dolphin and/or
Konqueror file managers within the KDE desktop environment.

-   kdegraphics-thumbnailers: Image files
-   kdesdk-thumbnailers: Plugins for the thumbnailing system
-   kdemultimedia-mplayerthumbs: Video files
-   raw-thumbnailer: .raw files
-   audiothumbs: Audio files (AUR)
-   kde-thumbnailer-apk: Android application package files (AUR)
-   kde-thumbnailer-blender: Blender application files (AUR)
-   kde-thumbnailer-epub: Electronic book files (AUR)
-   openoffice-thumbnail-plugin: OpenOffice / LibreOffice files (AUR)

> Archive Files

To extract compressed files such as tarballs (.tar and .tar.gz) within a
file manager, it will first be necessary to install a GUI archiver such
as file-roller. See List_of_Applications#Compression_tools for further
information. An additional package such as unzip must also be installed
to support the use of zipped .zip files. Once an archiver has been
installed, files in the file manager may consequently be right-clicked
to be archived or extracted.

> NTFS read/write support

Install ntfs-3g. See the NTFS-3G article for more information.

> Desktop Notifications

Some file managers make use of desktop notifications to confirm various
events and statuses like mounting, unmounting and ejection of removable
media.

Troubleshooting
---------------

> Password required to access partitions and removable Media

Warning:It is pointless to amend the default polkit permission files of
packages, as these may be be overwritten when the packages are updated.

The need to enter a password to access other partitions or mounted
removable media will likely be due to the default permission settings of
udisks2. More specifically, permission may be set to the root account
only, not the user account. There is a simple workaround for this
behaviour:

1.  Add your user account to the storage group. See Users and groups for
    details.
2.  Create a new polkit rule as shown in Polkit#Allow mounting a
    filesystem on a system device.

This will enable mounting a filesystem on a system device for all
members of the storage group without asking for password.

Retrieved from
"https://wiki.archlinux.org/index.php?title=File_manager_functionality&oldid=303002"

Category:

-   File managers

-   This page was last modified on 3 March 2014, at 09:16.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
