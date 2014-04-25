Ufsd
====

Ufsd is a closed-source driver for Microsoft's NTFS file system that
includes read and write support, developed by Paragon GmbH. It is
currently (as of 29-Aug, 2013) free for personal use. It offers
significantly faster writes to ntfs filesystems than the default ntfs-3g
driver. This document will describe how to setup ufsd to work on your
computer.

Contents
--------

-   1 Installation
    -   1.1 Without dkms
    -   1.2 With dkms
-   2 Usage
    -   2.1 Manual
    -   2.2 Automatic
-   3 See also

Installation
------------

You can setup ufsd with or without dkms. The advantage of using dkms is
that you wont need to bother about rebuilding and reinstalling every
time the kernel changes. See Dynamic Kernel Module Support for more
details on dkms.

> Without dkms

-   Download the ufsd-module tarball from the AUR.
-   Untar the tarball
-   Visit
    http://www.paragon-software.com/home/ntfs-linux-per/download.html
    and fill in the request form. You should receive an email with a
    download link shortly. Download the .tbz file and move it to the
    package folder.
-   Build and install the package

    $ makepkg -si

Note:You will need to rebuild and reinstall after a kernel upgrade.

> With dkms

-   Install the dkms package, found in the official repositories
-   Start and enable the dkms service

    # systemctl start dkms.service
    # systemctl enable dkms.service

-   Download the ufsd-module-dkms tarball from the AUR.
-   Untar the tarball
-   Visit
    http://www.paragon-software.com/home/ntfs-linux-per/download.html
    and fill in the request form. You should receive an email with a
    download link shortly. Download the .tbz file and move it to the
    package folder.
-   Build and install the package

    $ makepkg -si

-   Check if the module has been installed in dkms.

    $ dkms status

Usage
-----

Test using the manual method before setting it up for automatic loading
and mounting. Remember to create the target folder before mounting. And,
also remember to unmount your ntfs partition if it is already mounted
using ntfs-3g.

> Manual

    # modprobe ufsd
    # mount -t ufsd /dev/your-NTFS-partition /{mnt,...}/folder -o uid=your username,gid=users

> Automatic

For non-dkms setups, edit /etc/fstab as below:

    # <file system>   <dir>		<type>    <options>             <dump>  <pass>
    /dev/NTFS-part  /mnt/windows  ufsd   uid=your username,gid=users,noatime,umask=0222	0 0

For dkms setups, edit /etc/fstab as below:

    # <file system>   <dir>		<type>    <options>             <dump>  <pass>
    /dev/NTFS-part  /mnt/windows  ufsd   noauto,x-systemd.automount,uid=your username,gid=users,noatime,umask=0222	0 0

To load the ufsd driver at startup, create a *.conf file (e.g.
ufsd.conf) in /etc/modules-load.d that contains all modules that should
be loaded:

    /etc/modules-load.d/ufsd.conf

    ufsd

Note:You may need to update the kernel modules db in order to avoid 'no
such file or directory' error when loading ufsd. Run: depmod -a.

See also
--------

-   Ufsd options

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ufsd&oldid=273411"

Category:

-   File systems

-   This page was last modified on 1 September 2013, at 04:20.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
