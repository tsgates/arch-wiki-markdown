Mullvad
=======

Using Mullvad as plain OpenVPN
------------------------------

To use the VPN service Mullvad on Arch Linux a few small adjustments
need to be done. First, install OpenVPN and resolvconf. Download the
plain OpenVPN version of Mullvad "here". Next, copy the content of the
zip file to /etc/openvpn. Open the file mullvad_linux.conf and change
the end of the file from

    mullvad_linux.conf

    # Parses DHCP options from openvpn to update resolv.conf
    up /etc/openvpn/update-resolv-conf
    down /etc/openvpn/update-resolv-conf

    ping 10

    ca master.mullvad.net.crt
    cert mullvad.crt
    key mullvad.key

to

    mullvad_linux.conf

    # Parses DHCP options from openvpn to update resolv.conf
    # up /etc/openvpn/update-resolv-conf
    # down /etc/openvpn/update-resolv-conf
    up /usr/share/openvpn/update-resolv-conf
    down /usr/share/openvpn/update-resolv-conf

    ping 10

    ca /etc/openvpn/master.mullvad.net.crt
    cert /etc/openvpn/mullvad.crt
    key /etc/openvpn/mullvad.key

and make it executable by running

       sudo chmod +x /etc/openvpn/mullvad_linux.conf

Load the tun module by creating the file

    /etc/modules-load.d/tun.conf

    # Load tun.ko at boot
    tun

and create

    /usr/share/openvpn/update-resolv-conf

    #!/bin/bash
    #
    # Parses DHCP options from openvpn to update resolv.conf
    # To use set as 'up' and 'down' script in your openvpn *.conf:
    # up /etc/openvpn/update-resolv-conf
    # down /etc/openvpn/update-resolv-conf
    #
    # Used snippets of resolvconf script by Thomas Hood <jdthood@yahoo.co.uk>
    # and Chris Hanson
    # Licensed under the GNU GPL.  See /usr/share/common-licenses/GPL.
    #
    # 05/2006 chlauber@bnc.ch
    #
    # Example envs set from openvpn:
    # foreign_option_1='dhcp-option DNS 193.43.27.132'
    # foreign_option_2='dhcp-option DNS 193.43.27.133'
    # foreign_option_3='dhcp-option DOMAIN be.bnc.ch'

    [ -x /usr/sbin/resolvconf ] || exit 0

    case $script_type in

    up)
       for optionname in ${!foreign_option_*} ; do
          option="${!optionname}"
          echo $option
          part1=$(echo "$option" | cut -d " " -f 1)
          if [ "$part1" == "dhcp-option" ] ; then
             part2=$(echo "$option" | cut -d " " -f 2)
             part3=$(echo "$option" | cut -d " " -f 3)
             if [ "$part2" == "DNS" ] ; then
                IF_DNS_NAMESERVERS="$IF_DNS_NAMESERVERS $part3"
             fi
             if [ "$part2" == "DOMAIN" ] ; then
                IF_DNS_SEARCH="$part3"
             fi
          fi
       done
       R=""
       if [ "$IF_DNS_SEARCH" ] ; then
               R="${R}search $IF_DNS_SEARCH
    "
       fi
       for NS in $IF_DNS_NAMESERVERS ; do
               R="${R}nameserver $NS
    "
       done
       echo -n "$R" | /usr/sbin/resolvconf -a "${dev}.inet"
       ;;
    down)
       /usr/sbin/resolvconf -d "${dev}.inet"
       ;;
    esac

and don't forget to make it executable by running

       sudo chmod +x /usr/share/openvpn/update-resolv-conf

Lastly create the file

    /usr/bin/mullvad

    #! /bin/bash
    # Script to start Mullvad
    gksu openvpn /etc/openvpn/mullvad_linux.conf

make it executable

       sudo chmod +x /usr/bin/mullvad

and simply run Mullvad in the terminal by typing

       mullvad

To create a menu item we need the logo

       wget https://mullvad.net/images/logo.png -O /usr/share/icons/mullvad.png

Then create the .desktop file

    /usr/share/applications/mullvad.desktop

    [Desktop Entry]
    Type=Application
    Icon=/usr/share/icons/mullvad.png
    Name=Mullvad
    Comment=Start Mullvad VPN service
    Exec=mullvad
    Categories=Network

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mullvad&oldid=262390"

Category:

-   Virtual Private Network

-   This page was last modified on 11 June 2013, at 17:17.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
