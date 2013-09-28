AMD Catalyst
============

Summary

An overview of AMD's proprietary Linux "Catalyst" video card driver.

Related

ATI

Xorg

Resources

cchtml.com - Unofficial Wiki for the ATI Linux Driver

Unofficial ATI Linux Driver Bugzilla

Owners of ATI/AMD video cards have a choice between AMD's proprietary
driver (catalyst) and the open source driver (xf86-video-ati). This
article covers the proprietary driver.

AMD's Linux driver package catalyst was previously named fglrx (FireGL
and Radeon X). Only the package name has changed, while the kernel
module retains its original fglrx.ko filename. Therefore, any mention of
fglrx below is specifically in reference to the kernel module, not the
package.

As of April 26, 2013, Catalyst packages are no longer offered in the
official repositories. In the past, Catalyst has been dropped from
official Arch support because of dissatisfaction with the quality and
speed of development. This time, it's the incompatibility with Xorg
1.14.

Compared to the open source driver, Catalyst performs worse in 2D
graphics, but has a better support for 3D rendering and power
management. Supported devices are ATI/AMD Radeon video cards with
chipset R600 and newer (Radeon HD 2xxx and newer). See the Xorg decoder
ring or this table, to translate model names (X1900, HD4850) to/from
chip names (R580, RV770 respectively).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Installing the driver                                        |
|         -   1.1.1 Installing from the unofficial repository              |
|         -   1.1.2 Installing from the AUR                                |
|         -   1.1.3 Installing directly from AMD                           |
|                                                                          |
|     -   1.2 Configuring the driver                                       |
|         -   1.2.1 Configuring X                                          |
|         -   1.2.2 Loading the module at boot                             |
|         -   1.2.3 Disable kernel mode setting                            |
|         -   1.2.4 Checking operation                                     |
|                                                                          |
|     -   1.3 Custom Kernels                                               |
|     -   1.4 PowerXpress support                                          |
|         -   1.4.1 Running two X servers (one using the Intel driver,     |
|             another one using fglrx) simultaneously                      |
|                                                                          |
| -   2 Xorg repositories                                                  |
|     -   2.1 [xorg113]                                                    |
|     -   2.2 [xorg112]                                                    |
|     -   2.3 [xorg111]                                                    |
|                                                                          |
| -   3 Tools                                                              |
|     -   3.1 Catalyst-hook                                                |
|     -   3.2 Catalyst-generator                                           |
|     -   3.3 OpenCL and OpenGL development                                |
|         -   3.3.1 amdapp-aparapi                                         |
|         -   3.3.2 amdapp-sdk (formerly known as amdstream)               |
|         -   3.3.3 amdapp-codexl                                          |
|                                                                          |
| -   4 Features                                                           |
|     -   4.1 Tear Free Rendering                                          |
|     -   4.2 Video acceleration                                           |
|     -   4.3 GPU/Mem frequency, Temperature, Fan speed, Overclocking      |
|         utilities                                                        |
|     -   4.4 Double Screen (Dual Head / Dual Screen / Xinerama)           |
|         -   4.4.1 Introduction                                           |
|         -   4.4.2 ATI Catalyst Control Center                            |
|         -   4.4.3 Installation                                           |
|         -   4.4.4 Configuration                                          |
|                                                                          |
| -   5 Uninstallation                                                     |
| -   6 Troubleshooting                                                    |
|     -   6.1 3D Wine applications freeze                                  |
|     -   6.2 Problems with video colours                                  |
|     -   6.3 KWin and composite                                           |
|     -   6.4 Black screen with complete lockups and/or hangs after reboot |
|         or startx                                                        |
|         -   6.4.1 Faulty ACPI hardware calls                             |
|                                                                          |
|     -   6.5 KDM disappears after logout                                  |
|     -   6.6 Direct Rendering does not work                               |
|     -   6.7 Hibernate/Sleep Issues                                       |
|         -   6.7.1 Video fails to resume from suspend2ram                 |
|                                                                          |
|     -   6.8 System Freezes/Hard locks                                    |
|     -   6.9 Hardware Conflicts                                           |
|     -   6.10 Temporary hangs when playing video                          |
|     -   6.11 "aticonfig: No supported adapters detected"                 |
|     -   6.12 WebGL support in Chromium                                   |
|     -   6.13 Laggs/freezes when watching flash videos via Adobe's        |
|         flashplugin                                                      |
|     -   6.14 Laggs/slow windows movement in GNOME3                       |
|     -   6.15 Not using fullscreen resolution at 1920x1080                |
|         (underscanning)                                                  |
|     -   6.16 Dual Screen Setup: general problems with acceleration,      |
|         OpenGL, compositing, performance                                 |
|     -   6.17 Disabling VariBright Feature                                |
|     -   6.18 Hybrid/PowerXpress: turning off discrete GPU                |
|     -   6.19 Switching from X session to TTYs gives blank screen         |
+--------------------------------------------------------------------------+

Installation
------------

There are three ways of installing Catalyst on your system. One way is
to use Vi0L0's (Arch's unofficial Catalyst maintainer) repository. This
repository contains all the necessary packages. The second method you
can use is the AUR; PKGBUILDs offered here are also made by Vi0L0 and
are the same he uses to built packages for his repository. Lastly, you
can install the driver directly from AMD.

Before choosing the method you prefer, you will have to see which driver
you need. Since Catalyst 12.4, AMD has separated its development for
Radeon HD 2xxx, 3xxx and 4xxx cards into the legacy Catalyst driver. For
Radeon HD 5xxx and newer, there is the regular Catalyst driver.
Regardless of the driver you need, you will also need the Catalyst
utilities.

Note:After the instructions for every method of installing, you will
find general instructions everyone has to perform, regardless of the
method you used.

> Installing the driver

Installing from the unofficial repository

If you don't fancy building the packages from the AUR, this is the way
to go. The repository is maintained by our unofficial Catalyst
maintainer, Vi0L0. All packages are signed and are considered safe to
use. As you will see later on in this article, Vi0L0 is also responsible
for many other packages that will help you get your system working with
your ATI graphic cards.

Vi0L0 has three different Catalyst repositories, each having different
drivers:

-   [catalyst]; for the regular Catalyst driver needed by Radeon HD 5xxx
    and up, it contains the latest (stable or beta) Catalyst release;
-   [catalyst-stable]; for the regular Catalyst driver needed by Radeon
    HD 5xxx and up, with the latest stable driver;
