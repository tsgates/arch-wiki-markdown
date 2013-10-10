Setting up a uclibc development system
======================================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

(I converted this from html automatically, so it could do with cleaning
up!)

If you want to build small static binaries, say for an initrd/initramfs,
or maybe a boot floppy, one of the best ways of doing this is to use the
uclibc library instead of glibc. Here is how I got a development system
set up, with which I could then compile busybox, run-init (from klibc,
for use in an initramfs), and the utilities from unionfs.

There are various ways of getting a system based on uclibc running. The
easiest is to use the development system offered on the uclibc website
(www.uclibc.org) in the form of a root file-system (prebuilt root
file-system). It is not small - unpacked about 100M – but it provides
all the basic tools for compiling with uclibc in ready-made form. An
alternative, and more flexible approach is to use buildroot. I describe
first how to get these set up, and then give some examples of their use.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Using a prebuilt root file-system                                  |
| -   2 Using buildroot                                                    |
| -   3 Using the development environment                                  |
|     -   3.1 Compiling the unionfs utilities                              |
|     -   3.2 Compiling busybox                                            |
|     -   3.3 Compiling run-init.c from klibc                              |
+--------------------------------------------------------------------------+

Using a prebuilt root file-system
---------------------------------

-   Download it to a new build directory, e.g. ~/BUILD/uclibc. The file
    can be got from the uclibc download server, it was named
    root_fs_i386.ext2.bz2.
