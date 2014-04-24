Android
=======

Contents
--------

-   1 Exploring Android device on Arch
-   2 Android development on Arch Linux
    -   2.1 Install Android SDK core components
    -   2.2 Getting Android SDK platform API
    -   2.3 Setting up Development Environment
        -   2.3.1 Android Studio
        -   2.3.2 Eclipse
        -   2.3.3 Netbeans
    -   2.4 Connecting to a real device - Android Debug Bridge (ADB)
        -   2.4.1 Using existing rules
        -   2.4.2 Figure Out Your Device Ids
        -   2.4.3 Adding udev Rules
        -   2.4.4 Configuring adb
        -   2.4.5 Does It Work?
    -   2.5 Tools specific to NVIDIA Tegra platform
    -   2.6 Tethering
-   3 Building Android
    -   3.1 OS bitness
    -   3.2 Required packages
    -   3.3 Java Development Kit
    -   3.4 Setting up the build environment
    -   3.5 Downloading the source code
    -   3.6 Actually building the code
    -   3.7 Testing the build
-   4 Tips & Tricks
    -   4.1 During Debugging "Source not found"
    -   4.2 Linux distribution on the sdcard
    -   4.3 Android SDK on Arch 64
    -   4.4 Better MTP support
-   5 See Also

Exploring Android device on Arch
--------------------------------

To view the contents of your Android storage on your Arch machine, you
can install GVFS. For recognizing your phone, you also need gvfs-mtp (if
your device is connected via MTP) or gvfs-gphoto2 (if your phone is
connected via PTP).

Android development on Arch Linux
---------------------------------

There are 3 steps that need to be performed before you can develop
Android applications on your Arch Linux box:

1.  Install the Android SDK core component,
2.  Install one or several Android SDK Platform packages,
3.  Install one of the IDE compatible with the Android SDK.

> Install Android SDK core components

Note:First, if you are running a 64-bit system, make sure the multilib
repository is enabled in pacman.conf.

Before developing Android applications, you need to install the Android
SDK, which is made of 3 distinct packages, all installable from AUR:

1.  android-sdk
2.  android-sdk-platform-tools
3.  android-sdk-build-tools

If you have not changed the PKGBUILD, these packages will be installed
to this default location /opt/android-sdk.

> Getting Android SDK platform API

Even if the AUR currently contains multiple packages with Android
platforms, installing the platform API from AUR is not the clean way to
proceed. Aside the fact AUR packages might be outdated, an "SDK manager"
comes with the Android SDK, we will thus prefer it.

First, make sure your $PATH environment variable contains the path to
the Android SDK tools directory, by default /opt/android-sdk/tools/ and
/opt/android-sdk/platform-tools/.

As the SDK manager will download the API platforms to /opt and a
standard user account doesn't have right to write in that directory, we
will launch the SDK Manager with root privileges.

    # android

or with sudo,

    $ sudo android

The manager will then fetch some files to check if new versions of the
Android SDK are available.

Note:If you get an error like
Failed to fetch URL https://dl-ssl.google.com/android/repository/addons_list-2.xml, reason: peer not authenticated,
you need to go the options menu (Tools > Options...) and check Force
https://... sources to be fetched using http://....

Afterwards, check one or several API platforms you want to install (e.g.
Android 4.4.2 (API 19)), then click on Install packages... and accept
all license and package descriptions.

Finally, to make sure all users can read and browse the Android SDK
location, change the directory rights:

    # chmod -R 755 /opt/android-sdk

Tip:For more details about the specific Android SDK packages, see
Installing SDK Components on the Android developer website.

> Setting up Development Environment

Android Studio is a new (and still experimental!) Android development
environment based on IntelliJ IDEA. The more traditional IDE is Eclipse
with the ADT plugin and related packages. Alternatively you can use
Netbeans for development after installing the plugin as described below.

Android Studio

Android Studio is a new (and still experimental!) Android development
environment based on IntelliJ IDEA. Similar to Eclipse with the ADT
Plugin, Android Studio provides integrated Android developer tools for
development and debugging.

You can download and install it with the android-studio package from the
AUR. If you get an error about a missing SDK, refer to the section
Getting Android SDK platform API above.

Eclipse

Most stuff required for Android development in Eclipse is already
packaged in AUR:

Official plugin by Google – Eclipse ADT:

1.  eclipse-android

Dependencies:

1.  eclipse-emf
2.  eclipse-gef
3.  eclipse-wtp

> Note:

-   if you get a message about unresolvable dependencies, install Java
    manually and try again.
-   as an alternative, you can install the ADT via eclipse's built in
    "add new software" command (see instructions on ADT site).
-   if you are in real trouble, it is also possible to download Android
    SDK and use the bundled Eclipse. This usually works without
    problems.
