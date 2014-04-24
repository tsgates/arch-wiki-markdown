VirtualBox Arch Linux Guest On Physical Drive
=============================================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: References to    
                           initscripts (update to   
                           systemd) and GRUB Legacy 
                           (update to GRUB 2 and    
                           posibly support also     
                           other boot loaders).     
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Lots of users run a dual boot between Arch Linux and another Operating
System (Windows for instance). It can be tedious to switch back and
forth if you need to work in both. Using Virtual Machines, we can
install one OS in the VM and have both running. This is not always
convenient, because for performance reasons we might want to be able to
run both OSes natively when needed and still keep the convenience of
having access to both OSes at the same time.

This guide will help you set up your dual boot Arch Linux/Windows system
so you can still run your native Arch Linux while in Windows and be able
to boot back into the same Arch Linux natively.

Contents
--------

-   1 Prerequirements
-   2 Preliminary steps in Arch Linux
    -   2.1 Step 1 - Addressing using UUIDs
        -   2.1.1 Optional sanity check
    -   2.2 Step 2 - Create new mkinitcpio image
-   3 Setting up VirtualBox to boot Arch Linux from the Physical Drive
-   4 Enabling VirtualBox integration and Seamless mode
-   5 Additional notes

Prerequirements
---------------

First, we have to establish some requirements for this setup. Naturally,
you need to have both OSes installed and set up for dual boot correctly.
Here we will assume you are using GRUB to boot, but I'm sure other boot
managers can be set up in a similar manner. This guide is focusing on
setting up the environment using VirtualBox. Assumption is that you have
downloaded and installed the latest version of VirtualBox in Windows.

