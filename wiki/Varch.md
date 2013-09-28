Varch
=====

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Why Do We Need Varch?                                              |
| -   2 How Does Varch Work?                                               |
| -   3 Installation                                                       |
| -   4 Using Varch                                                        |
|     -   4.1 Generic Image Support                                        |
|     -   4.2 Virtualbox Specific Images                                   |
|     -   4.3 Application of a File Overlay                                |
|     -   4.4 Startup Script Generation                                    |
|         -   4.4.1 KVM Startup Script                                     |
|         -   4.4.2 Libvirt Startup Script                                 |
+--------------------------------------------------------------------------+

Why Do We Need Varch?
---------------------

The use of virtualization is rapidly expanding in the Linux world, many
Linux distributions have answered the move to virtualization with tool
specific to their distributions for automated virtual machine
provisioning.

The Fedora project spearheads the thincrust project
(http://thincrust.org), and Ubuntu/Debian uses the vmbuilder tool. These
tools can quickly generate installs of their distributions inside of
virtual machine images that can then be used with KVM.

ArchLinux was therefore left in the dark, without a means to automate
virtual machine provisioning. Not only this, but a number of special
modifications need to be made to ensure that Arch is properly installed
in a KVM virtual machine. This includes modifications to the mkinitcpio
image as well as a careful installation of grub.

Varch was developed to solve these problems!

How Does Varch Work?
--------------------

Many of the other virtual machine building tools are complicated,
require sometimes many configuration files to be made, and a very long
command line argument to create a virtual machine image. Varch is
different, and made to be simple to use in the best efforts to follow
KISS and the Arch way as possible.

Varch prepares a virtual machine image, mounts it using kpartx and then
calls the Arch installation Framework to run the actual install, this
ensures that arch is installed the "Arch" way without having to
re-create an installer. This also means that varch is configured with
the same files that configure AIF.

Installation
------------

Install the varch package from the official repositories.

Using Varch
-----------

Using Varch is very simple, without arguments the varch command will
generate a basic virtual machine image:

    # varch

and the options are very basic, -c to pass a custom configuration file,
-s to specify a size for the image, -f to tell the image to use another
format (raw and qcow2 are supported) and -i to specify the output name
of the virtual machine image. So, if using a custom config called
custom.aif, making a qcow2 formatted image, with a size of 50 GiB and
saving the image as "custom":

    # varch -c custom.aif -f qcow2 -s 50G -i custom

By default Varch creates images for KVM, since KVM is the "blessed"
Linux hypervisor, but since many other hypervisors exist, it would be
folly to ignore them. So Varch also supports "generic" images, which are
just raw disk images without virtio support, suitable for non hardware
accelerated qemu use and converting into other virtual machine hard
disks.

Varch also supports the Virtualbox vdi format.

> Generic Image Support

Varch can also make non-KVM virtual machine images, this basically means
that the virtio block drivers are not installed and the root disk is
/dev/sda. To create a generic virtual machine image pass the -g or
--generic flag:

    # varch -g

> Virtualbox Specific Images

Since Virtualbox is a popular choice for desktop virtualization support
for Virtualbox vdi images has been added to Varch. Simply pass vdi as
the format and the image will be made into a Virtualbox vdi image:

    # varch -f vdi

> Application of a File Overlay

While AIF can be used to easily modify the system post install, it can
be difficult to script into the aif file the addition of many files.
This is where the overlay feature comes into play.

The overlay option takes a directory, and anything in that directory
will be copied, raw, into the the root of the virtual machine.

    # varch -o ~/overlay/

Where ~/overlay contains a file system overlay.

> Startup Script Generation

Since some virtual machines can be tricky to start, varch can generate
startup scripts and configuration files.

KVM Startup Script

Since kvm virtual machines started with the qemu-kvm command can require
additional arguments varch can generate a startup script for the kvm
virtual machine. Add a -K argument and the script will be generated.

    # varch -K

This will create a bash script named <vm name>-kvm.sh

Libvirt Startup Script

Libvirt can be the most powerful way to run virtual machines in Linux,
varch can create a libvirt configuration file and a bash script to start
the generated virtual machine. Simply add a -L flag to the virtual
machine generation:

    # varch -L

Retrieved from
"https://wiki.archlinux.org/index.php?title=Varch&oldid=206904"

Category:

-   Virtualization
