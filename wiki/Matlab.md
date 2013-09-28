Matlab
======

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 General installation                                               |
|     -   1.1 Create Desktop and Menu Shortcuts                            |
|     -   1.2 Install 32-bit Matlab on 64-bit system                       |
|     -   1.3 Install supported compiler                                   |
|                                                                          |
| -   2 Troubleshooting                                                    |
|     -   2.1 License: invalid machine id                                  |
|     -   2.2 Resolving start warnings/errors                              |
|     -   2.3 MATLAB crashes when displaying graphics                      |
|     -   2.4 Blank/grey UI when using DWM/Awesome                         |
|                                                                          |
| -   3 OpenGL Acceleration                                                |
|     -   3.1 NVIDIA                                                       |
+--------------------------------------------------------------------------+

General installation
--------------------

Warning:This should not be necessary for MATLAB R2013a+, installation
should work without any additional packages.

Use the following commands to mount and install Matlab. Note that the
path to the install script should contain no spaces, or the install will
fail. For graphical install and interface libxp is needed. You may need
to install libxp from the official repositories first. Note also that
Matlab is not compliant with Java 7, so you may need to install, for
example, openjdk6. Install from iso file:

    # modprobe loop
    # mount -o loop matlab.iso /mnt/
    # /mnt/install

Additionally, install xorg-fonts-100dpi, xorg-fonts-75dpi, and
xorg-fonts-type1 so fonts are displayed properly in figures.

> Create Desktop and Menu Shortcuts

If you choose Custom in Installation Type, the symlink will be created
automatically. Otherwise, you may need to manually create a symlink in
/usr/local/bin to make it easier to launch in terminal:

    # ln -s /{MATLAB}/bin/matlab /usr/local/bin

To create a menu item, we need to get a icon first:

    # wget http://upload.wikimedia.org/wikipedia/commons/2/21/Matlab_Logo.png -O /usr/share/icons/matlab.png

Then create a new .desktop file in /usr/share/applications with
following lines:

    /usr/share/applications/matlab.desktop

    #!/usr/bin/env xdg-open
    [Desktop Entry]
    Type=Application
    Icon=/usr/share/icons/matlab.png
    Name=MATLAB
    Comment=Start MATLAB - The Language of Technical Computing
    Exec=matlab -desktop
    Categories=Development;

You can also put this .desktop file in the Desktop folder to create a
shortcut.

More details see MATLAB - Community Ubuntu Documents

> Install 32-bit Matlab on 64-bit system

Note:Follow this section only if you have a student version. All other
releases since R2012b are 64-bit only.

Unfortunately, there is no 64-bit version of the student version. These
instructions have been updated for R2012a student version. To start off
we need to install a bunch of packages from the multilib repository
(this list may be out of date): lib32-mesa, lib32-glu, lib32-glibc,
lib32-libxmu, lib32-zlib, lib32-ncurses, lib32-libxtst, lib32-libxi,
lib32-libxrender, lib32-libxfixes, lib32-freetype2, lib32-fontconfig,
lib32-libxdamage. A few packages from the AUR might also be needed:
lib32-libxpm, lib32-libxp, bin32-openjdk6 (openjdk7 might also work).

Once they are installed:

    $ ./install -glnx86

After fixing any library dependency problems, you will be able to guide
the installer through the install process. If activation doesn't work in
the installer you'll need to login to Wolfram's site and download a
license file which you'll put in ${MATLAB}/licenses. After the install
process, you'll need to create a symbolic link because the installer
oddly thinks it's installing the 64-bit version of Matlab:

    $ cd ${MATLAB}/sys/java/jre
    $ ln -s glnx86 glnxa64

In the above, ${MATLAB} should be replaced by the root directory you
chose for your installation.

You'll also need to put another link in Matlab's bin folder because
despite asking Matlab to install the 32bit version, it still thinks you
want to use the 64bit one:

    $ cd ${MATLAB}/bin
    $ ln -s glnx86 glnxa64

After that you'll need to edit the ${MATLAB}/bin/matlab script to get
the java settings correct. After the comments at the top of the file,
you'll need the line:

    export MATLAB_JAVA=/path/to/jre

Where /path/to/jre will be /opt/java/jre if you're using Sun's JRE. The
path is one level up from where rt.jar is located. That is, rt.jar
should be in /opt/java/jre/libs if you used /opt/java/jre for
MATLAB_JAVA. In Matlab R2010a it works pretty well, if you use the
internal JRE with:

    export MATLAB_JAVA=${MATLAB}/sys/java/jre/glnx86/jre

If using bin32-openjdk6, use

    export MATLAB_JAVA=/usr/lib/jvm/java-7-openjdk/jre/

To run it, you'll need to:

    $ ${MATLAB}/bin/matlab -glnx86 -desktop

At this point you may have to resolve more library dependencies or
troubleshoot Java. Your version of Matlab may need a specific version of
Sun's JRE installed.

> Install supported compiler

In order for Matlab to work with C code (needed for simulink) it is
necessarry to install a supported compiler. Install gcc44 from the AUR.

Then edit ${MATLAB}/bin/mexopts.sh and replace all occurances of
CC='gcc' with CC='gcc-4.4' and CXX='g++' with CXX='g++-4.4'. Afterwards
run

    mex -setup

in Matlab and select the mexopts.sh file.

Troubleshooting
---------------

As one installs Matlab, it might complain that it can't find a package,
for the most part just look at the package name and then install it with
Pacman, or in the case of x86_64 there are some libraries only in AUR.

License: invalid machine id

The installer may complain about an invalid machine id, because it is
looking for a network interface named eth0 to get a MAC address for
activation, while new Arch Linux setups do not have a network interface
called eth0 (systemd uses Predictable Network Interface Names). Just
change the name of the interface.

In a nutshell: install wireless_tools and execute the following:

    # systemctl stop NetworkManager
    # ifrename -i enp2s0f0 -n eth0
    # systemctl start NetworkManager

This will be needed after each reboot. To make it permanent:

    # ln -s /dev/null /etc/udev/rules.d/80-net-name-slot.rules

The machine id should now be different than 000000000000 and you should
be able to install and activate MATLAB without problems.

Resolving start warnings/errors

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

MATLAB crashes when displaying graphics

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

Blank/grey UI when using DWM/Awesome

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
"https://wiki.archlinux.org/index.php?title=Matlab&oldid=253740"

Category:

-   Mathematics and science
