SSD Memory Cell Clearing
========================

Summary help replacing me

This article presents a method to reset all cells on an SSD to their
factory default state thus recovering any loss of write performance.

Related Articles

Solid State Drives

Securely Wipe HDD

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

Contents
--------

-   1 tl; dr
-   2 Step 1 - Make sure the drive security is not frozen
-   3 Step 2 - Enable security by setting a user password
-   4 Step 3 - Issue the ATA Secure Erase command
-   5 Tips

tl; dr
------

Warning:It is recommended that you read the rest of the article BEFORE
you try this! This section literally shows the minimum to wipe out an
entire SSD for those not wanting to scroll though the text.

    hdparm --user-master u --security-set-pass PasSWorD /dev/sdX
    hdparm --user-master u --security-erase PasSWorD /dev/sdX

  

Step 1 - Make sure the drive security is not frozen
---------------------------------------------------

Issue the following command:

    # hdparm -I /dev/sdX

If the command output shows "frozen" one cannot continue to the next
step. Some BIOSes block the ATA Secure Erase command by issuing a
"SECURITY FREEZE" command to "freeze" the drive before booting an
operating system.

A possible solution is to simply suspend the system. Upon waking up, it
is likely that the freeze will be lifts. If unsuccessful, one can try
hot-(re)plug the data cable (which might crash the kernel). If
hot-(re)plugging the SATA data cable crashes the kernel try letting the
operating system fully boot up, then quickly hot-(re)plug both the SATA
power and data cables.

Step 2 - Enable security by setting a user password
---------------------------------------------------

Note:When the user password is set the drive will be locked after next
power cycle denying normal access until unlocked with the correct
password.

Any password will do, as this should only be temporary. After the secure
erase the password will be set back to NULL. In this example, the
password is "PasSWorD" as shown:

    # hdparm --user-master u --security-set-pass PasSWorD /dev/sdX
    security_password="PasSWorD"
    /dev/sdX:
    Issuing SECURITY_SET_PASS command, password="PasSWorD", user=user, mode=high

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

    # hdparm --user-master u --security-erase PasSWorD /dev/sdX

Wait until the command completes. This example output shows it took
about 40 seconds for an Intel X25-M 80GB SSD.

    security_password="PasSWorD"
    /dev/sdX:
    Issuing SECURITY_ERASE command, password="PasSWorD", user=user
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
"https://wiki.archlinux.org/index.php?title=SSD_Memory_Cell_Clearing&oldid=291699"

Category:

-   Storage

-   This page was last modified on 5 January 2014, at 14:38.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
