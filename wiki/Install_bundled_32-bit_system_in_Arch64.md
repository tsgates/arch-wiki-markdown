Install bundled 32-bit system in Arch64
=======================================

This article presents one way of running 32-bit applications, which may
be of use to those who do not wish to install the lib32-* libraries from
the multilib repository and instead prefer to isolate 32bit
applications. The approach involves creating a "chroot jail" to handle
32-bit apps.

Contents
--------

-   1 Make the i686 Chroot
    -   1.1 Install the Base 32-bit System
    -   1.2 Configuration files
-   2 Create an Arch32 Daemon Script and Systemd Service
-   3 Configure the new system
    -   3.1 Configure the chroot
    -   3.2 First-time Setup
    -   3.3 Install Needed Packages
    -   3.4 Regain Space (Optional)
-   4 Install and Configure Schroot
-   5 Using Schroot to run a 32-bit application
-   6 Troubleshooting
    -   6.1 Compilation and installing
    -   6.2 Video problems
    -   6.3 Sound in flash (youtube, etc.)
-   7 Tips and tricks
    -   7.1 Java in a chroot
    -   7.2 arch32-light
    -   7.3 Allowing 32-bit applications access to 64-bit PulseAudio
    -   7.4 Enabling sound in Firefox
    -   7.5 Enabling 3D acceleration
    -   7.6 Script for wine
    -   7.7 Printing

Make the i686 Chroot
--------------------

> Install the Base 32-bit System

1. Create the directory:

    mkdir /opt/arch32

2. Generate temporary pacman configuration files for chroot:

    sed -e 's/\$arch/i686/g' /etc/pacman.d/mirrorlist > /opt/arch32/mirrorlist
    sed -e 's@/etc/pacman.d/mirrorlist@/opt/arch32/mirrorlist@g' -e '/Architecture/ s,auto,i686,'  /etc/pacman.conf > /opt/arch32/pacman.conf

-   These files would conflict with the normal pacman files, which will
    be installed in the later steps.
-   For this reason they must be put into a temporary location
    (/opt/arch32 is used here).
-   Remember to delete/comment the multilib repo, if you have enabled
    it, in the /opt/arch32/pacman.conf file

3. Create the directory:

    mkdir -p /opt/arch32/var/{cache/pacman/pkg,lib/pacman}

4. Sync pacman:

    pacman --root /opt/arch32 --cachedir /opt/arch32/var/cache/pacman/pkg --config /opt/arch32/pacman.conf -Sy

5. Install the base and optionally base-devel groups:

    pacman --root /opt/arch32 --cachedir /opt/arch32/var/cache/pacman/pkg --config /opt/arch32/pacman.conf -S base base-devel

Optionally add your favorite text editor and distcc if you plan to
compile within the chroot with other machines:

    pacman --root /opt/arch32 --cachedir /opt/arch32/var/cache/pacman/pkg --config /opt/arch32/pacman.conf -S base base-devel sudo vim distcc

Optionally move the pacman mirror list into place:

    mv /opt/arch32/mirrorlist /opt/arch32/etc/pacman.d

> Configuration files

Key configuration files should be copied over:

    cd /opt/arch32/etc

    cp /etc/passwd* .
    cp /etc/shadow* .
    cp /etc/group* .
    cp /etc/sudoers .
    cp /etc/resolv.conf .
    cp /etc/localtime .
    cp /etc/locale.gen .
    cp /etc/profile.d/locale.sh profile.d
    cp /etc/vimrc .
    cp /etc/mtab .
    cp /etc/inputrc .

Be sure to include the "." character!

Remember to define the correct the number of MAKEFLAGS and other vars in
/opt/arch32/etc/makepkg.conf before attempting to build.