-   [catalyst-hd234k]; for the legacy Catalyst driver needed by Radeon
    HD 2xxx, 3xxx and 4xxx cards.

Warning:The regular Catalyst driver does not support Xorg 1.14 for now.
Support should be added by AMD in a century or two, but this could be
sooner. Should you want to use this driver, see #Xorg repositories for
instructions on how to roll back to or hold back Xorg 1.13.

Warning:The legacy Catalyst driver does not support Xorg 1.13. Should
you want to use this driver, see #Xorg repositories for instructions on
how to roll back to Xorg 1.12.

To enable one of these, you will have to edit /etc/pacman.conf and add
the repository of choice's information above all other repositories in
/etc/pacman.conf.

-   For [catalyst], add:

    [catalyst]
    Server = http://catalyst.wirephire.com/repo/catalyst/$arch

-   For [catalyst-stable], add:

    [catalyst-stable]
    Server = http://catalyst.wirephire.com/repo/catalyst/$arch

-   For [catalyst-hd234k], add:

    [catalyst-hd234k]
    Server = http://catalyst.wirephire.com/repo/catalyst-hd234k/$arch

You must also add Vi0L0's GPG key so that pacman trusts the
repositories.

    # pacman-key --keyserver pgp.mit.edu --recv-keys 0xabed422d653c3094
    # pacman-key --lsign-key 0xabed422d653c3094

Once you have done this, update pacman's database and install the
packages:

    # pacman -Syu
    # pacman -S catalyst catalyst-utils

Note:If pacman asks you about removing libgl you can safely do so.

Warning:Catalyst from Vi0L0's repository is compiled against one kernel
and one kernel only. For Vi0L0, it's getting more and more difficult to
keep up with kernel's pace and as such, we have seen a lot of users
asking for what to do in the forums. Often, the solution is to a) wait
for Vi0L0 to rebuilt the Catalyst package against those newer versions,
b) do so yourself or c) hold back the Linux kernel update. The easiest
solution is to do so yourself, not manually, but by using Vi0L0's
excellent #Catalyst-hook.

If you are on 64-bit and also need 32-bit OpenGL support:

    # pacman -S lib32-catalyst-utils

Repositories also contain other packages, that can replace the
catalyst-hook package:

-   catalyst-generator; this package is able to generate fglrx modules
    packed into pacman compliant packages - most secure and
    KISS-compatible package in this side-note, although it has to be
    operated manually. It's described in #Catalyst-generator
-   catalyst-hook; a systemd service which will automatically update the
    fglrx module whilst the system shuts down or reboots. It's described
    in #Catalyst-hook

You will find more details about those packages in #Tools. Lastly, both
repositories also contain the xvba-video package, which enables video
acceleration, described in #Video acceleration, the AMDOverdriveCtrl
package, which is a GUI to control over- and underclocking, also
described in #GPU/Mem frequency, Temperature, Fan speed, Overclocking
utilities, and a pack of tools for OpenCL/OpenGL developers, described
in #OpenCL and OpenGL development

Installing from the AUR

The second way to install Catalyst is from the AUR. If you want to built
the packages specifically for your computer, this is your way to go.
Note that this is also the most tedious way to install Catalyst; it
requires the most work and also requires manual updates upon every
kernel update.

Warning:If you install the Catalyst package from the AUR, you will have
to rebuild Catalyst every time the kernel is updated. Otherwise X will
fail to start.

All packages mentioned above in Vi0L0's unofficial repository are also
available on the AUR:

-   catalyst;
-   catalyst-generator;
-   catalyst-hook;
-   catalyst-utils;
-   lib32-catalyst-utils;

The AUR also holds some packages that are not found in any of the
repositories. These packages contain the so-called Catalyst-total
packages and the beta versions:

-   catalyst-total;
-   catalyst-total-pxp;
-   catalyst-total-hd234k;
-   catalyst-test;

The catalyst-total packages are made to make the lives of AUR users
easier. It builds the driver, the kernel utilities and the 32 bit kernel
utilities. It also builds the catalyst-hook package, which is explained
above.

catalyst-total-pxp builds Catalyst with experimental powerXpress
support.

Installing directly from AMD

Warning:Using the installer from ati.com/amd.com is not recommended! It
may cause file conflicts and X failures and you will miss Arch-specific
fixes. You must be familiar with booting to the command-line if you wish
to attempt this.

Note:If you have attempted a manual install from the official installer
and cannot recover your desktop:

    # /usr/share/ati/fglrx-uninstall.sh

1. Download the installer from AMD or elsewhere (whereas *-* will be the
version): ati-driver-installer-*-*-x86.x86_64.run

2. Make sure it's executable: # chmod +x ati-driver*

3. Ensure you're using a basic video driver like vesa and remove
conflicting drivers (i.e. xf86-video-ati) with pacman.

4. Symlink /usr/src/linux to /usr/src/{kernelsource}. 64-bit users also
symlink/usr/lib64 to /usr/lib.

5. Be sure to have your build environment setup:
# pacman -Syu base-devel linux-headers

6. Now run # ./ati-driver-installer-*-*-x86.86_64.run (Files will
extract to a temporary folder and scripts will run...)

7. Assuming nothing went horribly wrong, check
/usr/share/ati/fglrx-install.log for issues. There should also be a
/lib/modules/fglrx/make.{ker_version}.log

Note:If you modify the make scripts, save to a different filename.
Otherwise uninstall will not complete successfully.

> Configuring the driver

After you have installed the driver via your chosen method, you will
have to configure X to work with Catalyst. Also, you will have to make
sure the module gets loaded at boot. Also, one should disable kernel
mode setting.

Configuring X

To configure X, you will have to create an xorg.conf file. Catalyst
provides its own aticonfig tool to create and/or modify this file. It
also can configure virtually every aspect of the card for it also
accesses the /etc/ati/amdpcsdb file. For a complete list of aticonfig
options, run:

    # aticonfig --help | less

Warning:Use the --output option before committing to /etc/X11 as an
xorg.conf file will override anything in /etc/X11/xorg.conf.d

Note:If you want to adhere to the new xorg.conf.d: Append your aticonfig
string with --output so that you can adapt the Device section to
/etc/X11/xorg.conf.d/20-radeon.conf. The drawback of this is that many
aticonfig options rely on an xorg.conf, and thus will be unavailable.

