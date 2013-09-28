Ureadahead
==========

Ureadahead (Über-readahead) is used to speed up the boot process. It
works by reading all the files required during boot and makes pack files
for quicker access, then during boot reads these files in advance, thus
minimizes the access times for the harddrives. It's intended to replace
sreadahead.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Requirements                                                       |
| -   2 How it works                                                       |
| -   3 Using ureadahead                                                   |
| -   4 Configuration                                                      |
| -   5 Questions                                                          |
|     -   5.1 Q: Why does this take so long time tracing?                  |
|                                                                          |
| -   6 Helping out                                                        |
| -   7 More resources                                                     |
+--------------------------------------------------------------------------+

Requirements
------------

Currently, ureadahead needs a kernel patch to work. You can use
linux-ureadahead.

The user-space package is called ureadahead.

How it works
------------

When run without any arguments, ureadahead checks for pack files in
/var/lib/ureadahead, and if none are found or if the packfiles are older
than a month, it starts tracing the boot process. When tracing, it waits
for either a TERM or INT signal before generating the pack file.

Otherwise, if the file is up to date, it just reads the pack file in
preparation for the boot.

It works for both SSDs and traditional harddrives and automatically
optimizes the pack files depending on which you have.

Using ureadahead
----------------

First you need the patched kernel. After the installation you need to
make ureadahead start on boot. Simply create the file
/etc/rc.d/functions.d/ureadahead and add:

    ureadahead() {
    /sbin/ureadahead --timeout=240 &
    }

    add_hook sysinit_end ureadahead

to start it after sysinit.

Note:You can also use sysinit_premount to start it before it mounts all
the other filesystems in /etc/fstab, but this might create issues
depending on your system (e.g. if you have /var on a separate
partition).

Now you should be good to go.

Configuration
-------------

There are few configuration options for ureadahead. You can specify
which mountpoint to trace with:

    $ ureadahead /<mountpoint>

though it should automatically trace all needed mountpoints during boot.

You can also run it with --force-trace to force a retrace, however it is
better to remove the pack files and reboot.

The pack files are in /var/lib/ureadahead and are named after their
mountpoint (i.e. pack for root, home.pack for /home).

Questions
---------

Q: Why does this take so long time tracing?

A: If you didn't supply --timeout, you need to kill it manually. Either
just ^C it, or use pkill ureadahead.

Helping out
-----------

If your boot actually becomes slower after generating the pack files and
you're sure ureadahead is to blame, then file a bug report. To get
useful data, make sure both ureadahead and bootchart installed.

First, disable ureadahead on boot (remove
/etc/rc.d/functions.d/ureadahead) and remove the pack files in
/var/lib/ureadahead, then reboot and save the bootchart.

Then, reenable ureadahead (recreate the file in
/etc/rc.d/functions.d/ureadahead) and reboot. Save this bootchart too.

Finally, reboot once more, and save the final bootchart.

Now you should have 3 bootcharts, one without ureadahead, one when
ureadahead is tracing and one when it's running normally. Then, as root,
run:

    # ureadahead --dump > ureadahead.dump

to dump the contents of the pack file. Create a bug report on the
ureadahead launchpad file and attach the bootcharts along with the dump.

Note:I do not know how welcome this will be to the ubuntu developers,
since we're using arch. If you still want to help, give it a try and see
if they're interested.

More resources
--------------

-   ureadahead homepage
-   ureadahead package on AUR
-   Nvidia driver for the patched kernel

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ureadahead&oldid=225360"

Category:

-   Boot process
