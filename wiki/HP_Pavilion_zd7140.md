HP Pavilion zd7140
==================

Another work in Progress - by PhrakTure I am currently running Arch on
this laptop, 98% problem free... and no I have not yet configured the
media card reader, as I have no use for it. If anyone really has a
problem, let me know (PM from forums).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Modules                                                            |
| -   2 Other                                                              |
| -   3 Unusual settings                                                   |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Modules
-------

-   Ethernet: 8139too
-   Wireless: ndiswrapper using BCMWL5A [pkg] [PKGBUILD]
-   Audio: snd-intel-8x0 / snd-pcm-oss
-   Video: nvidia [1]

Other
-----

-   Composite: works, but gets goofy with flash animations in Firefox

Unusual settings
----------------

-   Video mode detected wrong

Add the following to the device (nvidia driver) section in xorg.conf

    Option "IgnoreEDID" "True"

-   And the following line to the "Monitor" section  

        Modeline "1440x900"  106.47  1440 1520 1672 1904  900 901 904 932  -hsync +vsync

The following Display Subsection (in the Screen Section) will allow you
to use the display's native viewing mode.

    Subsection "Display"
      Depth       24
      Modes "1440x900"
      Virtual 1440 900
    EndSubsection

See also
--------

-   This report is listed at the TuxMobil: Linux Laptop and Notebook
    Installation Guides Survey: Hewlett-Packard - HP.

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Pavilion_zd7140&oldid=196648"

Category:

-   HP
