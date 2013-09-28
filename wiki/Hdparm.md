hdparm
======

hdparm is a performance and benchmarking tool for your hard disk
(SATA/IDE).

Warning:Be careful, it is easy to destroy your hard drive with hdparm!

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Usage                                                              |
|     -   2.1 Disk info                                                    |
|     -   2.2 Reading speed MB/s                                           |
|     -   2.3 Writing speed MB/s                                           |
|     -   2.4 Parking your hard drive                                      |
|                                                                          |
| -   3 Tips and tricks                                                    |
|     -   3.1 KDE => 4.4.4 and hdparm                                      |
+--------------------------------------------------------------------------+

Installation
------------

hdparm can be installed from the official repositories. For use with
SCSI devices, install sdparm.

Usage
-----

> Disk info

To get information about your hard disk, run the following:

    # hdparm -I /dev/sda

> Reading speed MB/s

To measure how many MB/s your hard disk (SATA/IDE) can read, run the
following:

    # hdparm -t --direct /dev/sda

> Writing speed MB/s

To measure how many MB/s your hard disk (SATA/IDE) can write, run the
following:

    $ sync;time bash -c "(dd if=/dev/zero of=bf bs=8k count=500000; sync)"

Do not forget to Ctrl+c and rm bf after that.

Note:bf is just the name of the output file that dd writes to.

> Parking your hard drive

If your hard drive is clicking many times, the kernel is parking the
hard drive's actuator arm (what moves the read/write head). This happens
often on laptops (2.5" IDE hard drives). If it happens too often, it
could damage your hard drive.

This will just park the reading head when you shut down the computer:

    # hdparm -B254 /dev/sd

Default value is -B128. An average value could be -B199 if it is parking
too often.

To make this persistent, add a udev rule by creating e.g.
/etc/udev/rules.d/11-sda-apm-fix.rules:

    ACTION=="add", SUBSYSTEM=="block", KERNEL=="sda", RUN+="/sbin/hdparm -B 254 /dev/sda"

Note that the APM level may get reset after a suspend, so you will
probably also have to re-execute the command after each resume. That
could be automated via a systemd resume@ service file.

Tips and tricks
---------------

> KDE => 4.4.4 and hdparm

To stop KDE version 4.4.4 or greater from messing around with your
(manually) configured hdparm values, enter the following and you should
be done:

    # touch /etc/pm/power.d/harddrive

Retrieved from
"https://wiki.archlinux.org/index.php?title=Hdparm&oldid=251185"

Categories:

-   File systems
-   Storage
