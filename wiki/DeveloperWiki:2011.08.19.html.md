DeveloperWiki:2011.08.19
========================

Contents
--------

-   1 Summary
-   2 Main package changes
-   3 Package versions in LiveCD environment
-   4 Package versions in /repo/core/i686

Summary
-------

Built at:19. Aug 2011 (promoted testbuilds)   
 Announced at:20 Aug 2011  

Kernel:linux 3.0.3-1

Main package changes
--------------------

-   Removed:

    aufs2
    aufs2-util
    gen-init-cpio
    joe
    linux-atm
    mtools
    ndiswrapper
    ndiswrapper-utils
    perl-digest-sha1
    perl-passwd-md5
    sqlite3
    squashfs-tools
    tcp_wrappers
    tiacx
    tiacx-firmware

-   Replaced:

    dcron -> cronie
    heimdal -> krb5
    iwlwifi-3945-ucode -> linux-firmware
    iwlwifi-4965-ucode -> linux-firmware
    iwlwifi-5000-ucode -> linux-firmware
    iwlwifi-5150-ucode -> linux-firmware
    kernel26 -> linux
    kernel26-firmware -> linux-firmware
    mailx -> heirloom-mailx
    rt2x00-rt61-fw -> linux-firmware
    rt2x00-rt71w-fw -> linux-firmware
    spidermonkey -> js
    util-linux-ng -> util-linux
    xz-utils -> xz

-   Added:

    btrfs-progs-unstable
    ca-certificates
    crda
    curl
    dhclient
    dnsmasq
    gc
    hdparm
    iana-etc
    idnkit
    iw
    keyutils
    libedit
    libpipeline
    libproxy
    libssh2
    libusb-compat
    libxml2
    mkinitcpio-nfs-utils
    nbd
    netcfg
    nettle
    nilfs-utils
    openconnect
    rsync
    run-parts
    tre
    vpnc
    wireless-regdb
    wpa_actiond

