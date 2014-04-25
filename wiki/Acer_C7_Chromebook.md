Acer C7 Chromebook
==================

This page is a work in progress guide to running Arch Linux on the Acer
C7 Chromebook. See these installation instructions for the Acer C720
Chromebook. Over seven models exist, starting at $199.

For now you need another computer running *nix. If you're already
running ChrUbuntu on your Acer C7, skip to creating your own Arch image.

Contents
--------

-   1 Install Arch on an Acer C7 Chromebook
-   2 Enabling Dev Mode
-   3 Install ChrUbuntu
    -   3.1 Create Image File
    -   3.2 Convert Image to A Partition
    -   3.3 Install Arch on The New Image
-   4 Copy Arch Image to C7
-   5 Installing a 64bit Kernel
-   6 Finishing Up
-   7 Extra - Reduce Boot Time(DANGEROUS)
-   8 See Also

> Install Arch on an Acer C7 Chromebook

Arch runs well on the Acer C7. For 64bit installs first see Installing a
x86_64 kernel. "Patches welcome" for custom x86_64 ChromiumOS kernels.
The default install is 32bit due to the stock kernel.

Warning:*BACK UP YOUR DATA.* All of it, somewhere else(Cloud, USB,
another machine). The entire data partition will be purged many times.

> Enabling Dev Mode

First step is to enable Dev mode on the system so we can run some
unsigned code. This will wipe all your data!

To enter Dev Mode:

-   Press and hold the Esc+F3 (Refresh) keys, then press the Power
    button. This enters recovery mode.
-   Now, press Ctrl+D (no prompt). It will ask you to confirm, then the
    system will reboot into Dev Mode.

Dev Mode will show the white boot screen. Press Ctrl+D or wait 30
seconds to beep and boot.

Note:To hard reset, press Esc+F3 (Refresh). This acts like a reset
button on a desktop PC. The same warnings apply - The OS cannot save
itself from this, and data loss is possible.

See Also: Acer C7: Entering Developer Mode

> Install ChrUbuntu

While it is completely backwards to install Ubuntu just to install Arch,
currently it's the most automated and safe way. Scripts are a
work-in-progress, trying to mash the ChrUbuntu script with
arch-bootstrap. Stay tuned for details if they arrive.

-   After enabling dev mode on your Chromebook, boot to the ChromeOS
    setup screen. Set keyboard layout, language, and connect to a
    network. Do *not* log in to an account.
-   Press Ctrl+Alt+F2 and login as "chronos".
-   Bring up a bash prompt.

    # bash

-   Download Chrubuntu installer and run it.

    # curl -L -O git.io/pikNcg
    # sudo bash ./pikNcg

Set the partition size for the future Arch install. Example: I input
"260", most of the stock Acer C7(C710-2487)'s 320GB HDD.

-   Wait for the system reboot.
-   Wait 3-5 minutes for the system "repair" job to run.
-   Reset keyboard layout, language, and reconnect to a network. Don't
    log in to an account.
-   Ctrl+Alt+F2 again and log in as "chronos"(again).
-   Bring up a bash prompt(again).

    # bash

-   Download ChrUbuntu installer and run it(again).

    # curl -L -O git.io/pikNcg
    # sudo bash ./pikNcg

-   Let the ChrUbuntu installer run. You'll be asked a few setup
    questions, it's safe to hit Enter for all as we'll never use Ubuntu.
-   While that installs, let's install Arch on our spare *nix box!

Warning:When the script finishes, it will ask you to press Enter to
reboot, DO NOT. Press Ctrl+C to exit to a shell.

Create Image File

-   First we need to create an Arch Image to do things with. This can be
    done an any *nix box.

    # truncate -s 1G arch.img

Convert Image to A Partition

-   Convert image to an ext4 filesystem.

    # mkfs.ext4 -m 1 arch.img

-   Mount image to install to.

    # mkdir /mnt/arch_install
    # mount arch.img /mnt/arch_install

Install Arch on The New Image

Go through the Installation Guide as normal. I recommend a system with
the Arch install scripts package installed. This is a doable process
with many *nix systems(well documented on the Wiki), it will be much
smoother with the install scripts.

For 32 bit (x86),

    # pacstrap /mnt/arch_install base base-devel --arch i686

Note:The `--arch i686` part is important if you're on the stock stable
channel which currently uses a 32bit-PAE kernel.

For 64 bit (x64)

    # pacstrap /mnt/arch_install base base-devel --arch x86_64

When setting up fstab, you'll need to mount "/dev/sda7" at "/". UUIDs
aren't really an option here as data is about to get sorted all over the
place.

> Copy Arch Image to C7

Now it gets messy. You should have a ChrUbuntu install that you did not
reboot into(you're back in the bash shell in ChromeOS) and a ready-to-go
Arch install on arch.img. Copy the arch.img file to a transfer
medium(USB, HDD, Cloud, SSHFS, BT, etc).

-   Copy the Arch image to the Chromebook.
-   Create working directories.

    # mkdir mnt mnt2 mnt3 backup

-   If your Arch image is on a USB key or drive, run "mount /dev/sdb1
    mnt" (replacing /dev/sdb1 with the identifier of your USB drive
    according to ChromeOS). Then run "mount mnt/arch.img mnt2"
    (replacing arch.img with the name of your Arch image).
-   Otherwise, I'm assuming your Arch image was downloaded to the
    Chromebook somehow. So run "mount /path/to/arch.img mnt2"
