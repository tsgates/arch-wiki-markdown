3D Mouse
========

Also known as bats, flying mice, or wands, these devices generally
function through ultrasound and provide at least three degrees of
freedom. Probably the best known example would be 3DConnexion/Logitech's
SpaceMouse from the early 1990s. - Wikipedia

For more information:
http://www.3dconnexion.com/products/what-is-a-3d-mouse.html

Note:The following instructions have been tested and proven to work on
the most basic model (Space Navigator).

Contents
--------

-   1 Proprietary drivers
-   2 Open Source Drivers
    -   2.1 Rebuild Blender with spacenav support
-   3 See also

> Proprietary drivers

1. Plug your 3D mouse into your USB port. Use lsusb to check if it was
recognised

    $> lsusb
    Bus 003 Device 002: ID 046d:c626 Logitech, Inc. 3Dconnexion Space Navigator 3D Mouse

2. Install openmotif or if you need lesstif (e.g. for xpdf) you can just
get the libXm.so.4 library from it:

    $> sudo pacman -Sw openmotif # download openmotif to cache, do not install
    $> tar xJOf /var/cache/pacman/pkg/openmotif-* usr/lib/libXm.so.4.0.3 > libXm.so.4
    $> sudo mv libXm.so.4 /usr/lib/libXm.so.4

3. Symlink libXm.so.4 to libXm.so.3

    $> sudo ln -s /usr/lib/libXm.so.4 /usr/lib/libXm.so.3

4. The driver has some problems to get the username from /var/run/utmp
and will output a "failed to get user" error.

To fix this problem compile the following program. It appends the given
username to /var/run/utmp in such a way that the driver can read it.

    3dmouse.c

    /* source: http://forums.gentoo.org/viewtopic-t-609224.html
     *         http://www.3dconnexion.com/forum/viewtopic.php?t=1039
     */
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #include <utmpx.h>

    int main(int argc, char ** argv) {
      if (argc != 2) {
        fprintf(stderr, "Need a name to put in the structure\n");
        exit(1);
      }
      struct utmpx u;
      memset(&u, 0, sizeof(u));
      u.ut_type = USER_PROCESS;
      u.ut_pid = getpid();
      strcpy(u.ut_id, ":0");
      strcpy(u.ut_line, ":0");
      strcpy(u.ut_user, argv[1]);
      setutxent();
      pututxline(&u);
      endutxent();
    } 

    $> gcc 3dmouse.c -o 3dmouse
    $> sudo ./3dmouse root

5. Download the linux drivers to /tmp from here:
http://www.3dconnexion.com/service/drivers.html

6. Unpack the install script and run it

    $> tar xfz 3dxware-linux-v1-5-2.i386.tar.gz install-3dxunix.sh
    $> sudo ./install-3dxunix.sh
    Password:


    This installs 3DxWareUnix V1.5.2 on this machine. Continue? (y/n) [y]
    y

     Choose one of the following platforms:

      1.  HP-UX
      2.  Solaris
      3.  AIX 5
      4.  Linux
      5.  Exit

    Please enter your choice (1-5)[4]:
    4

    Installing files for 3DxWare for Unix / linux......

    Uninstalling a running driver. Please wait ...
    Done.

    Converting default configs V5.x to V5.3.
    (User configs will be converted when used)
    Please wait a moment...
    Converting configs... found 27 configurations
    Configuration file             Configuration name       Version Status
    /etc/3DxWare/UGSNX2_01.scg     ("UGS NX 2 config 01      ") 5.3 Ok.
    /etc/3DxWare/4DNav.scg         ("4D Navigator            ") 5.3 Ok.
    /etc/3DxWare/UGSNX5_02.scg     ("UGS NX 5 config 02      ") 5.3 Ok.
    /etc/3DxWare/CatiaV5_02.scg    ("CATIA V5 config 02      ") 5.3 Ok.
    /etc/3DxWare/Maya2011.scg      ("Maya 2011               ") 5.3 Ok.
    /etc/3DxWare/CatiaV4_01.scg    ("CATIA V4                ") 5.3 Ok.
    /etc/3DxWare/Patran_01.scg     ("Patran                  ") 5.3 Ok.
    /etc/3DxWare/UGSNX4_01.scg     ("UGS NX 4 config 01      ") 5.3 Ok.
    /etc/3DxWare/Pr(...)ire_02.scg ("ProE Wildfire config 02 ") 5.3 Ok.
    /etc/3DxWare/Pr(...)ire_01.scg ("ProE Wildfire config 01 ") 5.3 Ok.
    /etc/3DxWare/UGSNX2_02.scg     ("UGS NX 2 config 02      ") 5.3 Ok.
    /etc/3DxWare/CatiaV5_03.scg    ("CATIA V5 config 03      ") 5.3 Ok.
    /etc/3DxWare/UGSNX3_02.scg     ("UGS NX 3 config 02      ") 5.3 Ok.
    /etc/3DxWare/default_10.scg    ("Driver Protocol 1.0     ") 5.3 Ok.
    /etc/3DxWare/CADDS_R14.scg     ("CADDS5 R14 +            ") 5.3 Ok.
    /etc/3DxWare/CatiaV5_01.scg    ("CATIA V5 config 01      ") 5.3 Ok.
    /etc/3DxWare/DMUNav.scg        ("DMU Navigator           ") 5.3 Ok.
    /etc/3DxWare/UGSNX4_02.scg     ("UGS NX 4 config 02      ") 5.3 Ok.
    /etc/3DxWare/Enovia_VPM.scg    ("Enovia VPM              ") 5.3 Ok.
    /etc/3DxWare/UGSNX5_01.scg     ("UGS NX 5 config 01      ") 5.3 Ok.
    /etc/3DxWare/ICEM_MED.scg      ("ICEM MED                ") 5.3 Ok.
    /etc/3DxWare/CADDS_R13.scg     ("CADDS5 -R13             ") 5.3 Ok.
    /etc/3DxWare/DVise.scg         ("DVise                   ") 5.3 Ok.
    /etc/3DxWare/Op(...)alizer.scg ("Optegra Visualizer      ") 5.3 Ok.
    /etc/3DxWare/UGSNX3_01.scg     ("UGS NX 3 config 01      ") 5.3 Ok.
    /etc/3DxWare/IDEAS_01.scg      ("IDEAS                   ") 5.3 Ok.
    /etc/3DxWare/default.scg       ("Any Application         ") 5.3 Ok.

    Done.

    Do you want 3DxWareUnix being started with every login (from the /etc/inittab)? (y/n) [y]
    n

    Please start the driver manually. [/etc/3DxWare/daemon/3dxsrv -d <port>]

    ****************************************************************
        For testing purposes you can find the demos
                          xcube and xvalues at /tmp
    ****************************************************************

