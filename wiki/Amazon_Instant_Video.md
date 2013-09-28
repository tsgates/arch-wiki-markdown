Amazon Instant Video
====================

If you try to watch Amazon Instant Video, you may see the following
error: an error occurred and your player could not be updated

Amazon Instant Video requires the HAL daemon to be running. As it is
deprecated, it is not likely to be installed on newer systems. Checking
to see if hal is installed is easy, simply run the following command:

    $ pacman -Qi hal hal-info

If hal is not installed, you will need to install hal and hal-info from
the AUR. hal-info is a dependency of hal and should be installed first.

Once you have confirmed that hal is installed, start the daemon.

sysvinit:

    # /etc/rc.d/hal start

systemd:

    # systemctl start hal.service

You may also wish to enable the daemon at boot, either by adding hal to
your DAEMONS array in /etc/rc.conf (if using sysvinit), or by running
systemctl enable hal.service as root (if running systemd).

Finally, remove some Flash Player cached files:

    $ cd ~/.adobe/Flash_Player
    $ rm -rf NativeCache AssetCache APSPrivateData2

Retrieved from
"https://wiki.archlinux.org/index.php?title=Amazon_Instant_Video&oldid=248381"

Category:

-   Player
