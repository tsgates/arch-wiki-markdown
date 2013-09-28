Installation Template
=====================

Arch Linux 2012.07.15 Installation Template
-------------------------------------------

    Keyboard layout

    # ls /usr/share/kbd/keymaps/i386/qwerty
    # loadkeys us


    Internet connection

    # dhcpcd
    or
    # dhclient eth0
    or
    # ip link set dev eth0 up
    # ip addr add 192.168.1.2/24 dev eth0
    # ip route add default via 192.168.1.1
    # echo "nameserver 8.8.8.8" >> /etc/resolv.conf


    Correct time setting

    # ntpd -qg
    # hwclock -w
    or
    # date MMDDhhmmYYYY
    # hwclock --systohc
    or
    # hwclock --set --date="YYYY-MM-DD hh:mm:ss"
    # hwclock --hctosys


    Disk preparation

    # fdisk /dev/sda
    or
    # cfdisk /dev/sda
    OR
    # gdisk /dev/sda
    or
    # cgdisk /dev/sda

    # mkfs.ext4 /dev/sda1
    # mkswap /dev/sda4

    # mount /dev/sda1 /mnt
    # mount /dev/sda2 /mnt/boot
    # mount /dev/sda3 /mnt/home
    # swapon /dev/sda4


    Base system install

    # vi /etc/pacman.d/mirrorlist
    # pacstrap /mnt base base-devel


    Bootloader install

    # pacstrap /mnt syslinux
    or
    # pacstrap /mnt grub-bios
    or
    # pacstrap /mnt grub-efi-i386
    or
    # pacstrap /mnt grub-efi-x86_64


    System configuration

    # genfstab -p /mnt >> /mnt/etc/fstab
    or
    # genfstab -p -U /mnt >> /mnt/etc/fstab
    or
    # genfstab -p -L /mnt >> /mnt/etc/fstab
    # echo "/dev/sda4   swap   swap   defaults   0   0" >> /mnt/etc/fstab

    # arch-chroot /mnt
    # man archlinux
    # echo "archlinux" > /etc/hostname
    # vi /etc/hosts
    # vi /etc/rc.conf
    # echo "KEYMAP=us" > /etc/vconsole.conf
    # ln -s /usr/share/zoneinfo/Canada/Eastern /etc/localtime
    # vi /etc/locale.gen
    # locale-gen
    # echo "LANG=en_US.UTF-8" > /etc/locale.conf
    # vi /etc/mkinitcpio.conf
    # mkinitcpio -p linux
    # passwd


    Bootloader setup

    # syslinux-install_update -iam
    # vi /boot/syslinux/syslinux.cfg
    or (for GPT)
    # sgdisk /dev/sda -A N:set:2   # N=partition_number_of_/boot (example '7:set:2' for /dev/sda7)
    # dd bs=440 conv=notrunc count=1 if=/usr/lib/syslinux/gptmbr.bin of=/dev/sda
    # vi /boot/syslinux/syslinux.cfg
    or
    # grub-install --target=i386-pc --recheck --debug /dev/sda
    # grub-mkconfig -o /boot/grub/grub.cfg
    or
    # mkfs.vfat -F32 /dev/sda5
    # mkdir -p /boot/efi
    # mount -t vfat /dev/sda5 /boot/efi
    # modprobe dm-mod
    # grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --recheck --debug
    # mkdir -p /boot/grub/locale
    # cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
    # grub-mkconfig -o /boot/grub/grub.cfg


    Finish up

    # exit
    # umount /mnt/{boot,home,}
    # reboot

Retrieved from
"https://wiki.archlinux.org/index.php?title=Installation_Template&oldid=216967"

Category:

-   Getting and installing Arch