Now, to configure Catalyst. If you have only one monitor, run this:

    # aticonfig --initial

Note: If you have PowerXpress problem you should probably install
catalyst-utils-pxp

However, if you have two monitors and want to use both of them, you can
run the command stated below. Note that this will generate a dual head
configuration with the second screen located above the first screen.

    # aticonfig --initial=dual-head --screen-layout=above

Note:See #Double Screen (Dual Head / Dual Screen / Xinerama) for more
information on setting up dual monitors.

You can compare the generated file to one of the Sample Xorg.conf
examples listed on the Xorg page.

Although the current Xorg versions auto-detect most options when
started, you may want to specify some in case the defaults change
between versions.

Here is an example (with notes) for reference. Entries with '#' should
be required, add entries with '##' as needed:

    Section "ServerLayout"
            Identifier     "Arch"
            Screen      0  "Screen0" 0 0          # 0's are necessary.
    EndSection
    Section "Module"
            Load ...
            ...
    EndSection
    Section "Monitor"
            Identifier   "Monitor0"
            ...
    EndSection
    Section "Device"
            Identifier  "Card0"
            Driver      "fglrx"                         # Essential.
            BusID       "PCI:1:0:0"                     # Recommended if autodetect fails.
            Option      "OpenGLOverlay" "0"             ##
            Option      "XAANoOffscreenPixmaps" "false" ##
    EndSection
    Section "Screen"
            Identifier "Screen0"
            Device     "Card0"
            Monitor    "Monitor0"
            DefaultDepth    24
            SubSection "Display"
                    Viewport   0 0
                    Depth     24                        # Should not change from '24'
                    Modes "1280x1024" "2048x1536"       ## 1st value=default resolution, 2nd=maximum.
                    Virtual 1664 1200                   ## (x+64, y) to workaround potential OGL rect. artifacts/
            EndSubSection                               ## fixed in Catalyst 9.8
    EndSection
    Section "DRI"
            Mode 0666                                   # May help enable direct rendering.
    EndSection

Note:With every Catalyst update you should remove amdpcsdb file in this
way: kill X, remove /etc/ati/amdpcsdb, start X and then run amdcccle -
otherwise the version of Catalyst may display wrongly in amdcccle.

If you need more information on Catalyst, visit this thread.

Loading the module at boot

We have to blacklist the radeon module to prevent it from auto-loading.
To do so, blacklist radeon in /etc/modprobe.d/modprobe.conf. Also, make
sure that it is not loaded by any file under /etc/modules-load.d/. For
more information, see kernel modules#Blacklisting.

Then we will have to make sure that the fglrx module gets auto-loaded.
Either add fglrx on a new line of an existing module file located under
/etc/modules-load.d/, or create a new file and add fglrx.

Disable kernel mode setting

Disabling kernel mode setting is important, as the driver doesn't take
advantage of KMS yet. If you do not deactivate KMS, your system might
freeze when trying to switch to a tty or even when shutting down via
your DE.

To disable kernel mode setting, add nomodeset to your kernel parameters.
For example:

-   For GRUB Legacy, edit menu.lst and add nomodeset to the kernel line:

    kernel /boot/vmlinuz-linux root=/dev/sda1 ro nomodeset

-   For GRUB, edit /etc/default/grub and add nomodeset to
    GRUB_CMDLINE_LINUX:

    GRUB_CMDLINE_LINUX="nomodeset"

Then run, as root:

    # grub-mkconfig -o /boot/grub/grub.cfg

-   For Syslinux, edit /boot/syslinux/syslinux.cfg and add nomodeset to
    the APPEND line, e.g.:

    APPEND root=/dev/sda2 ro nomodeset

Checking operation

Assuming that a reboot to your login was successful, you can check if
fglrx is running properly with the following commands:

    $ lsmod | grep fglrx
    $ fglrxinfo

If you get output, it works. Finally, run X with startx or by using
GDM/KDM and verify that direct rendering is enabled by running the
following command in a terminal:

    $ glxinfo | grep "direct rendering"

If it says "direct rendering: yes" then you're good to go! If the
glxinfo command is not found install the mesa-demos package.

Note:You can also use:

    $ fgl_glxgears

as the fglrx alternative test to glxgears.

Warning:In recent versions of Xorg, the paths of libs are changed. So,
sometimes libGL.so cannot be correctly loaded even if it's installed.
Check this if your GL is not working. Please read "Troubleshooting"
section for details.

If you have trouble, see #Troubleshooting.

> Custom Kernels

To install catalyst for a custom kernel, you'll need to build your own
catalyst-$kernel package.

If you are at all uncomfortable or inexperienced with making packages,
read up the ABS wiki page first so things go smoothly.

1.  Obtain the PKGBUILD and catalyst.install files from Catalyst.
2.  Editing the PKGBUILD. Two changes need to be made here:
    1.  Change pkgname=catalyst to pkgname=catalyst-$kernel_name, where
        $kernel_name is whatever you want (e.g. custom, mm,
        themostawesomekernelever).
    2.  Change the dependency of linux to $kernel_name.

3.  Build your package and install; run makepkg -i or makepkg followed
    by pacman -U pkgname.pkg.tar.gz

Note:If you run multiple kernels, you have to install the Catalyst-utils
packages for all kernels. They won't conflict with one another.

Note:Catalyst-generator is able to build catalyst-{kernver} packages for
you so you do not actually need to perform all those steps manually. For
more information, see Tools section.

> PowerXpress support

PowerXpress technology allows switching notebooks with dual-graphic
capability from integrated graphics (IGP) to discrete graphics either to
increase battery life or to achieve better 3D rendering capabilities.

To use such functionality on Arch you will have to:

-   Get and build catalyst-total-pxp package from the AUR, or
-   Install catalyst-utils-pxp package from the [catalyst] repository
    (plus additional lib32-catalyst-utils-pxp, if needed).

To perform a switch into Intel's IGP you will also have to install the
mesa-libgl package and Intel's drivers: xf86-video-intel and intel-dri.

Note:With the latest version of Catalyst, version 13.1 (not Catalyst
legacy) ChrisXY was able to work on the newest xorg-server (version
1.13.1), mesa 9.0.1 and xf86-video-intel 2.20.18.

On any version of Catalyst below 13.1 (and all versions of Catalyst
legacy) there are some problems with the new Intel drivers and the last
noted working version of xf86-video-intel is 2.20.2-2, so you will
probably have to downgrade from the latest version that you have gotten
from Arch's repositories (although we recommend to test the newest one
before downgrading - there's always some possibility that it will work).