Create an Arch32 Daemon Script and Systemd Service
--------------------------------------------------

    /etc/systemd/system/arch32.service

    [Unit]
    Description=32-bit chroot

    [Service]
    Type=oneshot
    RemainAfterExit=yes
    ExecStart=/usr/local/bin/arch32 start
    ExecStop=/usr/local/bin/arch32 stop

    [Install]
    WantedBy=multi-user.target

    /usr/local/bin/arch32

    #!/bin/bash

    MOUNTPOINT=/opt/arch32
    PIDFILE=/run/arch32

    # Leave this blank if not using distccd from within the chroot.
    USEDISTCC=
    DISTCC_SUBNET='192.168.0.0/24'

    start_distccd() {
      [[ ! -L $MOUNTPOINT/usr/bin/distccd-chroot ]] && ln -s /usr/bin/distccd $MOUNTPOINT/usr/bin/distccd-chroot
      DISTCC_ARGS="--user nobody --allow $DISTCC_SUBNET --port 3692 --log-level warning --log-file /tmp/distccd-i686.log"

      if [[ -z "$(pgrep distccd-chroot)" ]]; then
        linux32 chroot $MOUNTPOINT /bin/bash -c "/usr/bin/distccd-chroot --daemon ${DISTCC_ARGS}"
      else
        echo "/usr/bin/distccd-chroot seems to be running so doing nothing!"
      fi
    }

    stop_distccd() {
      if [[ -n "$(pgrep distccd-chroot)" ]]; then
        linux32 chroot $MOUNTPOINT /bin/bash -c "pkill -SIGTERM distccd-chroot"
      else
        echo "/usr/bin/distccd-chroot does NOT seems to be running so doing nothing!"
      fi
    }

    case $1 in
      start)
        # Only relevant for users with an arch32 chroot on a separate partition.
        # Edit to fit your system and take note of the corresponding unmount option in the stop function!
        # mountpoint -q $MOUNTPOINT || mount LABEL="arch32" $MOUNTPOINT

        dirs=(/tmp /dev /dev/pts /home)
        for d in "${dirs[@]}"; do
          mount -o bind $d $MOUNTPOINT$d
        done

        mount -t proc none $MOUNTPOINT/proc
        mount -t sysfs none $MOUNTPOINT/sys
        touch $PIDFILE
        [[ -n "$USEDISTCC" ]] && start_distccd
        ;;
      stop)
        dirs=(/home /dev/pts /dev /tmp)
        [[ -n "$USEDISTCC" ]] && stop_distccd
        umount $MOUNTPOINT/{sys,proc}
        for d in "${dirs[@]}"; do
          umount -l "$MOUNTPOINT$d"
        done
        # Only relevant for users with an arch32 chroot on a separate partition.
        # umount -l $MOUNTPOINT
        rm -f $PIDFILE
        ;;
      *)
        echo "usage: $0 (start|stop)"
        exit 1
    esac

    # vim:set ts=2 sw=2 et:

Be sure to make the init script executable:

    # chmod +x /usr/local/bin/arch32

Enable the service as any other systemd service.

Configure the new system
------------------------

> Configure the chroot

Chroot into the new system:

    /usr/local/bin/arch32 start
    xhost +SI:localuser:usernametogiveaccesstogoeshere 
    chroot /opt/arch32

It is recommended to use a custom bash prompt inside the 32-bit chroot
installation in order to differentiate from the regular system. You can,
for example, add a ARCH32 string to the PS1 variable defined in
~/.bashrc. In fact, the default Debian .bashrc prompt string contains
appropriate logic to report whether the working directory is within a
chroot.

> First-time Setup

Fix possible locale problems:

    /usr/sbin/locale-gen

Initialize pacman:

    sed -i 's/CheckSpace/#CheckSpace/' /etc/pacman.conf
    pacman-key --init
    pacman-key --populate archlinux

> Install Needed Packages

Install the needed packages including apps, fonts, etc. for example:

    pacman -S firefox
    pacman -S flashplugin

> Regain Space (Optional)

Warning: This cleanup is for the 32-bit root environment and must then
be done inside it NOT the native 64-bit environment!

The following shows recommended packages for removal:

    pacman -Rd linux mkinitcpio dhcpcd xfsprogs reiserfsprogs jfsutils logrotate lvm2 pcmciautils netctl iputils iproute2 man-pages mdadm inetutils man-db cronie vi

Also consider regularly clearing out pacman's cache:

    pacman -Scc

Install and Configure Schroot
-----------------------------

