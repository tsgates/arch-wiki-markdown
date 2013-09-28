SSD Memory Cell Clearing
========================

Summary

This article presents a method to reset all cells on an SSD to their
factory default state thus recovering any loss of write performance.

Related Articles

Solid State Drives

Securely Wipe HDD

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 tl; dr                                                             |
| -   3 Step 1 - Make sure the drive security is not frozen                |
| -   4 Step 2 - Enable security by setting a user password                |
| -   5 Step 3 - Issue the ATA Secure Erase command                        |
| -   6 Tips                                                               |
+--------------------------------------------------------------------------+

Introduction
------------

On occasion, users may wish to completely reset an SSD's cells to the
same virgin state they were manufactured, thus restoring it to its
factory default write performance. Write performance is known to degrade
over time even on SSDs with native TRIM support. TRIM only safeguards
against file deletes, not replacements such as an incremental save.

Warning:Back up ALL data of importance prior to continuing! Using this
procedure will destroy ALL data on the SSD and render it unrecoverable
by even data recovery services! Users will have to repartition the
device and restore the data after completing this procedure!

Warning:Do not proceed with this if your drive isn't connected directly
to a SATA interface. Issuing the Secure Erase command on a drive
connected via USB or a SAS/RAID card could potentially brick the drive!

tl; dr
------

Warning:It is recommended that you read the rest of the article BEFORE
you try this!

    hdparm --user-master u --security-set-pass Eins /dev/sdX
    hdparm --user-master u --security-erase Eins /dev/sdX

Step 1 - Make sure the drive security is not frozen
---------------------------------------------------

Issue the following command:

    # hdparm -I /dev/sdX

If the command output shows "frozen" one cannot continue to the next
step. Most BIOSes block the ATA Secure Erase command by issuing a
"SECURITY FREEZE" command to "freeze" the drive before booting an
operating system.

A possible solution for SATA drives is hot-(re)plug the data cable
(which might crash the kernel). If hot-(re)plugging the SATA data cable
crashes the kernel try letting the operating system fully boot up, then
quickly hot-(re)plug both the SATA power and data cables.

-   It has been reported that hooking up the drive to an eSATA SIIG
    ExpressCard/54 with an eSATA enclosure will leave the drive security
    state to "not frozen".
-   Placing the target system into "sleep" (Clevo M865TU notebook,
    Fujitsu T2010 notebook, Dell XPS M1330, Lenovo ThinkPad x220/x230,
    Samsung NC10) and waking it up again has been reported to work as
    well; this may reset drives to "not frozen". In case you are booting
    from USB, you need a distribution, that runs entirely in RAM, like
    Grml, see the grml2ram option. Run echo -n mem > /sys/power/state to
    set the computer to sleep.
-   Hooking up the drive to a USB 2/3 port does NOT work, as you need to
    issue IDE commands, which is only possible via IDE/SATA connection.
-   Make sure drive security is disabled in BIOS, so no password is set:

    Security: 
            Master password revision code = 65534
                    supported
            not     enabled
            not     locked
            not     frozen
            not     expired: security count
                    supported: enhanced erase
            2min for SECURITY ERASE UNIT. 2min for ENHANCED SECURITY ERASE UNIT.

Step 2 - Enable security by setting a user password
---------------------------------------------------

Note:When the user password is set the drive will be locked after next
power cycle denying normal access until unlocked with the correct
password.

Any password will do, as this should only be temporary. After the secure
erase the password will be set back to NULL. In this example, the
password is "Eins" as shown:

    # hdparm --user-master u --security-set-pass Eins /dev/sdX
    security_password="Eins"
    /dev/sdX:
    Issuing SECURITY_SET_PASS command, password="Eins", user=user, mode=high

As a sanity check, issue the following command

    # hdparm -I /dev/sdX

The command output should display "enabled":

     Security: 
            Master password revision code = 65534
                    supported
                    enabled
            not     locked
            not     frozen
            not     expired: security count
                    supported: enhanced erase
            Security level high
            2min for SECURITY ERASE UNIT. 2min for ENHANCED SECURITY ERASE UNIT.

Step 3 - Issue the ATA Secure Erase command
-------------------------------------------

Warning:Triple check that the correct drive designation is used. THERE
IS NO TURNING BACK ONCE THE ENTER KEY HAS BEEN PRESSED! You have been
warned.

    # hdparm --user-master u --security-erase Eins /dev/sdX

Wait until the command completes. This example output shows it took
about 40 seconds for an Intel X25-M 80GB SSD.

    security_password="Eins"
    /dev/sdX:
    Issuing SECURITY_ERASE command, password="Eins", user=user
    0.000u 0.000s 0:39.71 0.0%      0+0k 0+0io 0pf+0w

The drive is now erased. After a successful erasure the drive security
should automatically be set to disabled (thus no longer requiring a
password for access). Verify this by running the following command:

    # hdparm -I /dev/sdX

The command output should display "not enabled":

     Security: 
            Master password revision code = 65534
                    supported
            not     enabled
            not     locked
            not     frozen
            not     expired: security count
                    supported: enhanced erase
            2min for SECURITY ERASE UNIT. 2min for ENHANCED SECURITY ERASE UNIT.

Tips
----

See the GRUB_EFI_Examples for hardware-specific instructions to get GRUB
EFI working following a wipe.

Retrieved from
"https://wiki.archlinux.org/index.php?title=SSD_Memory_Cell_Clearing&oldid=252505"

Category:

-   Storage