-   Unzip it: 'bunzip2 root_fs_i386.ext2.bz2'
-   Make a mount point: 'mkdir mnt'
-   Make a folder for the development system: 'mkdir ucroot'
-   From now on you need to be root, so do a 'su', then

    mount -o loop root_fs_i386.ext2 mnt
    cp -a   mnt/* ucroot
    rm -r ucroot/lost+found
    umount mnt
    rm root_fs_i386.ext2

-   To allow a normal user to read & write to ucroot/home: 'chmod 777
    ucroot/home'
-   This gives you a tar-ball of your fresh system, in case you mess it
    up and want to start again, without the hassle above:

    tar -cjf uclibc_rootfs.tar.bz2 -C ucroot .

Here I have just copied the development file-system to the directory
ucroot/, so that it is available within the normal file-system. After
copying and unmounting I can discard the original.

Unfortunately this pre-built root_fsseems not to be updated any more,
but at least it worked for me without any great difficulties.

Using buildroot
---------------

The recommended method is to use buildroot (buildroot.uclibc.org), but
at first I was too stupid for it, and it didn't work. After a bit of
consideration, I decided to base my .config on that used to build the
pre-built root_fs. The result was buildroot_my_config (see below), and
this seemed to work. Well, if I remember correctly, it only worked after
I had added a symlink from /usr/bin/install to /bin/install. The main
change I made was to set the architecture to i486, and to select the
tarred form for the final package (to save all the fiddling around with
mounting). Of course, there are many other possible configurations.

I should warn you that the compilation takes a while (I think about 40
minutes on my P4 3GHz computer) and uses a lot of space (about 1.4GB
were occupied at the end). Of course you can delete the build directory
when the compilation is finished (but remember to take the result, in my
case rootfs.i486.tar, out first – you might like to compress this 80MB
lump for convenience).

When you unpack your tar-ball to your ucroot/ directory, do it as root
if you want to preserve permissions and the device nodes (though the
latter won't be needed here).

Using the development environment
---------------------------------

To use the development environment, I can copy the needed source files
into this directory tree, using e.g. the ucroot/home/ directory (which
is otherwise unused), and do something like 'chroot ucroot', as root of
course, to get into it. It is quite convenient to have one terminal
operating "chrooted" in this development environment and another in the
normal environment running mc (or some GUI file manager) for copying
things around the system, etc., as nothing fancy is provided in the
development environment.

> Compiling the unionfs utilities

These are best statically linked for use in an initramfs, and they will
be much smaller if uclibc is used.

-   Create directory unionfs/ inside home
-   Create file fistdev.mk:

# Unionfs Makefile modifications  
EXTRACFLAGS=-DUNIONFS_NDEBUG  
PREFIX=/usr  
UNIONFS_DEBUG_CFLAG=  
  
# This builds static utils - but with glibc they get VERY big!  
UNIONFS_OPT_CFLAG=-Os -static  
  
# This stuff is necessary for compiling the kernel module  
# when a kernel other than the running one is the target.  
# It is not needed for the utilities.  
LINUXSRC=/usr/src/linux  
TOPINC=-I$(LINUXSRC)/include  
MODDIR=/lib/modules/2.6.xx

-   Unpack the unionfs tar-ball within unionfs/
-   Copy fistdev.mk into the base directory (e.g. unionfs-1.1.2/)
-   Run 'make utils' in that directory. In my case it failed building
    unionimap, but I guess you normally won't need that (whatever it
    is!)
-   Copy out unionctl and uniondbg, and strip them: 'strip unionctl
    uniondbg'

> Compiling busybox

I was playing around with LinuxLive scripts and the version supplied
there seemed a bit large to me – maybe it was compiled against glibc?
Anyway, I decided to do a uclibc version. Unfortunately the 'make
menuconfig' step didn't work for me in the uclibc development
environment. Maybe there's a trick or tweak (does anybody know?), but to
get around this you can do 'make menuconfig' in your normal system and
save the resulting .config file, delete the busybox-x.x.x/ folder,
unpack it again and copy your .config into that. Then do as below. If
you don't start with a fresh folder in the uclibc system, it won't work.

-   Enter the chroot system
-   Unpack busybox-1.0.1 within the home/ directory
-   Provide a .config as described above
-   cd to the busybox-1.0.1/ directory
-   make oldconfig  
    make dep  
    make
-   Copy out busybox

> Compiling run-init.c from klibc

-   Copy the file run-init.c from the klibc package (I used
    'klibc-1.1.1') to the home/ directory
-   Enter the chroot system
-   cd to the directory containing run-init.c
-   'gcc -Os -static -o run-init run-init.c'
-   Copy out run-init

     ----------------------------------------------------------------------
     

> buildroot_my_config

    #
     # Automatically generated make config: don't edit
     #
     BR2_HAVE_DOT_CONFIG=y
     # BR2_alpha is not set
     # BR2_arm is not set
     # BR2_armeb is not set
     # BR2_cris is not set
     BR2_i386=y
     # BR2_m68k is not set
     # BR2_mips is not set
     # BR2_mipsel is not set
     # BR2_nios2 is not set
     # BR2_powerpc is not set
     # BR2_sh is not set
     # BR2_sparc is not set
     # BR2_x86_64 is not set
     # BR2_x86_i386 is not set
     BR2_x86_i486=y
     # BR2_x86_i586 is not set
     # BR2_x86_i686 is not set
     BR2_ARCH="i486"
     BR2_ENDIAN="LITTLE"
     
     #
     # Build options
     #
     BR2_WGET="wget --passive-ftp"
     BR2_SVN="svn co"
     BR2_TAR_OPTIONS=""
     BR2_DL_DIR="$(BASE_DIR)/dl"
     BR2_SOURCEFORGE_MIRROR="easynews"
     BR2_STAGING_DIR="$(BUILD_DIR)/staging_dir"
     BR2_TOPDIR_PREFIX=""
     BR2_TOPDIR_SUFFIX=""
     BR2_GNU_BUILD_SUFFIX="pc-linux-gnu"
     BR2_JLEVEL=3
     
     #
     # Toolchain Options
     #
     
     #
     # Kernel Header Options
     #
     # BR2_KERNEL_HEADERS_2_4_25 is not set
     # BR2_KERNEL_HEADERS_2_4_27 is not set
     # BR2_KERNEL_HEADERS_2_4_29 is not set
     BR2_KERNEL_HEADERS_2_4_31=y
     # BR2_KERNEL_HEADERS_2_6_9 is not set
     # BR2_KERNEL_HEADERS_2_6_11 is not set
     # BR2_KERNEL_HEADERS_2_6_12 is not set
     BR2_DEFAULT_KERNEL_HEADERS="2.4.31"
     
     #
     # uClibc Options
     #
     # BR2_UCLIBC_VERSION_SNAPSHOT is not set
     # BR2_ENABLE_LOCALE is not set
     # BR2_PTHREADS_NONE is not set
     # BR2_PTHREADS is not set
     BR2_PTHREADS_OLD=y
     # BR2_PTHREADS_NATIVE is not set
     
     #
     # Binutils Options
     #
     # BR2_BINUTILS_VERSION_2_14_90_0_8 is not set
     # BR2_BINUTILS_VERSION_2_15 is not set
     # BR2_BINUTILS_VERSION_2_15_94_0_2_2 is not set
     # BR2_BINUTILS_VERSION_2_15_97 is not set
     # BR2_BINUTILS_VERSION_2_16 is not set
     BR2_BINUTILS_VERSION_2_16_1=y
     # BR2_BINUTILS_VERSION_2_16_90_0_3 is not set
     # BR2_BINUTILS_VERSION_2_16_91_0_2 is not set
     # BR2_BINUTILS_VERSION_2_16_91_0_3 is not set
     # BR2_BINUTILS_VERSION_2_16_91_0_4 is not set
     # BR2_BINUTILS_VERSION_2_16_91_0_5 is not set
     BR2_BINUTILS_VERSION="2.16.1"
     
     #
     # Gcc Options
     #
     # BR2_GCC_VERSION_3_3_5 is not set
     # BR2_GCC_VERSION_3_3_6 is not set
     # BR2_GCC_VERSION_3_4_2 is not set
     # BR2_GCC_VERSION_3_4_3 is not set
     # BR2_GCC_VERSION_3_4_4 is not set
     BR2_GCC_VERSION_3_4_5=y
     # BR2_GCC_VERSION_4_0_0 is not set
     # BR2_GCC_VERSION_4_0_1 is not set
     # BR2_GCC_VERSION_4_0_2 is not set
     # BR2_GCC_VERSION_4_1_0 is not set
     # BR2_GCC_VERSION_4_2_0 is not set
     BR2_GCC_VERSION="3.4.5"
     # BR2_GCC_USE_SJLJ_EXCEPTIONS is not set
     BR2_EXTRA_GCC_CONFIG_OPTIONS=""
     BR2_INSTALL_LIBSTDCPP=y
     # BR2_INSTALL_LIBGCJ is not set
     # BR2_INSTALL_OBJC is not set
     
     #
     # Ccache Options
     #
     BR2_CCACHE=y
     
     #
     # Gdb Options
     #
     # BR2_PACKAGE_GDB is not set
     # BR2_PACKAGE_GDB_SERVER is not set
     # BR2_PACKAGE_GDB_CLIENT is not set
     
     #
     # elf2flt
     #
     # BR2_ELF2FLT is not set
     
     #
     # Common Toolchain Options
     #
     # BR2_PACKAGE_SSTRIP_TARGET is not set
     # BR2_PACKAGE_SSTRIP_HOST is not set
     BR2_ENABLE_MULTILIB=y
     BR2_LARGEFILE=y
     BR2_TARGET_OPTIMIZATION="-Os -pipe"
     BR2_CROSS_TOOLCHAIN_TARGET_UTILS=y
     
     #
     # Package Selection for the target
     #
     
     #
     # The default minimal system
     #
     BR2_PACKAGE_BUSYBOX=y
     BR2_PACKAGE_BUSYBOX_SNAPSHOT=y
     BR2_PACKAGE_BUSYBOX_INSTALL_SYMLINKS=y
     BR2_PACKAGE_BUSYBOX_CONFIG="package/busybox/busybox.config"
     
     #
     # The minimum needed to build a uClibc development system
     #
     BR2_PACKAGE_BASH=y
     BR2_PACKAGE_BZIP2=y
     BR2_PACKAGE_COREUTILS=y
     BR2_PACKAGE_DIFFUTILS=y
     BR2_PACKAGE_ED=y
     BR2_PACKAGE_FINDUTILS=y
     BR2_PACKAGE_FLEX=y
     BR2_PACKAGE_FLEX_LIBFL=y
     BR2_PACKAGE_GAWK=y
     BR2_PACKAGE_GCC_TARGET=y
     BR2_PACKAGE_CCACHE_TARGET=y
     BR2_PACKAGE_GREP=y
     BR2_PACKAGE_MAKE=y
     BR2_PACKAGE_PATCH=y
     BR2_PACKAGE_SED=y
     BR2_PACKAGE_TAR=y
     
     #
     # Other stuff
     #
     # BR2_PACKAGE_ACPID is not set
     # BR2_PACKAGE_ASTERISK is not set
     # BR2_PACKAGE_AT is not set
     BR2_PACKAGE_AUTOCONF=y
     BR2_PACKAGE_AUTOMAKE=y
     # BR2_PACKAGE_BERKELEYDB is not set
     # BR2_PACKAGE_BIND is not set
     # BR2_PACKAGE_BISON is not set
     # BR2_PACKAGE_BOA is not set
     # BR2_PACKAGE_BRIDGE is not set
     # BR2_PACKAGE_CUSTOMIZE is not set
     # BR2_PACKAGE_ISC_DHCP is not set
     # BR2_PACKAGE_DIALOG is not set
     # BR2_PACKAGE_DIRECTFB is not set
     # BR2_PACKAGE_DISTCC is not set
     # BR2_PACKAGE_DM is not set
     # BR2_PACKAGE_DNSMASQ is not set
     # BR2_PACKAGE_DROPBEAR is not set
     # BR2_PACKAGE_EXPAT is not set
     BR2_PACKAGE_E2FSPROGS=y
     # BR2_PACKAGE_FAKEROOT is not set
     BR2_PACKAGE_FILE=y
     # BR2_PACKAGE_FREETYPE is not set
     # BR2_PACKAGE_GETTEXT is not set
     # BR2_PACKAGE_LIBINTL is not set
     BR2_PACKAGE_GZIP=y
     # BR2_PACKAGE_HOSTAP is not set
     # BR2_PACKAGE_HOTPLUG is not set
     # BR2_PACKAGE_IOSTAT is not set
     # BR2_PACKAGE_IPROUTE2 is not set
     # BR2_PACKAGE_IPSEC_TOOLS is not set
     # BR2_PACKAGE_IPTABLES is not set
     # BR2_PACKAGE_JPEG is not set
     BR2_PACKAGE_LESS=y
     # BR2_PACKAGE_LIBCGI is not set
     # BR2_PACKAGE_LIBCGICC is not set
     # BR2_PACKAGE_LIBELF is not set
     # BR2_PACKAGE_LIBFLOAT is not set
     # BR2_PACKAGE_LIBGLIB12 is not set
     # BR2_PACKAGE_LIBMAD is not set
     # BR2_PACKAGE_LIBPCAP is not set
     # BR2_PACKAGE_LIBPNG is not set
     # BR2_PACKAGE_LIBSYSFS is not set
     BR2_PACKAGE_LIBTOOL=y
     # BR2_PACKAGE_LIBUSB is not set
     # BR2_PACKAGE_LIGHTTPD is not set
     # BR2_PACKAGE_LINKS is not set
     # BR2_PACKAGE_LRZSZ is not set
     # BR2_PACKAGE_LTP-TESTSUITE is not set
     # BR2_PACKAGE_LTT is not set
     # BR2_PACKAGE_LVM2 is not set
     # BR2_PACKAGE_LZO is not set
     BR2_PACKAGE_M4=y
     # BR2_PACKAGE_MDADM is not set
     # BR2_PACKAGE_MEMTESTER is not set
     # BR2_PACKAGE_MICROCOM is not set
     # BR2_PACKAGE_MICROPERL is not set
     # BR2_PACKAGE_MICROWIN is not set
     # BR2_PACKAGE_MKDOSFS is not set
     # BR2_PACKAGE_MODULE_INIT_TOOLS is not set
     # BR2_PACKAGE_MODUTILS is not set
     # BR2_PACKAGE_MPG123 is not set
     # BR2_PACKAGE_MROUTED is not set
     # BR2_PACKAGE_MTD is not set
     # BR2_PACKAGE_NANO is not set
     BR2_PACKAGE_NCURSES=y
     # BR2_PACKAGE_NCURSES_TARGET_HEADERS is not set
     BR2_PACKAGE_NETKITBASE=y
     # BR2_PACKAGE_NETKITTELNET is not set
     # BR2_PACKAGE_NETSNMP is not set
     # BR2_PACKAGE_NEWT is not set
     # BR2_PACKAGE_NTP is not set
     # BR2_PACKAGE_OPENNTPD is not set
     # BR2_PACKAGE_OPENSSH is not set
     # BR2_PACKAGE_OPENSSL is not set
     # BR2_PACKAGE_OPENVPN is not set
     BR2_PACKAGE_PCIUTILS=y
     # BR2_PACKAGE_PORTAGE is not set
     # BR2_PACKAGE_PORTMAP is not set
     # BR2_PACKAGE_PPPD is not set
     BR2_PACKAGE_PROCPS=y
     # BR2_PACKAGE_PSMISC is not set
     # BR2_PACKAGE_PYTHON is not set
     # BR2_PACKAGE_QTE is not set
     BR2_QTE_TMAKE_VERSION="1.13"
     # BR2_PACKAGE_RAIDTOOLS is not set
     BR2_READLINE=y
     # BR2_PACKAGE_RSYNC is not set
     # BR2_PACKAGE_RUBY is not set
     # BR2_PACKAGE_RXVT is not set
     # BR2_PACKAGE_SDL is not set
     # BR2_PACKAGE_SFDISK is not set
     # BR2_PACKAGE_SLANG is not set
     # BR2_PACKAGE_SMARTMONTOOLS is not set
     # BR2_PACKAGE_SOCAT is not set
     # BR2_PACKAGE_STRACE is not set
     # BR2_PACKAGE_SYSKLOGD is not set
     # BR2_PACKAGE_SYSVINIT is not set
     # BR2_PACKAGE_TCL is not set
     # BR2_PACKAGE_TCPDUMP is not set
     # BR2_PACKAGE_TFTPD is not set
     # BR2_PACKAGE_THTTPD is not set
     # BR2_PACKAGE_TINYLOGIN is not set
     # BR2_PACKAGE_TINYX is not set
     # BR2_PACKAGE_TN5250 is not set
     # BR2_PACKAGE_TTCP is not set
     # BR2_PACKAGE_UDEV is not set
     # BR2_PACKAGE_UDHCP is not set
     # BR2_PACKAGE_USBUTILS is not set
     BR2_PACKAGE_UTIL-LINUX=y
     # BR2_PACKAGE_VALGRIND is not set
     # BR2_PACKAGE_VTUN is not set
     # BR2_PACKAGE_WGET is not set
     # BR2_PACKAGE_WHICH is not set
     # BR2_PACKAGE_WIPE is not set
     # BR2_PACKAGE_WIRELESS_TOOLS is not set
     # BR2_PACKAGE_XFSPROGS is not set
     # BR2_PACKAGE_XORG is not set
     BR2_PACKAGE_ZLIB=y
     # BR2_PACKAGE_ZLIB_TARGET_HEADERS is not set
     
     #
     # Target Options
     #
     
     #
     # filesystem for target device
     #
     # BR2_TARGET_ROOTFS_CRAMFS is not set
     # BR2_TARGET_ROOTFS_CLOOP is not set
     # BR2_TARGET_ROOTFS_EXT2 is not set
     # BR2_TARGET_ROOTFS_JFFS2 is not set
     # BR2_TARGET_ROOTFS_SQUASHFS is not set
     BR2_TARGET_ROOTFS_TAR=y
     BR2_TARGET_ROOTFS_TAR_OPTIONS=""
     
     #
     # bootloader for target device
     #
     # BR2_TARGET_GRUB is not set
     # BR2_TARGET_SYSLINUX is not set
     
     #
     # Board Support Options
     #
     # BR2_TARGET_SOEKRIS_NET4521 is not set
     # BR2_TARGET_SOEKRIS_NET4801 is not set
     # BR2_TARGET_VIA_EPIA_MII is not set
     
     #
     # Generic System Support
     #
     # BR2_TARGET_GENERIC_ACCESS_POINT is not set
     # BR2_TARGET_GENERIC_FIREWALL is not set
     # BR2_TARGET_GENERIC_DEV_SYSTEM is not set

Retrieved from
"https://wiki.archlinux.org/index.php?title=Setting_up_a_uclibc_development_system&oldid=198001"

Category:

-   Development
