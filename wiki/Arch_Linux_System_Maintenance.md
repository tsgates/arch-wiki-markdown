Arch Linux System Maintenance
=============================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Read the News                                                      |
| -   2 Update the system                                                  |
| -   3 Packages                                                           |
| -   4 Hardware                                                           |
| -   5 Bad Practices                                                      |
| -   6 See also                                                           |
+--------------------------------------------------------------------------+

Read the News
-------------

Often, the developers will provide important information about required
configurations and modifications for known issues. The Arch Linux user
is expected to consult these places before performing an upgrade.

The Arch Linux News is posted here: [1] You can subscribe to the rss
feed by adding: [2] to your favorite feed reading software. You can also
get news by subscribing to the Arch Announce mailing list: [3].

Pay special attention to news items with "manual intervention required"
in their header. You can avoid a lot of trouble and embarrassment by
reading the instructions in these news announcements and following them.

Update the system
-----------------

Warning:System updates should be performed with care. It is very
important to read and understand this before proceeding.

Sync, refresh the package database, and upgrade your entire system with:

    # pacman -Syu

Or, same thing:

    # pacman --sync --refresh --sysupgrade

If you are prompted to upgrade pacman itself at this point, respond by
pressing Y, and then reissue the pacman -Syu command when finished.

Note:Occasionally, configuration changes may take place requiring user
action during an update; read pacman's output for any pertinent
information. See Pacnew and Pacsave Files for more details.

Keep in mind that Arch is a rolling release distribution. This means the
user doesn't have to reinstall or perform elaborate system rebuilds to
upgrade to the newest version. Issuing pacman -Syu periodically (and
noting the above warning) keeps the entire system up-to-date and on the
bleeding edge. At the end of this upgrade, the system will be completely
current.

See Pacman and FAQ#Package Management for answers regarding updating and
managing packages. See this page if you have not update your system for
a long time.

Packages
--------

-   When you update, check pacman output for instructions related to
    updated packages.

-   Use pacman -Qdt to find orphaned packages, and pacman -Qo <file> to
    find out which package owns that particular file.

-   Search for .pac* files and merge them with configuration files (see
    Pacnew and Pacsave Files).

-   Check for out-of-date or unmaintained AUR packages on your system.
    Sometimes these can cause problems when you update.

-   Check the size of /var and clear pacman's cache once in a while. A
    useful tool to assist in this process is cacheclean.

Hardware
--------

-   Check disk (use fstab options to check at boot)

-   Search logs for errors (list scripts, tools to make this easier/more
    automated)

-   Look into errors as soon as possible - do not leave them unattended
    to.

Bad Practices
-------------

-   Linking random libraries together to get a program to work.

-   Updating once a year.

-   Copy-pasting commands into the terminal without at least reading man
    pages to understand what you are doing to your system.

-   Clearing the entire package cache using pacman -Scc - this removes
    the possibility to do package downgrades in cases of breakage.

See also
--------

-   General Recommendations#System administration
-   Category:System administration

Retrieved from
"https://wiki.archlinux.org/index.php?title=Arch_Linux_System_Maintenance&oldid=246232"

Category:

-   System administration
