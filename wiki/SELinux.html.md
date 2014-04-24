SELinux
=======

Related articles

-   Security
-   AppArmor

Security-Enhanced Linux (SELinux) is a Linux feature that provides a
variety of security policies, including U.S. Department of Defense style
mandatory access controls (MAC), through the use of Linux Security
Modules (LSM) in the Linux kernel. It is not a Linux distribution, but
rather a set of modifications that can be applied to Unix-like operating
systems, such as Linux and BSD.

Running SELinux under a Linux distribution requires three things: An
SELinux enabled kernel, SELinux Userspace tools and libraries, and
SELinux Policies (mostly based on the Reference Policy). Some common
Linux programs will also need to be patched/compiled with SELinux
features.

Contents
--------

-   1 Current status in Arch Linux
-   2 Concepts: Mandatory Access Controls
-   3 Installing SELinux
    -   3.1 Package description
        -   3.1.1 SELinux aware system utilities
        -   3.1.2 SELinux userspace utilities
        -   3.1.3 SELinux policy packages
        -   3.1.4 Other SELinux tools
    -   3.2 Installation
        -   3.2.1 Via Unofficial Repository
        -   3.2.2 Via AUR
    -   3.3 Changing boot loader configuration
        -   3.3.1 GRUB
        -   3.3.2 Syslinux
    -   3.4 Checking PAM
    -   3.5 Installing a policy
-   4 Post-installation steps
    -   4.1 Swapfiles
-   5 Working with SELinux
-   6 Troubleshooting
    -   6.1 Useful tools
-   7 See also

Current status in Arch Linux
----------------------------

Current status of those elements in Arch Linux:

  Name                                    Status                                                                Available at
  --------------------------------------- --------------------------------------------------------------------- --------------------------------------------------------
  SELinux enabled kernel                  Implemented                                                           Available in 3.13 official Arch kernel
  SELinux Userspace tools and libraries   Work in progress: https://aur.archlinux.org/packages/?O=0&K=selinux   Work is done at https://github.com/Siosm/siosm-selinux
  SELinux Policy                          Work in progress, will probably be named selinux-policy-arch          No working repository for now.

Summary of changes in AUR as compared to official core packages:

  Name            Status and comments
  --------------- ----------------------------------------------------------------------------------------------------------------------------------------------------------------
  linux-selinux   Deprecated. SELinux support now comes built-in to the official kernel package
  coreutils       Need a rebuild to link with libselinux
  cronie          Need a rebuild with --with-selinux flag
  findutils       Need SELinux patch, already upstream
  openssh         Need a rebuild with --with-selinux flag
  pam             Need a rebuild with --enable-selinux flag for Linux-PAM ; Need a patch for pam_unix2, which only removes a function already implemented in a library elsewhere
  pambase         Configuration changes to add pam_selinux.so
  psmisc          Need a patch, already upstream. Will be in version 22.21
  shadow          Need a rebuild with -lselinux and --with-selinux flags
  sudo            Need a rebuild with --enable-selinux flag
  systemd         Need a rebuild with --enable-selinux flag
  util-linux      Need a rebuild with --enable-selinux flag

All of the other SELinux-related packages may be included without risks.

Concepts: Mandatory Access Controls
-----------------------------------

Note:This section is meant for beginners. If you know what SELinux does
and how it works, feel free to skip ahead to the installation.

Before you enable SELinux, it is worth understanding what it does.
Simply and succinctly, SELinux enforces Mandatory Access Controls (MACs)
on Linux. In contrast to SELinux, the traditional user/group/rwx
permissions are a form of Discretionary Access Control (DAC). MACs are
different from DACs because security policy and its execution are
completely separated.

An example would be the use of the sudo command. When DACs are enforced,
sudo allows temporary privilege escalation to root, giving the process
so spawned unrestricted systemwide access. However, when using MACs, if
the security administrator deems the process to have access only to a
certain set of files, then no matter what the kind of privilege
escalation used, unless the security policy itself is changed, the
process will remain constrained to simply that set of files. So if sudo
is tried on a machine with SELinux running in order for a process to
gain access to files its policy does not allow, it will fail.

Another set of examples are the traditional (-rwxr-xr-x) type
permissions given to files. When under DAC, these are user-modifiable.
However, under MAC, a security administrator can choose to freeze the
permissions of a certain file by which it would become impossible for
any user to change these permissions until the policy regarding that
file is changed.

