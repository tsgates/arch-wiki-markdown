KVM
===

Related articles

-   QEMU
-   Libvirt
-   VirtualBox
-   Xen
-   VMware

KVM, Kernel-based Virtual Machine, is a hypervisor built into the Linux
kernel. It is similar to Xen in purpose but much simpler to get running.
Unlike native QEMU, which uses emulation, KVM is a special operating
mode of QEMU that uses CPU extensions (HVM) for virtualization via a
kernel module.

Using KVM, one can run multiple virtual machines running unmodified
GNU/Linux, Windows, or any other operating system. (See Guest Support
Status for more information.) Each virtual machine has private
virtualized hardware: a network card, disk, graphics card, etc.

Differences between KVM and Xen, VMware, or QEMU can be found at the KVM
FAQ.

This article does not cover features common to multiple emulators using
KVM as a backend. You should see related articles for such information.

Contents
--------

-   1 Checking support for KVM
    -   1.1 Hardware support
    -   1.2 Kernel support
    -   1.3 Loading kernel modules
-   2 How to use KVM
-   3 Tips and tricks
    -   3.1 Nested virtualization
    -   3.2 Poor Man's Networking
    -   3.3 Enabling huge pages
-   4 See also

Checking support for KVM
------------------------

> Hardware support

KVM requires that the virtual machine host's processor has
virtualization support (named VT-x for Intel processors and AMD-V for
AMD processors). You can check whether your processor supports hardware
virtualization with the following command:

    $ lscpu

Your processor supports virtualization only if there is a line telling
you so.

You can also run:

    $ grep -E "(vmx|svm|0xc0f)" --color=always /proc/cpuinfo

If nothing is displayed after running that command, then your processor
does not support hardware virtualization, and you will not be able to
use KVM.

Note:You may need to enable virtualization support in your BIOS.

> Kernel support

You can check if necessary modules (kvm and one of kvm_amd, kvm_intel)
are available in your kernel with the following command (assuming your
kernel is built with CONFIG_IKCONFIG_PROC):

    $ zgrep CONFIG_KVM /proc/config.gz

Note:Arch Linux kernels provide the appropriate kernel modules to
support KVM.

> Loading kernel modules

You need to load kvm module and one of kvm_amd and kvm_intel depending
on the manufacturer of the VM host's CPU. See Kernel modules#Loading and
Kernel modules#Manual module handling for information about loading
kernel modules.

If modprobing kvm_intel or kvm_amd fails but modprobing kvm succeeds,
(and lscpu claims that hardware acceleration is supported), check your
BIOS settings. Some vendors (especially laptop vendors) disable these
processor extensions by default. To determine whether there's no
hardware support or there is but the extensions are disabled in BIOS,
the output from dmesg after having failed to modprobe will tell.

Note:Newer versions of udev should load these modules automatically, so
manual intervention is not required.

How to use KVM
--------------

See the main article: QEMU.

Tips and tricks
---------------

Note:See QEMU#Tips and tricks and QEMU#Troubleshooting for general tips
and tricks.

> Nested virtualization

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: Is it possible   
                           also with kvm_amd?       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

On host, enable nested feature for kvm_intel:

    # modprobe -r kvm_intel
    # modprobe kvm_intel nested=1