xf86-video-intel 2.20.2-2 works only with xorg-server 1.12 and so it is
a part of the xorg112 repository. If you want to use it you will have to
downgrade xorg-server as well. For information on this, see #Xorg
repositories.

Now you can switch between the integrated and the discrete GPU, using
these commands:

    # aticonfig --px-igpu    #for integrated GPU
    # aticonfig --px-dgpu    #for discrete GPU

Just remember that fglrx needs /etc/X11/xorg.conf configured for AMD's
card with 'fglrx' inside.

You can also use the pxp_switch_catalyst switching script that will
perform some additional usefull operations:

-   Switching xorg.conf - it will rename xorg.conf into xorg.conf.cat
    (if there's fglrx inside) or xorg.conf.oth (if there's intel inside)
    and then it will create a symlink to xorg.conf, depending on what
    you chose.
-   Running aticonfig --px-Xgpu.
-   Running switchlibGL.
-   Adding/removing fglrx into/from /etc/modules-load.d/catalyst.conf.

Usage:

    # pxp_switch_catalyst amd
    # pxp_switch_catalyst intel

If you have got problems when you try to run X on Intel's driver you may
try to force "UXA" acceleration; just make sure that your xorg.conf for
Intel's GPU got Option "AccelMethod" "uxa", like here:

    Section "Device"
       Identifier  "Intel Graphics"
       Driver      "intel"
       #Option      "AccelMethod"  "sna"
       Option      "AccelMethod"  "uxa"
       #Option      "AccelMethod"  "xaa"
    EndSection

Running two X servers (one using the Intel driver, another one using fglrx) simultaneously

Because fglrx is crash-prone (regarding PowerXpress), it could be a good
idea to use the Intel driver in the main X server and have a secondary X
server using fglrx when 3D acceleration is needed. However, simply
switching to the discrete GPU from the integrated GPU using aticonfig or
amdcccle will cause all sorts of weird bugs when starting the second X.

