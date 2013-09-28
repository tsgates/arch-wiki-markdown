MTP
===

MTP is the "Media Transfer Protocol" and is used by many mp3 players
(e.g. Creative Zen) and mobile phones (e.g. Android 3+ devices). It is
part of the "Windows Media" Framework and has close relationship with
Windows Media Player.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Usage                                                              |
| -   3 Using media players                                                |
| -   4 mtpfs                                                              |
| -   5 go-mtpfs                                                           |
| -   6 gvfs-mtp                                                           |
| -   7 simple-mtpfs                                                       |
| -   8 KDE MTP KIO Slave                                                  |
|     -   8.1 Usage                                                        |
|     -   8.2 Workaround if the KDE device actions doesn't work            |
|                                                                          |
| -   9 GNOME gMTP                                                         |
| -   10 Workarounds for Android                                           |
+--------------------------------------------------------------------------+

Installation
------------

MTP support is provided by libmtp, installable with the libmtp package
from the official repositories.

Usage
-----

After installation, you have several MTP tools available. Upon
connecting your MTP device, you use:

    # mtp-detect

to see if your MTP device is detected.

To connect to your MTP device, you use:

    # mtp-connect

If connection is successful, you will be given several switch options in
conjunction with mtp-connect to access data on the device.

There are also several stand alone commands you can use to access your
MTP device such as,

Warning: Some commands may be harmful to your MTP device!!!

     mtp-albumart        mtp-emptyfolders    mtp-getplaylist     mtp-reset           mtp-trexist
     mtp-albums          mtp-files           mtp-hotplug         mtp-sendfile
     mtp-connect         mtp-folders         mtp-newfolder       mtp-sendtr
     mtp-delfile         mtp-format          mtp-newplaylist     mtp-thumb
     mtp-detect          mtp-getfile         mtp-playlists       mtp-tracks

Using media players
-------------------

You can also use your MTP device in music players such as Amarok. To do
this you may have to edit /etc/udev/rules.d/51-android.rules (the MTP
device used in the following example is a Galaxy Nexus): To do this run:

    $ lsusb

and look for your device, it will be something like:

    Bus 003 Device 011: ID 04e8:6860 Samsung Electronics Co., Ltd GT-I9100 Phone [Galaxy S II], GT-P7500 [Galaxy Tab 10.1]

in which case the entry would be:

    SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", ATTR{idProduct}=="6860", MODE="0666"

Then, reload udev rules:

    # udevadm control --reload

Note:After installing MTP you may have to reboot for your device to be
recognised

mtpfs
-----

Mtpfs is FUSE filesystem that supports reading and writing from any MTP
device. Basically it allows you to mount your device as an external
drive.

Mtpfs can be installed with the packge mtpfs, available from the
official repositories.

-   First edit your /etc/fuse.conf and uncomment the following line:

    user_allow_other

-   To mount your device

    $ mtpfs -o allow_other /media/YOURMOUNTPOINT

-   To unmount your device

    $ fusermount -u /media/YOURMOUNTPOINT

-   To unmount your device as root

    # umount /media/YOURMOUNTPOINT

Also, you can put them into your ~/.bashrc:

    alias android-connect="mtpfs -o allow_other /media/YOURMOUNTPOINT"
    alias android-disconnect="fusermount -u /media/YOURMOUNTPOINT"

Or, with sudo

    alias android-disconnect="sudo umount -u /media/YOURMOUNTPOINT"

Note:if you want not be asked for password when using sudo, please refer
to USB Storage Devices#Mounting USB devices

go-mtpfs
--------

Note:Go-mtpfs gives a better performance while writing files to some
devices than mtpfs/jmtpfs. Try it if you have slow speeds.

If the above instructions don't show any positive results one should try
go-mtpfs-git from the AUR. The following has been tested on a Samsung
Galaxy Nexus GSM and Samsung Galaxy S 3 mini.

If you want do it simpler, install go, libmtp and git from the official
repositories. After that install go-mtpfs-git from the AUR.

  
 As in the section above install android-udev which will provide you
with "/etc/udev/rules.d/51-android.rules" edit it to apply to your
vendorID and productID, which you can see after running mtp-detect. To
the end of the line add with a comma OWNER="yourusername". Save the
file.

-   Add yourself to the "fuse" group:

    gpasswd -a [user] fuse

-   If the group "fuse" doesn't exist create it with:

    groupadd fuse

Logout or reboot to apply these changes.

-   To create a mount point called "Android" issue the following
    commands:

    mkdir Android

-   To mount your phone use:

    go-mtpfs Android

-   To unmount your phone:

    fusermount -u Android

You can create a .bashrc alias as in the example above for easier use.

gvfs-mtp
--------

Philip Langdale is has implemented native MTP support for gvfs. The
weaknesses of gphoto2 and mtpfs are listed in his blog post.

-   The native mtp implementation for gvfs has been merged upstream and
    has been released in gvfs 1.15.2. You can grab the stable gvfs-mtp
    package from extra, when gvfs 1.16 will be released in the stable
    Arch repos.

-   Devices will have gvfs paths like this

    gvfs-ls mtp://[usb:002,013]/

simple-mtpfs
------------

This is another FUSE filesystem for MTP devices. You may find this to be
more reliable than mtpfs. simple-mtpfs is available in the AUR or can be
built from source. Remember do not run the following commands as root.

-   To list MTP devices run

     simple-mtpfs --list-devices

-   To mount a MTP devices (in this example device 0) run

    simple-mtpfs /path/to/your/mount/point

-   To un mount run

     fusermount -u /path/to/your/mount/point

KDE MTP KIO Slave
-----------------

There is a MTP KIO Slave built upon libmtp availiable as package
kio-mtp.

Using KIO makes file access in KDE seamless, in principle any KDE
application would be able read/write files on the device.

> Usage

The device will be available under the path mtp:/

> Workaround if the KDE device actions doesn't work

If you are not able to use the action "Open with File Manager", you may
work around this problem by editing the file
/usr/share/apps/solid/actions/solid_mtp.desktop

Change the line

    Exec=kioclient exec mtp:udi=%i/

To

    Exec=dolphin "mtp:/"

GNOME gMTP
----------

gMTP is a native Gnome application used for MTP access.

gmtp is currently located in the AUR .

Workarounds for Android
-----------------------

MTP is still buggy and may crash despite the best efforts of developers.
The following are alternatives:

-   AirDroid - an Android app to access files via your web browser.
-   FTP client on Android - If you run a local FTP server on Arch (such
    as Vsftp), there are many FTP clients available on the Play Store
    which will give read/ write access to your device's files.
-   FTP Server on Android. Note: since FTP client using passive transfer
    (server connect to client) do not forget to disable firewall or
    adding rules for allowing FTP server connect to your PC.
    -   Ftp Server (by The Olive Tree) app in Play Store acts as FTP
        server on Android and allows RW access to pretty much all your
        storage.
        -   Pro: Doesn't require root and just works!
        -   Cons: Doesn't work with tethering network.

    -   FTPServer (by Andreas Liebig) - Just work.

-   Samba - an Android app to share your SD card as a windows fileshare.
    Pros: Your desktop apps work as before (since the SD card appears as
    a windows fileshare). Cons: you need to root your phone.

Retrieved from
"https://wiki.archlinux.org/index.php?title=MTP&oldid=255879"

Category:

-   Sound
