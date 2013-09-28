TLP
===

TLP is an advanced power management tool for Linux. It is a pure command
line tool with automated background tasks and does not contain a GUI.

TLP is available in the AUR: tlp, tlp-rdw.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Features                                                           |
| -   2 Installation                                                       |
| -   3 Start                                                              |
| -   4 Configuration                                                      |
| -   5 Kernel 2.6.39                                                      |
| -   6 External Links                                                     |
+--------------------------------------------------------------------------+

Features
--------

Read the the full documentation at the project homepage.

Installation
------------

Install the following packages plus dependencies:

-   tlp (AUR) – Power saving
-   tlp-rdw (AUR) – optional, Radio Device Wizard
-   tp_smapi (Community) – optional ThinkPad only, tp-smapi is needed
    for battery charge thresholds and ThinkPad specific status output of
    tlp-stat
-   dkms-acpi_call-git (AUR) – optional ThinkPad only, acpi_call is
    needed for battery charge thresholds on Sandy Bridge and newer
    models (X220/T420, X230/T430 et al.)

Start
-----

After successful installation, you can start TLP by typing as root/with
sudo:

    tlp start

To run TLP automatically upon system startup, enable the service via:

     systemctl enable tlp.service

Hint: the above step is also necessary when upgrading to 0.3.8.1 because
the service name changed.

Configuration
-------------

The config file is located at /etc/default/tlp.

The default configuration provides optimized power saving out of the
box. For a full list of options see: TLP Configuration.

To make use of the ThinkPad-specific battery options, install and
configure tp_smapi and/or acpi_call (see Installation).

Kernel 2.6.39
-------------

According to this thread, the kernel 2.6.39 does not allow user-settings
to

    /sys/module/pcie_aspm/parameters/policy

You can use PCIe ASPM settings by starting the kernel with

    pcie_aspm=force

External Links
--------------

-   TLP - Linux Advanced Power Management - Project homepage &
    documentation

Retrieved from
"https://wiki.archlinux.org/index.php?title=TLP&oldid=253936"

Category:

-   Power management
