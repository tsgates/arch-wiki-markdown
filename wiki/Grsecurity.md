Grsecurity
==========

From Grsecurity homepage:

Unlike other expensive security "solutions" that pretend to achieve
security through known-vulnerability patching, signature-based
detection, or other reactive methods, grsecurity provides real proactive
security. The only solution that hardens both your applications and
operating system, grsecurity is essential for public-facing servers and
shared-hosting environments.

The grsecurity project provides patches to the Linux kernel which
enhance security further than many other solutions. The main advantage
is a "learning mode" designed to configure a tight Mandatory Access
Control almost effortlessly. Comparable security implementations include
SELinux and Apparmor. It is up to the user to decide which one is
appropriate.

In order to utilize grsecurity most effectively, it is understood that
the reader has a working knowledge of computer security in general.

Contents
--------

-   1 Build options
    -   1.1 Install binary kernel packages
    -   1.2 Build kernel from AUR
        -   1.2.1 Download files
        -   1.2.2 Verify the GPG signatures
        -   1.2.3 Setup build environment
        -   1.2.4 Build the kernel package
        -   1.2.5 Make a backup
        -   1.2.6 Install PaX and RBAC utilities
        -   1.2.7 Set PaX Flags
        -   1.2.8 Install hardened kernel
    -   1.3 Build kernel without the AUR
-   2 RBAC
    -   2.1 Configuring the kernel
    -   2.2 Working with gradm
    -   2.3 Generating a policy
    -   2.4 Tweaking your policy
-   3 PaX
    -   3.1 Fighting the exploitation of software bugs
    -   3.2 PaX kernel configuration
    -   3.3 Controlling PaX
    -   3.4 Verifying the PaX settings
-   4 Other features
    -   4.1 Filesystem protection
        -   4.1.1 Fighting chroot and filesystem abuse
            -   4.1.1.1 Kernel configuration
            -   4.1.1.2 Triggering the Security Mechanism
    -   4.2 Kernel auditing
        -   4.2.1 Extend your system's logging facilities
        -   4.2.2 The various Kernel Audit Settings
        -   4.2.3 Process restrictions
            -   4.2.3.1 Executable protection
            -   4.2.3.2 Network protection
            -   4.2.3.3 Kernel settings
-   5 Using linux-pax-flags AUR package
-   6 Tips and tricks

Build options
-------------

There are three ways you can install a grsecurity hardened kernel in
Arch. The first is by adding a repository to install the binary kernel.
The second option is to build it from the AUR package. The third option
is to patch and build the kernel all by hand.

Your best bet is probably to use the binary grsecurity kernel
repository. If you have the time, build the AUR package yourself for
added security.

Note:Any way you choose to install the grsecurity kernel you will need
to also install gradm, paxctl, and linux-pax-flags

> Install binary kernel packages

Add the Arsch Arch Linux Repository to your package sources and install
the kernel with pacman -Sy linux-grsec (or the PaX only kernel with
pacman -Sy linux-pax). Finish by adding the new kernel to your
bootloader menu (with grub-mkconfig -o /boot/grub/grub.cfg for example)
and reboot.

If you rely on specific hooks, like catalyst-hook, you have to install
the headers first with pacman -Sy linux-grsec-headers.

After configuration of grsecurity sysctl options, set
kernel.grsecurity.grsec_lock = 1 in /etc/sysctl.d/10-grsecurity.conf, so
no hardening option can be deactivated later (even by root).

> Build kernel from AUR

To build the AUR package we will follow this general game plan. First,
download all needed files and check GPG signatures. Second, configure
kernel and compile. Third, copy a backup of these files to the Root
users home folder. Forth, install utilities needed for PaX and RBAC.
Fifth, install the kernel package. Sixth, run linux-pax-flags to poke
security holes in applications that will not run without them. Finally,
reboot into your hardened system.

The AUR has all the utilities and kernel packages you need to run a
hardened Arch Linux system. There is even a script called
linux-pax-flags which will make using PaX as painless as possible by
setting all the PaX flags automatically.

Download files

Download the packages linux-grsec Or linux-grsec-lts

Kernel linux-3.X.tar.xz and current patch-3.X.X.tar.xz also the .sign
signature files for each. kernel.org

Download the current grsecurity patch and Signatures grsecurity Test Or
grsecurity Stable for LTS kernel

Tip:The Grsecurity Test is in fact stable. The Stable Grsecurity version
is just for the LTS

Verify the GPG signatures

