Mathematica
===========

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Summary

Mathematica is a commercial program used in scientific, engineering and
mathematical fields. Here we explain how to install it.

Related

Scientific Applications

Sage-mathematics

Matlab

Resources

Official site

Official Support

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Mathematica 6                                                |
|         -   1.1.1 Mounting iso                                           |
|         -   1.1.2 Running the Installer                                  |
|         -   1.1.3 Fonts                                                  |
|         -   1.1.4 Troubleshooting                                        |
|                                                                          |
|     -   1.2 Mathematica 7                                                |
|     -   1.3 Mathematica 8                                                |
|         -   1.3.1 Mathematica 8.0.1                                      |
|                                                                          |
|     -   1.4 Mathematica 8.0.4.0                                          |
+--------------------------------------------------------------------------+

Installation
------------

> Mathematica 6

Mounting iso

One way to mount the Mathematica .iso is to create /media/iso and add
the following line to the fstab:

    /<location/of/mathematica.iso> /media/iso iso9660 exec,ro,user,noauto,loop=/dev/loop0   0 0

Now you can mount it with:

    mount /media/iso

Running the Installer

You can start the installer by navigating to:

    /Unix/Installer

Run ./MathInstaller with:

    sh ./MathInstaller

Note:If you do not place the sh in front, then you will get an error
about a bad interpreter

Fonts

Add the directories containing Type1 and BDF fonts to your FontPath.

Troubleshooting

If you have font rendering problems where certain symbols do not show up
(i.e. "/" appears as a square), try uninstalling the package
"mathematica-fonts".

Also, try this solution.

> Mathematica 7

Mathematica 7 is much easier to install.

    tar xf Mathematica-7.0.1.tar.gz
    cd Unix/Installer
    ./MathInstaller

Follow instructions.

For KDE users, the Mathematica icon may appear in the Lost & Found
category. To solve this, execute the following as root:

    sudo ln -s /etc/xdg/menus/applications-merged /etc/xdg/menus/kde-applications-merged

  

> Mathematica 8

Mathematica 8.0.1

There is a package on the AUR for Mathematica 8.0.1-2 available here.
The Mathematica_8.0.1_LINUX.sh installation script is required.

> Mathematica 8.0.4.0

On 64-bit machines, two known issues are present; but solutions are
provided. The second issue is present on 64-bit installs: but not yet
confirmed on a 32-bit arch setup.

The first issue assumes you are trying to use nVidia, CUDA and OpenCL
libraries within Mathematica.

The 64-bit archlinux nvidia and opencl driver packages install libraries
in /usr/lib, not in /usr/lib64 as does nVidia's binary installer. This
is not a problem; /usr/lib is the correct location for 64-bit libraries
on a 64-bit arch system. However, a 64-bit install of Mathematica will
assume the drivers are installed in /usr/lib64; other distributions that
Mathematica has been tested on have their drivers in that location. The
easiest method to overcome this is to make a symlink from /usr/lib64 ->
/usr/lib. Mathematica will be able to find nVidia, CUDA, and OpenCL
libraries this way without further tweaking.

A second, separate but partial solution, is to set the following
environment variables:

export NVIDIA_DRIVER_LIBRARY_PATH=/usr/lib/libnvidia-tls.so

export CUDA_LIBRARY_PATH=/usr/lib/libcuda.so

This second method, however, still will not permit Mathematica to find
the OpenCL libraries in /usr/local as Mathematica seems hardwired to
find them in /usr/lib64.

The second issue with Mathematica 8 in 64-bit archlinux (may also affect
32-bit environments; but not tested) is a reproducible crash when
performing WolframAlpha[] functions. By default, Mathematica is
configured to detect the system's proxy settings when configuring how to
connect to the internet to fetch data. A "bug" exists that will
eventually crash Mathematica when the calling library is used. A
workaround is to avoid this library call altogether by configuring
Mathematica to "directly connect" to the internet. (Edit -> Preferences
-> Internet Connectivity -> Proxy Settings). This bug has been reported
to Wolfram.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mathematica&oldid=216235"

Category:

-   Mathematics and science
