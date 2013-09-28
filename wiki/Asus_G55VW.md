Asus G55VW
==========

This page contains instructions, tips, pointers, and links for
installing and configuring Arch Linux on the ASUS G55VW ROG Laptop

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Bootloader                                                         |
|     -   1.1 Boot on usb                                                  |
|     -   1.2 Set up UEFI boot                                             |
|                                                                          |
| -   2 Graphics Drivers                                                   |
| -   3 Screen Backlight                                                   |
| -   4 Other Keys                                                         |
|     -   4.1 keyboard backlight script                                    |
+--------------------------------------------------------------------------+

Bootloader
----------

> Boot on usb

Press Escape to get the boot menu. If usb bootable device is not listed,
enter configuration menu and directly press F10 to save. Press Escape
again on reboot : this time USB bootable device should appears in the
menu.

  

> Set up UEFI boot

Note:It is recommended to read the UEFI, GPT and UEFI_Bootloaders pages
before following those instructions.

  
 It is possible to use UEFISTUB in-kernel bootloader, if you wish. We
present here the GRUB2 way. We assume x86_64 version of Arch Linux.

Warning: UX31A firmware is x86_64, so it makes it compulsory to use
x86_64 kernel to be able to dual boot with Windows in UEFI mode

In the original partition setup:

first partition: UEFI boot fat32 partition, should be mounted on
/boot/efi in Arch.

second partition: GUID Partition Table

  
 Step 0 (optional): install x86_64 UEFI Shell 2.0 (Beta):

See UEFI#UEFI_Shell. Can be useful during install, especially it allows
to manually boot using UEFISTUB.

Step 1: granted you can boot into your install through install disk,
grub1 or via a liveusb and a chroot:

    # pacman -S grub-efi-x86_64

Follow GRUB2#UEFI_systems_2.

Optional: add some power optimisation kernel parameters. In
/etc/default/grub file:

    GRUB_CMDLINE_LINUX_DEFAULT="quiet add_efi_memmap i915.i915_enable_rc6=1 drm.vblankoffdelay=1 i915.semaphores=1"

Note: concerning kernel parameter  pcie_aspm=force, I'm unsure: Ubuntu
wiki recommends it, but UX31E Arch wiki says it should not be used.

Reinstall grub2 :

    grub-mkconfig -o /path/to/grub.cfg

Step 2: it is not yet possible to finish install by creating GRUB2 entry
in the Firmware Boot Manager since it is required to boot in UEFI mode
to be able to use efibootmgr. The tricks is to do:

    # cp /boot/efi/EFI/arch_grub/grubx64.efi /boot/efi/shellx64.efi

Note: temporary move shellx64.efi if necessary

    # reboot

Press F2 on reboot and choose "Launch EFI shell from filesystem device".
It should trigger grub2 and boot into arch if grub2 is correctly set up.
You should now be able to use efibootmgr to add grub entry to firmware.

Graphics Drivers
----------------

The proprietary nvidia drivers can be installed by enabling the "extra"
repository in the "/etc/pacman.conf" file, and the executing:

    # pacman -S nvidia

Screen Backlight
----------------

Using the nvidia drivers provided in the extra repo screen the
backlight-adjust keys(Fn+F5, Fn+F6) do not work. To get around this, you
need to grab ({aur|nvidiabl-git}). Once you have installed that package,
you can map your keys to the script.

Other Keys
----------

It is also possible to use Dynamic Kernel Module Support (DKMS) (package
in community), to avoid compiling the whole kernel:

1 get the archive at
http://ubuntuforums.org/showthread.php?p=12054636#post12054636 (ubuntu
forums account + minimum of 50 posts required) or
http://markmail.org/message/idvl6s27r26xzorb (no account required)

Note: there is perhaps more suitable place to get the asus-wmi kernel
module sources, the patch and the dkms conf file

2 extract the archive, and then extract the .deb and get the sources
inside (asus-wmi.c is already patched with above patch):

     # cp -a usr/src/asus-wmi-0.2 /usr/src/
     # cd /usr/src/
     # dkms add -m asus-wmi -v 0.2
     # dkms built -m asus-wmi -v 0.2 -k 3.4.6-1-ARCH
     # dkms status
     # dkms install -m asus-wmi -v 0.2 -k 3.4.6-1-ARCH
     # dkms status

replace 3.4.6-1-ARCH by your output for uname -r

3 There is still a problem since dkms doesn't gzip the kernel module and
archlinux does (see $ modinfo asus-wmi):

    # cd /lib/modules/3.4.6-1-ARCH/kernel/drivers/platform/x86/
    # mv asus-wmi.ko.gz asus-wmi.ko.gz.save
    # gzip asus-wmi.ko

Note: there is probably a cleaner way to do that with dkms

4 After reboot, xev should display events for Fn keys. And keyboard
backlight can be trigger by:

    # echo 0 >> /sys/class/leds/asus\:\:kbd_backlight/brightness
    # echo 3 >> /sys/class/leds/asus\:\:kbd_backlight/brightness

> keyboard backlight script

In the same style that for screen backlight. As root, create the file
/usr/local/share/kbd_backlight:

    #!/bin/bash

    path="/sys/class/leds/asus::kbd_backlight"
    #path="/sys/class/leds/asus\:\:kbd_backlight"

    # max should be 3
    max=$(cat ${path}/max_brightness)
    # step: represent the difference between previous and next brightness
    step=1
    previous=$(cat ${path}/brightness)

    function commit {
    	if [[ $1 = [0-9]* ]]
    	then 
    		if [[ $1 -gt $max ]]
    		then 
    			next=$max
    		elif [[ $1 -lt 0 ]]
    		then 
    			next=0
    		else 
    			next=$1
    		fi
    		echo $next >> ${path}/brightness
    		exit 0
    	else 
    		exit 1
    	fi
    }

    case "$1" in
     up)
         commit $(($previous + $step))
      ;;
     down)
         commit $(($previous - $step))
      ;;
     max)
    	 commit $max
      ;;
     on)
    	 $0 max
      ;;
     off)
    	 commit 0
      ;;
     show)
    	 echo $previous
      ;;
     night)
    	 commit 1 
    	 ;;
     allowusers)
    	 # Allow members of users group to change brightness
    	 sudo chgrp users ${path}/brightness
    	 sudo chmod g+w ${path}/brightness
      ;;
     disallowusers)
    	 # Allow members of users group to change brightness
    	 sudo chgrp root ${path}/brightness
    	 sudo chmod g-w ${path}/brightness
      ;;
     *)
    	 commit	$1
    esac

    exit 0

Allow file to be executed :

    # chmod +x /usr/local/share/kbd_backlight

Allow users to change brightness at each boot :

    # echo "/bin/bash /usr/local/share/kbd_backlight allowusers" >> /etc/rc.local

Adding to .zshrc or .bashrc :

    alias -g "kbd_backlight"="/bin/bash /usr/local/share/kbd_backlight"

allows to easy toggle backlight in terminal :

    $ kbd_backlight up
    $ kbd_backlight down
    $ kbd_backlight max
    $ kbd_backlight off
    $ kbd_backlight night
    $ kbd_backlight 2
    $ kbd_backlight show

And finally, add some convenient keyboard shortcuts by the method of
your choice.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Asus_G55VW&oldid=215618"

Category:

-   ASUS