As you may imagine, this is particularly useful for processes which have
the potential to be compromised, i.e. web servers and the like. If DACs
are used, then there is a particularly good chance of havoc being
wrecked by a compromised program which has access to privilege
escalation.

For further information, do visit the MAC Wikipedia page.

Installing SELinux
------------------

> Package description

All SELinux related packages belong to the selinux group in the AUR as
well as in Siosm's unofficial repository.

SELinux aware system utilities

 coreutils-selinux 
    Modified coreutils package compiled with SELinux support enabled. It
    replaces the coreutils package

 selinux-flex 
    Flex version needed only to build checkpolicy. The normal flex
    package causes a failure in the checkmodule command. It replaces the
    flex package.

 pam-selinux and pambase-selinux 
    PAM package with pam_selinux.so. and the underlying base package.
    They replace the pam and pambase packages respectively.

 systemd-selinux 
    An SELinux aware version of Systemd. It replaces the systemd
    package.

 util-linux-selinux 
    Modified util-linux package compiled with SELinux support enabled.
    It replaces the util-linux package.

 findutils-selinux 
    Patched findutils package compiled with SELinux support to make
    searching of files with specified security context possible. It
    replaces the findutils package.

 sudo-selinux 
    Modified sudo package compiled with SELinux support which sets the
    security context correctly. It replaces the sudo package.

 psmisc-selinux 
    Psmisc package compiled with SELinux support; for example, it adds
    the -Z option to killall. It replaces the psmisc package.

 shadow-selinux 
    Shadow package compiled with SELinux support; contains a modified
    /etc/pam.d/login file to set correct security context for user after
    login. It replaces the shadow package.

 cronie-selinux 
    Fedora fork of Vixie cron with SELinux enabled. It replaces the
    cronie package.

 selinux-logrotate 
    Logrotate package compiled with SELinux support. It replaces the
    logrotate package.

 openssh-selinux 
    OpenSSH package compiled with SELinux support to set security
    context for user sessions. It replaces the openssh package.

SELinux userspace utilities

 checkpolicy 
    Tools to build SELinux policy

 libselinux 
    Library for security-aware applications. Python bindings needed for
    semanage and setools now included.

 libsemanage 
    Library for policy management. Python bindings needed for semanage
    and setools now included.

 libsepol 
    Library for binary policy manipulation.

 policycoreutils 
    SELinux core utils such as newrole, setfiles, etc.

 sepolgen 
    A Python library for parsing and modifying policy source.

