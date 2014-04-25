RTL-SDR
=======

Related articles

-   DVB-T
-   GNU Radio

RTL-SDR is a set of tools that enables DVB-T USB dongles based on the
Realtek RTL2832U chipset to be used as cheap software defined radios,
given that the chip allows transferring raw I/Q samples from the tuner
straight to the host device.

See the RTL-SDR wiki for exact technical specifications.

Packages
--------

The latest stable RTL-SDR version can be installed from rtl-sdr in the
official repositories.

Bleeding edge is on rtl-sdr-git in the AUR.

Note:RTL-SDR conflicts with existing DVB-T drivers in the kernel, and
upon installation blacklists the relevant drivers as can be seen in
/etc/modprobe.d/rtlsdr.conf. To use the dongle with the original DVB-T
drivers, it is required to manually load them, see DVB-T#Driver.

udev rules are installed at /etc/udev/rules.d/rtl-sdr.rules and set the
proper permissions such that non-root users can access the device.

Usage
-----

Performing a simple test, and make sure the dongle works and that there
are no lost samples:

    $ rtl_test

Raw samples can be captured directly to file (or fifo), for example to
tune to 123.4MHz and capture 1.8M samples/sec:

    $ rtl_sdr capture.bin -s 1.8e6 -f 123.4e6

Tune to your favorite radio station and pipe to sox for audio:

    $ rtl_fm -M wbfm -f 91.8M | play -r 32k -t raw -e signed-integer -b 16 -c 1 -V1 -

Applications
------------

Some popular applications that use RTL-SDR:

-   dump1090-git - a lightweight ModeS (1090Mhz) decoder
-   multimon-ng-git - a decoder for various digital modes

Retrieved from
"https://wiki.archlinux.org/index.php?title=RTL-SDR&oldid=299317"

Category:

-   Other hardware

-   This page was last modified on 20 February 2014, at 23:27.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
