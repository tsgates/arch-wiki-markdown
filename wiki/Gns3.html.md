Gns3
====

  
 GNS3 is a Graphical Network Simulator. It allows you to simulate a
network on your computer. From the webpage:

  GNS3 is an open source software that simulate complex networks while
  being as close as possible to the way real networks perform. All of
  this without having dedicated network hardware such as routers and
  switches.

Contents
--------

-   1 Installation
-   2 Adding virtual machines
    -   2.1 VirtualBox
        -   2.1.1 Install VirtualBox
        -   2.1.2 Adding VMs to GNS3
        -   2.1.3 Adding VMs to your topology
    -   2.2 Qemu
    -   2.3 VMware
        -   2.3.1 Installation
        -   2.3.2 Adding VMs to your topology
-   3 Connecting devices

Installation
============

You can get GNS3 from the AUR, or install in manually by getting the
package from the GNS3 website

Adding virtual machines
=======================

When creating your topology (your virtual network), you most likely want
to add machines to it. GNS3 supports Qemu and VirtualBox out of the box.
VMware does not make for as easy integration. You can use VMWare but you
can not add the machines directly in your topology as you can with Qemu
and VirtualBox.

VirtualBox
----------

> Install VirtualBox

To use VirtualBox-machines for your topology you need to install
virtualbox and virtualbox-sdk. To avoid any problems with GNS3 not
finding virtualbox it is recommended to install virtualbox AFTER you
install GNS3. If you already have virtualbox installed, you should be
able to just reinstall it.

# pacman -S virtualbox virtualbox-sdk

If you don't install the virtualbox-sdk package you will not get the
vboxapi.py script and GNS3s vboxwrapper.py needs this to connect the
VMs.

> Adding VMs to GNS3

When the connection between GNS3 and VirtualBox have been made you need
to tell GNS3 which VMs it should see and be able to use.

1.  In GNS3, click on Preferences -> VirtualBox. Check that the path to
    vboxwrapper.py (should be /usr/share/gns3/vboxwrapper.py and is set
    per default) is correct (if you get an OK when pressing the "Test
    Settings"-button, it works, otherwise see the installation step).
2.  Go to the VirtualBox Guest tab to add the VirtualBox VMs in GNS3.
    Choose an identifier name, a VM from the VM list (you may have to
    refresh the list using the provided button). To avoud confusion and
    possible errors, it is recomended to use the same identifier name as
    the name of the VM. When a VM is selected you can choose other
    options for it as well:
    -   Number of NICs is the number of network interface cards you will
        see inside your VM (e.g. ifconfig on Linux, if you have 4 NICs
        on your VM, then set it to 4 in GNS3, if you have 1 NIC, then
        set it to 1 in GNS3).
    -   Reserve first NIC for VirtualBox NAT to host OS is to you have
        your first network interface card (e.g. eth0 on Linux)
        configured with network address translation (NAT), allowing your
        VM to access your host network and Internet (if your host can
        access it of course).
    -   Enable console support to activate a serial console access to
        your VM. Please note that serial console support must also be
        configured on the operating system running in your VirtualBox
        guest for this feature to work. Here is a howto for
        Debian/Ubuntu Linux.
    -   Enable console server (for remote access) is to remotely access
        to your VM serial console. GNS3 creates a mini Telnet server
        that act as a proxy between the serial console and Telnet
        clients. This feature requires the Enable console support to be
        enabled.
    -   Start in headless mode (without GUI) will hide the VirtualBox
        graphical interface when the VM is started. This option is
        mostly useful if you have configured the previously described
        console support.

> Adding VMs to your topology

After you have told GNS3 which VMs is should be able to see you can
drag'n'drop them in your topology. Simply select the computer-icon in
the left sidebar. You can now choose "VirtualBox guest". Drag this to
where you want to add your VM in your topology. When you drop it in you
will be prompted about which VM to add. Select the one you want and
click OK. You should now be able to boot the VM from GNS3 by right click
-> start.

  

Qemu
----

To be written

VMware
------

> Installation

See VMware.

> Adding VMs to your topology

To use VMware in GNS3 you need to create a cloud in your GNS3 topology,
and then in your VMware machine, connect it to the NIC of the cloud in
your topology.

Instructions taken (and ported) from GNS3 forums:

1.  Select network adapter "Host only" to your Virtual machine in Vmware
2.  Check how this network adapter (vmnet1) is named ($ ifconfig should
    list it).
3.  Add a cloud to your workspace in GNS3.
4.  Configure the cloud and select the network adapter you just looked
    up.
    -   Right Click on the cloud and select Configure.
    -   Select the C0 on the cloud.
    -   Select NIO Ethernet.
    -   Select Generic Ethernet NIO.
    -   Select the appropriate adapter from the drop-down menu and press
        the Add button.
    -   The adapter for your virtual machine should now be added to the
        cloud.

5.  Connect cloud to your topology, for example to a router.
6.  Assing IP addresses (in the same subnet) to the Virtual machine and
    the emulated router in GNS3.
7.  Ping between router and virtual machine should now be successful,
    otherwise, try to redo the steps.

Connecting devices
==================

When devices have been added to your topology you will need to connect
them. Select the link-icon (the bottom icon in the left sidebar, looks
sort of like a mouse or ethernet-port+rj45 connector), click on a device
(like a switch). Next, click on the device (like a VM) you want to
connect to the switch. You will be promted to select the NIC which
should be used. When you have created all the links you want, click the
link-icon in the left sidebar to deselect it, otherwise GNS3 will still
be in 'create link'-mode.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Gns3&oldid=289112"

Categories:

-   Networking
-   Emulators
-   Virtualization

-   This page was last modified on 18 December 2013, at 14:02.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
