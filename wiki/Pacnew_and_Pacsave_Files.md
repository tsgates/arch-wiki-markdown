Pacnew and Pacsave Files
========================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Getting Started                                                    |
| -   2 Package backup files                                               |
| -   3 Types Explained                                                    |
|     -   3.1 .pacnew                                                      |
|     -   3.2 .pacsave                                                     |
|     -   3.3 .pacorig                                                     |
|                                                                          |
| -   4 Locating .pac* Files                                               |
| -   5 Managing .pacnew Files                                             |
|     -   5.1 Using Meld to Update Differences                             |
|                                                                          |
| -   6 Resources                                                          |
+--------------------------------------------------------------------------+

Getting Started
---------------

When pacman removes a package that has a configuration file, it normally
creates a backup copy of that config file and appends .pacsave to the
name of the file.

Likewise, when pacman upgrades a package which includes a new config
file created by the maintainer differing from the currently installed
file, it writes a .pacnew config file. Occasionally, under special
circumstances, a .pacorig file is created. Pacman provides notice when
these files are written.

A .pacnew file may be created during a package upgrade (pacman -Syu,
pacman -Su or pacman -U) to avoid overwriting a file which already
exists and was previously modified by the user. When this happens a
message like the following will appear in the output of pacman:

    warning: /etc/pam.d/usermod installed as /etc/pam.d/usermod.pacnew

A .pacsave file may be created during a package removal (pacman -R), or
by a package upgrade (the package must be removed first). When the
pacman database has record that a certain file owned by the package
should be backed up it will create a .pacsave file. When this happens
pacman outputs a message like the following:

    warning: /etc/pam.d/usermod saved as /etc/pam.d/usermod.pacsave

These files require manual intervention from the user and it is good
practice to handle them right after every package upgrade or removal. If
left unhandled, improper configurations can result in improper function
of the software, or the software being unable to run altogether.

Package backup files
--------------------

A package's PKGBUILD file specifies which files should be preserved or
backed up when the package is upgraded or removed. For example, the
PKGBUILD for pulseaudio contains the following line:

    backup=('etc/pulse/client.conf' 'etc/pulse/daemon.conf' 'etc/pulse/default.pa')

Types Explained
---------------

The different types of *.pac* files.

> .pacnew

For each backup file in a package being upgraded, pacman cross-compares
three md5sums generated from the file's contents: one sum for the
version originally installed by the package, one for the version
currently in the filesystem, and one for the version in the new package.
If the version of the file currently in the filesystem has been modified
from the version originally installed by the package, pacman cannot know
how to merge those changes with the new version of the file. Therefore,
instead of overwriting the modified file when upgrading, pacman saves
the new version with a .pacnew extension and leaves the modified version
untouched.

Going into further detail, the 3-way MD5 sum comparison results in one
of the following outcomes:

 original = X, current = X, new = X 
    All three versions of the file have identical contents, so
    overwriting is not a problem. Overwrite the current version with the
    new version and do not notify the user. (Although the file contents
    are the same, this overwrite will update the filesystem's
    information regarding the file's installed, modified, and accessed
    times, as well as ensure that any file permission changes are
    applied.)

 original = X, current = X, new = Y 
    The current version's contents are identical to the original's, but
    the new version is different. Since the user has not modified the
    current version and the new version may contain improvements or
    bugfixes, overwrite the current version with the new version and do
    not notify the user. This is the only auto-merging of new changes
    that pacman is capable of performing.

 original = X, current = Y, new = X 
    The original package and the new package both contain exactly the
    same version of the file, but the version currently in the
    filesystem has been modified. Leave the current version in place and
    discard the new version without notifying the user.

 original = X, current = Y, new = Y 
    The new version is identical to the current version. Overwrite the
    current version with the new version and do not notify the user.
    (Although the file contents are the same, this overwrite will update
    the filesystem's information regarding the file's installed,
    modified, and accessed times, as well as ensure that any file
    permission changes are applied.)

 original = X, current = Y, new = Z 
    All three versions are different, so leave the current version in
    place, install the new version with a .pacnew extension and warn the
    user about the new version. The user will be expected to manually
    merge any changes necessary from the new version into the current
    version.

> .pacsave

If the user has modified one of the files specified in backup then that
file will be renamed with a .pacsave extension and will remain in the
filesystem after the rest of the package is removed.

Note: Use of the -n option with pacman -R will result in complete
removal of all files in the specified package, therefore no .pacsave
files will be created.

> .pacorig

