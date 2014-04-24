Acer Aspire 1410
================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This page will eventually hold information to install Arch Linux on the
Acer Aspire 1410. Here is the (albeit empty) forum post for discussion:
https://bbs.archlinux.org/viewtopic.php?pid=626296

This laptop is almost perfect for Linux. It has Intel chipset on
motherboard (includes OpenGL 2.0-compatible video) and well-known
Atheros network devices (on some models). Even special keyboard and
suspend work fine.

Contents
--------

-   1 Summary
    -   1.1 Specifications
-   2 Installing Arch
    -   2.1 Pre-Install
    -   2.2 During the Installation
    -   2.3 Post-Install
        -   2.3.1 Kernel Issues
        -   2.3.2 Setup the Touchpad
        -   2.3.3 Fan Issues
        -   2.3.4 Panel aspect ratio
-   3 Extra resources

Summary
-------

> Specifications

+--------------------------+--------------------------+--------------------------+
| Hardware                 | Details                  | Driver/Status            |
+==========================+==========================+==========================+
| Graphics                 | Integrated Intel®        | Install xf86-video-intel |
|                          | Graphics Media           |                          |
|                          | Accelerator 4500MHD      |                          |
+--------------------------+--------------------------+--------------------------+
| Wireless                 | [8804] Intel WiFi Link   | Install                  |
|                          | 5100 802.11a/b/g/Draft-N | iwlwifi-5000-ucode       |
|                          | Wireless                 | Out-of-box (kernel       |
|                          | or Atheros AR9285        | module ath9k)            |
|                          | Wireless Network Adapter |                          |
+--------------------------+--------------------------+--------------------------+
| Ethernet                 | Attansic Technology      | Works out-of-box         |
|                          | Gigabit Ethernet         |                          |
|                          | or Atheros               |                          |
|                          | Communications Device    |                          |
|                          | 1063                     |                          |
+--------------------------+--------------------------+--------------------------+
| Audio                    | Built-in speakers        | Works                    |
|                          | Headphone Jack           | Works                    |
|                          |  Integrated Microphone   |  Untested                |
|                          |  Microphone Jack         |  Untested                |
+--------------------------+--------------------------+--------------------------+
| Card Reader              | 5-in-1 card reader:      | Untested                 |
|                          | MultiMediaCard™          |  Works                   |
|                          |  Secure Digital          |  Untested                |
|                          |  Memory Stick®           |  Works                   |
|                          |  Memory Stick PRO™       |  Works                   |
|                          |  xD-Picture Card™        |                          |
+--------------------------+--------------------------+--------------------------+
| Webcam                   | Chicony Electronics Co.  | Works out-of-box         |
|                          | Ltd                      |                          |
+--------------------------+--------------------------+--------------------------+
| Touchpad                 |                          | Install                  |
|                          |                          | xf86-input-evdev,        |
|                          |                          | xf86-input-synaptics     |
+--------------------------+--------------------------+--------------------------+
| HDMI Out                 |                          | Works OOTB               |
+--------------------------+--------------------------+--------------------------+

Installing Arch
---------------

> Pre-Install

If you are receiving errors booting or during the install, try setting
the SATA mode to "IDE" in the BIOS. This is not necessary for all users.

> During the Installation

Be sure to install the necessary wireless driver (see above),
"wireless_tools", and optionally "netcfg" if you would like wireless to
work post-install.

Note for beginners: connect to wifi-router directly by ethernet cable,
or completely switch-off authentication. After that install Arch from
network mirrors, reload and install network-manager with your preferred
Desktop Environment.

> Post-Install

Kernel Issues

Kernel 2.6.36 and 2.6.37 often freeze the system. Make sure to upgrade
to newest kernel. This also fixes issues with the touchpad.

Setup the Touchpad

Make sure to install xf86-input-synaptics. Don't forget to enable the
touchpad with <Fn>-F7. The following threads might also be interesting:
[1] [2]

Kernel 2.6.36 has an annoying bug makeing the touchpad finicky. A
temporary workaround [3] is:

    xinput --set-prop "SynPS/2 Synaptics TouchPad" "Synaptics Two-Finger Pressure" 280

Please note that since kernel 2.6.38 the touchpad works well and no such
fix is necessary.

Fan Issues

If the noise is running too often or making too much noise, try
installing the latest version of acerhdf.

Panel aspect ratio

Default mode for this laptop is 1366x768 (widescreen). Different
resolutions may look ugly because of whole-screen-stretching. To
overcome this do the command from regular user:

    xrandr --output LVDS1 --set "scaling mode" "Full aspect"

Extra resources
---------------

-   Official US site
-   Linux Laptop
-   Ubuntu wiki
-   Thread post containing specs of different models
-   Thread of tips, tricks, & tweaks
-   Power saving tips and tricks from Ubuntu forum

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_Aspire_1410&oldid=304888"

Category:

-   Acer

-   This page was last modified on 16 March 2014, at 08:58.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