NOTE: I chose not to run the driver everytime I login.

7. You can run the driver manually by calling it like this (for USB
version):

    $> sudo /etc/3DxWare/daemon/3dxsrv -d USB

8. You should now have a working 3D mouse in Arch Linux! You can test it
by extracting the demos from the driver archive.

    $> tar xfz 3dxware-linux-v1-5-2.i386.tar.gz xcube
    $> ./xcube

> Open Source Drivers

There exists also an open source driver for 3Dconnexion devices
maintained by the spacenav project. Unfortunately the list of supported
applications is very short. Actually there is only one major software
supporting the spacenav driver, namely the 3D creation suite Blender.
For it to work three things must be fulfilled

1.  The device must be recognized by the kernel as input device
2.  The spacenavd daemon must be running
3.  The application must be compiled with spacenav support.
    (community/blender isn't)

The first requirement should be fulfilled automatically after plugging
in the device. It can be checked by looking if the device is listed in
/proc/bus/input/devices e.g. by

    $> grep 3Dconnexion /proc/bus/input/devices
    N: Name="3Dconnexion SpaceNavigator"

For the second point install libspnav and spacenavd from AUR. For
testing it's a good idea to start the daemon on foreground mode. The
output should look similar to this:

    $> sudo spacenavd -v -d
    Spacenav daemon 0.5
    Device detection, parsing /proc/bus/input/devices
    using device: /dev/input/event21
    device name: 3Dconnexion SpaceNavigator
    trying to open X11 display ":0"
       XAUTHORITY=/home/user/.Xauthority

If it works you can simply shut down the daemon by hitting CTRL-C and
run it using sudo /etc/rc.d/spacenavd start. On a systemd-only system
the following service script can be used to start the daemon with
sudo systemctl start spacenavd.service

    /etc/systemd/system/spacenavd.service

    [Unit]
    Description=Userspace Daemon of the spacenav driver.

    [Service]
    Type=forking
    PIDFile=/var/run/spnavd.pid
    ExecStart=/usr/bin/spacenavd

    [Install]
    WantedBy=multi-user.target

Now everything is up and running and every supported application should
be able to use the 3D Mouse.

Rebuild Blender with spacenav support

Unfortunately the blender package in the community repository is not
compiled with spacenav support. So you have to compile it yourself which
is very easy

    $> yaourt -S libspnav # blender will automatically build with NDOF(=spacenav) support when libspnav is installed
    $> yaourt -G blender
    $> cd blender
    $> makepkg
    $> sudo pacman -U blender-*.tar.xz

Now you can fire up blender and test your 3D Mouse.

    $> blender
    ndof: using SpaceNavigator

See also
--------

-   3dconnexion linux forum
-   Source of C program used
-   Information about libXm.so.4 and libXm.so.3
-   Website of the open source driver spacenav
-   Community Wiki about Spacemice

Retrieved from
"https://wiki.archlinux.org/index.php?title=3D_Mouse&oldid=257463"

Category:

-   Mice

-   This page was last modified on 18 May 2013, at 02:15.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