To run two X servers at the same time (each using different drivers),
you should firstly set up a fully working X with Catalyst and then move
its xorg.conf to a temporary place (for example,
/etc/X11/xorg.conf.fglrx. The next time X is started, it will use the
Intel driver by default instead of fglrx.

To start a second X server using fglrx, simply move xorg.conf back to
the proper place (/etc/X11/xorg.conf) before starting X. This method
even allows you to switch between running X sessions. When you are done
using fglrx, move xorg.conf somewhere else again.

The only disadvantage of this method is not having 3D acceleration using
the Intel driver. 2D acceleration, however, is fully functional. Other
than that, this will provide us with a completely stable desktop.

Xorg repositories
-----------------

Catalyst is notorious for its slow update process. As such, it is common
that a new Xorg version is pushed down from upstream that will break
compatibility for Catalyst. This means that Catalyst users either have
to hold the Xorg packages from updating, or use a backported repository
that only contains the Xorg packages that should be hold back. Vi0L0 has
stepped in to fulfil this task and provides several backported
repositories.

If you want to use pacman to hold back packages from updating, see
pacman#Skip package from being upgraded. Packages you should hold back,
are:

-   xorg-server-*
-   xf86-input-*
-   xf86-video-*

If you want to use the backported repositories, you have to edit
/etc/pacman.conf and add the information of the repository above all
other repositories, even above your Catalyst repository, should you use
one.

> [xorg113]

Catalyst doesn't support xorg-server 1.14.

    [xorg113]
    Server = http://catalyst.wirephire.com/repo/xorg113/$arch

> [xorg112]

Catalyst < 12.10 and Catalyst Legacy do not support xorg-server 1.13.

    [xorg112]
    Server = http://catalyst.wirephire.com/repo/xorg112/$arch

> [xorg111]

Catalyst < 12.6 doesn't support xorg-server 1.12.

    [xorg111]
    Server = http://catalyst.wirephire.com/repo/xorg111/$arch

Tools
-----

> Catalyst-hook

Catalyst-hook is a systemd service that will automatically rebuild the
fglrx modules while the system shuts down or reboots, but only if it's
necessary (e.g. after an update).

Before using this package make sure that both the base-devel group and
the linux-headers package (the one specific to the kernel you use) are
installed:

    # pacman -S base-devel linux-headers

To enable the automatic update, enable the catalyst-hook.service:

    # systemctl enable catalyst-hook
    # systemctl start catalyst-hook

You can also use this package to build the fglrx module manually. Simply
run the catalyst_build_module script after the kernel has been updated:

    # catalyst_build_module all

A few more technical details:

The catalyst-hook.service is stopping the systemd "river" and is forcing
systemd to wait until catalyst-hook finishes its job.

The catalyst-hook.service is calling the catalyst_build_module check
function which checks if fglrx rebuilds are really necessary.

The check function is checking if the fglrx module exists, if it:

-   doesn't exist, it will build it;

-   does exist, it will compare the two values to be sure that a rebuild
    is necessary.

These values are md5sums of the
/usr/lib/modules/<kernel_version>/build/Module.symvers file (because I,
Vi0L0, noticed that this file is unique and different for every kernel's
release). The first value is the md5sum of the existing Module.symvers
file. The second value is the md5sum of the Module.symvers file which
existed in a moment of the fglrx module creation. This value was
compiled into the fglrx module by a catalyst_build_module script.

If the values are different, it will compile the new fglrx module.

The check is checking the whole /usr/lib/modules/ directory and building
modules for all of the installed kernels if it's necessary. If the build
or rebuild isn't necessary, the whole process takes only some
milliseconds to complete before it gets killed by systemd.

> Catalyst-generator

Catalyst-generator is a package that is able to build and install the
fglrx module packed into pacman compliant catalyst-${kernver} packages.
The basic difference from Catalyst-hook is that you will have to trigger
this command manually, whereas Catalyst-hook will do this automatically
at boot when a new kernel got installed.

It creates catalyst-${kernver} packages using makepkg and installs them
with pacman. ${kernver} is the kernel version for which each package was
built (e.g. catalyst-2.6.35-ARCH package was built for 2.6.35-ARCH
kernel).

To build and install catalyst-${kernver} package for a currently booted
kernel as an unprivileged user (non-root; safer way), use
catalyst_build_module. You will be asked for your root password to
proceed to package installation.

A short summary on how to use this package:

1.  As root: catalyst_build_module remove. This will remove all unused
    catalyst-{kernver}  packages.
2.  As unprivileged user: catalyst_build_module ${kernver}, where
    ${kernver} is the version of the kernel to which you just updated.
    For example: catalyst_build_module 2.6.36-ARCH. You can also build
    catalyst-${kernver} for all installed kernels by using
    catalyst_build_module all.
3.  If you want to remove catalyst-generator, it's best to run this as
    root before removing catalyst-generator:
    catalyst_build_module remove_all. This will remove all
    catalyst-{kernver} packages from the system.

Catalyst-generator isn't able to remove all those catalyst-{kernver}
packages automatically while being removed because there can not be more
than one instance of pacman running. If you forget to run
catalyst_build_module remove_all before using
pacman -R catalyst-generator catalyst-generator will tell you which
catalyst-{kernver} packages you will have to remove manually after
removing catalyst-generator itself.

Catalyst-generator is most safe and KISS-friendly solution because:

- you can use unprivileged user to build the package;

- it's building modules in fakeroot environment;

- it's not throwing files here and there, package manager always knows
where they are;

... all you have to do is to remember to use it

Note:If you see those warnings:

WARNING: Package contains reference to $srcdir

WARNING: '.pkg' is not a valid archive extension.

while building catalyst-{kernver} package, do not be concerned, it's
normal.

> OpenCL and OpenGL development

Since years AMD is working on tools for OpenCL and OpenGL developement.

Now under the banner of "Heterogeneous Computing" AMD is providing even
more of them, fortunately most of their computing tools are available
also for Linux.

In the AUR and the [catalyst] repositories you will find packages that
represent the most important work from AMD, namely; amdapp-aparapi,
amdapp-sdk and amdapp-codexl.

APP shortcut stands for Accelerated Parallel Processing.

amdapp-aparapi

AMD's Aparapi is an API for expressing data parallel workloads in Java
and a runtime component capable of converting the Java bytecode of
compatible workloads into OpenCL so that it can be executed on a variety
of GPU devices. If Aparapi can’t execute on the GPU, it will execute in
a Java thread pool.

You can find more information about Aparapi here.

amdapp-sdk (formerly known as amdstream)

The AMD APP Software Development Kit (SDK) is a complete development
platform created by AMD to allow you to quickly and easily develop
applications accelerated by AMD APP technology. The SDK provides
samples, documentation and other materials to quickly get you started
leveraging accelerated compute using OpenCL, Bolt, or C++ AMP in your
C/C++ application.

Since version 2.8 amdapp-sdk is providing aparapiUtil as well as
aparapi's samples. A package is available on the [catalyst] repository;
it depends on the amdapp-aparapi package. The AUR's package will let you
decide whether you want aparapi's additions or not.

Version 2.8 does not provide Profiler functionality, it has been moved
to CodeXL.

You can find more information about AMD APP SDK here.

amdapp-codexl

CodeXL is an OpenCL and OpenGL Debugger and Profiler, with a static
OpenCL kernel analyzer. It's a GUI application written atop of the well
known gDEBugger and is available only for x86_64 systems.

You can find more informations about CodeXL here.

Features
--------

> Tear Free Rendering

Presented in Catalyst 11.1, the Tear Free Desktop feature reduces
tearing in 2D, 3D and video applications. This likely adds
triple-buffering and v-sync. Do note that it requires additional GPU
processing.

To enable 'Tear Free Desktop' run amdcccle and go to: Display Options →
Tear Free.

Or as root run:

    # aticonfig --set-pcs-u32=DDX,EnableTearFreeDesktop,1

To disable, again use amdcccle or run as root:

    # aticonfig --del-pcs-key=DDX,EnableTearFreeDesktop

> Video acceleration

Video Acceleration API (VA API) is an open source software library
(libVA) and API specification which provides GPU acceleration for video
processing on Linux/UNIX based operating systems. The process works by
enabling hardware accelerated video decode at various entry-points (VLD,
IDCT, Motion Compensation, deblocking) for common encoding standards
(MPEG-2, MPEG-4 ASP/H.263, MPEG-4 AVC/H.264, and VC-1/WMV3).

VA-API gained a proprietary backend (in November 2009) called
xvba-video, that allows VA-API programmed applications to take advantage
of AMD Radeons UVD2 chipsets via the XvBA (X-Video Bitstream
Acceleration API designed by AMD) library.

XvBA support and xvba-video is still under development, however it is
working very well in most cases. Build the xvba-video package from AUR
or soon, install it from [community] and install mplayer-vaapi and
libva. Then just set your video player to use vaapi:gl as video output:

    $ mplayer -vo vaapi:gl movie.avi

These options can be added to your mplayer configuration file, see
MPlayer.

For smplayer:

    Options → Preferences → General → Video (tab) → Output driver: User Defined : vaapi:gl
    Options → Preferences → General → Video (tab) → Double buffering on
    Options → Preferences → General → General → Screenshots → Turn screenshots off
    Options → Preferences → Performance → Threads for decoding: 1 (to turn off -lavdopts parameter)

Note:If Tear Free Desktop is enabled it's better to use:

    Options -> Preferences -> General -> Video (tab) -> Output driver: vaapi

If Video Output vaapi:gl isn't working - please check:

    vaapi, vaapi:gl2 or simply xv(0 - AMD Radeon AVIVO Video).

For VLC:

    Tools → Preferences → Input & Codecs → Use GPU accelerated decoding

It might help to enable v-sync in amdcccle:

    3D → More Settings → Wait for vertical refresh = Always On

Note:If you are using Compiz/KWin, the only way to avoid video
flickering is to watch videos in full-screen and only when Unredirect
Fullscreen is off. In compiz you need to set Redirected Direct Rendering
in General Options of ccsm. If it is still flickering, try to disable
this option in CCSM. It's off by default in KWin, but if you see
flickering try to turn "Suspend desktop effects for fullscreen windows"
on or off in System Settings → Desktop Effects → Advanced.

> GPU/Mem frequency, Temperature, Fan speed, Overclocking utilities

You can get the GPU/Mem clocks with: $ aticonfig --od-getclocks.

You can get the fan speed with: $ aticonfig --pplib-cmd "get fanspeed 0"

You can get the temperature with: $ aticonfig --odgt

To set the fanspeed with: $ aticonfig --pplib-cmd "set fanspeed 0 50"
Query Index: 50, Speed in percent

To overclock and/or underclock it's easier to use a GUI, like ATi
Overclocking Utility, which is very simple and requires qt to work. It
might be out of date/old, but you can get it here.

Another, more complex utility to perform such operations is
AMDOverdriveCtrl. Its homepage is here and you can build an Arch package
from AUR or from Vi0L0's unofficial repositories.

> Double Screen (Dual Head / Dual Screen / Xinerama)

Introduction

Warning: you should know that there isn't one specific solution because
each setup differs and needs its own configuration. That's why you will
have to adapt the steps below to your own needs. It is possible that you
have to try more than once. Therefore, you should save your working
/etc/X11/xorg.conf before you start modifying and you must be able to
recover from a command-line environment.

-   In this chapter, we will describe the installation of two
    different-sized screens on only one graphics card with two different
    output ports (DVI + HDMI) using a "BIG Desktop" configuration.

-   The Xinerama solution has some inconveniences, especially because it
    is not compatible with XrandR. For that very reason, you should not
    use this solution, because XrandR is a must for our later
    configuration.

-   The Dual Head solution would allow you to have 2 different sessions
    (one for each screen). It could be what you want, but you will not
    be able to move windows from one screen to another. If you have only
    one screen, you will have to define the mouse inside your Xorg
    session for each of the two sessions inside the Server Layout
    section.

ATI Documentation

ATI Catalyst Control Center

The GUI tool shipped by ATI is very useful and we will try to use it as
much as we can. To launch it, open a terminal and use the following
command:

    $ {kdesu/gksu} amdcccle

Warning:Do not use sudo directly with a GUI. Sudo gives you admin rights
with user account information. Instead, use gksu (GNOME) or kdesu (KDE).

Installation

Before we start, make sure that your hardware is plugged in correctly,
that power is on and that you know your hardware characteristics (screen
dimensions, sizes, refreshment rates, etc.) Normally, both screens are
recognized during boot time but not necessarily identified properly,
especially if you are not using any Xorg base configuration file
(/etc/X11/xorg.conf) but relying on the hot-plugging feature.

The first step is to make sure that you screens will be recognized by
your DE and by X. For this, you need to generate a basic Xorg
configuration file for your two screens:

    # aticonfig --initial --desktop-setup=horizontal --overlay-on=1

or

    # aticonfig --initial=dual-head --screen-layout=left

Note:overlay is important because it allows you to have 1 pixel (or
more) shared between the 2 screens.

Tip:For the other possible and available options, do not hesitate to
type aticonfig --help inside a terminal to display all available command
lines.

Now you should have a basic Xorg configuration file that you can edit to
add your screen resolutions. It is important to use the precise
resolution, especially if you have screens of different sizes. These
resolutions have to be added in the "Screen" section:

    SubSection "Display"
    Depth 24
    Modes "X-resolution screen 1xY-resolution screen 1" "Xresolution screen 2xY-resolution screen 2"
    EndSubSection

From now on, instead of editing the xorg.conf file manually, let us use
the ATI GUI tool. Restart X to be sure that your two screens are
properly supported and that the resolutions are properly recognized
(Screens must be independent, not mirrored).

Configuration

Now you will only have to launch the ATI control center with root
privileges, go to the display menu and choose how you would like to set
your configuration (small arrow of the drop down menu). A last restart
of X and you should be done!

Before you restart X, do not hesitate to verify your new xorg.conf file.
At this stage, inside the "Display" sub-section of the "Screen" section,
you should see a "Virtual" command line, of which the resolution should
be the sum of both screens. The "Server Layout" section says all the
rest.

Uninstallation
--------------

If for any reason this driver is not working for you or if you somply
want to try out the open source driver, remove the catalyst and
catalyst-utils packages. Also you should remove catalyst-generator,
catalyst-hook and lib32-catalyst-utils packages if they have been
installed on your system.

Warning:You may need to use pacman -Rdd to remove catalyst-utils (and/or
lib32-catalyst-utils) because that package contains gl related files and
many of your installed packages depend on them. These dependencies will
be satisfied again when you install xf86-video-ati.

Warning:You may need to remove /etc/profile.d/ati-flgrx.sh and
/etc/profile.d/lib32-catalyst (if it exists on your system), otherwise
r600_dri.so will fail to load and you would not have 3D support.

Note:You should remove unofficial repositories from your
/etc/pacman.conf and run pacman -Syu, because those repositories include
out-dated Xorg packages to allow use of catalyst and the xf86-video-ati
package needs up-to-date Xorg packages from the Official repositories.

Also follow these steps:

-   If you have the /etc/modprobe.d/blacklist-radeon.conf file remove it
    or comment the line blacklist radeon in that file.
-   If you have a file in /etc/modules-load.d to load the fglrx module
    on boot, remove it or comment the line containing fglrx.
-   Make sure to remove or backup /etc/X11/xorg.conf.
-   If you have installed the catalyst-hook package, make sure to
    disable the systemd service.
-   If you have installed the catalyst-generator package, make sure to
    remove "fglrx" from the "MODULES" array of /etc/rc.conf in case if
    post-removal script of the package don't work.
-   If you used the "nomodeset" option in your configuration file in
    kernel parameters line and plan to use KMS, remove it.
-   Reboot before installing another driver.

Troubleshooting
---------------

If you can still boot to command-line, then the problem probably lies in
/etc/X11/xorg.conf

You can parse the whole /var/log/Xorg.0.log or, for clues:

    $ grep '(EE)' /var/log/Xorg.0.log
    $ grep '(WW)' /var/log/Xorg.0.log

If you are still confused about what is going on, search the forums
first. Then post a message in the thread specific to ATI/AMD. Provide
the information from xorg.conf and both commands mentioned above.

> 3D Wine applications freeze

If you use a 3D Wine application and it hangs, you have to disable TLS.
To do this, either use aticonfig or edit /etc/X11/xorg.conf. To use
aticonfig:

    # aticonfig --tls=off

Or, to edit /etc/X11/xorg.conf; first open the file in an editor as root
and then add Option "UseFastTLS" "off" to the Device section of this
file.

After applying either of the solutions, restart X for it to take effect.

> Problems with video colours

You may still use vaapi:gl to avoid video flickering, but without video
acceleration:

-   Run mplayer without -vo vaapi switch.

-   Run smplayer remove -vo vaapi from Options → Preferences → Advanced
    → Options for MPlayer → Options: -vo vaapi

Plus for smplayer you may now safely turn screenshots on.

> KWin and composite

You may use XRender if the rendering with OpenGL is slow. However,
XRender might also be slower than OpenGL depending on your card. XRender
also solves artefact issues in some cases, for instance when resizing
Konsole.

> Black screen with complete lockups and/or hangs after reboot or startx

Ensure you have added the nomodeset option to the kernel options line in
your bootloader (see #Disable kernel mode setting).

If you are using the legacy driver (catalyst-hd234k) and get a black
screen, try downgrading xorg-server to 1.11 by using the #xorg111
repository.

Faulty ACPI hardware calls

It is possible that fglrx doesn't cooperate well with the system's ACPI
hardware calls, so it auto-disables itself and there is no screen
output.

If so, try to run this:

    $ aticonfig --acpi-services=off

> KDM disappears after logout

If you are running Catalyst proprietary driver and you get a console
(tty1) instead of the expected KDM greeting when you log out, you must
instruct KDM to restart the X server after each logout:

    $ sudo nano /usr/share/config/kdm/kdmrc

Uncomment the following line under the section titled [X-:*-Core]:

    TerminateServer=True

KDM should now appear when you log out of KDE.

> Direct Rendering does not work

This problem may occur when using the proprietary Catalyst driver.

Warning:This error would also appear if you have not rebooted your
system after the installation or upgrade of catalyst. The system needs
to load the fglrx.ko module in order to make the driver work.

If you have problem with direct rendering, run:

    $ LIBGL_DEBUG=verbose glxinfo > /dev/null

at the command prompt. At the very start of the output, it'll usually
give you a nice error message saying why you do not have direct
rendering.

Common errors and their solutions, are:

    libGL error: XF86DRIQueryDirectRenderingCapable returned false

-   Ensure that you are loading the correct agp modules for your AGP
    chipset before you load the fglrx kernel module. To determine which
    agp modules you'll need, run hwdetect --show-agp. Then open your
    fglrx.conf file in /etc/modules-load.d and add the agp module on a
    line before the fglrx line.

    libGL error: failed to open DRM: Operation not permitted
    libGL error: reverting to (slow) indirect rendering

    libGL: OpenDriver: trying /usr/lib/xorg/modules/dri//fglrx_dri.so
    libGL error: dlopen /usr/lib/xorg/modules/dri//fglrx_dri.so failed
    (/usr/lib/xorg/modules/dri//fglrx_dri.so: cannot open shared object file: No such file or directory)
    libGL error: unable to find driver: fglrx_dri.so

-   Something has not been installed correctly. If the paths in the
    error message are /usr/X11R6/lib/modules/dri/fglrx_dri.so, then
    ensure you've logged completely out of your system, then back in. If
    you're using a graphical login manager (gdm, kdm, xdm), ensure that
    /etc/profile is sourced every time you log in. This is usually
    accomplished by adding source /etc/profile into ~/.xsession or
    ~/.xinitrc, but this may vary between login managers.

-   If the paths above in your error message are
    /usr/lib/xorg/modules/dri/fglrx_dri.so, then something has not been
    correctly installed. Try reinstalling the catalyst package.

Errors such as:

    fglrx: libGL version undetermined - OpenGL module is using glapi fallback

could be caused by having multiple versions of libGL.so on your system.
Run:

    $ sudo updatedb
    $ locate libGL.so

This should return the following output:

    $ locate libGL.so
    /usr/lib/libGL.so
    /usr/lib/libGL.so.1
    /usr/lib/libGL.so.1.2

These are the only three libGL.so files you should have on your system.
If you have any more (e.g. /usr/X11R6/lib/libGL.so.1.2), then remove
them. This should fix your problem.

You might not get any error to indicate that this is a problem. If you
are using X11R7, make sure you do not have these files on your system:

    /usr/X11R6/lib/libGL.so.1.2
    /usr/X11R6/lib/libGL.so.1

> Hibernate/Sleep Issues

Video fails to resume from suspend2ram

ATI's proprietary Catalyst driver cannot resume from suspend if the
framebuffer is enabled. To disable the framebuffer, add vga=0 to your
kernel options in for example, Grub Legacy's /boot/grub/menu.lst:

    kernel /vmlinuz-linux root=/dev/sda3 resume=/dev/sda2 ro quiet vga=0

To see where you need to add this with other bootloaders, see #Disable
kernel mode setting.

> System Freezes/Hard locks

-   The radeonfb framebuffer drivers have been known in the past to
    cause problems of this nature. If your kernel has radeonfb support
    compiled in, you may want to try a different kernel and see if this
    helps.

-   If you experience system freezes when exiting your DE (shut down,
    suspend, switching to tty etc.) you probably forgot to deactivate
    KMS. (See #Disable kernel mode setting)

> Hardware Conflicts

Radeon cards used in conjunction with some versions of the nForce3
chipset (e.g. nForce 3 250Gb) won't have 3D acceleration. Currently the
cause of this issue is unknown, but some sources indicate that it may be
possible to get acceleration with this combination of hardware by
booting Windows with the drivers from nVIDIA and then rebooting the
system. This can be verified by issuing in a root console the following
command:

    $ dmesg | grep agp

If you get something similar to this (using an nForce3-based system):

        agpgart: Detected AGP bridge 0
        agpgart: Setting up Nforce3 AGP.
        agpgart: aperture base > 4G

and also if issuing this command...

    $ tail -n 100 /var/log/Xorg.0.log | grep agp

...gets something similar to:

    (EE) fglrx(0): [agp] unable to acquire AGP, error "xf86_ENODEV"

Then you have this bug.

Some sources indicate that in some situations, downgrading the
motherboard BIOS may help, but this cannot be verified in all cases.
Also, a bad BIOS downgrade can render your hardware useless, so beware.

See this bugreport for more information and a potential fix.

> Temporary hangs when playing video

This problem may occur when using the proprietary Catalyst.

If you experience temporary hangs lasting from a few seconds to several
minutes occuring randomly during playback with mplayer, check
/var/log/messages.log for output like:

    Nov 28 18:31:56 pandemonium [<c01c64a6>] ? proc_get_sb+0xc6/0x160
    Nov 28 18:31:56 pandemonium [<c01c64a6>] ? proc_get_sb+0xc6/0x160
    Nov 28 18:31:56 pandemonium [<f8bc628c>] ? ip_firegl_ioctl+0x1c/0x30 [fglrx]
    Nov 28 18:31:56 pandemonium [<c01c64a6>] ? proc_get_sb+0xc6/0x160
    Nov 28 18:31:56 pandemonium [<c0197038>] ? vfs_ioctl+0x78/0x90
    Nov 28 18:31:56 pandemonium [<c01970b7>] ? do_vfs_ioctl+0x67/0x2f0
    Nov 28 18:31:56 pandemonium [<c01973a6>] ? sys_ioctl+0x66/0x70
    Nov 28 18:31:56 pandemonium [<c0103ef3>] ? sysenter_do_call+0x12/0x33
    Nov 28 18:31:56 pandemonium [<c01c64a6>] ? proc_get_sb+0xc6/0x160
    Nov 28 18:31:56 pandemonium =======================

Adding the nopat kernel option to your kernel options in your bootloader
and rebooting fixed the problem at least for me. To see how to do this
for different bootloaders, see #Disable kernel mode setting.

> "aticonfig: No supported adapters detected"

If when running

    # aticonfig --initial

you get:

    aticonfig: No supported adaptaters detected

But you do have an AMD GPU (or APU), it may still be possible to get
Catalyst working by manually setting the device in your your
etc/X11/xorg.conf file or by copying an older working /etc/ati/control
file (preferred - this also fixes the watermark issue).

To get an older control file, download a previous version of fglrx from
AMD and run it with "--extract driver" parameter. You'll find the
control file in driver/common/etc/ati/control. Copy the extracted file
over the system file and restart Xorg. You can try different versions of
the file.

To set your model in xorg.conf,edit the device section of
/etc/X11/xorg.conf to:

    Section "Device"
     Identifier "ATI radeon ****"
     Driver "fglrx"
    EndSection

Where **** should be replaced with your device's marketing number (e.g.
6870 for the HD 6870 and 6310 for the E-350 APU).

Xorg will start and it is possible to use amdcccle instead of aticonfig.
There will be an "AMD Unsupported hardware" watermark.

You can remove this watermark using the following script:

    #!/bin/sh
    DRIVER=/usr/lib/xorg/modules/drivers/fglrx_drv.so
    for x in $(objdump -d $DRIVER|awk '/call/&&/EnableLogo/{print "\\x"$2"\\x"$3"\\x"$4"\\x"$5"\\x"$6}'); do
     sed -i "s/$x/\x90\x90\x90\x90\x90/g" $DRIVER
    done

and rebooting.

> WebGL support in Chromium

Google has blacklisted Linux's Catalyst driver from supporting webGL in
their Chromium/Chrome browsers.

You can turn webGL on by editing
/usr/share/applications/chromium.desktop file and adding
--ignore-gpu-blacklist flag into the Exec line so it looks like this:

    Exec=chromium %U --ignore-gpu-blacklist

You can also run chromium from console with the same
--ignore-gpu-blacklist flag:

    $ chromium --ignore-gpu-blacklist

Warning:Catalyst does not support the GL_ARB_robustness extension, so it
is possible that a malicious site could use WebGL to perform a DoS
attack on your graphic card. For more info, read this.

> Laggs/freezes when watching flash videos via Adobe's flashplugin

Edit /etc/adobe/mms.cfg and make it look like this:

    #EnableLinuxHWVideoDecode=1
    OverrideGPUValidation=true

If you are using KDE make sure that "Suspend desktop effects for
fullscreen windows" is unchecked under System Settings->Workspace
Appearance and Behaviour->Desktop Effects->Advanced.

> Laggs/slow windows movement in GNOME3

You can try this solution out, it's working for many people.

Add this line into ~/.profile or into /etc/profile:

    export CLUTTER_VBLANK=none

Restart X server or reboot your system.

> Not using fullscreen resolution at 1920x1080 (underscanning)

Using the amdcccle GUI you can select the display, go to adjustments,
and set Underscan to 0% (aticonfig defaults to 15% underscan).

Alternatively, you can use aticonfig to disable underscanning as well:

    aticonfig --set-pcs-val=MCIL,DigitalHDTVDefaultUnderscan,0

For newer version (for example, 12.11), if Catalyst control center
repeatedly fails to save the overscan setting, edit /etc/ati/amdpcsdb:

    TVEnableOverscan=V0

Then logout and login.

> Dual Screen Setup: general problems with acceleration, OpenGL, compositing, performance

Try to disable xinerama and xrandr12. Check out ie. this way:

As root type those commands:

    aticonfig --initial
    aticonfig --set-pcs-str="DDX,EnableRandR12,FALSE"

Then reboot your system. In /etc/X11/xorg.conf check that xinerama is
disabled, if it's not disable it and reboot your system.

Next run amdcccle and pick up amdcccle->display
manager->multi-display->multidisplay desktop with display(s) 2.

Reboot again and set up your display layout whatever you desire.

> Disabling VariBright Feature

As root type command:

    aticonfig --set-pcs-u32=MCIL,PP_UserVariBrightEnable,0

> Hybrid/PowerXpress: turning off discrete GPU

When you are using catalyst-total-pxp or catalyst-utils-pxp and you are
switching to integrated GPU you may notice that discrete GPU is still
working, consuming power and making your system's temperature higher.

Sometimes ie. when your integrated GPU is intel's one you can use
vgaswitcheroo to turn the discrete GPU off. Sometimes unfortunatelly,
it's not working.

Then you may check out acpi_call. MrDeepPurple has prepared the script
which he's using to perform 'turn off' task, he's calling script via
systemd service while booting and resuming his system. Here's his
script:

    #!/bin/sh
    libglx=$(/usr/lib/fglrx/switchlibglx query)
    modprobe acpi_call
    if [ "$libglx" = "intel" ]; then
    echo '\_SB.PCI0.PEG0.PEGP._OFF' > /proc/acpi/call
    fi

> Switching from X session to TTYs gives blank screen

Workaround for this "feature", which appeared in catalyst 13.2 betas, is
to use vga= kernel option, like vga=792. You can get the list of
supported resolutions with

    hwinfo --framebuffer

command. Pick up the one from the very bottom, and copy-paste it into
kernel line of your bootloader, so it could look like ie. vga=0x03d4

Retrieved from
"https://wiki.archlinux.org/index.php?title=AMD_Catalyst&oldid=255977"

Categories:

-   Graphics
-   X Server
