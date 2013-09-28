Sync and connect with windows mobile
====================================

This page is a howto for connecting your Windows Mobile device with
Archlinux. Afterwards you can sync and install cabs just like you can do
with activesync in windows. It uses the kde app synce-kde, but gnome and
*box users can relax, the only qt-deps are qscintilla-2.3.2-2 and
pyqt-4.4.4-2. And they are small.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Connecting to your phone                                           |
| -   3 Troubleshooting                                                    |
| -   4 Other problems                                                     |
| -   5 Work with PocketPC files from file manager                         |
+--------------------------------------------------------------------------+

Installation
------------

1.  Install synce-odccm and synce-kde,available in the Official
    Repositories.
2.  Install synce-sync-engine, available in the Official Repositories.

Connecting to your phone
------------------------

1.  Start odccm:

        # odccm

2.  Start sync-engine. You can use "sync-engine -d" to have it running
    in the background as a daemon.
3.  Start synce-kpm
4.  Connect your WM phone.

Now you can sync your phone, install cabs and so on. Have fun.Before
syncing you will have to crete a partnership with your phone. Just as
with active sync in Windows.

Troubleshooting
---------------

If your phone does not show in synce-kpm, make sure the
activesync-setting in your phone is set to "activesync", and not "mass
storage device"" or similar. (Settings → Connections → USB connection
settings)

Other problems
--------------

There is only one problem I have experienced with this. Sometimes it
will stop working, and you will get an error report on your phone saying
device.exe had a problem and was teminated. To fix this, simply go to
USB-connection setting, choose "mass storage device" and select Ok, and
then select "active sync" and again ok.

If the above did not work, you might have to quit/kill sync-engine and
odccm, and restart them. Start odccm first. This seems to be necessary
when sync-engine is stuck at " Authorization pending - waiting for
password on device" You will get output if you start sync-engine without
the -d option.

I think this problem arises after the phone has suspended, but I'm not
quite sure what really causes it.

Work with PocketPC files from file manager
------------------------------------------

There is a SynCE FS project, which is aimed to provide a possibility to
work with winmobile device filesystem as a remote filesystem. It ts
based on SynCE and Coda.

Install syncefs, available in the Arch User Repository. To use SynCE FS,
you need a working SynCE installation.

At the first step you need to load coda kernel module.

At the next step you need to start SynCE tools: odccm and sync-engine.

Finally you can mount your PocketPC filesystem with a command:

    mount /mnt/synce

(Directory /mnt/synce is normally created during installation. If not -
please create it manually.)

Now you can use your PocketPC filesystem from /mnt/synce directory.

Tip:

To mount PocketPC filesystem as ordinal user (non-root), you need to add
the following to your fstab:

    none /mnt/synce cefs rw,user,noauto,codadev=/dev/cfs0 0 0

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sync_and_connect_with_windows_mobile&oldid=206360"

Category:

-   Mobile devices
