Thinkpad Fan Control
====================

From the Thinkpad Fan Control website:

tp-fan monitors temperatures and controls fan speed of IBM/Lenovo
ThinkPad notebooks. tp-fan is an open-source project released under the
GPL v3.

The tpfand daemon controls the system fan in software. It can be used to
make the notebook more quiet. However this will also result in higher
system temperatures that may damage and/or shorten the lifespan of the
computer. Since version 0.90 fan trigger temperatures can be configured
separately for each temperature sensor.

This project also provides the tpfan-admin GTK+ frontend to monitor
system temperature and adjust fan trigger temperatures.

Warning: This program may damage your notebook. The author does not take
any responsibility for damages caused by the use of this program.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 tpfand                                                       |
|     -   1.2 tpfanco                                                      |
|                                                                          |
| -   2 Configuration                                                      |
|     -   2.1 Running                                                      |
+--------------------------------------------------------------------------+

Installation
------------

> tpfand

Note:tpfand is not actively developed anymore! There's a fork called
tpfanco (see below).

The tpfand daemon can be installed from the AUR. Alternatively, a
version that doesn't require HAL is also available from the AUR:
tpfand-no-hal

An additional GTK+ frontend is provided in the tpfan-admin package in
the AUR which enables the monitoring of temperatures as well as the
graphical adjustment of trigger points.

> tpfanco

Due to tpfand not beeing actively developed anymore, there's a fork
called tpfanco (which in fact uses the same names for the executables as
tpfand): tpfanco-svn. It may be used as a complete replacement for
tpfand.

Configuration
=============

The configuration file for tpfand (same for tpfanco) is found in
/etc/tpfand.conf. This file can be edited to adjust the fan trigger
points to suit your needs.

Additionally, the tpfand-profiles package in the AUR gives the latest
fan profiles for various thinkpad models.

Running
-------

The tpfand daemon can be started by running (as root):

    # systemctl start tpfand

or by automatically loading it on system startup:

    # systemctl enable tpfand

Retrieved from
"https://wiki.archlinux.org/index.php?title=Thinkpad_Fan_Control&oldid=247961"

Category:

-   Lenovo
