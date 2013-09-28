Acer C7 Chromebook
==================

The following is a work in progress, of getting arch working on Acer's
new C7 200$ Chromebook. From opening the box to an Arch Linux command
line.

Currently you'll need a second computer already running *nix. In the
future If there's enough requests I'll create a way to install Arch
without the need for a second computer. Much like the cr48-ubuntu
script. If you're already running Ubuntu on your C7 then you can just
skip to creating your own arch image.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing Arch onto an Acer C7 Chromebook                         |
|     -   1.1 Backup all your data!                                        |
|     -   1.2 Enabling Dev Mode                                            |
|     -   1.3 Partitioning For Arch                                        |
|     -   1.4 Create Arch Disk Image                                       |
|         -   1.4.1 Create Image File                                      |
|         -   1.4.2 Convert Image To A Partition                           |
|         -   1.4.3 Install Arch onto this new image                       |
|                                                                          |
|     -   1.5 Copy Arch Image To C7                                        |
|                                                                          |
| -   2 Problems AKA: Work In Progress                                     |
| -   3 See alse                                                           |
+--------------------------------------------------------------------------+

Installing Arch onto an Acer C7 Chromebook
------------------------------------------

Currently Archlinux does work on the C7 but the install process is a bit
odd. Currently I have no way to replace the chromeos kernel, and I'd
really like to. If you manage to figure it out PLEASE let me know how.
In the mean time the system does work really well (for a chromebook)
with Arch.

> Backup all your data!

I'm assuming you're buying the system to install Arch, and that there's
no personal data on the device. But if that's not the case

Warning:*BACK UP YOUR DATA.*

Off device too, the hard disk gets wiped clean by design when you enter
Dev Mode.

> Enabling Dev Mode

First step is to enable Dev mode on the system so we can run some
unsigned code. This will wipe all your data!

To enter Dev Mode:

-   Press hold down the Esc+F3 (Refresh) keys, and press the Power
    button.

This enters recovery mode,