With the .sign files in the same directory as the file it is a a
signature of, verify the signature like so...

    $ gpg2 --verify linux-3.10.tar.sign

Setup build environment

Unpack the linux-grsec.tar.gz and copy all the files into it

    $ tar xzf linux-grsec.tar.gz
    $ cp ~/Downloads/linux-3.10.tar.xz ~/linux-grsec
    $ cp ~/Downloads/patch-3.10.9.tar.xz ~/linux-grsec
    $ cp ~/Downloads/grsecurity-2.9.1-3.10.9-201308202015.patch ~/linux-grsec

Change into the build directory

    $ cd ~/linux-grsec

Build the kernel package

It is going to take a long time to build the kernel because it is based
on the default Arch kernel config with has about ten times as make
modules enabled then your system actually needs. However, it is a known
working config and to eliminate any more variables it is advisable to
just live with the extra build time.

Build the package

    $ MENUCONFIG=2 makepkg

You should be dropped into the ncurses GUI now. Navigate to the
grsecurity settings to verify the configuration and/or change things as
needed. These setting can be found in
Security options ---> grsecurity ---> Customize Configuration --->

For both Desktops and Servers after you are sure you will not need to
change any of the Grsecurity settings with sysctl, disable
Sysctl support found in Sysctl Support.

If this kernel is for a Server also enable Disable privileged I/O found
in Memory Protections.

All other setting should be optimal as they are, so now exit out of the
ncurses GUI config and Save. Now the package should start to build. If
all goes well you will have two .pkg.tar.xz packages one for the kernel
and one for the kernel-headers.

Make a backup

Keep all linux-grsec.tar.gz files along with the grsecruity patch and
compiled packages in the Root users home folder. That way you can roll
back if needed. Every time a new grsecurity patch is release you will
not be able to download outdated patches every again.

    # mkdir /root/3.10.9
    # cp -r /home/USER/linux-grsec /root/3.10.9

Install PaX and RBAC utilities

The AUR has three utilities you will need to install. They are paxctl,
gradm, and linux-pax-flags.

Set PaX Flags

Use the linux-pax-flags program to configure all the PaX flags for
troublesome programs. More information can be found in the Using
linux-pax-flags AUR Package section.

    # linux-pax-flags

Install hardened kernel

Now that all the needed utilities are installed and the system is
configured for PaX, install the hardened kernel and headers.

    # pacman -U /root/3.10.9/*.pkg.tar.xz

Finish by adding the new kernel to your bootloader menu (with
grub-mkconfig -o /boot/grub/grub.cfg for example) and reboot.

You should now be in your hardened system. Just make sure to run
linux-pax-flags after every time you update your system or install a new
program and you should have a trouble free experience.

> Build kernel without the AUR

Throughout this document we will talk about kernel configuration using
the kernel variables like CONFIG_GRKERNSEC_PAX_NO_ACL_FLAGS. These are
the variables that the kernel build process uses to determine if a
certain feature needs to be compiled.

When you configure your kernel through make menuconfig or similar, you
receive a user interface through which you can select the various kernel
options. If you select the Help button at a certain kernel feature you
will see at the top that it lists such a kernel variable.

You can therefore still configure your kernel as you like - with a bit
of thinking. And if you cannot find a certain option, there is always
the possibility to edit /usr/src/linux/.config by hand :)

Of course, to be able to select the various grsecurity kernel options,
you must enable grsecurity in your kernel. See default grsecurity kernel
configuration

RBAC
----

Role Based Access Control

There are two basic types of access control mechanisms used to prevent
unauthorized access to files (or information in general): DAC
(Discretionary Access Control) and MAC (Mandatory Access Control). By
default, Linux uses a DAC mechanism: the creator of the file can define
who has access to the file. A MAC system however forces everyone to
follow rules set by the administrator.

The MAC implementation grsecurity supports is called Role Based Access
Control. RBAC associates roles with each user. Each role defines what
operations can be performed on certain objects. Given a well-written
collection of roles and operations your users will be restricted to
perform only those tasks that you tell them they can do. The default
"deny-all" ensures you that a user cannot perform an action you have not
thought of.

> Configuring the kernel

The recommended kernel setting for RBAC is:

    #
    # Role Based Access Control Options
    #
    CONFIG_GRKERNSEC_ACL_HIDEKERN=y
    CONFIG_GRKERNSEC_ACL_MAXTRIES=3
    CONFIG_GRKERNSEC_ACL_TIMEOUT=30

