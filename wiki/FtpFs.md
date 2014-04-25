FtpFs
=====

From Wikipedia:

"FTPFS (File Transfer Protocol FileSystem) is an obsoleted Linux kernel
module that allows the user to mount a FTP server onto the local
filesystem".

The old implementation (ftpfs) was replaced by LUFS (UserLand
FileSystem), which in turn was made obsolete by FUSE (Filesystem in
Userspace).

Two ftpfs implementations exist today: fuseftp and lufis/ftpfs. Fuseftp
is quite unusable IMO, and lufis is not supported by Arch Linux -- but
it is possible to make it work.

Note: the recommended way to mount ftp is with curlftpfs.

Contents
--------

-   1 Fuseftp
    -   1.1 Installation
    -   1.2 Usage example
-   2 LUFIS / ftpfs
    -   2.1 To install
    -   2.2 Usage example

Fuseftp
-------

Fuseftp is a FTP filesystem written in Perl, based on FUSE.

> Installation

You can get it from the AUR. It's useful to install the dependencies
with CPAN.

> Usage example

Mount:

    # fuseftp /mnt/ftp_local/ ftp.example.com  --cache=memory --passive

Unmount:

    # fusermount -u /mnt/ftp_local

Refer to the Fuseftp website for more examples and information.

LUFIS / ftpfs
-------------

To use LUFS modules with 2.6x kernel, You will need a bridge called
LUFIS.

> To install

-   Get LUFS tar.gz
-   ./configure, make, make install
-   Copy the "liblufs-ftpfs.so*" files from MAKEDIR/filesystems/ftpfs to
    /usr/lib
-   Install fuse (pacman -S fuse)
-   Get LUFIS tar.gz
-   ./configure, make, then copy lufis to /usr/bin

> Usage example

Mount:

    # lufis fs=ftpfs,host=ftp.exaple.com,username=USERNAME,password=ABCD /mnt/ftp_local/ -s

Unmount:

    # fusermount -u /mnt/ftp_local

Retrieved from
"https://wiki.archlinux.org/index.php?title=FtpFs&oldid=225276"

Category:

-   File systems

-   This page was last modified on 26 September 2012, at 17:08.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
