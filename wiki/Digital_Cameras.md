Digital Cameras
===============

  Summary
  -----------------------------------
  Infos on digital cameras support.

This article documents the configuration of libgphoto2 to access digital
cameras. Some digital cameras will mount as normal USB Storage Devices
and may not require the use of libgphoto2.

Note:As of libgphoto2 version 2.14.13, users do not need to be part of
the camera group.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Libgphoto2                                                         |
|     -   1.1 Installation and Configuration                               |
|     -   1.2 Permission issues                                            |
|                                                                          |
| -   2 GPhoto2 Usage                                                      |
| -   3 Frontend (external) Applications for GPhoto2                       |
| -   4 Miscellaneous Troubleshooting                                      |
|     -   4.1 Groups                                                       |
|                                                                          |
| -   5 Wiki Articles Relating to Photo/Cameras                            |
+--------------------------------------------------------------------------+

Libgphoto2
----------

Libgphoto2 is the core library designed to allow access to digital
cameras by external (front end) programs, such as Digikam and gphoto2.
The current 'officially' supported cameras are here (though more may
work).

> Installation and Configuration

Core library:

    # pacman -S libgphoto2

(Optional) gvfs (for Nautilus integration):

    # pacman -S gvfs-gphoto2

(Optional) Command line interface:

    # pacman -S gphoto2

> Permission issues

Users with a local session have permissions granted for cameras using
ACLs. See General Troubleshooting#Session permissions if it does not
work.

If you want these permissions to work for remote (SSH) sessions too, you
can use the old 'camera' group, by adding the requisite users to the
deprecated camera group and create a new udev rules file as follows:

    # /usr/lib/libgphoto2/print-camera-list udev-rules version 175 group camera > /etc/udev/rules.d/40-gphoto.rules

These rules will use the group for newly added camera devices.

If the camera is not present in any udev rule, can check vendor and
product id and add it. To check it just run:

    # lsusb
    ...
    Bus 001 Device 005: ID 04a9:318e Canon, Inc.
    ...

GPhoto2 Usage
-------------

GPhoto2 is a command line client for libgphoto2. GPhoto2 allows access
to the libgpohoto2 library from a terminal or from a script shell to
perform any camera operation that can be done. This is the main user
interface.

GPhoto2 also provides convenient debugging features for camera driver
developers.

Quick Commands

-   gphoto2 --list-ports
-   gphoto2 --auto-detect
-   gphoto2 --summary
-   gphoto2 --list-files
-   gphoto2 --get-all-files

For advanced file manipulation, use

-   gphoto2 --shell

Frontend (external) Applications for GPhoto2
--------------------------------------------

-   gphotofs - allow using cameras with any tool able to read from a
    mounted filesystem.
-   RawTherapee
-   darktable
-   Digikam
-   F-Spot
-   Gthumb
-   GTKam

Miscellaneous Troubleshooting
-----------------------------

> Groups

Make sure that the user to which access should be granted is part of the
storage group.

Wiki Articles Relating to Photo/Cameras
---------------------------------------

-   Jalbum - Freeware for creating professional albums/galleries.
-   HCL/Digital Cameras - Partial list of supported cameras for gphoto2

Retrieved from
"https://wiki.archlinux.org/index.php?title=Digital_Cameras&oldid=242520"

Category:

-   Imaging