> Working with gradm

gradm is a tool which allows you to administer and maintain a policy for
your system. With it, you can enable or disable the RBAC system, reload
the RBAC roles, change your role, set a password for admin mode, etc.

When you install gradm a default policy will be installed in
/etc/grsec/policy. Please see in AUR for gradm package.

By default, the RBAC policies are not activated. It is the sysadmin's
job to determine when the system should have an RBAC policy enforced.
Before activating the RBAC system you should set an admin password.

    # gradm -P admin
    Setting up grsecurity RBAC password
    Password: (Enter a well-chosen password)
    Re-enter Password: (Enter the same password for confirmation)
    Password written in /etc/grsec/pw
    # gradm -E

To disable the RBAC system, run gradm -D. If you are not allowed to, you
first need to switch to the admin role:

    # gradm -a admin
    Password: (Enter your admin role password)
    # gradm -D

If you want to leave the admin role, run gradm -u admin:

    # gradm -u admin

> Generating a policy

The RBAC system comes with a great feature called "learning mode". The
learning mode can generate an anticipatory least privilege policy for
your system. This allows for time and money savings by being able to
rapidly deploy multiple secure servers.

To use the learning mode, activate it using gradm:

    # gradm -F -L /etc/grsec/learning.log

Now use your system, do the things you would normally do. Try to avoid
rsyncing, running locate or any other heavy file i/o operation as this
can really slow down the processing time.

When you believe you have used your system sufficiently to obtain a good
policy, let gradm process them and propose roles under
/etc/grsec/learning.roles:

    # gradm -F -L /etc/grsec/learning.log -O /etc/grsec/learning.roles

Audit the /etc/grsec/learning.roles and save it as /etc/grsec/policy
(mode 0600) when you are finished.

    # mv /etc/grsec/learning.roles /etc/grsec/policy
    # chmod 0600 /etc/grsec/policy

You will now be able to enable the RBAC system with your new learned
policy.

> Tweaking your policy

An interesting feature of grsecurity 2.x is Set Operation Support for
the configuration file. Currently it supports unions, intersections and
differences of sets (of objects in this case).

    define objset1 {
    /root/blah rw
    /root/blah2 r
    /root/blah3 x
    }

    define somename2 {
    /root/test1 rw
    /root/blah2 rw
    /root/test3 h
    }

Here is an example of its use, and the resulting objects that will be
added to your subject:

    subject /somebinary o
    $objset1 & $somename2

The above would expand to:

    subject /somebinary o
    /root/blah2 r

This is the result of the & operator which takes both sets and returns
the files that exist in both sets and the permission for those files
that exist in both sets.

    subject /somebinary o
    $objset1 | $somename2

This example would expand to:

    subject /somebinary o
    /root/blah rw
    /root/blah2 rw
    /root/blah3 x
    /root/test1 rw
    /root/test3 h

This is the result of the | operator which takes both sets and returns
the files that exist in either set. If a file exists in both sets, it is
returned as well and the mode contains the flags that exist in either
set.

    subject /somebinary o
    $objset1 - $somename2

This example would expand to:

    subject /somebinary o
    /root/blah rw
    /root/blah2 h
    /root/blah3 x

This is the result of the - operator which takes both sets and returns
the files that exist in the set on the left but not in the match of the
file in set on the right. If a file exists on the left and a match is
found on the right (either the filenames are the same, or a parent
directory exists in the right set), the file is returned and the mode of
the second set is removed from the first set, and that file is returned.

In some obscure pseudo-language you could see this as:

    if ( ($objset1 contained /tmp/blah rw) and
         ($objset2 contained /tmp/blah r) )
    then
      $objset1 - $objset2 would contain /tmp/blah w

    if ( ($objset1 contained /tmp/blah rw) and
         ($objset2 contained / rwx) )
    then 
      $objset1 - $objset2 would contain /tmp/blah h

As for order of precedence (from highest to lowest): "-, & |".

If you do not want to bother remembering precedence, parenthesis support
is also included, so you can do things like:

    (($set1 - $set2) | $set3) & $set4

PaX
---

Fighting the exploitation of software bugs

PaX introduces a couple of security mechanisms that make it harder for
attackers to exploit software bugs that involve memory corruption (so do
not treat PaX as if it protects against all possible software bugs). The
PaX introduction document talks about three possible exploit techniques:

1.  introduce/execute arbitrary code
2.  execute existing code out of original program order
3.  execute existing code in original program order with arbitrary data

