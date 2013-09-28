Install Arch i586
=================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Preface                                                            |
| -   2 Requirements                                                       |
| -   3 Step 1. Prepare build enviroment                                   |
| -   4 Step 2. Build packages                                             |
| -   5 Step 3. Solve Problem during Compiling                             |
| -   6 Step 4. Share Built Packages for i586                              |
| -   7 Step 5. Install Arch Linux on i586 by bootable linux               |
+--------------------------------------------------------------------------+

Preface
-------

This document tries to describe the process which let me successfully
build Arch Linux under other architectures.

Requirements
------------

-   A faster PC with Arch Linux already installed, we'll use it to build
    packages for i586.
-   free disk space about 2G bytes.

(space reqirement might grow to 4GB for a core repository per the begin
of 2009)

-   enough time, experience and temper prepared for fixing any problem
    encountered during the long long build

(the core repository might take two days to build, excluding those
failed, on a 2GHz E5405)

Step 1. Prepare build enviroment
--------------------------------

Prepare your system for build tasks as described in Makepkg#Setting
Things Up :

    pacman -S base-devel abs

Check /etc/abs.conf for activated repos, you should have at least core
activated, check out or update your abs tree. Then create an work
directory for your i586 PKGBUILDs and duplicate repos into it.

    # abs
    # mkdir -p /home/i586/abs
    # cd /home/i586/abs
    # cp -r /var/abs/core .

(in order to avoid building packages as root, it is better to customize
specific ~/.abs.conf and ~/.makepkg.conf instead of system-wide
/etc/abs.conf and /etc/makepkg.conf)

You also should create an directory where you will put the packages.

    # mkdir -p /home/i586/pkg

Edit the /etc/makepkg.conf or copy to ~/.makepkg.conf , modify the
following lines, we'll use -mtune option for x86 can also use the binary
packages.

    CARCH="i586"
    CHOST="i586-pc-linux-gnu"
    CFLAGS="-mtune=i586 -O2 -pipe"
    CXXFLAGS="-mtune=i586 -O2 -pipe"

For faster compiling take a look on ccache and/or distcc.

Step 2. Build packages
----------------------

After we have prepared our build enviroment now is the time to run some
last commands and get some coffee. Change to your i586 abs directory and
run makeworld.

    # cd /home/i586/abs
    # makeworld --clean --ignorearch --syncdeps --rmdeps --noconfirm /home/i586/pkg/core/ core/

When you didn't want to repeat typing your root pw for resolving
dependencies you could allow your build user to use pacman without
retyping pw. See Disable root password and gain su sudo with no password
for more information.

(sudo is designed with security concerns, environs are stripped during
sessions; so for those have only proxied access to the internet, it is
better to expicitly allow passing environs like
http_proxy/ftp_proxy/RSYNC_PROXY etc in /etc/sudoer)

And do not forget to deactivate it after using for building process!

Step 3. Solve Problem during Compiling
--------------------------------------

After the build Process come to an end, we should check which packages
have problems while building.

    # grep failed build.log

Then you should change to the package directorys in your abs copy and
retry building it.

    # cd core/<failed package>
    # PKGDEST=/home/i586/pkg/core/ makepkg --clean --ignorearch --syncdeps --rmdeps

For more information about building packages see in makepkg

Step 4. Share Built Packages for i586
-------------------------------------

Set up a Custom local repository for sharing your packages with the
target system.

Step 5. Install Arch Linux on i586 by bootable linux
----------------------------------------------------

See Install Arch from within another distro, and use your custom repos
as package source. More soon ....

Retrieved from
"https://wiki.archlinux.org/index.php?title=Install_Arch_i586&oldid=205213"

Categories:

-   Getting and installing Arch
-   CPU