-   Now press Ctrl+d (there's no prompt). It will ask you to confirm,
    then the system will reboot into dev-mode.

Dev Mode will always show the scary boot screen and you need to press
Ctrl+d or wait 30 seconds to continue booting.

If you want to boot fromDirect_bootstrapping_Archlinux a chromium type
usb drive you'll have to run "crossystem dev_boot_usb=1" from ChromeOS
and reboot once to boot from USB drives with Ctrl+u. But we don't care
about that.

Note:If you need to hard reset. Press the refresh/F3 and press the power
button. This will hard reset the system. It's occasionally useful, but
use it with care - it wont sync the disk or shut down nicely, so there's
a nonzero chance of trashing the contents of your disk.

(all of this was stolen from [1]) Direct_bootstrapping_Archlinux

> Partitioning For Arch

Next you need to make room for Arch by repartitioning the Chromebook.

You can use the following script to repartition your C7 to make room for
Arch Linux. (It will also probably work on other chromebooks as well.)

It will prompt you for sizes, then it will partition your disk for
installing Arch, then reboot. After it reboots the C7 will reinstall
ChromeOS to factory, but you'll have the partitions needed for
installing Arch in the later sections.

    if [ "$1" != "" ]; then
      target_disk=$1
      echo "Got ${target_disk} as target drive"
      echo ""
      echo "WARNING! All data on this device will be wiped out! Continue at your own risk!"
      echo ""
      read -p "Press [Enter] to partition for Arch Linux on ${target_disk} or CTRL+C to quit"

      ext_size="`blockdev --getsz ${target_disk}`"
      aroot_size=$((ext_size - 65600 - 33))
      parted --script ${target_disk} "mktable gpt"
      cgpt create ${target_disk} 
      cgpt add -i 6 -b 64 -s 32768 -S 1 -P 5 -l KERN-A -t "kernel" ${target_disk}
      cgpt add -i 7 -b 65600 -s $aroot_size -l ROOT-A -t "rootfs" ${target_disk}
      sync
      blockdev --rereadpt ${target_disk}
      partprobe ${target_disk}
      crossystem dev_boot_usb=1
    else
      target_disk="`rootdev -d -s`"
      # Do partitioning (if we haven't already)
      ckern_size="`cgpt show -i 6 -n -s -q ${target_disk}`"
      croot_size="`cgpt show -i 7 -n -s -q ${target_disk}`"
      state_size="`cgpt show -i 1 -n -s -q ${target_disk}`"

      max_archlinux_size=$(($state_size/1024/1024/2))
      rec_archlinux_size=$(($max_archlinux_size - 1))
      # If KERN-C and ROOT-C are one, we partition, otherwise assume they're what they need to be...
      if [ "$ckern_size" =  "1" -o "$croot_size" = "1" ]
      then
        while :
        do
          read -p "Enter the size in gigabytes you want to use for Arch Linux. Acceptable range is 5 to $max_archlinux_size  but $rec_archlinux_size is the recommended maximum: " archlinux_size
          if [ ! $archlinux_size -ne 0 2>/dev/null ]
          then
            echo -e "\n\nNumbers only please...\n\n"
            continue
          fi
          if [ $archlinux_size -lt 5 -o $archlinux_size -gt $max_archlinux_size ]
          then
            echo -e "\n\nThat number is out of range. Enter a number 5 through $max_archlinux_size\n\n"
            continue
          fi
          break
        done
        # We've got our size in GB for ROOT-C so do the math...

        #calculate sector size for rootc
        rootc_size=$(($archlinux_size*1024*1024*2))

        #kernc is always 16mb
        kernc_size=32768

        #new stateful size with rootc and kernc subtracted from original
        stateful_size=$(($state_size - $rootc_size - $kernc_size))

        #start stateful at the same spot it currently starts at
        stateful_start="`cgpt show -i 1 -n -b -q ${target_disk}`"

        #start kernc at stateful start plus stateful size
        kernc_start=$(($stateful_start + $stateful_size))

        #start rootc at kernc start plus kernc size
        rootc_start=$(($kernc_start + $kernc_size))

        #Do the real work
        
        echo -e "\n\nModifying partition table to make room for Arch." 
        echo -e "Your Chromebook will reboot, wipe your data and then"
        echo -e "you should re-run this script..."
        umount /mnt/stateful_partition
        
        # stateful first
        cgpt add -i 1 -b $stateful_start -s $stateful_size -l STATE ${target_disk}

        # now kernc
        cgpt add -i 6 -b $kernc_start -s $kernc_size -l KERN-C ${target_disk}

        # finally rootc
        cgpt add -i 7 -b $rootc_start -s $rootc_size -l ROOT-C ${target_disk}

        reboot
        exit
      fi
    fi

> Create Arch Disk Image

Create Image File

-   First we need to create an Arch Image to do things with. It's
    recommended that you use arch to create this image (because that's
    how I did it), but you can probably do this from any linux system.

    # truncate -s 1G arch.img

Convert Image To A Partition

-   Convert image to a ext3 filesystem.

    # mkfs.ext3 arch.img

-   Mount image to install to

    # mkdir /mnt/arch_install
    # mount -o arch.img /mnt/arch_install

Install Arch onto this new image

There's plenty of ways to go about this, the method I recommend is
Directly bootstrapping Archlinux. If you go this way you can just follow
the Installation_Guide. But anyway you choose to create your Arch linux
install should work, unless you do something very strange, in that case
good luck!

> Copy Arch Image To C7

The following is a quick mockup to get you started. It's incomplete, be
careful, you'll be left with an unworking system if you follow this
guide!

You should now have the following

1.  An image of Arch Linux
2.  A freshly partitioned Acer C7
3.  A copy of the kernel
4.  A copy of the kernel modules

From there all you need to do is;

-   get the arch.img on the C7
-   download a copy of your kernel
-   download a copy of your kernel modules
-   mount your image
-   mount your root-c partition
-   repack/resign the kernel
-   dd the kernel
-   copy over the kernel modules
-   copy over cgpt
-   set boot with cgpt
-   reboot
-   be happy

Problems AKA: Work In Progress
------------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

See alse
--------

-   Developer information on Official site

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_C7_Chromebook&oldid=254953"

Category:

-   Acer
