Dell XPS M1530
==============

The Dell XPS M1530 works almost out of the box, just like its little
brother the Dell XPS M1330. Since kernel 2.6.25, everything is working
smooth and nice.

  

-   Video:

     Proprietary driver: nvidia
     Free drivers: nv or nouveau

-   Sound

     When using Kernel 2.6.25.4-1 you have to add the String options snd_hda_intel model=dell-3stack
     to a new file in /etc/modprobe.d/ (e.g. /etc/modprobe.d/dellsound)

-   Touchpad Synaptics

     It is an ALPS touch-pad
     To get it working correctly you have to add "i8042.nomux=1" to your kernel (in the /boot/grub/menu.lst)
     (kernel /vmlinuz-linux root=/dev/disk/by-uuid/cf732cd7-6dd2-c6fa086eb765 ro i8042.nomux=1)

-   Ethernet:

     Must use kernel 2.6.24 or above. "Arch 2007.8-2 Dont Panic ISO" default kernel will not work.

-   Wi-Fi:

     Works out of the box with current kernel. With the 2007.8-2 ISO you need the iwlwifi-4965 package.
     On some models you need to add noapic to kernel boot parameters.
     If you have a Broadcom Corporation BCM4328 802.11a/b/g/n wireless adapter, you need the broadcom-wl package from the AUR.
     Certain other Broadcom adapters may require firmware or extra configuration as described in the Broadcom wireless page.

-   Bluetooth:

     Need to install bluez

-   Multimedia keys

     With Keytouch: using this configuration file.
     Do not forget to add keytouch to DAEMONS in /etc/rc.conf, and make sure /etc/X11/Xsession is executed when logging in.
     With GNOME: have not managed to get them to work after a reboot (did not spend much time either. details to come)
     (GNOME: Edit System->Preferences->Keyboard Shortcuts)

-   Remote

     Same as multimedia keys: Works with Keytouch. Also with GNOME, but no permanent configuration found.

-   Webcam:

     Works with UVC (linux-uvc-svn)  (included in kernel since 2.6.26)

-   Internal microphone (digital mic)

     Working with kernel 2.6.25 and above.

-   External microphone (mic in)

     Working with kernel 2.6.25 and above.

-   External VGA output

     Works by default (tweak xorg.conf or use the nvidia-settings GUI utility)

-   USB

     Works out-of-the-box.

-   DVD-RW

     Works (with dvd+rw-tools and burning app installed)

-   Memory Sticks Reader / SD cards / MMC

     Works out-of-the-box.

-   Fingerprint reader

     Works with ThinkFinger

-   HDMI

     Works well with nouveau drivers and GNOME. Nvidia drivers also work, though the integration with Gnome isn't very good.

Not tested
----------

-   Firewire 1394

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_XPS_M1530&oldid=206043"

Category:

-   Dell