Package versions in LiveCD environment
--------------------------------------

    acl 2.2.51-1
    aif 2011.08.19-1
    attr 2.4.46-1
    b43-fwcutter 014-1
    bash 4.2.010-1
    binutils 2.21.1-1
    btrfs-progs-unstable 0.19.20101006-1
    bzip2 1.0.6-1
    ca-certificates 20110421-3
    coreutils 8.12-3
    cracklib 2.8.18-1
    crda 1.1.1-3
    cronie 1.4.8-1
    cryptsetup 1.3.1-2
    curl 7.21.7-1
    db 5.2.28-1
    dbus-core 1.4.14-1
    ddrescue 1.14-1
    device-mapper 2.02.87-1
    dhclient 4.2.1.1-1
    dhcpcd 5.2.12-1
    dialog 1.1_20110707-1
    diffutils 3.1-1
    dmraid 1.0.0.rc16.3-2
    dnsmasq 2.57-1
    dnsutils 9.8.0.P4-1
    dosfstools 3.0.11-1
    e2fsprogs 1.41.14-1
    elinks 0.13-8
    eventlog 0.2.12-2
    expat 2.0.1-6
    file 5.08-1
    filesystem 2011.08-1
    findutils 4.4.2-3
    fuse 2.8.5-1
    gawk 4.0.0-1
    gc 7.1-3
    gcc-libs 4.6.1-2
    gdbm 1.8.3-8
    gettext 0.18.1.1-3
    glib2 2.28.8-1
    glibc 2.14-4
    gmp 5.0.2-2
    gnu-netcat 0.7.1-3
    gnutls 3.0.0-2
    gpm 1.20.6-6
    grep 2.9-1
    groff 1.21-1
    grub 0.97-20
    gzip 1.4-2
    hdparm 9.37-1
    heirloom-mailx 12.5-2
    iana-etc 2.30-2
    idnkit 1.0-1
    inetutils 1.8-3
    initscripts 2011.07.3-1
    iproute2 2.6.39-1
    iputils 20101006-1
    ipw2100-fw 1.3-5
    ipw2200-fw 3.1-3
    iw 3.0-1
    jfsutils 1.1.15-2
    js 1.8.5-3
    kbd 1.15.3-1
    keyutils 1.5.2-1
    krb5 1.9.1-3
    less 444-1
    lftp 4.3.1-2
    libarchive 2.8.4-2
    libcap 2.22-1
    libedit 20110802_3.0-1
    libevent 2.0.12-1
    libfetch 2.33-3
    libgcrypt 1.5.0-1
    libgpg-error 1.10-1
    libgssglue 0.3-1
    libidn 1.22-1
    libldap 2.4.26-3
    libnl 1.1-2
    libpcap 1.1.1-2
    libpipeline 1.2.0-1
    libproxy 0.4.7-1
    librpcsecgss 0.19-5
    libsasl 2.1.23-7
    libssh2 1.2.7-2
    libtasn1 2.9-1
    libtirpc 0.2.2-2
    libui-sh 2011.08.19-1
    libusb 1.0.8-1
    libusb-compat 0.1.3-1
    libxml2 2.7.8-1
    licenses 2.8-1
    lilo 23.2-3
    linux 3.0.3-1
    linux-api-headers 2.6.39.1-1
    linux-firmware 20110727-1
    logrotate 3.8.0-1
    lua 5.1.4-6
    lvm2 2.02.87-1
    lzo2 2.05-1
    man-db 2.6.0.2-2
    man-pages 3.32-1
    mdadm 3.2.2-3
    memtest86+ 4.20-1
    mkinitcpio 0.7.2-1
    mkinitcpio-busybox 1.18.5-1
    mkinitcpio-nfs-utils 0.2-1
    module-init-tools 3.16-1
    nano 2.2.6-1
    nbd 2.9.23-1
    ncurses 5.9-1
    netcfg 2.6.7-1
    nettle 2.2-1
    net-tools 1.60-18
    nfsidmap 0.24-2
    nfs-utils 1.2.4-2
    nilfs-utils 2.0.23-1
    nmap 5.51-1
    nspr 4.8.8-1
    ntfs-3g 2011.4.12-1
    ntfsprogs 2011.4.12-1
    ntp 4.2.6.p3-3
    openconnect 1:3.02-1
    openssh 5.8p2-9
    openssl 1.0.0.d-1
    openvpn 2.2.1-1
    pacman 3.5.4-3
    pacman-mirrorlist 20110816-1
    pam 1.1.4-1
    parted 3.0-3
    pciutils 3.1.7-4
    pcmciautils 018-1
    pcre 8.13-1
    perl 5.14.1-3
    popt 1.16-3
    ppp 2.4.5-2
    pptpclient 1.7.2-3
    procps 3.2.8-4
    psmisc 22.14-1
    readline 6.2.001-2
    reiserfsprogs 3.6.21-3
    rpcbind 0.2.0-3
    rp-pppoe 3.10-7
    rsync 3.0.8-2
    run-parts 3.4.4-1
    sed 4.2.1-3
    shadow 4.1.4.3-2
    speedtouch 1.3.1-3
    sysfsutils 2.1.0-6
    syslinux 4.04-2
    syslog-ng 3.2.4-3
    sysvinit 2.88-2
    tar 1.26-1
    tcpdump 4.1.1-2
    texinfo 4.13a-5
    tre 0.8.0-1
    tzdata 2011h-1
    udev 173-3
    usbutils 003-1
    util-linux 2.19.1-3
    vi 1:050325-1
    vpnc 0.5.3.svn457-1
    wget 1.13.1-1
    which 2.20-4
    wireless-regdb 2010.11.24-1
    wireless_tools 29-4
    wpa_actiond 1.1-2
    wpa_supplicant 0.7.3-3
    xfsprogs 3.1.5-1
    xz 5.0.3-1
    zd1211-firmware 1.4-4
    zlib 1.2.5-3

Package versions in /repo/core/i686
-----------------------------------