To make it permanent (see Kernel modules#Setting module options):

    /etc/modprobe.d/modprobe.conf

    options kvm_intel nested=1

Verify that feature is activated:

    $ systool -m kvm_intel -v | grep nested

        nested              = "Y"

Run guest VM with following command:

    $ qemu-system-x86_64 -enable-kvm -cpu host

Boot VM and check if vmx flag is present:

    $ grep -E "(vmx|svm)" /proc/cpuinfo

> Poor Man's Networking

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with QEMU.       
                           Notes: This section is   
                           not KVM-specific, it's   
                           generally applicable to  
                           all QEMU VMs. (Discuss)  
  ------------------------ ------------------------ ------------------------

Setting up bridged networking can be a bit of a hassle sometimes. If the
sole purpose of the VM is experimentation, one strategy to connect the
host and the guests is to use SSH tunneling.

The basic steps are as follows:

-   Setup an SSH server in the host OS
-   (optional) Create a designated user used for the tunneling (e.g.
    tunneluser)
-   Install SSH in the VM
-   Setup authentication

See: SSH for the setup of SSH, especially SSH#Forwarding_Other_Ports.

When using the default user network stack, the host is reachable at
address 10.0.2.2.

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: Usage of         
                           /etc/rc.local is         
                           discouraged. This should 
                           be a proper systemd      
                           service file. (Discuss)  
  ------------------------ ------------------------ ------------------------

If everything works and you can SSH into the host, simply add something
like the following to your /etc/rc.local

    # Local SSH Server
    echo "Starting SSH tunnel"
    sudo -u vmuser ssh tunneluser@10.0.2.2 -N -R 2213:127.0.0.1:22 -f
    # Random remote port (e.g. from another VM)
    echo "Starting random tunnel"
    sudo -u vmuser ssh tunneluser@10.0.2.2 -N -L 2345:127.0.0.1:2345 -f

In this example a tunnel is created to the SSH server of the VM and an
arbitrary port of the host is pulled into the VM.

This is a quite basic strategy to do networking with VMs. However, it is
very robust and should be quite sufficient most of the time.

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: Isn't this       
                           option enough? I think   
                           it should have the same  
                           effect:                  
                           -redir tcp:2222:10.0.2.1 
                           5:22                     
                           (it redirects port 2222  
                           from host to             
                           10.0.2.15:22, where      
                           10.0.2.15 is guest's IP  
                           address. (Discuss)       
  ------------------------ ------------------------ ------------------------

> Enabling huge pages

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: With systemd,    
                           hugetlbfs is mounted on  
                           /dev/hugepages by        
                           default, but with mode   
                           0755 and root's uid and  
                           gid. (Discuss)           
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with QEMU.       
                           Notes: qemu-kvm no       
                           longer exists as all of  
                           its features have been   
                           merged into qemu. After  
                           the above issue is       
                           cleared, I suggest       
                           merging this section     
                           into QEMU. (Discuss)     
  ------------------------ ------------------------ ------------------------

You may also want to enable hugepages to improve the performance of your
virtual machine. With an up to date Arch Linux and a running KVM you
probably already have everything you need. Check if you have the
directory /dev/hugepages. If not, create it. Now we need the right
permissions to use this directory.

Add to your /etc/fstab:

    hugetlbfs       /dev/hugepages  hugetlbfs       mode=1770,gid=78        0 0

Of course the gid must match that of the kvm group. The mode of 1770
allows anyone in the group to create files but not unlink or rename each
other's files. Make sure /dev/hugepages is mounted properly:

    # umount /dev/hugepages
    # mount /dev/hugepages
    $ mount | grep huge

    hugetlbfs on /dev/hugepages type hugetlbfs (rw,relatime,mode=1770,gid=78)

Now you can calculate how many hugepages you need. Check how large your
hugepages are:

    $ grep Hugepagesize /proc/meminfo

Normally that should be 2048 kB ≙ 2 MB. Let's say you want to run your
virtual machine with 1024 MB. 1024 / 2 = 512. Add a few extra so we can
round this up to 550. Now tell your machine how many hugepages you want:

    # echo 550 > /proc/sys/vm/nr_hugepages

If you had enough free memory you should see:

    $ grep HugePages_Total /proc/meminfo 

    HugesPages_Total:  550

If the number is smaller, close some applications or start your virtual
machine with less memory (number_of_pages x 2):

    $ qemu-system-x86_64 -enable-kvm -m 1024 -mem-path /dev/hugepages -hda <disk_image> [...]

Note the -mem-path parameter. This will make use of the hugepages.

Now you can check, while your virtual machine is running, how many pages
are used:

    $ grep HugePages /proc/meminfo 

    HugePages_Total:     550
    HugePages_Free:       48
    HugePages_Rsvd:        6
    HugePages_Surp:        0

Now that everything seems to work you can enable hugepages by default if
you like. Add to your /etc/sysctl.d/40-hugepage.conf:

    vm.nr_hugepages = 550

See also:

-   https://www.kernel.org/doc/Documentation/vm/hugetlbpage.txt
-   http://wiki.debian.org/Hugepages
-   http://www.linux-kvm.com/content/get-performance-boost-backing-your-kvm-guest-hugetlbfs

See also
--------

-   KVM Howto
-   KVM FAQ

Retrieved from
"https://wiki.archlinux.org/index.php?title=KVM&oldid=293926"

Categories:

-   Virtualization
-   Kernel

-   This page was last modified on 22 January 2014, at 09:47.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
