IBM ThinkPad T42
================

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This page documents configuration and troubleshooting of the IBM
ThinkPad T42. The T42 ThinkWiki page is an indispensable and easy
reference.

See the Beginners' guide for installation instructions.

Contents
--------

-   1 ACPI
-   2 CPU frequency scaling
-   3 Suspend and hibernate
-   4 Wireless
    -   4.1 The IBM Cards
    -   4.2 The Intel Cards
    -   4.3 More Information on Wireless

ACPI
----

Add thinkpad_acpi to your MODULES array in /etc/rc.conf

See acpid and laptop for more information.

See http://www.thinkwiki.org/wiki/How_to_make_ACPI_work for more
thinkpad specific information.

CPU frequency scaling
---------------------

See cpufrequtils.

Suspend and hibernate
---------------------

See pm-utils.

Wireless
--------

The MiniPCI slot on the T42 usually comes with 1 of 6 wireless cards, 3
by IBM and 3 by Intel.

> The IBM Cards

-   IBM 11b/g Wireless LAN Mini PCI Adapter (use madwifi)
-   IBM 11a/b/g Wireless LAN Mini PCI Adapter (use madwifi)
-   IBM 11a/b/g Wireless LAN Mini PCI Adapter II (use madwifi)

You can use the atheros madwifi's ath_pci module (Package: madwifi). or
the newer ath5k module (since kernel 2.6.27). However I used the former
since at that time it was the most stable and had fully functional wpa
encryption. For the ath5k modlule, please read this. Otherwise to load
the madwifi driver, type:

    # modprobe ath_pci

If using ath_pci, you may need to blacklist ath5k by adding it to the
MODULES= array in /etc/rc.conf, and subsequently prefixing it with a
bang (!):

    MODULES=(ath_pci !ath5k forcedeth snd_intel8x0 ... ...)

Note:If despite trying everything the wireless still doesn't work, try a
reboot!

Installing these madwifi drivers is common; consult the main Wireless
network configuration document for detailed instructions, and the
ThinkWiki pages[1] for Thinkpad specific instructions.

> The Intel Cards

To configure the Intel cards see here.

If an Archer has experience with a T42 that uses the Intel PRO wireless
card, please modify this document to include information about:

-   Intel PRO/Wireless LAN 2100 3B Mini PCI Adapter (use ipw2100)
-   Intel PRO/Wireless 2200BG Mini-PCI Adapter (use ipw2200)
-   Intel PRO/Wireless 2915ABG Mini-PCI Adapter (use ipw2200)

> More Information on Wireless

For more details, wireless encryption configurations or problems
solutions, please visit:

-   Wireless network configuration
-   Netctl
-   Wpa_supplicant

Retrieved from
"https://wiki.archlinux.org/index.php?title=IBM_ThinkPad_T42&oldid=298021"

Category:

-   IBM

-   This page was last modified on 16 February 2014, at 07:04.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
