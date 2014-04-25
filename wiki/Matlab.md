Matlab
======

Related articles

-   Octave
-   Sage-mathematics
-   Mathematica

From the official website:

MATLAB is a high-level language and interactive environment for
numerical computation, visualization, and programming. Using MATLAB, you
can analyze data, develop algorithms, and create models and
applications. The language, tools, and built-in math functions enable
you to explore multiple approaches and reach a solution faster than with
spreadsheets or traditional programming languages, such as C/C++ or
Java.

Contents
--------

-   1 General installation
    -   1.1 Create Desktop and Menu Shortcuts
    -   1.2 Install supported compiler
-   2 Troubleshooting
    -   2.1 Install-Time Library Errors
    -   2.2 License: invalid machine id
        -   2.2.1 Rename Interfaces
    -   2.3 Resolving start warnings/errors
    -   2.4 MATLAB crashes when displaying graphics
    -   2.5 Blank/grey UI when using DWM/Awesome
-   3 OpenGL Acceleration
    -   3.1 NVIDIA

General installation
--------------------

Note:Versions earlier than MATLAB R2013a are not compatible with Java 7.
When installing an older version, first install libxp and jre6.

MATLAB 2013a+ should install fine with the ./install script provided by
MATLAB, without any additional packages. You can run the script as root
to install MATLAB system-wide, or run it as your user to install it only
for you.

To install from an iso file:

    # modprobe loop
    # mount -o loop matlab.iso /mnt/
    # /mnt/install

Additionally, install xorg-fonts-100dpi, xorg-fonts-75dpi, and
xorg-fonts-type1 so fonts are displayed properly in figures.

> Create Desktop and Menu Shortcuts

During the installation, you are asked if you want symlinks to be
created. If you did not choose to do so, you can now manually create a
symlink in /usr/local/bin to make it easier to launch in terminal:

    # ln -s /{MATLAB}/bin/matlab /usr/local/bin

To create a menu item, we need to get a icon first:

    # curl http://upload.wikimedia.org/wikipedia/commons/2/21/Matlab_Logo.png -o /usr/share/icons/matlab.png

Then create a new .desktop file in /usr/share/applications with
following lines:

    /usr/share/applications/matlab.desktop

    #!/usr/bin/env xdg-open
    [Desktop Entry]
    Type=Application
    Icon=/usr/share/icons/matlab.png
    Name=MATLAB
    Comment=Start MATLAB - The Language of Technical Computing
    Exec=env -u _JAVA_OPTIONS matlab -desktop -nosplash -r "cd('%d'); edit '%f'"
    Categories=Development;
    MimeType=text/x-matlab;

The Exec command line is composed as follows:

-   -desktop is a flag needed to run Matlab without a terminal.
-   -nosplash is a flag preventing the splash screen from showing and
    taking up a temporary space in your task bar.
-   env -u _JAVA_OPTIONS prevents the creation of a .java.log-file in
    your home directory by unsetting $_JAVA_OPTIONS. Java prints all
    options set this way to stdout, and Matlab treats everything in
    stdout as an error worth logging.
-   -r '...' executes Matlab code on startup:
    1.  cd('%d') This changes the working directory of Matlab to the
        opened file’s directory.
    2.  edit '%f' This spawns an editor tab for the file.

You can also put this .desktop file in the ~/Desktop directory to create
a shortcut on your desktop.

More details see MATLAB - Community Ubuntu Documents

> Install supported compiler

In order for Matlab to work with C code (needed for simulink) it is
necessary to install a supported compiler. For example, if using Matlab
r2013a, install gcc44 from the AUR.

Then edit ${MATLAB}/bin/mexopts.sh and replace all occurances of
CC='gcc' with CC='gcc-4.4' and CXX='g++' with CXX='g++-4.4'. Afterwards
run

    mex -setup

in Matlab and select the mexopts.sh file.

Troubleshooting
---------------

As one installs Matlab, it might complain that it cannot find a package,
for the most part just look at the package name and then install it with
Pacman, or in the case of x86_64 there are some libraries only in AUR.

> Install-Time Library Errors

-   Make sure that the symlink bin/glnx64/libstdc++.so.6 is pointing to
    the correct version of libstdc++.so.xx (which is also in the same
    directory and has numbers where 'xx' is). By default, it may be
    pointing to an older (and nonexistent) version (different value for
    'xx').

-   Make sure the device you're installing from is not mounted as noexec

-   If you downloaded the files from Mathworks' website, make sure they
    are not on an NTFS or FAT partition, because that can mess up the
    symlinks. Ext4 or Ext3 should work.

> License: invalid machine id

Note:This seems to be fixed in r2014a.

The installer may complain about an invalid machine id, because it is
looking for a network interface named eth0 to get a MAC address for
activation, while new Arch Linux setups do not have a network interface
called eth0 (systemd uses Predictable Network Interface Names).

