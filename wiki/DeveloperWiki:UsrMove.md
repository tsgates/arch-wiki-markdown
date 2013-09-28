DeveloperWiki:UsrMove
=====================

This page is for planning.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Stage 1: Packages with files in /lib                               |
|     -   1.1 libraries                                                    |
|     -   1.2 initcpio                                                     |
|     -   1.3 systemd service files                                        |
|     -   1.4 udev rules                                                   |
|     -   1.5 modprobe                                                     |
|     -   1.6 firmware                                                     |
|     -   1.7 security                                                     |
|     -   1.8 modules                                                      |
|     -   1.9 left until the very end                                      |
+--------------------------------------------------------------------------+

Stage 1: Packages with files in /lib
------------------------------------

1.  rebuild kmod/systemd/udev to read config from both /lib and
    /usr/lib, keep /lib/modules in place, and accept both /lib/firmware
    and /usr/lib/firmware (prefering the latter). Rebuild packages with
    helpers in /lib/{udev,systemd}/ at the same time [DONE]
2.  rebuild packages with libs, or config files one at a time [DONE]
3.  rebuild /lib/security [DONE]
4.  rebuild /lib/modules (linux, kmod, and all other packages which
    create or package modules) [DONE -- in testing]
5.  rebuild glibc with /lib symlinked to /usr/lib. With /lib only having
    files owned by glibc, this is possible to do in a single
    transaction.
6.  remove any temporary hacks in order to support both /usr/lib and
    /lib in udev+kmod+systemd

Steps 1 through 3 are complete. Once step 4 moves from [testing], a
final glibc package will reclaim /lib as a symlink instead of a
directory.

At each step we must consider how to alert people who have installed
third party software.

libraries

Plan: Simple rebuild.

    acl
    attr
    bzip2
    cryptsetup
    dmraid
    e2fsprogs
    e4rat
    fuse
    keyutils
    libcap
    libgcrypt
    libgpg-error
    lvm2
    multipath-tools
    nilfs-utils
    nss_ldap
    ntfs-3g_ntfsprogs
    pam
    popt
    procps
    readline
    samba
    sysfsutils
    xfsprogs

initcpio

Plan: Simple rebuild.

    archboot
    cryptsetup
    dmraid
    lvm2
    mdadm
    mkinitcpio-nfs-utils
    v86d

systemd service files

Plan: Simple rebuild.

    accountsservice
    alsa-utils
    avahi
    backuppc
    bird
    bitlbee
    colord
    consolekit
    dbus-core
    dnsmasq
    libcanberra
    linux-tools
    lm_sensors
    mpd
    netcfg
    networkmanager
    ossp
    pcsclite
    radvd
    rsyslog
    rtkit
    shorewall
    stunnel
    syslog-ng
    wicd

udev rules

Plan: Simple rebuild.

    alsa-utils
    bluez
    capi4hylafax
    cdemu-daemon
    colord
    crda
    drbd
    fuse
    gnome-bluetooth
    gpsd
    hplip
    jack
    jack2
    jack2-multilib
    kino
    libffado
    libfprint
    libgphoto2
    lvm2
    mdadm
    media-player-info
    modemmanager
    networkmanager
    ossp
    ozerocdoff
    pulseaudio
    qemu
    qemu-kvm
    rfkill
    sane
    upower
    usbmuxd
    v4l-utils
    virtualbox
    virtualbox-modules
    xf86-input-vmmouse
    xf86-input-wacom

modprobe

Plan: Simple rebuild.

    nvidia
    nvidia-lts

firmware

Plan: Likely a simple rebuild, as udev has support for both
/lib/firmware and /usr/lib/firmware. However, we should double check
that nothing else reads from /lib/firmware directly.

    alsa-firmware
    amd-ucode
    bluez-firmware
    intel-ucode
    ipw2100-fw
    ipw2200-fw
    ivtv-utils
    linux-atm
    linux-firmware
    zd1211-firmware

security

Plan: Rebuild together.

    consolekit
    ecryptfs-utils
    fprintd
    gnome-keyring
    libcap
    pam
    pam-krb5
    pam_ldap
    pam_mysql
    pam_pwcheck
    samba
    systemd
    thinkfinger
    virtualbox

modules

Plan: Simultaneous rebuild, together with kmod+udev. Need to consider
custom kernels. Possibly add symlink /lib/modules -> /usr/lib/modules,
if nothing else, this will conflict with custom kernels, making sure
nothing is left behind by accident.

    cdfs
    fcpci
    fcpcmcia
    filesystem
    linux
    linux-headers
    linux-lts
    linux-lts-headers
    lirc
    ndiswrapper
    nvidia
    nvidia-lts
    open-vm-tools-modules
    r8168
    r8168-lts
    rt3562sta
    slmodem
    vhba-module
    virtualbox-modules

left until the very end

    glibc
    lib32-glibc

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:UsrMove&oldid=212043"

Category:

-   DeveloperWiki
