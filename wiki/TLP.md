TLP
===

Related articles

-   Laptop Mode Tools

TLP is an advanced power management tool for Linux.

It is a pure, command-line tool with automated background tasks and does
not contain a GUI.

Contents
--------

-   1 Features
-   2 Installation
-   3 Start
-   4 Configuration
-   5 See also

Features
--------

Read the full documentation at the project homepage.

Installation
------------

Install the tlp and tlp-rdw packages, which are available in the
official repositories.

Note: tlp conflicts with pm-utils (or any other power management tool
for that matter). This was worked around before in the AUR .install file
by replacing some pm-utils files with symlinks to tlp scripts. However
this workaround will not be used in an official package.

Optional dependencies are:

-   tp_smapi – optional ThinkPad only, tp-smapi is needed for battery
    charge thresholds and ThinkPad specific status output of tlp-stat
-   acpi_call – optional ThinkPad only, acpi_call is needed for battery
    charge thresholds on Sandy Bridge and newer models (X220/T420,
    X230/T430 et al.)

After package installation, it is mandatory to enable both contained
services via:

    # systemctl enable tlp
    # systemctl enable tlp-sleep

Important: if you want to use tlp-rdw – which in turn requires
NetworkManager – it is mandatory to enable the corresponding service:

    # systemctl enable NetworkManager-dispatcher

Start
-----

After successful installation, TLP starts automatically on every boot.

Configuration
-------------

The configuration file is located at /etc/default/tlp.

The default configuration provides optimized power saving out of the
box. For a full list of options, see: TLP Configuration.

To make use of the ThinkPad-specific battery options, install and
configure tp_smapi and/or acpi_call (see Installation).

See also
--------

-   TLP - Linux Advanced Power Management - Project homepage &
    documentation

Retrieved from
"https://wiki.archlinux.org/index.php?title=TLP&oldid=294741"

Category:

-   Power management

-   This page was last modified on 28 January 2014, at 08:36.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
