Install on windows by CoLinux
=============================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Arch and coLinux                                                   |
| -   2 The image build steps (for expert users)                           |
|     -   2.1 1. Download required files                                   |
|     -   2.2 2. Get newarch script                                        |
|     -   2.3 3. Run debian system and mount windows c:\colinux directory  |
|         as /mnt/win                                                      |
|     -   2.4 4. Using the new arch.fs to boot                             |
|     -   2.5 5. Modify fstab                                              |
|                                                                          |
| -   3 Building a Minimal Image (optional)                                |
+--------------------------------------------------------------------------+

Arch and coLinux
----------------

Note: The new image described here is a few years old

The previous 0.7.x Arch Linux image doesn't work, because Arch Linux
changed the name of the 'current' repository to 'core'. I've build a new
image for CoLinux. All you need to do is download the co.7z batch file.
ref: http://web.twpda.com/colinux .

Install method:

    co arch 1 

Daily usage:

    co arch

Or, you can download the images directly from
http://web.twpda.com/colinux.

The image build steps (for expert users)
----------------------------------------

Using Remote Arch Linux Install and an existing Debian image I built an
Arch Linux 0.8.0 base ext3 filesystem. I put the method to build Arch
Linux image here. (The newest image is in co.7z) (Note: arch.cmd is the
same as co.cmd, which is in the co.7z archive, linked in the previous
section)

Build Arch Linux on Colinux From Debian

-   colinux 0.8.0 (devel-coLinux-20080120.exe)
-   archlinux 2007.08-2 (Archlinux-i686-2007.08-2.ftp.iso)
-   Debian 4.0r0 (Debian-4.0r0-etch.ext3.1gb)

1. Download required files

-   On sf.net's colinux download page
    -   colinux 0.8.0
    -   Debian-4.0r0.ext3-etch.ext3.1gb.bz2

-   Install colinux 0.8.0
-   Download fs_256Mb.bz2 blank ext3 file system:
    http://gniarf.nerim.net/colinux/fs
-   Download swap_64Mb.bz2: http://gniarf.nerim.net/colinux/swap/
-   Extract all *.bz2 file into colinux's directory (can use 7-zip to
    extract)

PS. This step could complete by following command.(wget & 7-zip
required)

    arch.cmd deb 1	  

2. Get newarch script

Reference: Quick Custom Installation

Use copy and paste method to create pacman.conf, newarch in c:\colinux
(Must be Unix line feed format)

3. Run debian system and mount windows c:\colinux directory as /mnt/win

Run deb.cmd under windows cmd window

    C:> arch.cmd deb

    apt-get install wget
    mkdir -p /mnt/win /mnt/arch
    mount -t cofs cofs1:/ /mnt/win
    cd /mnt/win/colinux/
    # arch.fs is thd file downloaded from http://gniarf.nerim.net/colinux/fs
    # mke2fs -j arch.fs  # using ext3 format, if the arch.fs is not formated by ext3
    mount -o loop arch.fs /mnt/arch/
    ./newarch  # answer y, y, n (don't need to make tar.gz file)

4. Using the new arch.fs to boot

Copy deb.cmd to arch.cmd and change every word DEB to ARCH, deb to arch.

    colinux-daemon -t nt kernel=vmlinux mem=%MEM% initrd=initrd.gz hda1=arch.fs hda2=arch.swap cofs1=c:\ root=/dev/hda1 eth0=slirp,,tcp:22:22/tcp:5000:5000

Run arch.cmd under windows cmd window

    C:> arch.cmd arch

Under colinux box:

    # nano -w /etc/rc.conf

Change the 'eth0' line as following:

    eth0=dhcp

To access the network via slirp's dhcp method:

    # /etc/rc.d/network restart

5. Modify fstab

    # mkdir -p /mnt/win
    # vi /etc/fstab

Append the following lines:

    /dev/hda1      /        ext3     noatime         1       1
    /dev/hda2      none     swap     defaults        0       0
    cofs1:/	       /mnt/win cofs     noauto          0       0

Here we let /dev/hda1 do auto fsck that may cause first time boot fail.
But, just continue, and try booting again, it will success.

Building a Minimal Image (optional)
-----------------------------------

1. Reduce the disk usage in fs.from by removing useless packages.

1.1 Boot from arch.fs

1.2 Try to remove most BASE packages:

    mkdir /mnt/win
    mount -t cofs cofs1:/ /mnt/win
    cd /mnt/win/colinux
    ./reduce.sh
    # edit reqpkg.txt if some dependency failed

1.3 Power off

2. Boot from debian, copy arch.fs to arch_to.fs

2.1 In windows create new empty file system as arch_to.fs

2.2 In debian box:

    mkdir -p /mnt/arch /mnt/arch_to
    cd /mnt/win/colinux
    mount -o loop arch.fs /mnt/arch
    mount -o loop arch_to.fs /mnt/arch_to
    ./clean.sh  # remove some log files in arch.fs
    cp -rdp /mnt/arch/* /mnt/arch_to

Retrieved from
"https://wiki.archlinux.org/index.php?title=Install_on_windows_by_CoLinux&oldid=204823"

Category:

-   Getting and installing Arch