When a file (usually a configuration found in /etc) is encountered
during package installation or upgrade that does not belong to any
installed package but is listed in backup for the package in the current
operation, it will be saved with a .pacorig extension and replaced with
the version of the file from the package. Usually this happens when a
configuration file has been moved from one package to another. If such a
file were not listed in backup, pacman would abort with a file conflict
error.

Note: Because .pacorig files tend to be created for special
circumstances, there is no universal method for handling them. It may be
helpful to consult the Arch News for handling instructions if it is a
known case.

Locating .pac* Files
--------------------

Arch Linux does not provide official utilities for .pacnew files. You'll
need to maintain these yourself; a few tools are presented in the next
section. To do this manually, first you will need to locate them. When
upgrading or removing a large number of packages, updated *.pac* files
may be missed. To discover whether any *.pac* files have been installed:

To just search where most global configurations are stored:

    $ find /etc -regextype posix-extended -regex ".+\.pac(new|save|orig)" 2> /dev/null

or the entire disk:

    $ find / -regextype posix-extended -regex ".+\.pac(new|save|orig)" 2> /dev/null

Or use locate if you have installed it. First re-index the database:

    # updatedb

Then:

    $ locate -e --regex "\.pac(new|orig|save)$"

Or use pacman's log to find them:

    $ egrep "pac(new|orig|save)" /var/log/pacman.log

Note that the log does not keep track of which files are currently in
the filesystem nor of which files have already been removed.

Managing .pacnew Files
----------------------

There are various tools to help resolve .pacnew and .pacsave file
issues. The standard diff utility (alternatively, colordiff) provides an
easy way to compare the files. Finally, the pacnews bash script provides
similar functionality. Both pacdiff and pacnews use vimdiff to compare
and edit .pacnew and .pacsave files.

Once all existing .pacnew files have been located, the user may handle
them manually using common merge tools such as vimdiff, ediff (part of
emacs), meld (a GNOME GUI tool), sdiff (part of diffutils, or Kompare (a
KDE GUI tool), then deleting the .pacnew files afterwards.

A few third-party utilities providing various levels of automation for
these tasks are available from the community repository and the AUR.

-   pacdiff - A minimal CLI script from pacman package. It will search
    all the pacnew and pacsave files and asking for action on them.
-   pacmerge-git - CLI interactive merge program
-   Vimdiff - a type of Vim specially designed for merging files
-   Dotpac - Basic interactive script with ncurses-based text interface
    and helpful walkthrough. No merging or auto-merging features.
-   pacdiffviewer - Full-featured interactive CLI script with
    auto-merging capability. Part of the yaourt package.
-   diffpac - Standalone pacdiffviewer replacement
-   Yaourt - A package manager that supports the AUR repository. Use
    yaourt -C to compare, replace and merge configuration files..
-   etc-update - Arch port of Gentoo's etc-update utility, providing a
    simple CLI to view changes, interactively edit and merge changes,
    and automatically merge trivial changes (e.g. comments.) Unlike some
    others above, this uses your preferred text editor rather than
    forcing you to learn a new one.
-   pacnews-git is a simple script aimed at finding all .pacnew files,
    then editing with vimdiff. It differs from the below script using
    meld.

> Using Meld to Update Differences

Using meld in a loop can be used to update configuration files. This
script will loop through the files one by one then prompt to delete the
.pacnew file.

    pacnew

    #!/bin/bash
    # Merge new *.pacnew configuration files with their originals

    pacnew=$(find /etc -type f -name "*.pacnew")

    # Check if any .pacnew configurations are found
    if [[ -z "$pacnew" ]]; then
      echo " No configurations to update"
    fi

    for config in $pacnew; do
      # Diff original and new configuration to merge
      gksudo meld ${config%\.*} $config &
      wait
      # Remove .pacnew file?
      while true; do
        read -p " Delete \""$config"\"? (Y/n): " Yn
        case $Yn in
          [Yy]* ) sudo rm "$config" && \
                  echo " Deleted \""$config"\"."
                  break                         ;;
          [Nn]* ) break                         ;;
          *     ) echo " Answer (Y)es or (n)o." ;;
        esac
      done
    done

The above script uses GNOME's gksudo for graphical sudo permissions. Use
kdesu for KDE.

Resources
---------

-   Arch Linux Forums: Dealing With .pacnew Files

Retrieved from
"https://wiki.archlinux.org/index.php?title=Pacnew_and_Pacsave_Files&oldid=252972"

Category:

-   Package management