SELinux policy packages

 selinux-refpolicy 
    Precompiled modular-otherways-vanilla Reference policy with headers
    and documentation but without sources.

 selinux-refpolicy-src 
    Reference policy sources

 selinux-refpolicy-arch 
    Precompiled modular Reference policy with headers and documentation
    but without sources. Development Arch Linux Refpolicy patch
    included, but for now [February 2011] it only fixes some issues with
    /etc/rc.d/* labeling.

Note:The selinux-refpolicy-arch package was last updated in 2011, hence
it seems doubtful that it is useful any longer.

Other SELinux tools

 setools 
    CLI and GUI tools to manage SELinux

> Installation

Only ext2, ext3, ext4, JFS, XFS and BtrFS filesystems are supported to
use SELinux. Since the 3.13 kernel update, the options required for
SELinux to work on any system are enabled in the default kernel
configuration, hence there should be no problems by default. If you are
using a custom kernel, please do make sure that Xattr (Extended
Attributes), CONFIG_AUDIT and CONFIG_SECURITY_SELINUX are enabled in
your config. (Source: Debian Wiki)

Note:If using proprietary drivers, such as NVIDIA graphics drivers, you
may need to rebuild them for custom kernels.

There are two methods to install the requisite SELinux packages.

Via Unofficial Repository

Add the siosm-selinux repository into pacman.conf and add Siosm's key.

Then install the following packages by either using the su - command or
by logging in as root:

-   pambase-selinux
-   pam-selinux
-   coreutils-selinux
-   libsemanage
-   shadow-selinux
-   libcgroup
-   policycoreutils
-   cronie-selinux
-   findutils-selinux
-   selinux-flex
-   selinux-logrotate
-   openssh-selinux
-   psmisc-selinux
-   python2-ipy
-   setools
-   systemd-selinux

Warning:Do not use the sudo command to install these packages. This is
because pam, which is used for sudo authentication, is being replaced.

Via AUR

A lot of credit for this section must go to jamesthebard for his
outstanding work and documentation.

The first install needs to be of pambase-selinux and pam-selinux.
However, do not use yaourt -S selinux-pam selinux-pambase or use sudo
after building to install the package. This is because pam is what
handles authentication. Hence, it is best if the packages are built as
an ordinary user using makepkg and installed by root using a simple
pacman -U <packagename>.

Next, you need to build and install coreutils-selinux, libsemanage,
shadow-selinux, libcgroup, policycoreutils, cronie-selinux,
findutils-selinux, selinux-flex, selinux-logrotate, openssh-selinux and
psmisc-selinux from the AUR and python2-ipy from the community
repository.

Tip:The openssh-selinux package needs to be built in a gui environment
else it fails in the pairs.sh test during compilation.

Now comes the setools package. For this, do make sure that you have the
jdk7-openjdk package installed, in order for the JAVA_HOME variable to
be set properly. If it still isn't even after installing the package,
run:

    $ export JAVA_HOME=/usr/lib/jvm/java-7-openjdk

Next, backup your /etc/sudoers file. Install sudo-selinux, checkpolicy,
util-linux-selinux and systemd-selinux

> Changing boot loader configuration

If you've installed a new kernel, make sure that you update your
bootloader accordingly

GRUB

Run the following command:

    # grub-mkconfig -o /boot/grub/grub.cfg

Syslinux

Change your syslinux.cfg file by adding:

    /boot/syslinux/syslinux.cfg

    LABEL arch-selinux
             LINUX ../vmlinuz-linux-selinux
             APPEND root=/dev/sda2 ro
             INITRD ../initramfs-linux-selinux.img

at the end. Change "linux-selinux" to whatever kernel you are using.

> Checking PAM

A correctly set-up PAM is important to get the proper security context
after login. Check for the presence of the following lines in
/etc/pam.d/system-login:

    # pam_selinux.so close should be the first session rule
    session         required        pam_selinux.so close

    # pam_selinux.so open should only be followed by sessions to be executed in the user context
    session         required        pam_selinux.so open

> Installing a policy

Warning:The reference policy as given by Tresys is not very good for
Arch Linux, as almost no file is labelled correctly. However, as of
writing, Archers have no other choice. If anyone has made any
significant strides in addressing this problem, they are encouraged to
share it, preferably on the AUR.

Policies are the mainstay of SELinux. They are what govern its
behaviour. The only policy currently available in the AUR is the
Reference Policy. In order to install it, you should use the source
files, which may be got from the package selinux-refpolicy-src. Change
the pkgver to 20130424 and the sha256sums to
6039ba854f244a39dc727cc7db25632f7b933bb271c803772d754d4354f5aef4 and
build the file. Now, navigate to /etc/selinux/refpolicy/src/policy and
run the following commands:

    # make bare
    # make conf
    # make install

to install the reference policy as it is. Those who know how to write
SELinux policies can tweak them to their heart's content before running
the commands written above. The command takes a while to do its job and
taxes one core of your system completely, so don't worry. Just sit back
and let the command run for as long as it takes.

Then, make the file /etc/selinux/config with the following contents
(Only works if you used the defaults as mentioned above. If you decided
to change the name of the policy, you need to tweak the file):

    /etc/selinux/config

    # This file controls the state of SELinux on the system.
    # SELINUX= can take one of these three values:
    #       enforcing - SELinux security policy is enforced.
    #                   Set this value once you know for sure that SELinux is configured the way you like it and that your system is ready for deployment
    #       permissive - SELinux prints warnings instead of enforcing.
    #                    Use this to customise your SELinux policies and booleans prior to deployment. Recommended during policy development.
    #       disabled - No SELinux policy is loaded.
    #                  This is not a recommended setting, for it may cause problems with file labelling
    SELINUX=permissive
    # SELINUXTYPE= takes the name of SELinux policy to
    # be used. Current options are:
    #       refpolicy (vanilla reference policy)
    #       <custompolicy> - Substitute <custompolicy> with the name of any custom policy you choose to load
    SELINUXTYPE=refpolicy

Now, you may reboot. After rebooting, run:

    # restorecon -r /

to label your filesystem.

Now, make a file requiredmod.te with the contents:

    requiredmod.te

    module requiredmod 1.0;

    require {
            type devpts_t;
            type kernel_t;
            type device_t;
            type var_run_t;
            type udev_t;
            type hugetlbfs_t;
            type udev_tbl_t;
            type tmpfs_t;
            class sock_file write;
            class unix_stream_socket { read write ioctl };
            class capability2 block_suspend;
            class dir { write add_name };
            class filesystem associate;
    }

    #============= devpts_t ==============
    allow devpts_t device_t:filesystem associate;

    #============= hugetlbfs_t ==============
    allow hugetlbfs_t device_t:filesystem associate;

    #============= kernel_t ==============
    allow kernel_t self:capability2 block_suspend;

    #============= tmpfs_t ==============
    allow tmpfs_t device_t:filesystem associate;

    #============= udev_t ==============
    allow udev_t kernel_t:unix_stream_socket { read write ioctl };
    allow udev_t udev_tbl_t:dir { write add_name };
    allow udev_t var_run_t:sock_file write;

and run the following commands:

    # checkmodule -m -o requiredmod.mod requiredmod.te
    # semodule_package -o requiredmod.pp -m requiredmod.mod
    # semodule -i requiredmod.pp

This is required to remove a few messages from /var/log/audit/audit.log
which are a nuisance to deal with in the reference policy. This is an
ugly hack and it should be made very clear that the policy so installed
simply patches the reference policy in order to hide the effects of
incorrect labelling.

Post-installation steps
-----------------------

You can check that SELinux is working with sestatus. You should get
something like:

    SELinux status:                 enabled
    SELinuxfs mount:                /sys/fs/selinux
    SELinux root directory:         /etc/selinux
    Loaded policy name:             refpolicy
    Current mode:                   permissive
    Mode from config file:          permissive
    Policy MLS status:              disabled
    Policy deny_unknown status:     allowed
    Max kernel policy version:      28

To maintain correct context, you can use restorecond:

    # systemctl enable restorecond

To switch to enforcing mode without rebooting, you can use:

    # echo 1 > /sys/fs/selinux/enforce

> Swapfiles

If you have a swap file instead of a swap partition, issue the following
commands in order to set the appropriate security context:

    # semanage fcontext -a -t swapfile_t "/path/to/swapfile"
    # restorecon /path/to/swapfile

Working with SELinux
--------------------

SELinux defines security using a different mechanism than traditional
Unix access controls. The best way to understand it is by example. For
example, the SELinux security context of the apache homepage looks like
the following:

    $ls -lZ /var/www/html/index.html
    -rw-r--r--  username username system_u:object_r:httpd_sys_content_t /var/www/html/index.html

The first three and the last columns should be familiar to any (Arch)
Linux user. The fourth column is new and has the format:

    user:role:type[:level]

To explain:

1.  User: The SELinux user identity. This can be associated to one or
    more roles that the SELinux user is allowed to use.
2.  Role: The SELinux role. This can be associated to one or more types
    the SELinux user is allowed to access.
3.  Type: When a type is associated with a process, it defines what
    processes (or domains) the SELinux user (the subject) can access.
    When a type is associated with an object, it defines what access
    permissions the SELinux user has to that object.
4.  Level: This optional field can also be know as a range and is only
    present if the policy supports MCS or MLS.

This is important in case you wish to understand how to build your own
policies, for these are the basic building blocks of SELinux. However,
for most purposes, there is no need to, for the reference policy is
sufficiently mature. However, if you are a power user or someone with
very specific needs, then it might be ideal for you to learn how to make
your own SELinux policies.

This is a great series of articles for someone seeking to understand how
to work with SELinux.

Troubleshooting
---------------

The place to look for SELinux errors is the systemd journal. In order to
see SELinux messages related to the label
system_u:system_r:policykit_t:s0 (for example), you would need to run:

    # journalctl _SELINUX_CONTEXT=system_u:system_r:policykit_t:s0

> Useful tools

There are some tools/commands that can greatly help with SELinux.

restorecon
    Restores the context of a file/directory (or recursively with -R)
    based on any policy rules
chcon
    Change the context on a specific file

See also
--------

-   Security Enhanced Linux
-   Gentoo SELinux Handbook
-   Fedora Project's SELinux Wiki
-   NSA's Official SELinux Homepage
-   Reference Policy Homepage
-   SELinux Userspace Homepage
-   SETools Homepage

Retrieved from
"https://wiki.archlinux.org/index.php?title=SELinux&oldid=305933"

Categories:

-   Security
-   Kernel

-   This page was last modified on 20 March 2014, at 17:29.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