This list is from the i686 medium, on x86_64 it should be the same
versions.

    acl-2.2.51-1-i686.pkg.tar.xz
    attr-2.4.46-1-i686.pkg.tar.xz
    autoconf-2.68-1-any.pkg.tar.xz
    automake-1.11.1-2-any.pkg.tar.xz
    b43-fwcutter-014-1-i686.pkg.tar.xz
    bash-4.2.010-1-i686.pkg.tar.xz
    bin86-0.16.18-1-i686.pkg.tar.xz
    binutils-2.21.1-1-i686.pkg.tar.xz
    bison-2.5-1-i686.pkg.tar.xz
    bridge-utils-1.4-4-i686.pkg.tar.xz
    btrfs-progs-unstable-0.19.20101006-1-i686.pkg.tar.xz
    bzip2-1.0.6-1-i686.pkg.tar.xz
    ca-certificates-20110421-3-any.pkg.tar.xz
    cloog-0.16.2-1-i686.pkg.tar.xz
    coreutils-8.12-3-i686.pkg.tar.xz
    cracklib-2.8.18-1-i686.pkg.tar.xz
    crda-1.1.1-3-i686.pkg.tar.xz
    cronie-1.4.8-1-i686.pkg.tar.xz
    cryptsetup-1.3.1-2-i686.pkg.tar.xz
    dash-0.5.7-2-i686.pkg.tar.xz
    db-5.2.28-1-i686.pkg.tar.xz
    dbus-core-1.4.14-1-i686.pkg.tar.xz
    device-mapper-2.02.87-1-i686.pkg.tar.xz
    dhcpcd-5.2.12-1-i686.pkg.tar.xz
    dialog-1.1_20110707-1-i686.pkg.tar.xz
    diffutils-3.1-1-i686.pkg.tar.xz
    dmraid-1.0.0.rc16.3-2-i686.pkg.tar.xz
    dnsutils-9.8.0.P4-1-i686.pkg.tar.xz
    e2fsprogs-1.41.14-1-i686.pkg.tar.xz
    ed-1.5-2-i686.pkg.tar.xz
    eventlog-0.2.12-2-i686.pkg.tar.xz
    expat-2.0.1-6-i686.pkg.tar.xz
    fakeroot-1.16-1-i686.pkg.tar.xz
    file-5.08-1-i686.pkg.tar.xz
    filesystem-2011.08-1-any.pkg.tar.xz
    findutils-4.4.2-3-i686.pkg.tar.xz
    flex-2.5.35-4-i686.pkg.tar.xz
    gawk-4.0.0-1-i686.pkg.tar.xz
    gcc-4.6.1-2-i686.pkg.tar.xz
    gcc-libs-4.6.1-2-i686.pkg.tar.xz
    gdbm-1.8.3-8-i686.pkg.tar.xz
    gettext-0.18.1.1-3-i686.pkg.tar.xz
    glib2-2.28.8-1-i686.pkg.tar.xz
    glibc-2.14-4-i686.pkg.tar.xz
    gmp-5.0.2-2-i686.pkg.tar.xz
    gpm-1.20.6-6-i686.pkg.tar.xz
    grep-2.9-1-i686.pkg.tar.xz
    groff-1.21-1-i686.pkg.tar.xz
    grub-0.97-20-i686.pkg.tar.xz
    gzip-1.4-2-i686.pkg.tar.xz
    hdparm-9.37-1-i686.pkg.tar.xz
    heirloom-mailx-12.5-2-i686.pkg.tar.xz
    iana-etc-2.30-2-any.pkg.tar.xz
    idnkit-1.0-1-i686.pkg.tar.xz
    ifenslave-1.1.0-6-i686.pkg.tar.xz
    inetutils-1.8-3-i686.pkg.tar.xz
    initscripts-2011.07.3-1-i686.pkg.tar.xz
    iproute2-2.6.39-1-i686.pkg.tar.xz
    iptables-1.4.12-2-i686.pkg.tar.xz
    iputils-20101006-1-i686.pkg.tar.xz
    ipw2100-fw-1.3-5-any.pkg.tar.xz
    ipw2200-fw-3.1-3-any.pkg.tar.xz
    isdn4k-utils-3.2p1-6-i686.pkg.tar.xz
    isl-0.06-1-i686.pkg.tar.xz
    iw-3.0-1-i686.pkg.tar.xz
    jfsutils-1.1.15-2-i686.pkg.tar.xz
    kbd-1.15.3-1-i686.pkg.tar.xz
    kernel26-lts-2.6.32.45-1-i686.pkg.tar.xz
    kernel26-lts-headers-2.6.32.45-1-i686.pkg.tar.xz
    keyutils-1.5.2-1-i686.pkg.tar.xz
    krb5-1.9.1-3-i686.pkg.tar.xz
    less-444-1-i686.pkg.tar.xz
    libarchive-2.8.4-2-i686.pkg.tar.gz
    libcap-2.22-1-i686.pkg.tar.xz
    libedit-20110802_3.0-1-i686.pkg.tar.xz
    libevent-2.0.12-1-i686.pkg.tar.xz
    libfetch-2.33-3-i686.pkg.tar.gz
    libgcrypt-1.5.0-1-i686.pkg.tar.xz
    libgpg-error-1.10-1-i686.pkg.tar.xz
    libgssglue-0.3-1-i686.pkg.tar.xz
    libldap-2.4.26-3-i686.pkg.tar.xz
    libmpc-0.9-1-i686.pkg.tar.xz
    libnl-1.1-2-i686.pkg.tar.xz
    libpcap-1.1.1-2-i686.pkg.tar.xz
    libpipeline-1.2.0-1-i686.pkg.tar.xz
    librpcsecgss-0.19-5-i686.pkg.tar.xz
    libsasl-2.1.23-7-i686.pkg.tar.xz
    libtirpc-0.2.2-2-i686.pkg.tar.xz
    libtool-2.4-4-i686.pkg.tar.xz
    libusb-1.0.8-1-i686.pkg.tar.xz
    libusb-compat-0.1.3-1-i686.pkg.tar.xz
    licenses-2.8-1-any.pkg.tar.xz
    lilo-23.2-3-i686.pkg.tar.xz
    links-2.3-1-i686.pkg.tar.xz
    linux-3.0.3-1-i686.pkg.tar.xz
    linux-api-headers-2.6.39.1-1-i686.pkg.tar.xz
    linux-atm-2.5.1-2-i686.pkg.tar.xz
    linux-docs-3.0.3-1-i686.pkg.tar.xz
    linux-firmware-20110727-1-any.pkg.tar.xz
    linux-headers-3.0.3-1-i686.pkg.tar.xz
    logrotate-3.8.0-1-i686.pkg.tar.xz
    lvm2-2.02.87-1-i686.pkg.tar.xz
    lzo2-2.05-1-i686.pkg.tar.xz
    m4-1.4.16-1-i686.pkg.tar.xz
    make-3.82-3-i686.pkg.tar.xz
    man-db-2.6.0.2-2-i686.pkg.tar.xz
    man-pages-3.32-1-any.pkg.tar.xz
    mdadm-3.2.2-3-i686.pkg.tar.xz
    mkinitcpio-0.7.2-1-any.pkg.tar.xz
    mkinitcpio-busybox-1.18.5-1-i686.pkg.tar.xz
    mkinitcpio-nfs-utils-0.2-1-i686.pkg.tar.gz
    mlocate-0.24-1-i686.pkg.tar.xz
    module-init-tools-3.16-1-i686.pkg.tar.xz
    mpfr-3.0.1.p4-1-i686.pkg.tar.xz
    nano-2.2.6-1-i686.pkg.tar.xz
    ncurses-5.9-1-i686.pkg.tar.xz
    netcfg-2.6.7-1-any.pkg.tar.xz
    net-tools-1.60-18-i686.pkg.tar.xz
    nfsidmap-0.24-2-i686.pkg.tar.xz
    nfs-utils-1.2.4-2-i686.pkg.tar.xz
    nilfs-utils-2.0.23-1-i686.pkg.tar.xz
    openldap-2.4.26-3-i686.pkg.tar.xz
    openssh-5.8p2-9-i686.pkg.tar.xz
    openssl-1.0.0.d-1-i686.pkg.tar.gz
    openvpn-2.2.1-1-i686.pkg.tar.xz
    pacman-3.5.4-3-i686.pkg.tar.gz
    pacman-mirrorlist-20110816-1-any.pkg.tar.gz
    pam-1.1.4-1-i686.pkg.tar.xz
    patch-2.6.1-2-i686.pkg.tar.xz
    pciutils-3.1.7-4-i686.pkg.tar.xz
    pcmciautils-018-1-i686.pkg.tar.xz
    pcre-8.13-1-i686.pkg.tar.xz
    perl-5.14.1-3-i686.pkg.tar.xz
    pkg-config-0.26-1-i686.pkg.tar.xz
    popt-1.16-3-i686.pkg.tar.xz
    ppl-0.11.2-1-i686.pkg.tar.xz
    ppp-2.4.5-2-i686.pkg.tar.xz
    pptpclient-1.7.2-3-i686.pkg.tar.xz
    procinfo-ng-2.0.304-2-i686.pkg.tar.xz
    procps-3.2.8-4-i686.pkg.tar.xz
    psmisc-22.14-1-i686.pkg.tar.xz
    readline-6.2.001-2-i686.pkg.tar.xz
    reiserfsprogs-3.6.21-3-i686.pkg.tar.xz
    rfkill-0.4-2-i686.pkg.tar.xz
    rpcbind-0.2.0-3-i686.pkg.tar.xz
    rp-pppoe-3.10-7-i686.pkg.tar.xz
    run-parts-3.4.4-1-i686.pkg.tar.xz
    sdparm-1.06-1-i686.pkg.tar.xz
    sed-4.2.1-3-i686.pkg.tar.xz
    shadow-4.1.4.3-2-i686.pkg.tar.xz
    sqlite3-3.7.7.1-1-i686.pkg.tar.xz
    sqlite3-doc-3.7.7.1-1-i686.pkg.tar.xz
    sqlite3-tcl-3.7.7.1-1-i686.pkg.tar.xz
    sudo-1.8.1.p2-1-i686.pkg.tar.xz
    sysfsutils-2.1.0-6-i686.pkg.tar.xz
    syslinux-4.04-2-i686.pkg.tar.xz
    syslog-ng-3.2.4-3-i686.pkg.tar.xz
    sysvinit-2.88-2-i686.pkg.tar.xz
    tar-1.26-1-i686.pkg.tar.xz
    texinfo-4.13a-5-i686.pkg.tar.xz
    tzdata-2011h-1-i686.pkg.tar.xz
    udev-173-3-i686.pkg.tar.xz
    udev-compat-173-3-i686.pkg.tar.xz
    usbutils-003-1-i686.pkg.tar.xz
    util-linux-2.19.1-3-i686.pkg.tar.xz
    vi-1:050325-1-i686.pkg.tar.xz
    wget-1.13.1-1-i686.pkg.tar.xz
    which-2.20-4-i686.pkg.tar.xz
    wireless-regdb-2010.11.24-1-any.pkg.tar.xz
    wireless_tools-29-4-i686.pkg.tar.xz
    wpa_actiond-1.1-2-i686.pkg.tar.xz
    wpa_supplicant-0.7.3-3-i686.pkg.tar.xz
    xfsprogs-3.1.5-1-i686.pkg.tar.xz
    xinetd-2.3.14-7-i686.pkg.tar.xz
    xz-5.0.3-1-i686.pkg.tar.gz
    zd1211-firmware-1.4-4-any.pkg.tar.xz
    zlib-1.2.5-3-i686.pkg.tar.xz

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:2011.08.19&oldid=239000"

Category:

-   DeveloperWiki

-   This page was last modified on 6 December 2012, at 01:22.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