The optimal solution is to create a dummy network interface named eth0
with the MAC address of the network device in use (wireless or wired)
when you activated MATLAB. First, get that MAC address using ip link
Next, create the following file:

    /etc/systemd/system/matlab.licensing.service

    [Unit]
    Description=Dummy network interface for MATLAB
    Requires=systemd-modules-load.service

    [Service]
    Type=oneshot
    ExecStart=/sbin/ip link set dev dummy0 name eth0
    ExecStart=/sbin/ip link set dev eth0 address 00:00:00:00:00:00

    [Install]
    WantedBy=multi-user.target

Replace 00:00:00:00:00:00 with your MAC address.

Then make the script run on boot:

    # systemctl enable matlab.licensing

Finally, set the dummy module to load on boot by creating the following
file:

    /etc/modules-load.d/dummy.conf

    dummy

Rename Interfaces

A less preferable option is to change the name of the interface.

The machine id should now be different than 000000000000 and you should
be able to install and activate MATLAB without problems.

> Resolving start warnings/errors

-   Even if all needed libraries are installed, Matlab when starting can
    still report some missing libraries. This is resolved by symbolic
    linking of needed libraries to directories that Matlab checks at
    start-up. For example, if Matlab triggers error/warning about
    missing /lib64/libc.so.6 library, this can be resolved by:

    # ln -s /lib/libc.so.6 /lib64

-   Matlab R2011b with an up-to-date Arch Linux (as of March 12, 2012)
    fails on startup with the familiar "Failure loading desktop class."
    A solution is to point Matlab to the system JVM (confirmed to work
    with the jdk7-openjdk package):

    export MATLAB_JAVA=/usr/lib/jvm/java-7-openjdk/jre

> MATLAB crashes when displaying graphics

To identify this error, start MATLAB with

    LIBGL_DEBUG=verbose matlab

from the terminal and try to collect OpenGL information with opengl info
from the MATLAB command prompt. If it crashes again and there is an
output line like

    libGL error: dlopen /usr/lib/xorg/modules/dri/swrast_dri.so failed 
    (/usr/local/MATLAB/R2011b/bin/glnxa64/../../sys/os/glnxa64/libstdc++.so.6: 
    version `GLIBCXX_3.4.15' not found (required by /usr/lib/xorg/modules/dri/swrast_dri.so))

then the problem is that MATLAB uses its own GNU C++ library, which is
an older version than the up-to-date version on your Archlinux system.
Make MATLAB use the current C++ library for your system by

    cd /usr/local/MATLAB/R(your release)/sys/os/glnxa64
    sudo unlink libstdc++.so.6
    sudo ln -s /usr/lib/libstdc++.so.6

> Blank/grey UI when using DWM/Awesome

wmname LG3D

OpenGL Acceleration
-------------------

Once Matlab is installed type the following in the interpreter:

    >> opengl info

The output should be similar to the following:

    Version         = 2.0 Mesa 7.8.2
    Vendor          = Advanced Micro Devices, Inc.
    Renderer        = Mesa DRI R600 (RV710 9552) 20090101 x86/MMX/SSE2 TCL DRI2
    MaxTextureSize  = 4096
    Visual          = 0xcb (TrueColor, depth 24, RGB mask 0xff0000 0xff00 0x00ff)
    Software        = false
    # of Extensions = 107

    Driver Bug Workarounds:
    OpenGLBitmapZbufferBug    = 0
    OpenGLWobbleTesselatorBug = 0
    OpenGLLineSmoothingBug    = 0
    OpenGLClippedImageBug     = 0
    OpenGLEraseModeBug        = 0

This will vary with card you are using, but the important part is
"Software = false". If it's not "false" for you, then there is a problem
with your hardware acceleration.

> NVIDIA

With an NVIDIA card, the output should be similar to this:

    >> opengl info
    Version         = 2.1.2 NVIDIA 177.82
    Vendor          = NVIDIA Corporation
    Renderer        = Quadro NVS 140M/PCI/SSE2
    MaxTextureSize  = 8192
    Visual          = 0x21 (TrueColor, depth 16, RGB mask 0xf800 0x07e0 0x001f)
    Software        = false
    # of Extensions = 144

    Driver Bug Workarounds:
    OpenGLBitmapZbufferBug    = 0
    OpenGLWobbleTesselatorBug = 0
    OpenGLLineSmoothingBug    = 0
    OpenGLClippedImageBug     = 1
    OpenGLEraseModeBug        = 0

With the NVIDIA card all it required to start working was to copy the
libGLU.so from the Matlab installed library
${MATLAB}/sys/opengl/lib/glnx86/libGLU.so to /usr/lib directory. Note
that in x86_64 this might be a different directory.

Note:Although, not thoroughly tested, using lib32-nvidia-utils seems to
work as well.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Matlab&oldid=304144"

Category:

-   Mathematics and science

-   This page was last modified on 12 March 2014, at 13:27.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