One prevention method disallows executable code to be stored in writable
memory. When we look at a process, it requires five memory regions:

1.  a data section which contains the statically allocated and global
    data
2.  a BSS region (Block Started by Symbol) which contains information
    about the zero-initialized data of the process
3.  a code region, also called the text segment, which contains the
    executable instructions
4.  a heap which contains the dynamically allocated memory
5.  a stack which contains the local variables

The first PaX prevention method, called NOEXEC, is meant to give control
over the runtime code generation. It marks memory pages that do not
contain executable code as non-executable. This means that the heap and
the stack, which only contain variable data and should not contain
executable code, are marked as non-executable. Exploits that place code
in these areas with the intention of running it will fail.

NOEXEC does more than this actually, interested readers should focus
their attention to the PaX NOEXEC documentation.

The second PaX prevention method, called ASLR (Address Space Layout
Randomization), randomize the addresses given to memory requests. Where
previously memory was assigned contiguously (which means exploits know
where the tasks' memory regions are situated) ASLR randomizes this
allocation, rendering techniques that rely on this information useless.

More information about ASLR can be found online.

PaX kernel configuration

The recommended kernel setting for PaX is:

    #
    # Security options
    #
    #
    # PaX
    #
    CONFIG_PAX=y
    #
    # PaX Control
    #
    # CONFIG_PAX_SOFTMODE is not set
    CONFIG_PAX_EI_PAX=y
    CONFIG_PAX_PT_PAX_FLAGS=y
    CONFIG_PAX_NO_ACL_FLAGS=y
    # CONFIG_PAX_HAVE_ACL_FLAGS is not set
    # CONFIG_PAX_HOOK_ACL_FLAGS is not set
    #
    # Non-executable pages
    #
    CONFIG_PAX_NOEXEC=y
    CONFIG_PAX_PAGEEXEC=y
    CONFIG_PAX_SEGMEXEC=y
    # CONFIG_PAX_DEFAULT_PAGEEXEC is not set
    CONFIG_PAX_DEFAULT_SEGMEXEC=y
    CONFIG_PAX_EMUTRAMP=y
    CONFIG_PAX_MPROTECT=y
    # CONFIG_PAX_NOELFRELOCS is not set
    #
    # Address Space Layout Randomization
    #
    CONFIG_PAX_ASLR=y
    CONFIG_PAX_RANDKSTACK=y
    CONFIG_PAX_RANDUSTACK=y
    CONFIG_PAX_RANDMMAP=y
    #
    # Miscellaneous hardening features
    #
    CONFIG_PAX_MEMORY_SANITIZE=y
    CONFIG_PAX_MEMORY_UDEREF=y
    CONFIG_KEYS=y
    # CONFIG_KEYS_DEBUG_PROC_KEYS is not set
    CONFIG_SECURITY=y
    CONFIG_SECURITY_NETWORK=y
    CONFIG_SECURITY_NETWORK_XFRM=y
    CONFIG_SECURITY_CAPABILITIES=m
    CONFIG_SECURITY_ROOTPLUG=m

If you are running a non-x86 system you will observe that there is no
CONFIG_GRKERNSEC_PAX_NOEXEC. You should select
CONFIG_GRKERNSEC_PAX_PAGEEXEC instead as it is the only non-exec
implementation around.

> Controlling PaX

Not all Linux applications are happy with the PaX security restrictions.
These tools include xorg-x11, java, mplayer, xmms and others. If you
plan on using them you can elevate the protections for these
applications using chpax and paxctl. You can find they on AUR.

You can also use pax-utils, which is a small toolbox which contains
useful applications to administrate a PaX aware server. Find it on AUR.

Interesting tools include scanelf and pspax:

-   With scanelf you can scan over library and binary directories and
    list the various permissions and ELF types that pertain to running
    an ideal pax/grsec setup
-   With pspax you can display PaX flags/capabilities/xattr from the
    kernel's perspective

> Verifying the PaX settings

Peter Busser has written a regression test suite called paxtest. This
tool will check various cases of possible attack vectors and inform you
of the result. When you run it, it will leave a logfile called
paxtest.log in the current working directory.

    # paxtest
    Executable anonymous mapping             : Killed
    Executable bss                           : Killed
    Executable data                          : Killed
    Executable heap                          : Killed
    Executable stack                         : Killed
    Executable anonymous mapping (mprotect)  : Killed
    Executable bss (mprotect)                : Killed
    Executable data (mprotect)               : Killed
    Executable heap (mprotect)               : Killed
    Executable stack (mprotect)              : Killed
    Executable shared library bss (mprotect) : Killed
    Executable shared library data (mprotect): Killed
    Writable text segments                   : Killed
    Anonymous mapping randomisation test     : 16 bits (guessed)
    Heap randomisation test (ET_EXEC)        : 13 bits (guessed)
    Heap randomisation test (ET_DYN)         : 25 bits (guessed)
    Main executable randomisation (ET_EXEC)  : 16 bits (guessed)
    Main executable randomisation (ET_DYN)   : 17 bits (guessed)
    Shared library randomisation test        : 16 bits (guessed)
    Stack randomisation test (SEGMEXEC)      : 23 bits (guessed)
    Stack randomisation test (PAGEEXEC)      : No randomisation
    Return to function (strcpy)              : Vulnerable
    Return to function (memcpy)              : Vulnerable
    Return to function (strcpy, RANDEXEC)    : Killed
    Return to function (memcpy, RANDEXEC)    : Killed
    Executable shared library bss            : Killed
    Executable shared library data           : Killed

In the above example run you notice that:

-   strcpy and memcpy are listed as Vulnerable. This is expected and
    normal - it is simply showing the need for a technology such as
    ProPolice/SSP
-   there is no randomization for PAGEEXEC. This is normal since our
    recommended x86 kernel configuration did not activate the PAGEEXEC
    setting. However, on arches that support a true NX (non-executable)
    bit (most of them do, including x86_64), PAGEEXEC is the only method
    available for NOEXEC and has no performance hit.

Other features
--------------

> Filesystem protection

Fighting chroot and filesystem abuse

Grsecurity includes many patches that prohibits users from gaining
unnecessary knowledge about the system. This includes restrictions on
/proc usage, chrooting, linking, etc.

Kernel configuration

We recommend the following grsecurity kernel configuration for
filesystem protection:

    #
    # Filesystem Protections
    #
    CONFIG_GRKERNSEC_PROC=y
    # CONFIG_GRKERNSEC_PROC_USER is not set
    CONFIG_GRKERNSEC_PROC_USERGROUP=y
    CONFIG_GRKERNSEC_PROC_GID=3
    CONFIG_GRKERNSEC_PROC_ADD=y
    CONFIG_GRKERNSEC_LINK=y
    CONFIG_GRKERNSEC_FIFO=y
    CONFIG_GRKERNSEC_CHROOT=y
    CONFIG_GRKERNSEC_CHROOT_MOUNT=y
    CONFIG_GRKERNSEC_CHROOT_DOUBLE=y
    CONFIG_GRKERNSEC_CHROOT_PIVOT=y
    CONFIG_GRKERNSEC_CHROOT_CHDIR=y
    CONFIG_GRKERNSEC_CHROOT_CHMOD=y
    CONFIG_GRKERNSEC_CHROOT_FCHDIR=y
    CONFIG_GRKERNSEC_CHROOT_MKNOD=y
    CONFIG_GRKERNSEC_CHROOT_SHMAT=y
    CONFIG_GRKERNSEC_CHROOT_UNIX=y
    CONFIG_GRKERNSEC_CHROOT_FINDTASK=y
    CONFIG_GRKERNSEC_CHROOT_NICE=y
    CONFIG_GRKERNSEC_CHROOT_SYSCTL=y
    CONFIG_GRKERNSEC_CHROOT_CAPS=y

Triggering the Security Mechanism

When you are using a kernel compiled with the above (or similar)
settings, you will get the option to enable/disable many of the options
through the /proc filesystem or via sysctl.

The example below shows an excerpt of a typical
/etc/sysctl.d/10-grsecurity.conf.

    kernel.grsecurity.chroot_deny_sysctl = 1
    kernel.grsecurity.chroot_caps = 1
    kernel.grsecurity.chroot_execlog = 0
    kernel.grsecurity.chroot_restrict_nice = 1
    kernel.grsecurity.chroot_deny_mknod = 1
    kernel.grsecurity.chroot_deny_chmod = 1
    kernel.grsecurity.chroot_enforce_chdir = 1
    kernel.grsecurity.chroot_deny_pivot = 1
    kernel.grsecurity.chroot_deny_chroot = 1
    kernel.grsecurity.chroot_deny_fchdir = 1
    kernel.grsecurity.chroot_deny_mount = 1
    kernel.grsecurity.chroot_deny_unix = 1
    kernel.grsecurity.chroot_deny_shmat = 1

You can enable or disable settings at will using the sysctl command:

    (Toggling the exec_logging feature ON)
    # sysctl -w kernel.grsecurity.exec_logging = 1
    (Toggling the exec_logging feature OFF)
    # sysctl -w kernel.grsecurity.exec_logging = 0

There is a very important sysctl setting pertaining to grsecurity,
namely kernel.grsecurity.grsec_lock. When set, you are not able to
change any setting anymore.

    # sysctl -w kernel.grsecurity.grsec_lock = 1

> Kernel auditing

Extend your system's logging facilities

grsecurity adds extra functionality to the kernel pertaining the
logging. With grsecurity's Kernel Auditing the kernel informs you when
applications are started, devices (un)mounted, etc.

The various Kernel Audit Settings

The following kernel configuration section can be used to enable
grsecurity's Kernel Audit Settings:

    #
    # Kernel Auditing
    #
    # CONFIG_GRKERNSEC_AUDIT_GROUP is not set
    CONFIG_GRKERNSEC_EXECLOG=y
    CONFIG_GRKERNSEC_RESLOG=y
    CONFIG_GRKERNSEC_CHROOT_EXECLOG=y
    CONFIG_GRKERNSEC_AUDIT_CHDIR=y
    CONFIG_GRKERNSEC_AUDIT_MOUNT=y
    CONFIG_GRKERNSEC_AUDIT_IPC=y
    CONFIG_GRKERNSEC_SIGNAL=y
    CONFIG_GRKERNSEC_FORKFAIL=y
    CONFIG_GRKERNSEC_TIME=y
    CONFIG_GRKERNSEC_PROC_IPADDR=y
    CONFIG_GRKERNSEC_AUDIT_TEXTREL=y

Process restrictions

Executable protection

With grsecurity you can restrict executables. Since most exploits work
through one or more running processes this protection can save your
system's health.

Network protection

Linux' TCP/IP stack is vulnerable to prediction-based attacks.
grsecurity includes randomization patches to counter these attacks.
Apart from these you can also enable socket restrictions, disallowing
certain groups network access altogether.

Kernel settings

The following kernel settings enable various executable and network
protections:

    #
    # Executable Protections
    #
    CONFIG_GRKERNSEC_EXECVE=y
    CONFIG_GRKERNSEC_DMESG=y
    CONFIG_GRKERNSEC_RANDPID=y
    CONFIG_GRKERNSEC_TPE=y
    CONFIG_GRKERNSEC_TPE_ALL=y
    CONFIG_GRKERNSEC_TPE_GID=100

    #
    # Network Protections
    #
    CONFIG_GRKERNSEC_RANDNET=y
    CONFIG_GRKERNSEC_RANDISN=y
    CONFIG_GRKERNSEC_RANDID=y
    CONFIG_GRKERNSEC_RANDSRC=y
    CONFIG_GRKERNSEC_RANDRPC=y
    # CONFIG_GRKERNSEC_SOCKET is not set

Using linux-pax-flags AUR package
---------------------------------

The linux-pax-flags program is what makes using PaX on Arch Linux easy
as pie. When you run this program it will set the PaX flags for all the
problematic programs for you. However, if you use some uncommon program
it may have problems forcing you to set the paxctl flags yourself. You
will most likely see something like Denied RWX in journalctl. That means
you will need to disable MPROTECT for the program
paxctl -cPEmRXS /usr/bin/bla

After you find what PaX flags need to be set post a comment on the
linux-pax-flags AUR package so it can be added.

More extensive documentation of the linux-pax-flags utility is to be
found on its man page.

Tips and tricks
---------------

Because you will not be able to change the PaX flags for a running
program, and that the vast majority of programs which would need them
are graphical, it is strongly advisable to not use a Graphical Login
like GDM or KDM. Instead simply have the system drop you to a console to
log in and use startx. Then you will have a chance to set the PaX flags
before anything starts. For the same reasons it is strongly advisable to
update your system and run linux-pax-flags right after boot, before
running startx.

Grsecurity will harden /proc and /sys so your normal user will no longer
be able to see the network status, because of this none of your desktop
network monitors will work. Instead just install terminal based
monitoring programs, such as nmon or nload and run them as root, or as a
user in the proc-trusted group.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Grsecurity&oldid=298546"

Categories:

-   Kernel
-   Security

-   This page was last modified on 17 February 2014, at 12:52.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