-   if you need to install extra SDK plugins not found in the AUR, you
    must change the file ownership of /opt/android-sdk first. You can do
    this with
    # chgrp -R users /opt/android-sdk ; chmod -R 0775 /opt/android-sdk
    (see File Permissions for more details).

Enter the path to the Android SDK Location in

    Windows -> Preferences -> Android

Netbeans

If you prefer using Netbeans as your IDE and want to develop Android
applications, download the nbandroid by going to:

    Tools -> Plugins -> Settings

Add the following URL:
http://nbandroid.org/release72/updates/updates.xml

Then go to Available Plugins and install the Android and Android Test
Runner plugins for your IDE version. Once you have installed go to:

if you have problem with netbeans 7.2
"org.netbeans.modules.gsf.testrunner was needed and not found." Please
remove the the Android and Android Test Runner , then change the url of
nbandroid to: http://nbandroid.org/release72/updates/updates.xml ,
update the sources and you just need to install the Android only.

    Tools -> Options -> Miscellaneous -> Android

and select the path where the SDK is installed. That's it, now you can
create a new Android project and start developing using Netbeans.

> Connecting to a real device - Android Debug Bridge (ADB)

To get ADB to connect to a real device or phone under Arch, you must

-   Enable USB Debugging on your phone or device. This is usually done
    from Settings --> Applications --> Development --> USB debugging.
    Reboot the phone after checking this option to make sure USB
    debugging is enabled (if there is no such option, this step probably
    does not apply to your version of Android)
-   install the udev rules to connect the device to the proper /dev/
    entries.

Using existing rules

Install the AUR package android-udev to get a common list of vendor IDs.
If ADB recognizes your device (it is visible and accessible in IDE), you
are done. Otherwise see instructions below.

Figure Out Your Device Ids

Each Android device has a USB vendor/product ID. An example for HTC Evo
is:

    vendor id: 0bb4
    product id: 0c8d

Plug in your device and execute:

    $ lsusb

It should come up something like this:

    Bus 002 Device 006: ID 0bb4:0c8d High Tech Computer Corp.

Adding udev Rules

Use the rules from Android developer or you can use the following
template for your udev rules, just replace [VENDOR ID] and [PRODUCT ID]
with yours. Copy these rules into /etc/udev/rules.d/51-android.rules:

    /etc/udev/rules.d/51-android.rules

    SUBSYSTEM=="usb", ATTR{idVendor}=="[VENDOR ID]", MODE="0666"
    SUBSYSTEM=="usb",ATTR{idVendor}=="[VENDOR ID]",ATTR{idProduct}=="[PRODUCT ID]",SYMLINK+="android_adb"
    SUBSYSTEM=="usb",ATTR{idVendor}=="[VENDOR ID]",ATTR{idProduct}=="[PRODUCT ID]",SYMLINK+="android_fastboot"

Then, to reload your new udev rules, execute:

    # udevadm control --reload-rules

Configuring adb

Instead of using udev rules you may create/edit ~/.android/adb_usb.ini
which contains list of vendor ids.

     $ cat ~/.android/adb_usb.ini 
     0x27e8

Does It Work?

After you have setup the udev rules, unplug your device and replug it.

After running:

    $ adb devices

you should see something like:

    List of devices attached 
    HT07VHL00676    device

If you do not have the adb program (usually available in
/opt/android-sdk/platform-tools/), it means you have not installed the
platform tools.

