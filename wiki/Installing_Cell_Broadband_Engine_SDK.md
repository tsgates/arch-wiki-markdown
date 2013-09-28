Installing Cell Broadband Engine SDK
====================================

  
 The CBE SDK installation only supports the Fedora 9 or RHEL linux
distributions. I managed to install it on my Arch Linux system with the
help of a post in the gentoo forum, and doing some trial/error.

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Required Packages                                                  |
| -   2 Installation                                                       |
|     -   2.1 Get ISOs and build the SDK                                   |
|                                                                          |
| -   3 Running the Simulator                                              |
|     -   3.1 Other...                                                     |
+--------------------------------------------------------------------------+

Required Packages
=================

All of the following required packages are provided by the pacman
databases and the versions should be recent enough.

Core repository:

-   gcc 4.x
-   glibc
-   perl 5.x
-   freeglut
-   gawk
-   bison
-   flex

Extra repository:

-   rpmextract
-   tcl
-   tk

To make sure all of these are installed:

    # pacman -S gcc glibc perl freeglut gawk bison flex rpmextract tcl tk

  

Installation
============

> Get ISOs and build the SDK

You'll have to download the two 3.1 SDK ISOs (Developer, Extra) for
Fedora 9 manually from IBMs website, which requires free registration.
Place them in a build folder, and get the cellsdk build files from the
AUR, and place them in the same folder. Now the SDK is ready to be
build, but you will have to do it as root because the PKGBUILD uses
mount of loop-devices to extract packages from the ISOs. Build the SDK
by running:

    sudo makepkg --asroot

Now a cellsdk-3.1-1-x86_64.pkg.tar.gz should be ready for installation!
Just run

    sudo pacman -A cellsdk-3.1-1-x86_64.pkg.tar.gz

and now the SDK is installed and ready for use.

Running the Simulator
=====================

Go to /opt/ibm/systemsim-cell/ directory and type sudo ./systemsim -g
You can run without root by changing the owner and group.

    sudo chown -R /opt/ibm/systemsim-cell
    sudo chgrp -R /opt/ibm/systemsim-cell 

  

    cd /opt/ibm/systemsim-cell/bin/s
    ./systemsim -g

> Other...

Since the PKGBUILD does not run the official install script there is
bound to be something not setup completely correct... Place a comment on
the cellsdk AUR page.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Installing_Cell_Broadband_Engine_SDK&oldid=237259"

Category:

-   Emulators
