libvirt
=======

Summary

This article does not try to cover everything about libvirt, just the
things that were not intuitive at first or not well documented.

Related

QEMU

KVM

VirtualBox

Xen

VMware

libvirt is a virtualization API and a daemon for managing virtual
machines (VMs) -- remote or locally, using multiple virtualization
back-ends (QEMU/KVM, VirtualBox, Xen, etc).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing                                                         |
|     -   1.1 Building libvirt for Xen                                     |
|                                                                          |
| -   2 Configuration                                                      |
|     -   2.1 Run daemon                                                   |
|     -   2.2 PolicyKit authorization                                      |
|     -   2.3 Unix file-based permissions                                  |
|     -   2.4 Enable KVM acceleration for QEMU                             |
|     -   2.5 Stopping / resuming guest at host shutdown / startup         |
|                                                                          |
| -   3 Usage                                                              |
|     -   3.1 Installing a new VM                                          |
|     -   3.2 Creating a storage pool in virt-manager                      |
|     -   3.3 Using VirtualBox with virt-manager                           |
|                                                                          |
| -   4 Remote access to libvirt                                           |
|     -   4.1 Using unencrypted TCP/IP socket (most simple, least secure)  |
|     -   4.2 Using SSH                                                    |
|     -   4.3 Using Python                                                 |
|                                                                          |
| -   5 Bridged Networking                                                 |
|     -   5.1 Host configuration                                           |
|     -   5.2 Guest configuration                                          |
+--------------------------------------------------------------------------+

Installing
----------

For servers you need the following packages from the official Arch Linux
repositories:

-   libvirt
-   urlgrabber (required by virtinst)
-   qemu (optional if not using KVM)
-   dnsmasq (optional)
-   bridge-utils (optional)

For GUI management tools, you also need all of the following from the
official Arch Linux repositories:

-   virtviewer
-   virtinst
-   virt-manager

> Building libvirt for Xen

The PKGBUILD for both libvirt-git in the AUR and libvirt in the official
repositories currently disables Xen support with the --without-xen flag
during the make process. If you want to use libvirt for managing Xen,
you will need to grab the whole file set to enable Xen support and build
your own libvirt package using the Arch Build System. Furthermore, you
need to make sure you have libxenctrl installed. If xen is installed,
you don't need to install libxenctrl.

The alternative XenAPI driver is lacking a package at the moment?
(2010-05-23, friesoft)

Configuration
-------------

> Run daemon

Change default user and group in /etc/libvirt/qemu.conf. QEMU defaults
to nobody:nobody.

Start the libvirtd daemon and enable the libvirt systemd service so it
starts automatically on boot.

Note:The Avahi daemon is used for local discovery of libvirt hosts via
multicast-DNS. To disable this functionality, set mdns_adv = 0 in
/etc/libvirt/libvirtd.conf.

> PolicyKit authorization

To allow a non-root user to manage virtual machines, you need to create
the following file (for polkit >= 0.107 only):

    /etc/polkit-1/rules.d/50-org.libvirt.unix.manage.rules

    polkit.addRule(function(action, subject) {
        if (action.id == "org.libvirt.unix.manage" &&
            subject.user == "<replace with user name>") {
                return polkit.Result.YES;
        }
    });

Alternatively, you can grant only the monitoring rights with
org.libvirt.unix.monitor.

For more information, see the libvirt wiki.

> Unix file-based permissions

Note:This is an alternative to PolicyKit authentication.

If you wish to use Unix file-based permissions to allow some non-root
users to use libvirt, you can modify the configuration files.

First, you will need to create the libvirt group and add any users you
want to have access to libvirt to that group.

    # groupadd libvirt
    # gpasswd -a [username] libvirt

Any users that are currently logged in will need to log out and log back
in to update their groups. Alternatively, the user can use the following
command in the shell they will be launching libvirt from to update the
group:

    $ newgrp libvirt

Uncomment the following lines in /etc/libvirt/libvirtd.conf (they are
not all in the same location in the file):

    /etc/libvirt/libvirtd.conf

     #unix_sock_group = "libvirt"
     #unix_sock_ro_perms = "0777"
     #unix_sock_rw_perms = "0770"
     #auth_unix_ro = "none"
     #auth_unix_rw = "none"

Note:You may also wish to change unix_sock_ro_perms from 0777 to 0770 to
disallow read-only access to people who are not members of the libvirt
group.

> Enable KVM acceleration for QEMU

Note:KVM will conflict with VirtualBox. You cannot use KVM and
VirtualBox at the same time.

Running virtual machines with the usual QEMU emulation (i.e. without
KVM)), will be painfully slow. You definitely want to enable KVM support
if your CPU supports it. To find out, run the following command:

    egrep --color "vmx|svm" /proc/cpuinfo

If that command generates output, then your CPU supports hardware
acceleration via KVM; if that command does not generate output, then you
cannot use KVM.

If KVM is not working, you will find the following message in your
/var/log/libvirt/qemu/VIRTNAME.log:

    /var/log/libvirt/qemu/VIRTNAME.log

     Could not initialize KVM, will disable KVM support

More info is available from the official KVM FAQ

> Stopping / resuming guest at host shutdown / startup

Running guests may be suspended (or shutdown) at host shutdown
automatically using the libvirt-guests service. On the other hand, at
host startup, this same daemon will resume (startup) the suspended
(shutdown) guests automatically. Check /etc/conf.d/libvirtd-guests for
libvirt-guests options.

Usage
-----

> Installing a new VM