Finally, depending on your hard drive set up, device files for your hard
drives may be different when you run Arch Linux natively and in a VM.
For instance in my setup I run fake raid so my root partition is
natively /dev/mapper/isw_ci...Systemp6 while under VM it is /dev/sda6
because Windows abstracts away fake raid for us. Your setup may be
different but the same problem may apply. To circumvent this problem we
need an addressing scheme that is persistent to both systems (e.g.
doesn't change). One sure way of doing it is through UUIDs, which is how
we are going to do it.

To sum up, you need:

-   Running dual-boot Arch Linux/Windows system using Grub
-   Hard drive partitions mapped using UUIDs in Grub and /etc/fstab
-   Have installed VirtualBox in Windows

So let's get started. Boot into your Arch Linux and open up a terminal.

Preliminary steps in Arch Linux
-------------------------------

> Step 1 - Addressing using UUIDs

If you do not have this set up already we are going to switch addressing
scheme in Grub and /etc/fstab to UUIDs. First step is to find out UUIDs
for your partitions. Type in:

    sudo blkid

Your output should be something like:

    /dev/sda1: UUID="4AD8..." LABEL="System Reserved" TYPE="ntfs" 
    /dev/sda2: UUID="82D2..." LABEL="System" TYPE="ntfs" 
    /dev/sda3: UUID="3cbcd99c-..." TYPE="ext2" 
    /dev/sda5: UUID="bf5adc7a-..." TYPE="swap" 
    /dev/sda6: UUID="3ca3b8f2-..." TYPE="ext4" 

This tells you what the UUID of each partition is. Write it down or copy
paste to the editor because we'll need it later. Next we need to update
/etc/fstab so it maps partitions using UUIDs and not through device
files:

    sudo nano /etc/fstab

For all your hard drive partitions, switch out their device name in the
first column with the UUID given above using the following example as a
guide:

Before:

    /dev/sda6 / ext4 defaults 0 1
    /dev/sda2 /mnt/Win7 ntfs-3g defaults 0 0

After:

    UUID=3ca3... / ext4 defaults 0 1
    UUID=82D2... /mnt/Win7 ntfs-3g defaults,noauto,ro 0 0

Please note the ro flag marked in red. You must NOT allow Arch Linux
write access to the Windows Partition where system is. Because they will
be both running at the same time you are risking corruption of data due
to concurrent writes. This is EXTREMELY DANGEROUS so you must put a
read-only flag here. Noauto flag is added because at boot Arch will try
to mount the partition and give an error because it has been locked for
mounting by the running Windows. We will get to mounting it back later.

Now we need to tell grub to use UUIDs as well so we can reach mkinitcpio
image and the kernel to boot properly. Let's go to grub config:

    cd /boot/grub
    sudo nano menu.lst

Find your boot entry for Arch Linux and copy paste a new entry with the
same config. Rename it to "Arch Linux VirtualBox" and modify the root
option to use UUIDs using the following guide as example:

    # (5) Arch Linux VirtualBox
    title  Arch Linux VirtualBox
    root
    kernel /vmlinuz-linux root=/dev/disk/by-uuid/3ca3b8f2-... ro vga=773
    initrd /initramfs-linux-vbox.img

Substitute the root= device file name with the UUID of the partition you
used in that place like in the example (vga flag gives us a nice
framebuffer you may omit it if you do not want it). Make note of the
initrd line. We are telling GRUB we want to use a new mkinitcpio image
that we are about to build.

Repeat the process here, for the fallback entry. Create a new GRUB entry
by copy pasting default Arch Linux fallback entry, call it "Arch Linux
VirtualBox Fallback" and update its kernel and initrd lines so they
show:

    kernel /vmlinuz-linux root=/dev/disk/by-uuid/3ca3b8f2-... ro
    initrd /initramfs-linux-vbox-fallback.img

Make note the mkinitcpio image in this case is named
initramfs-linux-vbox-fallback.img.

Another important thing to note, is that you should NEVER allow
VirtualBox to try and boot Windows partition of the host. This will
create a bunch of problems, and will lead to filesystem corruption. If
you have Windows set up as a default entry in GRUB, take special care
when you are booting VirtualBox and tell it to boot Arch Linux
VirtualBox entry. Give yourself enough timeout in the GRUB configuration
file so you can do this comfortably and do not risk booting Windows host
in the VM. 5 seconds works for me.

Optional sanity check

You may want to double check your /etc/fstab and GRUB configuration so
they are correct and restart Arch to see that the system will still boot
fine using UUIDs. It is also encouraged you create a backup of both
fstab and GRUB's menu.lst should you make a mistake somewhere.

> Step 2 - Create new mkinitcpio image

Next we need to generate a new mkinitcpio image that will comply with
VirtualBox hardware configuration. Lets setup a new mkinitcpio image. Go
to mkinitcpio.d:

    cd /etc/mkinitcpio.d/

Here mkinitcpio keeps all the presets for generating images. We want to
create a new preset, stemming from the default one "linux". So lets make
a copy and call it linux-vbox and open it in your favorite editor:

    sudo cp linux.preset linux-vbox.preset
    sudo nano linux-vbox.preset

Here we need to change a few things. Change all occurrences of "linux"
for "linux-vbox" except the line that is sourcing linux.ver file. Here
are the parts that need to be changed:

    ALL_config="/etc/mkinitcpio-vbox.conf"
    ...
    #default_config="/etc/mkinitcpio-vbox.conf"
    default_image="/boot/initramfs-linux-vbox.img"
    #default_options=""
    ...
    #fallback_config="/etc/mkinitcpio-vbox.conf"
    fallback_image="/boot/initramfs-linux-vbox-fallback.img"
    fallback_options="-S autodetect"

Now we need to create the configuration file for the preset. I keep them
in /etc along with the default mkinitcpio.conf but you may want to do
differently. If so, update the preset with proper paths to
mkinitcpio-vbox.conf. Again we are going to use the default mkinitcpio
as a guide:

    cd /etc/
    sudo cp mkinitcpio.conf mkinitcpio-vbox.conf 
    sudo nano /etc/mkinitcpio-vbox.conf

Modify the modules line to include hardware used by VirtualBox. I have
found that the following works good:

    MODULES="piix ahci pata_acpi ata_piix"

Modify the hooks line to include boot hooks that VirtualBox and your
partitions will need. Keep all the filesystem, lvm and encryption hooks
you may be using, but add the following (if they are not there already)
"ide, sata". Hooks line that should work for a usual Arch system is:

    HOOKS="base udev autodetect ide sata filesystems"

We are almost done with this step. All we have to do is tell mkinitcpio
to generate the images:

    sudo mkinitcpio -p linux-vbox

Sit back and enjoy while it finishes. This completes all the preliminary
setup necessary for Arch to work both natively and in VM. Reboot and
lets go to Windows.

Setting up VirtualBox to boot Arch Linux from the Physical Drive
----------------------------------------------------------------

Now we need to setup VirtualBox with a new VM one that uses the physical
drive. Before we can do that, we need to create a mapping for the
physical drive. Unfortunately, VirtualBox does not have this option in
the GUI but we can do it from the console. Open prompt (if you are in
Vista/Win7 open it in admin mode by typing in cmd and hitting
ctrl-shift-enter). Go to your VirtualBox installation folder:

    cd c:\Program Files\Sun\VirtualBox\

According to the VirtualBox User Manual section 9.8 we can create an
image that represents the entire physical hard disk using the VBoxManage
tool:

    .\VBoxManage internalcommands createrawvmdk -filename \path\to\file.vmdk -rawdisk \\.\PhysicalDrive?

Where \path\to\file.vmdk is the location and the name where you want the
mapping file stored. I like to keep things neat, so I placed it where
VirtualBox keeps other hard drive mapping files (you can find the
location in VirtualBox's preferences). Substitute the question mark in
\\.\PhysicalDrive? with the number of your physical hard drive as
Windows sees it, numbered from zero. So first hard drive would be
\\.\PhysicalDrive0.

Afterwards we have to create a new machine and attach the newly image to
the machine

    .\VBoxManage createvm -name machineA -register
    .\VBoxManage storagectl machineA --name "IDE Controller" --add ide
    .\VBoxManage storageattach machineA --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium \path\to\file.vmdk

where machineA is the name of the newly created virtual machine.

You should get a confirmation the file was created successfully and now
we can finally create the VM. Set the options you want for the VM and
during the Virtual Hard disk screen select "Use existing hard disk"
option with the mapping file you created moments ago. I'd also recommend
turning on the 3D acceleration, increasing video memory to 32 or 64MB
and setting the network interface to bridge mode for the best results.

Enabling VirtualBox integration and Seamless mode
-------------------------------------------------

Finally, you may want to seamlessly integrate your Arch Linux in Windows
and allow copy pasting between OSes. For a guide how to set this up look
at Virtual Box page.

Additional notes
----------------

For X to work in both VM and natively (since obviously it will be using
different drivers) it is best if hotplugging is enabled and there is no
xorg.conf so X will pick up everything it needs on the fly. If however
you really do need xorg.conf then perhaps the best way to circumvent
this is to set GRUB to boot into runlevel 3 for VirtualBox entry so you
end up in the console. Then you can startx with custom xorg.conf.

Retrieved from
"https://wiki.archlinux.org/index.php?title=VirtualBox_Arch_Linux_Guest_On_Physical_Drive&oldid=302407"

Category:

-   Virtualization

-   This page was last modified on 28 February 2014, at 15:55.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
