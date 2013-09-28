Android
=======

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Android Development on Arch                                        |
|     -   1.1 Install Android SDK core components                          |
|     -   1.2 Getting Android SDK Platform packages                        |
|         -   1.2.1 Automatic installation                                 |
|         -   1.2.2 Getting from AUR                                       |
|         -   1.2.3 Manual installation                                    |
|                                                                          |
|     -   1.3 Setting up Development Environment                           |
|         -   1.3.1 Setting up Eclipse                                     |
|         -   1.3.2 Setting up Netbeans                                    |
|                                                                          |
|     -   1.4 Connecting to a real device - Android Debug Bridge (ADB)     |
|         -   1.4.1 Using existing rules                                   |
|         -   1.4.2 Figure Out Your Device Ids                             |
|         -   1.4.3 Adding udev Rules                                      |
|         -   1.4.4 Configuring adb                                        |
|         -   1.4.5 Does It Work?                                          |
|                                                                          |
|     -   1.5 Tools specific to NVIDIA Tegra platform                      |
|     -   1.6 Tethering                                                    |
|                                                                          |
| -   2 Building Android                                                   |
| -   3 Tips & Tricks                                                      |
|     -   3.1 During Debugging "Source not found"                          |
|     -   3.2 Linux distribution on the sdcard                             |
|     -   3.3 Android SDK on Arch 64                                       |
|     -   3.4 Better MTPFS Support                                         |
+--------------------------------------------------------------------------+

Android Development on Arch
---------------------------

There are three parts to set up:

1.  Android SDK core component,
2.  Android SDK Platform packages
3.  Development environment

> Install Android SDK core components

Before developing android applications, you need to install at least one
Android platform. Install core SDK components from AUR:

1.  android-sdk
2.  android-sdk-platform-tools

Typical installation location is /opt/android-sdk.

Note:If you are running Arch64, you have to enable the multilib repo, to
be able to to install the required dependencies using pacman.

> Getting Android SDK Platform packages

And then install the Android SDK Platform packages which can be done
either automatically, from the AUR, or manually.

Automatic installation

Automatic installation is done via the Android SDK and device manager,
which is accessible by invoking (assuming that the $PATH variable
contains the path to the Android SDK tools directory):

    $ android

or alternatively:

    $ <path_to_android-sdk>/tools/android

If the automatic installation errors out, then you must do one of the
following:

-   run the android tool with heightened privileges

    # android

-   set your user account as the owner of the directory. To change the
    owner ID for all SDK directories, run the following command as root:

    # chown -R USER /opt/android-sdk

-   change the group ID instead (recommended for multiple users), first
    create the group, perhaps called android, and add your user account
    to it:

    # groupadd android
    # gpasswd -a USER android

Next, change the directory permissions:

    # chgrp -R android /opt/android-sdk
    # chmod -R g+w /opt/android-sdk
    # find /opt/android-sdk -type d -exec chmod g+s {} \;

The final command sets the setgid bit on all subdirectories so that any
new files created within them will inherit the proper group ID. Then
rerun

    $ android

For step-by-step automatic installation, see: Installing SDK Components.

Getting from AUR

AUR currently contains multiple packages with Android platforms
sometimes duplicating each other and/or having incorrect file
permissions set.

Manual installation

For manual installation:

1.  Download the platform you want to develop on. This site provides
    online links to several Android SDK components.
2.  Extract the tarball to /<path_to_android-sdk>/platforms.

Now, you should see the platform of your choice installed in the
Installed Packages window of the Android SDK and device manager.

> Setting up Development Environment

When using Eclipse as an IDE you need to install the ADT plugin and
related packages. If you get a message about unresolvable dependencies,
install Java manually and try again. Alternatively you can use Netbeans
for development after installing living and usually up to date plugin
according to these instructions.

Setting up Eclipse

Most stuff required for Android development in Eclipse is already
packaged in AUR:

Official plugin by Google – Eclipse ADT:

1.  eclipse-android

Dependencies:

1.  eclipse-emf
2.  eclipse-gef
3.  eclipse-wtp

Note:

-   as an alternative, you can install the ADT via eclipse's built in
    "add new software" command (see instructions on ADT site).
-   if you are in real trouble, it is also possible to download Android
    SDK and use the bundled Eclipse. This usually works without
    problems.

Enter the path to the Android SDK Location in

    Windows -> Preferences -> Android

Setting up Netbeans

If you prefer using Netbeans as your IDE and want to develop Android
applications, download the nbandroid by going to:

    Tools -> Plugins -> Settings

Add the following URL:
http://kenai.com/projects/nbandroid/downloads/download/updatecenter/updates.xml

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
install the udev rules to connect the device to the proper /dev/
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

Note: reloading udev rules under systemd should not be required, as any
rule changes should be picked up automatically.

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

See Android_Tethering

Building Android
----------------

To build android, you need to install these packages.

For 32 bits or 64 bits systems

    git gnupg flex bison gperf sdl wxgtk squashfs-tools curl ncurses zlib schedtool openjdk6 perl-switch zip unzip

Only for 64 bits systems

    lib32-zlib lib32-ncurses lib32-readline gcc-libs-multilib gcc-multilib lib32-gcc-libs

And you need to change the default python from version 3 to version 2

    # rm /usr/bin/python
    # ln -s /usr/bin/python2 /usr/bin/python

Download the repo utility.

    $ mkdir ~/bin
    $ export PATH=~/bin:$PATH
    $ curl https://dl-ssl.google.com/dl/googlesource/git-repo/repo > ~/bin/repo
    $ chmod a+x ~/bin/repo

Create a directory to build.

    $ mkdir ~/android
    $ cd ~/android

Synchronize the repositories.

    $ repo init -u https://android.googlesource.com/platform/manifest (checkout the master)
    $ repo sync

Wait a lot.

When finished, start building.

    $ source build/envsetup.sh
    $ lunch full-eng
    $ make -j4

If you run lunch without arguments, it will ask what build you want to
create. Use -j with a number between the number of cores and 2 * number
of cores.

The build takes a lot of time.

Note:Make sure you have enough RAM.

Android will use the /tmp directory heavily. By default the size of the
partition the /tmp folder is mounted on is half the size of your RAM. If
it fills up, the build will fail. 4GB of RAM or more is recommended.

-   Alternatively, you can get rid of the tmpfs from fstab all together.

When finished, run the final image.

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

> Better MTPFS Support

If you have an Android device that doesn't support UMS and you find
mtpfs to be extremely slow you can install jmtpfs from the AUR.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Android&oldid=255597"

Category:

-   Development
