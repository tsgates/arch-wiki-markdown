Gamecube Tutorial
=================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Needs updating   
                           for systemd. (Discuss)   
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Summary                                                            |
| -   2 Required Hardware                                                  |
|     -   2.1 Any Setup                                                    |
|     -   2.2 NFS Setup                                                    |
|     -   2.3 SD Setup                                                     |
|                                                                          |
| -   3 Preface: Setting up things                                         |
|     -   3.1 Gamecube Setup                                               |
|     -   3.2 The Cross Compiler                                           |
|     -   3.3 The Linux Kernel                                             |
|                                                                          |
| -   4 Booting Linux                                                      |
|     -   4.1 NFS Setup                                                    |
|         -   4.1.1 Server Setup                                           |
|         -   4.1.2 Gamecube Setup                                         |
|                                                                          |
|     -   4.2 SD Setup                                                     |
|                                                                          |
| -   5 TODO                                                               |
| -   6 My Notes                                                           |
+--------------------------------------------------------------------------+

Summary
-------

This will tutorial is targeted at those who may want to try running Arch
Linux on a Nintendo Gamecube. With the NFS Setup you'll be able to
easily interact with the Gamecube via SSH, and even have it connect to
the internet. With the SD Setup you do not need a BBA, but you should at
least have a keyboard, otherwise your newly booted Arch Linux wont do
any good.

Required Hardware
-----------------

> Any Setup

-   A computer to prepare the Arch PPC files on. NOTE: I assume Linux
    here, but it could possibly be done on other OS's)
-   A Nintendo Gamecube.
-   A known way to execute code. I use SDLoad, but other methods should
    work also.
-   The ability to compile a Linux kernel.
    -   A powerpc cross compiler is needed for this in most cases.

> NFS Setup

-   A Computer with an NFS server enabled.
-   A Nintendo Gamecube Broadband Adapter.
-   A network cable to connect the computer and Gamecube.

> SD Setup

-   An SD Reader for the Gamecube.

Preface: Setting up things
--------------------------

> Gamecube Setup

Rather than go into great detail here, I'll send you to the GameCube
Linux wiki and give a quick overview of SDLoad. SDLoad is part Action
Replay exploit and part code on a SD card to allow you to execute other
code. You have to patch the SD card and put the program on the SD Card.
Go to http://www.gc-linux.org/wiki/SDload for more detailed information.

After you have SD Load working you can execute the kernel one of two
ways, either send it via networking or have the kernel on the SD card. I
will try to cover both ways in this tutorial.

> The Cross Compiler

You can use this https://github.com/losinggeneration/buildcross/ . Even
though it uses uclibc, it works just as well.

    git clone https://github.com/losinggeneration/buildcross.git
    cd buildcross
    ./buildcross.sh -gcl

That's all you need, make sure you have access to writing to
/usr/local/gc-linux. If not do this instead.

    TESTING="$HOME/gc-linux" ./buildcross.sh -gcl

That will install to ~/gc-linux

> The Linux Kernel

This isn't too hard. You'll need the kernel source which is over at
http://www.kernel.org and also the gamecube patch which is maintained by
the gc-linux.org team. Gamecube kernel patches. I've successfully
patched and booted 2.6.21.1 and prior versions should work also. After
you get the patch, have the linux-version-gc.patch.gz and
linux-version.tar.gz and extract the kernel.

    cd linux-version
    zcat ../linux-version-gc.patch.gz | patch -p1

That's how you patch the kernel in case you've never done that before

Now you're ready to build the kernel. I use the following script:

    PATH=$PATH:/usr/local/gc-linux/bin
    # Change NFSPATH to where you put the Arch PowerPC NFS
    NFSPATH=/mnt/exports/gamecube
    case "$1" in
    	"modules_install")
    		make ARCH=ppc CROSS_COMPILE=powerpc-gekko-linux-uclibc- INSTALL_MOD_PATH=$NFSPATH $@ || exit 1
    		;;
    	"install")
    		cp ./arch/ppc/boot/images/zImage.elf $NFSPATH/boot/ || exit 1
    		doltool -d $NFSPATH/zImage.elf || exit 1
    		rm $NFSPATH/zImage.elf || exit 1
    		;;
    	"run")
    		psolore $NFSPATH/zImage.dol || exit 1
    		;;
    	*)
    		make ARCH=ppc CROSS_COMPILE=powerpc-gekko-linux-uclibc- $@ || exit 1
    		;;
    esac

You do not have to use this by any means, it just makes it slightly
easier if you're to run it more than once. This script assumes you're
using NFS, you'll need to change it accordingly to use another directory
you setup for SD. First time you run it you'll need to do a
gamecube_defconfig. Remember you'll need to edit the IP/Gateway
addresses as well as the NFS server IP in the boot options.

Booting Linux
-------------

> NFS Setup

Server Setup

Since there are more extensive documents on this subject, I'll only
touch on what you need here.

1.  pacman -S nfs-utils
2.  edit /etc/hosts to include "192.168.1.101 gamecube"
3.  edit /etc/exports to include "/mnt/exports/gamecube
    gamecube(rw,no_root_squash,subtree_check)"
4.  mkdir -p /mnt/exports/gamecube
5.  Start /etc/rc.d/portmap /etc/rc.d/nfslock /etc/rc.d/nfsd

 NOTES 
    192.168.1.101 is the static IP you're going to use for the Gamecube
    /mnt/exports/gamecube might need to be changed to a more standard
    location. I do not know since I've never really dealt much with NFS
    besides on my own
    ALL : 192.168.1.0/255.255.255.0 should be changed to something more
    secure