-   Mount Ubuntu's root at mnt3.

    # mount /dev/sda7 mnt3

-   Copy all firmware and kernel modules, which we'll need to
    successfully boot Arch.

    # cp -a mnt3/lib/{firmware,modules} backup/

-   Save all module configs.

    # cp -a mnt3/etc/modprobe.d/*.conf backup/

-   Remove old Ubuntu install

    # rm -rf mnt3/*

Warning:Make 100% certain you typed "mnt3/*" and not some other
mountpoint or you may toast your USB stick or Arch install.

-   Copy your Arch install off to what was Ubuntu's root directory.

    # cp -a mnt2/* mnt3/

-   Restore module configs.

    # cp -a backup/*.conf mnt3/etc/modprobe.d/

If running x86

-   Run "cp -a backup/modules/* mnt3/lib/modules/". This will restore
    kernel modules.

If running x86_64

    # wget http://grayhatter.com/public/archC7/zgb-x64-modules.tar.bz2
    # tar xf zgb-x64-modules.tar.bz2
    # sudo cp -R 3.4.0 mnt3/lib/modules/

-   Restore kernel firmwares.

    # cp -a backup/firmware mnt3/lib/

-   Copy CGPT to arch so we can boot back and fourth.

    # cp /usr/bin/cgpt mnt3/usr/bin/
    # mkdir mnt3/usr/bin/old_bins
    # cp /usr/bin/old_bins/cgpt mnt3/usr/bin/old_bins

-   To use CGPT later, you will need to install glibc (32-bit) or
    lib32-glibc (64-bit).
-   "umount" mnt3, mnt2, and mnt. In that order.

> Installing a 64bit Kernel

You have two choices, the official or unofficial way. 64bit kernels can
be used with a 64 or 32bit filesystem.

-   Official: You can simply login on your Chromebook and go to
    chrome://help , then change the channel from stable to Dev.

To check your kernel(currently the ChromeOS filesystem is 32bit), run:

    # sudo modprobe configs && zcat /proc/config.gz | grep CONFIG_64BIT ; uname -m

If you have a 64bit kernel you will see the output CONFIG_64BIT=y and
x86_64.

Or

-   Unofficial: Run these commands from within ChromeOS before
    rebooting.

    # wget http://grayhatter.com/public/archC7/zgb-x64-kernel-partition.bz2
    # bunzip2 zgb-x64-kernel-partition.bz2
    # use_kernfs="zgb-x64-kernel-partition"
    # target_kern="/dev/sda6"
    # vbutil_kernel --repack $use_kernfs \
     --keyblock /usr/share/vboot/devkeys/kernel.keyblock \
     --version 1 \
     --signprivate /usr/share/vboot/devkeys/kernel_data_key.vbprivk \
     --oldblob $use_kernfs
    # dd if=$use_kernfs of=${target_kern}

> Finishing Up

-   Reboot and enjoy your Arch install! Note that ChrUbuntu's installer
    only told cgpt to boot to the Linux partition one time, so if
    anything is hosed, a reboot will send you back to ChromeOS. If all
    went well and you are happy with everything, you can reboot to
    ChromeOS, drop to the Ctrl+Alt+F2 console, and run a `sudo cgpt add
    -i 6 -P 5 -S 1 /dev/sda` to make the Chromebook always boot Arch.

Extra - Reduce Boot Time(DANGEROUS)
-----------------------------------

To see how dangerous this is; see bricking, unbricking, and lessions
learned.

There is a way to silence the developer screen while reduce the auto
boot time to three seconds(vs 30), removing the need to hit Ctrl+d each
boot. This is dangerous because you can brick your Chromebook, requiring
a JTAG to recover. These steps have been fully tested several times on
several Acer C7 revisions. The BIOS flashing does not start if anything
is unstable, having built in protection. Proceed with caution.

-   Make sure the battery is completely full, Acer C7 is plugged in, and
    booted into ChromeOS.
-   Press Ctrl+Alt+F2 or Ctrl+Alt+T to get to a terminal (log in if you
    use Ctrl+Alt+F2)

    # cd ~/Downloads
    # shell
    # sudo -s
    # flashrom -r bios.bin # Back up old BIOS
    # gbb_utility –set –flags=0×01 bios.bin bios.new # Modifies the BIOS as needed

-   Refer to this image to find the "Write Protect Jumper"
    http://goo.gl/4OuGrw
-   Short the BIOS protect jumper, making sure the connection is stable.
    Jumpers from an old IDE HDD should work, I used a small knife.

    # flashrom” again – “flashrom -w bios.new # Flashes the modified BIOS

-   If this command fails, the jumpers are not fully shorted or the
    connection became unstable on the jumpers. It will revert if the
    connection becomes unstable at any time. If it fails while in a
    flash, DO NOT REBOOT! Flash again until it works if it started the
    flash, ensuring tools recovery works and that you didn't have a bad
    flash. Do not rely on the built in check.
-   If successful, you should have a working BIOS mod. Reboot. The
    developer mode screen should vanish in three seconds, silently!
-   Back up bios.bin and bios.new to another machine or the cloud in
    case you ever want to revert.

See Also
--------

-   Official developer information, straight from Chromium.org
-   The ChrUbuntu script official Github
-   The official ChrUbuntu script site for the older script. It has tips
    on cgpt commands and other info.
-   Source for BIOS modification (for different device, this page shows
    correct procedure for C7)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_C7_Chromebook&oldid=289735"

Category:

-   Acer

-   This page was last modified on 21 December 2013, at 03:47.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