If you are getting an empty list (your device isn't there), it may be
because you have not enabled USB debugging on your device. You can do
that by going to Settings => Applications => Development and enabling
USB debugging. On Android 4.2 (Jelly Bean) the Development menu is
hidden; to enable it go to Settings => About phone and tap Build number
7 times.

Tip:Make sure that your user is added to the group:

    # gpasswd -a username adbusers

If there are still problems such as adb displaying "???????? no
permissions" under devices, try restarting the adb server as root.

    # adb kill-server
    # adb start-server

> Tools specific to NVIDIA Tegra platform

If you target your application at NVIDIA Tegra platform, you might also
want to install tools, samples and documentation provided by NVIDIA. In
NVIDIA Developer Zone for Mobile there are two packages - Tegra Android
Development Pack, available from AUR as tegra-devpack and Tegra Toolkit,
available from AUR as tegra-toolkit.

The tegra-toolkit package provides tools (mostly CPU and GPU
optimization related), samples and documentation, while the
tegra-devpack provides tools (NVIDIA Debug Manager) related to Eclipse
ADT and their documentation.

> Tethering

See Android Tethering

Building Android
----------------

Please note that these instructions are based on the official AOSP build
instructions. Other Android-derived systems such as CyanogenMod will
often require extra steps.

> OS bitness

Android 2.2.x (Froyo) and below are the only versions of Android that
will build on a 32-bit system. For 2.3.x (Gingerbread) and above, you
will need a 64-bit installation.

> Required packages

To build any version of Android, you need to install these packages:

-   32-bit and 64-bit systems: gcc git gnupg flex bison gperf sdl wxgtk
    squashfs-tools curl ncurses zlib schedtool perl-switch zip unzip
    libxslt python2-virtualenv

-   64-bit systems only: gcc-multilib lib32-zlib lib32-ncurses
    lib32-readline

> Java Development Kit

Android requires a working Sun/Oracle JDK installed on your build
system. It will not work with OpenJDK.

For 2.3.x and higher, you can use jdk6, if you don't develop on the JVM,
or jdk6-compat, if you do have a preferred JVM for other tasks. For
2.2.x and below, a version 5 JDK is required; jre5-opt is currently the
only one left on the AUR.

Note that, if you choose to install jdk6-compat, you will need to set
the JAVA_HOME environment variable to the location of the JDK6:

    $ export JAVA_HOME=/opt/java6

Otherwise, $PATH will be reset to the location of the JDK7 by the build
scripts, and all your AOSP builds will abort, complaining about the
wrong version of javac (the Java Compiler.)

To set JAVA_HOME on the system level, see the files in /etc/profile.d
named jdk.sh, jdk.csh, jre.csh, and jre.sh.

> Setting up the build environment

Download the repo utility.

    $ mkdir ~/bin
    $ export PATH=~/bin:$PATH
    $ curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
    $ chmod a+x ~/bin/repo

Create a directory to build.

    $ mkdir ~/android
    $ cd ~/android

You will need to change the default Python from version 3 to version 2:

    $ virtualenv2 venv # Creates a directory, venv/, containing the Virtualenv

Activate the Virtualenv, which will update $PATH to point at Python 2.

Note:this activation is only active for the current terminal session.

    $ source venv/bin/activate

> Downloading the source code

This will clone the repositories. You only need to do this the first
time you build Android, or if you want to switch branches.

-   The repo has a -j switch that operates similarly to the one used
    with make. Since it controls the number of simultaneous downloads,
    you should adjust the value depending on downstream network
    bandwidth.

-   You will need to specify a branch (release of Android) to check out
    with the -b switch. If you leave the switch out, you will get the
    so-called master branch.

    $ repo init -u https://android.googlesource.com/platform/manifest -b master
    $ repo sync -j4

Wait a long time. Just the uncompiled source code, along with the .repo
and .git directories that are used to keep track of it, are well over 10
GB.

Note:If you want to update your local copy of the Android source, at a
later time, simply enter the build directory, load the Virtualenv, and
re-sync:

    $ repo sync

> Actually building the code

This should do what you need for AOSP:

    $ source build/envsetup.sh
    $ lunch full-eng
    $ make -j4

If you run lunch without arguments, it will ask what build you want to
create. Use -j with a number between one and two times number of
cores/threads.

The build takes a very long time.

Note:Make sure you have enough RAM.

Android will use the /tmp directory heavily. By default the size of the
partition the /tmp folder is mounted on is half the size of your RAM. If
it fills up, the build will fail. 4GB of RAM or more is recommended.

-   Alternatively, you can get rid of the tmpfs from fstab all together.

> Testing the build

When finished, run/test the final image(s).

    $ emulator

Tips & Tricks
-------------

> During Debugging "Source not found"

Most probably the debugger wants to step into the Java code. As the
source code of Android does not come with the Android SDK, this leads to
an error. The best solution is to use step filters to not jump into the
Java source code. Step filters are not activated by default. To activate
them:

    Window -> Preferences -> Java -> Debug -> Step Filtering

Consider to select them all. If appropriate you can add the android.*
package. See the forum post for more information:
http://www.eclipsezone.com/eclipse/forums/t83338.rhtml

> Linux distribution on the sdcard

You can install Debian like in this thread. Excellent guide to
installing Arch in chroot (in parallel with Android) can be found on
archlinuxarm.org forum.

> Android SDK on Arch 64

When using the Android SDK and the Eclipse plugin on a 64 bit system,
and the 'emulator' always crashes with a segfault, do the following:
Provide a localtime file in /usr/share/zoneinfo/localtime e.g.:

     # cp /usr/share/zoneinfo/Europe/Berlin /usr/share/zoneinfo/localtime

> Better MTP support

If you have an Android device that doesn't support UMS and you find
mtpfs to be extremely slow you can install jmtpfs from the AUR. See MTP
for more options.

See Also
--------

-   Android Notifier

Retrieved from
"https://wiki.archlinux.org/index.php?title=Android&oldid=303705"

Category:

-   Development

-   This page was last modified on 9 March 2014, at 02:29.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