Gamecube Setup

You are now ready to setup the Gamecube specific portions of the NFS
root.

To start with you should probably just download the ISO: Arch Linux PPC
ISOs. This is since it's slightly easier to deal with then finding each
package on the ftp we will need initially. Now that you have the ISO,
extract it and mount it as a loopback device (I'll use $HOME/archppc as
where you mounted it.) After that cd /mnt/exports/gamecube and we can
start extracting the needed packages. You'll need to extract the
following packages from $HOME/archppc/arch/pkg/

    acl attr autoconf automake bash binutils bzip2 cracklib db dbh dcron e2fsprogs ed eventlog file filesystem
    findutils flex gawk gcc gdbm glibc gnutls grep gzip initscripts kbd kernel-headers less libjpeg libpcap libpng
    libtasn1 libtiff libusb logrotate lzo2 m4 make mcpp mktemp module-init-tools ncurses net-tools ntp  openslp
    openssh openssl pacman pam parted patch pcre portmap procinfo procps readline sed shadow sudo sysfsutils syslog-ng
    sysvinit tar tcp_wrappers udev util-linux vim which zlib

Now you have those untared into the /mnt/exports/gamecube directory you
can setup some initial settings that need to be there.

-   Add this to etc/hosts "192.168.1.1 arch"
-   Modify etc/rc.conf with

    HOSTNAME="gamecube"
    eth0="eth0 192.168.1.101 netmask 255.255.255.0 broadcast 192.168.1.255"
    DAEMONS=(syslog-ng netfs crond ntpdate sshd)

-   If you're on a primarily single user station doing this, I'd suggest
    copying /etc/passwd and /etc/shadow to etc so you have a user and
    password ready on the Gamecube.
-   Modify etc/ssh/sshd_config with

    #ClientAliveInterval 15
    #ClientAliveCountMax 4
    X11Forwarding yes
    XAuthLocation /usr/bin/xauth

-   I suggest adding wheel to sudoers at least until you get everything
    setup

    %wheel ALL=(ALL) ALL

Now you should have a basic NFS root ready. You should be able to send
the kernel you made from above to the Gamecube and it should boot from
the NFS we just set up.

You'll need DOLtool as psolore in the path to run install/run the image.
I use the above script to send the kernel to the Gamecube. Otherwise run
this from inside the kernel directory.

    cd arch/ppc/boot/images/zImage.elf
    doltool -d zImage.elf
    psolore zImage.dol

After you've booted into the system, you need to login. If you do not
have a PS/2 adapter for your Gamecube or a PSO keyboard, you'll be able
to SSH to the system. From here you should have a very minimalistic Arch
system. But, pacman doesn't know any packages are actually installed as
of right now. So, we should probably do that right? Right, so all the
packages you installed earlier should be reinstalled with pacman -Sy;
pacman -S --force packages. Optionally, you could have copied the
packages from the ISO to the /mnt/exports/gamecube/var/cache/pacman/pkg
directory so you do not have to download all the packages over again.
Though, you may have to redownload many after you do pacman -Syu
anyways. So now you reinstalled all the programs you've previously
extracted and Arch Linux should now run as expected.

> SD Setup

To be written. I'm currently going back and redoing this to get
step-by-step instructions. I'll post my notes I've taken thus far. I'll
put them into a more coherent tutorial in the next couple of weeks.

Note: If you have trouble finding SDLoad, here it is!
http://wii-news.dcemu.co.uk/sdload.zip

TODO
----

-   Get SD card config
-   Get SD card tutorial
-   Cleanup
-   Retest all steps and fill in any gaps that might be there.

My Notes
--------

-   added XAuthLocation /usr/bin/xauth to /etc/ssh/sshd_config
-   extracted base system and openssh
-   booted into system and pacman base system
-   booted kernel 2.16.17.3 with
    CONFIG_CMDLINE="ip=192.168.1.101:192.168.1.1:192.168.1.1:255.255.255.0:gamecube:eth0:off
    root=/dev/nfs ro *nfsroot=192.168.1.1:/mnt/exports/gamecube,v3,tcp
    video=gamecubefb panic=15" will need to change ips as needed
-   ntp suggested to be added to rc.conf
-   network needs to be before syslog-ng in rc.conf because of being a
    completely nfs system
-   rebuild kernel using ABS in arch
-   create ssh keys locally
-   while installing many packages ssh closes terminating pacman,
    changed sshd KeepAlive values
-   Optional: copied local arch passwd and shadow to have same passwords
    and users (not a good option for machines with many users)
-   post kernel .config
-   Base packages needed

-   acl alsa-lib attr autoconf automake bash binutils bzip2 cracklib
    cups db dbh dcron dialog diffutils e2fsprogs ed eventlog expat file
    filesystem findutils flex gawk gcc gdbm glibc gnutls grep gzip
    initscripts jfsutils kbd kernel-headers less libcups libdrm libexif
    libgcrypt libgpg-error libice libjpeg libpcap libpng libsm libtasn1
    libtiff libusb libxdmcp libxml2 logrotate lzo2 m4 mac-fdisk mailx
    make mcpp mktemp module-init-tools ncurses net-tools ntp opencdk
    openslp openssh openssl pacman pam parted patch pcre perl popt
    portmap procinfo procps readline reiserfsprogs sed shadow sudo
    sysfsutils syslog-ng sysvinit tar tcp_wrappers udev util-linux vim
    which xfsprogs zlib

Retrieved from
"https://wiki.archlinux.org/index.php?title=Gamecube_Tutorial&oldid=235410"

Category:

-   PowerPC
