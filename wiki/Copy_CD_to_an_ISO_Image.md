Copy CD to an ISO Image
=======================

Use the dd command to create an ISO image from an optical drive like a
CD-ROM or DVD:

    dd if=/dev/cdrom of=/tmp/cdimage.iso

Adapt the command to the appropriate source drive in the if section and
the destination directory in the of section to your needs. Please note
that the /tmp directory is only a temporary storage and will be deleted
when you reboot. It is recommended to move the ISO into another
directory or initially set the appropriate destination directory in the
of section.

To mount the created ISO image read the article "Mounting images as
user".

Retrieved from
"https://wiki.archlinux.org/index.php?title=Copy_CD_to_an_ISO_Image&oldid=197174"

Category:

-   Data compression and archiving