Install "schroot" to the native 64-bit installation:

    pacman -S schroot

Edit /etc/schroot/schroot.conf, and create an [Arch32] section.

    [Arch32]
    type=directory
    profile=arch32
    description=Arch32
    directory=/opt/arch32
    users=user1,user2,user3
    groups=users
    root-groups=root
    personality=linux32
    aliases=32,default

Optionally edit /etc/schroot/arch32/mount to match the mounts created
within /usr/local/bin/arch32.

Using Schroot to run a 32-bit application
-----------------------------------------

The general syntax for calling an application inside the chroot is:

    schroot -p -- htop

In this example, htop is called from within the 32-bit environment.

Troubleshooting
---------------

> Compilation and installing

Ensure the desired options are set in the local /etc/makepkg.conf.

Some packages may require a --host flag be added to the ./configure
script in the PKBUILD:

    ./configure --host="i686-pc-linux" ...

This is the case when the build makes use of values (for example, the
output of the uname command) inherited from your base system.

You may need to give users write access to your chroot's /dev/null to
stop some scripts from failing:

    chmod 666 /dev/null

> Video problems

If you get:

    X Error of failed request: BadLength (poly request too large or internal Xlib length error)

while trying to run an application that requires video acceleration,
make sure you have installed appropriate video drivers in your chroot.
For example,

    pacman -S nvidia

> Sound in flash (youtube, etc.)

To get sound from the flash player in Firefox, open a terminal and
chroot inside the 32-bit system:

    chroot /opt/arch32

From there, install alsa-oss:

    pacman -S alsa-oss

Then type:

    export FIREFOX_DSP="aoss"

Every chroot into the 32-bit system will require this export command to
be entered so it may be best to incorporate it into a script.

Finally, launch Firefox.

For Wine this works the same way. The package alsa-oss will also install
the alsa libs required by Wine to output sound.

Tips and tricks
---------------

> Java in a chroot

See Java for installation instructions.

After installing, adjust the path to get Java working:

    export PATH="/opt/java/bin/:$PATH"

> arch32-light

Xyne has created a package that installs a minimalist 32-bit chroot as
described above. More information can be found on the forum and on the
project page.

> Allowing 32-bit applications access to 64-bit PulseAudio

Add these lines in /usr/local/bin/arch32, before the daemon is started:

    mount --bind /var/run /opt/arch32/var/run
    mount --bind /var/lib/dbus /opt/arch32/var/lib/dbus

And before the daemon is stopped:

    umount /opt/arch32/var/run
    umount /opt/arch32/var/lib/dbus

More information is available at the PulseAudio article, especially the
section on PulseAudio from within a chroot.

> Enabling sound in Firefox

Open a text editor and save the following in /usr/bin/firefox32 as root:

    #!/bin/sh
    schroot -p firefox $1;export FIREFOX_DSP="aoss"

Make it executable:

    sudo chmod +x /usr/bin/firefox32

Now you can make an alias for Firefox, if desired:

    alias firefox="firefox32"

Add this to the end of file ~/.bashrc and source it to enable its usage.
Or you can just change all your desktop environment's launchers to
firefox32 if you still want 64-bit Firefox to be available.

> Enabling 3D acceleration

You need to install the corresponding package under your "native" arch
for 3D support.

For information on how to set up your graphic adapter refer to:

-   ATI
-   Intel
-   NVIDIA

> Script for wine

In order to compile wine, you need a 32-bit system installed. Compiling
wine is needed for applying patches in order to get PulseAudio working.
See also wine-hacks from AUR.

Add the following alias to ~/.bashrc:

    alias wine='schroot -pqd "$(pwd)" -- wine'

The -q switch makes schroot operate in quiet mode, so it works like
"regular" wine does. Also note that If you still use dchroot instead of
schroot, you should use switch -d instead of -s.

> Printing

For accessing CUPS printers intalled in the base system from the chroot
environment, see the applicable section of the Arch CUPS Wiki page.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Install_bundled_32-bit_system_in_Arch64&oldid=298857"

Category:

-   Arch64

-   This page was last modified on 18 February 2014, at 23:42.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