To create a new VM, you need some sort of installation media, which is
usually a standard .iso file. Copy it to the /var/lib/libvirt/images/
directory (alternatively, you can create a new storage pool directory in
virt-manager and copy it there).

Note:SELinux requires that virtual machines be stored in
/var/lib/libvirt/images/ by default. If you use SELinux and are having
issues with virtual machines, ensure that your VMs are in that directory
or ensure that you have added the correct labeling to the non-default
directory that you used.

Then run virt-manager, connect to the server, right click on the
connection and choose New. Choose a name, and select Local install
media. Just continue with the wizard.

On the 4th step, you may want to uncheck Allocate entire disk now --
this way you will save space when your VM is not using all of its disk.
However, this can cause increased fragmentation of the disk, and you
must pay attention to the total available disk space on the VM host
because it is much easier to over-allocate disk space to VMs.

On the 5th step, open Advanced options and make sure that Virt Type is
set to kvm. If the kvm choice is not available, see section Enable KVM
acceleration for QEMU above.

> Creating a storage pool in virt-manager

First, connect to an existing server. Once you are there, right click
and choose Details. Go to Storage and press the + icon at the lower
left. Then just follow the wizard. :)

> Using VirtualBox with virt-manager

Note:VirtualBox support in libvirt is not quite stable yet and may cause
your libvirtd to crash. Usually this is harmless and everything will be
back once you restart the daemon.

virt-manager does not let you to add any VirtualBox connections from the
GUI. However, you can launch it from the command line:

    virt-manager -c vbox:///system

Or if you want to manage a remote system over SSH:

    virt-manager -c vbox+ssh://username@host/system

Remote access to libvirt
------------------------

> Using unencrypted TCP/IP socket (most simple, least secure)

Warning:This should only be used for testing or use over a secure,
private, and trusted network.

Edit /etc/libvirt/libvirtd.conf:

    /etc/libvirt/libvirtd.conf

    listen_tls = 0
    listen_tcp = 1
    auth_tcp=none

Warning:We do not enable SASL here, so all TCP traffic is cleartext! For
real world use, always enable SASL.

It is also necessary to start the server in listening mode by editing
/etc/conf.d/libvirtd

    /etc/conf.d/libvirtd

    LIBVIRTD_ARGS="--listen"

> Using SSH

The openbsd-netcat package is needed for remote management over SSH.

To connect to the remote system using virsh:

    $ virsh -c qemu+ssh://username@host/IP address/system

If something goes wrong, you can get some logs using:

    $ LIBVIRT_DEBUG=1 virsh -c qemu+ssh://username@host/IP address/system

To display the graphical console for a virtual machine:

    $ virt-viewer --connect qemu+ssh://username@host/IP address/system myvirtualmachine

To display the virtual machine desktop management tool:

    $ virt-manager -c qemu+ssh://username@host/IP address/system

Note:If you are having problems connecting to a remote RHEL server (or
anything other than Arch, really), try the two workarounds mentioned in
FS#30748 and FS#22068.

> Using Python

The libvirt package comes with a python2 API in
/usr/lib/python2.7/site-packages/libvirt.py

General examples are given in
/usr/share/doc/libvirt-python-your_libvirt_version/examples/

Unofficial example using qemu and openssh:

    #! /usr/bin/env python2
    # -*- coding: utf-8 -*-
    import socket
    import sys
    import libvirt
    if (__name__ == "__main__"):
       conn = libvirt.open("qemu+ssh://xxx/system")
       print "Trying to find node on xxx"
       domains = conn.listDomainsID()
       for domainID in domains:
           domConnect = conn.lookupByID(domainID)
           if domConnect.name() == 'xxx-node':
               print "Found shared node on xxx with ID " + str(domainID)
               domServ = domConnect
               break

Bridged Networking
------------------

To use physical Ethernet from your virtual machines, you have to create
a bridge between your physical Ethernet device (here eth0) and the
virtual Ethernet device the VM is using.

> Host configuration

libvirt creates the bridge virbr0 for NAT networking, so use another
name such as br0 or virbr1. You have to create a new Netcfg Profile to
configure the bridge, for example (with DHCP configuration):

    /etc/network.d/br0

    INTERFACE="br0"
    CONNECTION="bridge"
    DESCRIPTION="KVM Bridge connection"
    BRIDGE_INTERFACES="eth0"
    IP="dhcp"
    ## sets forward delay time
    #FWD_DELAY=0
    ## sets max age of hello message
    #MAX_AGE=10

Tip:It is recommended that you enable Spanning Tree Protocol (STP) on
the virtual bridge (e.g. br0) that you create to avoid any potential
bridging loops. You can automatically enable STP by appending
POST_UP="brctl stp $INTERFACE on" to the netcfg profile.

> Guest configuration

Now we have to activate the bridge interface in our VMs. If have a
recent Linux machine, you can use this code in the .xml file:

     [...]
     <interface type='bridge'>
       <source bridge='br0'/>
       <mac address='24:42:53:21:52:49'/>
       <model type='virtio' />
     </interface>
     [...]

This code activates a virtio device on the machine so, in Windows you
will have to install an additional driver (you can find it here Windows
KVM VirtIO drivers) or remove the line <model type='virtio' />:

     [...]
     <interface type='bridge'>
       <source bridge='br0'/>
       <mac address='24:42:53:21:52:49'/>
     </interface>
     [...]

Retrieved from
"https://wiki.archlinux.org/index.php?title=Libvirt&oldid=249776"

Category:

-   Virtualization
