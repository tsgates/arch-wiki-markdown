Yandex Disk
===========

Installation
------------

Yandex Disk is a free cloud storage service created by Yandex.ru that
gives you access to your photos, videos and documents from any
internet-enabled device. The Yandex.Disk client console lets you:

-   synchronize files and folders with your Disk
-   get public links to files and folders
-   customize folder syncing

Yandex-disk client for Linux can be installed in from the AUR. Note that
it's a console client - there's no GUI for it present for it at the
moment.

To setup your proxy, user and local folder, enter

    $ yandex-disk setup

Syncing will start after completing this step, now you're ready to use
Yandex Disk.

Commands
--------

You can manage your folder using any filemanager or console.

Full list of commands is available in man yandex-disk or using

    $ yandex-disk --help

Here're some examples of use:

-   setup - Launch the setup wizard.

-   start - Launch as daemon and start syncing folders. The current sync
    status is recorded in the file ".sync/status".

-   stop - stop daemon.

-   status - show daemon status: sync status, errors, recently synced
    files, disk space status. If FILE is shown, the status for this file
    will be returned.

-   token - receive OAuth token, encode and save it in a special file
    (by default - /.config/yandex-disk/passwd). If the options -p
    PASSWORD or --password PASSWORD are not shown, then the password
    must be entered from STDIN.

-   sync - sync the folder and log out (if the daemon is running, wait
    for syncing to finish).

-   publish - make the file/folder public and remove the link to STDOUT.
    The item will be copied to the sync folder. Use the option
    --overwrite to rewrite existing items.

-   unpublish - removes public access to the file/folder.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Yandex_Disk&oldid=302678"

Category:

-   Internet applications

-   This page was last modified on 1 March 2014, at 04:32.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
