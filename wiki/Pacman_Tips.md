Pacman Tips
===========

> Summary

This is a collection of common tips for new pacman users.

> Related

pacman

Mirrors

Creating Packages

Custom local repository

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Cosmetic and Convienence                                           |
|     -   1.1 Color output                                                 |
|     -   1.2 Shortcuts                                                    |
|         -   1.2.1 Configure the shell                                    |
|         -   1.2.2 Usage                                                  |
|         -   1.2.3 Notes                                                  |
|                                                                          |
|     -   1.3 Operations and Bash syntax                                   |
|                                                                          |
| -   2 Maintenance                                                        |
|     -   2.1 Listing all installed packages with size                     |
|     -   2.2 Identify files not owned by any package                      |
|     -   2.3 Removing orphaned packages                                   |
|     -   2.4 Removing everything but base group                           |
|     -   2.5 Listing official installed packages only                     |
|     -   2.6 Getting the dependencies list of several packages            |
|     -   2.7 Getting the size of several packages                         |
|     -   2.8 Listing changed configuration files                          |
|     -   2.9 Listing all packages that nothing else depends on            |
|     -   2.10 Backing up Local database with Systemd                      |
|                                                                          |
| -   3 Installation and recovery                                          |
|     -   3.1 Installing packages from a CD/DVD or USB stick               |
|     -   3.2 Custom local repository                                      |
|     -   3.3 Network shared pacman cache                                  |
|         -   3.3.1 Read-only cache                                        |
|         -   3.3.2 Read-write cache                                       |
|         -   3.3.3 Preventing unwanted cache purges                       |
|                                                                          |
|     -   3.4 Backing up and retrieving a list of installed packages       |
|     -   3.5 List downloaded packages that are not in base or base-devel  |
|     -   3.6 Reinstalling all installed packages                          |
|     -   3.7 Restore pacman's local database                              |
|         -   3.7.1 Log filter script                                      |
|         -   3.7.2 Generating the package recovery list                   |
|         -   3.7.3 Performing the recovery                                |
|                                                                          |
|     -   3.8 Recovering a USB key from existing install                   |
|     -   3.9 Extracting contents of a .pkg file                           |
|     -   3.10 Viewing a single file inside a .pkg file                    |
+--------------------------------------------------------------------------+

Cosmetic and Convienence
------------------------

> Color output

As of version 4.1, Pacman has a color option. Uncomment the "Color" line
in pacman.conf.

> Shortcuts

The following instructions allow users to run some of the more common
pacman commands without the need to type them fully via a script alias.

Configure the shell

Add the following examples, which work in both Bash and Zsh:

     # Pacman alias examples
     alias pacupg='sudo pacman -Syu'        # Synchronize with repositories before upgrading packages that are out of date on the local system.
     alias pacin='sudo pacman -S'           # Install specific package(s) from the repositories
     alias pacins='sudo pacman -U'          # Install specific package not from the repositories but from a file 
     alias pacre='sudo pacman -R'           # Remove the specified package(s), retaining its configuration(s) and required dependencies
     alias pacrem='sudo pacman -Rns'        # Remove the specified package(s), its configuration(s) and unneeded dependencies
     alias pacrep='pacman -Si'              # Display information about a given package in the repositories
     alias pacreps='pacman -Ss'             # Search for package(s) in the repositories
     alias pacloc='pacman -Qi'              # Display information about a given package in the local database
     alias paclocs='pacman -Qs'             # Search for package(s) in the local database

     # Additional pacman alias examples
     alias pacupd='sudo pacman -Sy && sudo abs'     # Update and refresh the local package and ABS databases against repositories
     alias pacinsd='sudo pacman -S --asdeps'        # Install given package(s) as dependencies of another package
     alias pacmir='sudo pacman -Syy'                # Force refresh of all package lists after updating /etc/pacman.d/mirrorlist

Usage

Perform the respective commands by simply typing the alias name. For
example, to synchronize with repositories before upgrading packages that
are out of date on the local system:

    $ pacupg

Install packages from repositories:

    $ pacin <package1> <package2> <package3>

Install a custom built package:

    $ pacins /path/to/<package>

Completely remove a locally installed package:

    $ pacrem <package>

Search for available packages in the repositories:

    $ pacreps <keywords>

Display information about a package (e.g. size, dependencies) in the
repositories:

    $ pacrep <keywords>

Notes

The aliases used above are merely examples. By following the syntax
samples above, rename the aliases as convenient. For example:

    alias pacrem='sudo pacman -Rns'
    alias pacout='sudo pacman -Rns'

In the case above, the commands pacrem and pacout both call your shell
to execute the same command.

> Operations and Bash syntax

In addition to pacman's standard set of features, there are ways to
extend its usability through rudimentary Bash commands/syntax.

-   To install a number of packages sharing similar patterns in their
    names -- not the entire group nor all matching packages; eg. kde:

    # pacman -S kde-{applets,theme,tools}

-   Of course, that is not limited and can be expanded to however many
    levels needed:

    # pacman -S kde-{ui-{kde,kdemod},kdeartwork}

-   Sometimes, -s's builtin ERE can cause a lot of unwanted results, so
    it has to be limited to match the package name only; not the
    description nor any other field:

    # pacman -Ss '^vim-'

-   pacman has the -q operand to hide the version column, so it is
    possible to query and reinstall packages with "compiz" as part of
    their name:

    # pacman -S $(pacman -Qq | grep compiz)

Maintenance
-----------

House keeping, in the interest of keeping a clean system and following
The Arch Way

> Listing all installed packages with size

-   You may want to get the list of installed packages sorted by size,
    which may be useful when freeing space on your hard drive.
-   Use pacsysclean from pacman package.
-   Install expac and run  expac -s "%-30n %m" 
-   Invoke pacgraph with the -c option to produce a list of all
    installed packages with their respective sizes on the system.
    Pacgraph is available from [community].

> Identify files not owned by any package

Periodic checks for files outside of pacman database are recommended.
These files are often some 3rd party applications installed using the
usual procedure (e.g. ./configure && make && make install). Search the
file-system for these files (or symlinks) using this simple script:

    pacman-disowned

    #!/bin/sh

    tmp=${TMPDIR-/tmp}/pacman-disowned-$UID-$$
    db=$tmp/db
    fs=$tmp/fs

    mkdir "$tmp"
    trap 'rm -rf "$tmp"' EXIT

    pacman -Qlq | sort -u > "$db"

    find /bin /etc /sbin /usr \
      ! -name lost+found \
      \( -type d -printf '%p/\n' -o -print \) | sort > "$fs"

    comm -23 "$fs" "$db"

To generate the list:

    $ pacman-disowned > non-db.txt

Note that one should not delete all files listed in non-db.txt without
confirming each entry. There could be various configuration files, logs,
etc., so use this list responsibly and only proceed after extensively
searching for cross-references using grep.

> Removing orphaned packages

For recursively removing orphans:

    # pacman -Rs $(pacman -Qtdq)

The following alias is easily inserted into ~/.bashrc and removes
orphans if found:

    ~/.bashrc

    # '[r]emove [o]rphans' - recursively remove ALL orphaned packages
    alias pacro="/usr/bin/pacman -Qtdq > /dev/null && sudo /usr/bin/pacman -Rs \$(/usr/bin/pacman -Qtdq | sed -e ':a;N;\$!ba;s/\n/ /g')"

The following function is easily inserted into ~/.bashrc and removes
orphans if found:

    ~/.bashrc

    orphans() {
      if [[ ! -n $(pacman -Qdt) ]]; then
        echo "No orphans to remove."
      else
        sudo pacman -Rs $(pacman -Qdtq)
      fi
    }

> Removing everything but base group

If it is ever necessary to remove all packages except the base group,
try this one liner:

    # pacman -Rs $(comm -23 <(pacman -Qeq|sort) <((for i in $(pacman -Qqg base); do pactree -ul $i; done)|sort -u|cut -d ' ' -f 1))

Source: Look at discussion here

Notes:

1.  comm requires sorted input otherwise you get e.g.
    comm: file 1 is not in sorted order.
2.  pactree prints the package name followed by what it provides. For
    example:

    $ pactree -lu logrotate

    logrotate
    popt
    glibc
    linux-api-headers
    tzdata
    dcron cron
    bash
    readline
    ncurses
    gzip

The dcron cron line seems to cause problems, that is why cut -d ' ' -f 1
is needed - to keep just the package name.

> Listing official installed packages only

    pacman -Qqn

This list packages that are found in the sync database(s). If the user
has unofficial repositories configured, it will list packages from such
repositories too.

> Getting the dependencies list of several packages

Dependencies are alphabetically sorted and doubles are removed. Note
that you can use pacman -Qi to improve response time a little. But you
won't be able to query as many packages. Unfound packages are simply
skipped (hence the 2>/dev/null). You can get dependencies of AUR
packages as well if you use yaourt -Si, but it will slow down the
queries.

    $ pacman -Si $@ 2>/dev/null | awk -F ": " -v filter="^Depends" \ '$0 ~ filter {gsub(/[>=<][^ ]*/,"",$2) ; gsub(/ +/,"\n",$2) ; print $2}' | sort -u

Alternatively, you can use expac: expac -l '\n' %E -S $@ | sort -u.

> Getting the size of several packages

You can use (and tweak) this little shell function:

    ~/.bashrc

    pacman-size()
    {
    	CMD="pacman -Si"
    	SEP=": "
    	TOTAL_SIZE=0
    	
    	RESULT=$(eval "${CMD} $@ 2>/dev/null" | awk -F "$SEP" -v filter="^Size" -v pkg="^Name" \
    	  '$0 ~ pkg {pkgname=$2} $0 ~ filter {gsub(/\..*/,"") ; printf("%6s KiB %s\n", $2, pkgname)}' | sort -u -k3)
    	
    	echo "$RESULT"
    	
    	## Print total size.
    	echo "$RESULT" | awk '{TOTAL=$1+TOTAL} END {printf("Total : %d KiB\n",TOTAL)}'
    }

As told for the dependencies list, you can use pacman -Qi instead, but
not yaourt since AUR's PKGBUILD do not have size information.

A nice one-liner:

    $ pacman -Si "$@" 2>/dev/null" | awk -F ": " -v filter="Size" -v pkg="Name" \ '$0 ~ pkg {pkgname=$2} $0 ~ filter {gsub(/\..*/,"") ; printf("%6s KiB %s\n", $2, pkgname)}' | sort -u -k3 \ | tee >(awk '{TOTAL=$1+TOTAL} END {printf("Total : %d KiB\n",TOTAL)}')

You should replace "$@" with packages, or put this line in a shell
function.

> Listing changed configuration files

If you want to backup your system configuration files you could copy all
files in /etc/, but usually you're only interested in the files that you
have changed. In this case you want to list those changed configuration
files, we can do this with the following command:

    # pacman -Qii | awk '/^MODIFIED/ {print $2}'

The following script does the same. You need to run it as root or with
sudo.

    changed-files.sh

    #!/bin/bash
    for package in /var/lib/pacman/local/*; do
    	sed '/^%BACKUP%$/,/^%/!d' $package/files | tail -n+2 | grep -v '^$' | while read file hash; do
    		[ "$(md5sum /$file | (read hash file; echo $hash))" != "$hash" ] && echo $(basename $package) /$file
    	done
    done

> Listing all packages that nothing else depends on

If you want to generate a list of all installed packages that nothing
else depends on, you can use the following script. This is very helpful
if you are trying to free hard drive space and have installed a lot of
packages that you may not remember. You can browse through the output to
find packages which you no longer need.

    clean

    #!/bin/bash

    # This script is designed to help you clean your computer from unneeded
    # packages. The script will find all packages that no other installed package
    # depends on. It will output this list of packages excluding any you have
    # placed in the ignore list. You may browse through the script's output and
    # remove any packages you do not need.

    # Enter groups and packages here which you know you wish to keep. They will
    # not be included in the list of unrequired packages later.
    ignoregrp="base base-devel"
    ignorepkg=""

    # Temporary file locations
    tmpdir=/tmp
    ignored=$tmpdir/ignored
    installed=$tmpdir/installed

    # Generate list of installed packages and packages you wish to keep.
    echo $(pacman -Sg $ignoregrp | awk '{print $2}') $ignorepkg | tr ' ' '\n' | sort | uniq > $ignored
    pacman -Qq | sort > $installed

    # Do not loop packages you are keeping
    loop=$(comm -13 $ignored $installed)

    # Check each remaining package. If package is not required by anything and
    # is not on your ignore list, print the package name to the screen.
    for line in $loop; do
      check=$(pacman -Qi $line | awk '/Required By/ {print $4}')
      if [ "$check" == 'None' ]; then echo $line; fi
    done

    # Clean up $tmpdir
    rm $ignored $installed

If you install expac you can run
expac "%n %N" -Q $(expac "%n %G" | grep -v ' base') | awk '$2 == "" {print $1}'
which should give the same results but much faster.

> Backing up Local database with Systemd

Systemd can take snapshots of the pacman local database everytime it is
modified.

Note: There is a more configurable version in the AUR: pakbak-git

Tip: Save the following script as
/usr/lib/systemd/scripts/pakbak_script.

Note: Change the value of $pakbak to modify where the backed up database
is stored.

    #!/bin/bash

    declare -r pakbak="/pakbak.tar.xz";  ## set backup location
    tar -cJf "$pakbak" "/var/lib/pacman/local";  ## compress & store pacman local database in $pakbak

Tip:Save the following service file as
/usr/lib/systemd/system/pakbak.service.

    [Unit]
    Description=Back up pacman database

    [Service]
    Type=oneshot
    ExecStart=/bin/bash /usr/lib/systemd/scripts/pakbak_script
    RemainAfterExit=no

Tip:Save the following path file as /usr/lib/systemd/system/pakbak.path.

    [Unit]
    Description=Back up pacman database

    [Path]
    PathChanged=/var/lib/pacman/local
    Unit=pakbak.service

    [Install]
    WantedBy=multi-user.target

Tip:To start the backup service :

    # systemctl start pakbak.path

To enable the backup service automatically on reboot :

    # systemctl enable pakbak.path

Installation and recovery
-------------------------

Alternative ways of getting and restoring packages.

> Installing packages from a CD/DVD or USB stick

To download packages, or groups of packages:

    # cd ~/Packages
    # pacman -Syw base base-devel grub-bios xorg gimp --cachedir .
    # repo-add ./custom.db.tar.gz ./*

Then you can burn the "Packages" folder to a CD/DVD or transfer it to a
USB stick, external HDD, etc.

To install:

1. Mount the media:

    # mkdir /mnt/repo
    # mount /dev/sr0 /mnt/repo    #For a CD/DVD.
    # mount /dev/sdxY /mnt/repo   #For a USB stick.

2. Edit pacman.conf and add this repository before the other ones (e.g.
extra, core, etc.). This is important. Don't just uncomment the one on
the bottom. This way it ensures that the files from the CD/DVD/USB take
precedence over those in the standard repositories:

    # nano /etc/pacman.conf

    [custom]
    SigLevel = PackageRequired
    Server = file:///mnt/repo/Packages

3. Finally, synchronize the pacman database to be able to use the new
repository:

    # pacman -Sy

> Custom local repository

pacman 3 introduced a new script named repo-add which makes generating a
database for a personal repository much easier. Use repo-add --help for
more details on its usage.

Simply store all of the built packages to be included in the repository
in one directory, and execute the following command (where repo is the
name of the custom repository):

    $ repo-add /path/to/repo.db.tar.gz /path/to/*.pkg.tar.xz

Note that when using repo-add, the database and the packages do not need
to be in the same directory. But when using pacman with that database,
they should be together.

To add a new package (and remove the old if it exists), run:

    $ repo-add /path/to/repo.db.tar.gz /path/to/packagetoadd-1.0-1-i686.pkg.tar.xz

Note:If there is a package that needs to be removed from the repository,
read up on repo-remove.

Once the local repository has been made, add the repository to
pacman.conf. The name of the db.tar.gz file is the repository name.
Reference it directly using a file:// url, or access it via FTP using
ftp://localhost/path/to/directory.

If willing, add the custom repository to the list of unofficial user
repositories, so that the community can benefit from it.

> Network shared pacman cache

Read-only cache

If you're looking for a quick and dirty solution, you can simply run a
standalone webserver which other computers can use as a first mirror:
darkhttpd /var/cache/pacman/pkg. Just add this server at the top of your
mirror list. Be aware that you might get a lot of 404 errors, due to
cache misses, depending on what you do, but pacman will try the next
(real) mirrors when that happens.

Read-write cache

Tip:See pacserve for an alternative (and probably simpler) solution than
what follows.

In order to share packages between multiple computers, simply share
/var/cache/pacman/ using any network-based mount protocol. This section
shows how to use shfs or sshfs to share a package cache plus the related
library-directories between multiple computers on the same local
network. Keep in mind that a network shared cache can be slow depending
on the file-system choice, among other factors.

First, install any network-supporting filesystem; for example sshfs,
shfs, ftpfs, smbfs or nfs.

Tip:To use sshfs or shfs, consider reading Using SSH Keys.

Then, to share the actual packages, mount /var/cache/pacman/pkg from the
server to /var/cache/pacman/pkg on every client machine.

To have shared package databases, mount
/var/lib/pacman/sync/{core,extra,testing,community}  in the same way.
Proceed to place the appropriate lines in /etc/fstab.

Preventing unwanted cache purges

By default, pacman -Sc removes package tarballs from the cache that
correspond to packages that are not installed on the machine the command
was issued on. Because pacman cannot predict what packages are installed
on all machines that share the cache, it will end up deleting files that
should not be.

To clean up the cache so that only outdated tarballs are deleted, add
this entry in the [options] section of /etc/pacman.conf:

    CleanMethod = KeepCurrent

> Backing up and retrieving a list of installed packages

It is good practice to keep periodic backups of all pacman-installed
packages. In the event of a system crash which is unrecoverable by other
means, pacman can then easily reinstall the very same packages onto a
new installation.

-   First, backup the current list of non-local packages:

$ comm -23 <(pacman -Qeq|sort) <(pacman -Qmq|sort) > pkglist.txt

-   Store the pkglist.txt on a USB key or other convenient medium or
    gist.github.com or Evernote, Dropbox, etc.

-   Copy the pkglist.txt file to the new installation, and navigate to
    the directory containing it.

-   Issue the following command to install from the backup list:

# pacman -S $(< pkglist.txt)

In the case you have a list which was not generated like mentioned
above, there may be foreign packages in it (i.e. packages not belonging
to any repos you have configured, or packages from the AUR).

In such a case, you may still want to install all available packages
from that list:

    # pacman -S --needed $(comm -12 <(pacman -Slq|sort) <(sort badpkdlist) )

Explanation:

-   pacman -Slq lists all available softwares, but the list is sorted by
    repository first, hence the sort command.
-   Sorted files are required in order to make the comm command work.
-   The -12 parameter display lines common to both entries.
-   The --needed switch is used to skip already installed packages.

You may also try to install all unavailable packages (those not in the
repos) from the AUR using yaourt (not recommended unless you know
exactly what you are doing):

    $ yaourt -S --needed $(comm -13 <(pacman -Slq|sort) <(sort badpkdlist) )

Finally, you may want to remove all the packages on your system that are
not mentioned in the list.

Warning:Use this command wisely, and always check the result prompted by
pacman.

    # pacman -Rsu $(comm -23 <(pacman -Qq|sort) <(sort pkglist))

> List downloaded packages that are not in base or base-devel

The following command will list any installed packages that are not in
base/base-devel, and as such were likely installed manually by the user:

    $ comm -23 <(pacman -Qeq|sort) <(pacman -Qgq base base-devel|sort)

> Reinstalling all installed packages

If you mess up your system (rm -rf) you can repair by having pacman
reinstall all of your packages.

If your system does not contain any foreign (AUR) packages you can run:

    # pacman -Qeq | pacman -S -

Pacman preserves the installation reason by default.

If you have foreign packages this will error as packages will not be
found in the repositories. The following will make a list of all
packages and remove the foreign packages seen with pacman -Qmq.
Combining a command to list all packages, and another to hide the list
of foreign packages is required.

The following will reinstall every package found in the repositories:

    # comm -23 <(pacman -Qeq|sort) <(pacman -Qmq|sort) | pacman -S -

> Restore pacman's local database

Signs that pacman needs a local database restoration:

-   pacman -Q gives absolutely no output, and pacman -Syu erroneously
    reports that the system is up to date.
-   When trying to install a package using pacman -S package, and it
    outputs a list of already satisfied dependencies.
-   When testdb (part of pacman) reports database inconsistency.

Most likely, pacman's database of installed software,
/var/lib/pacman/local, has been corrupted or deleted. While this is a
serious problem, it can be restored by following the instructions below.

Firstly, make sure pacman's log file is present:

    $ ls /var/log/pacman.log

If it does not exist, it is not possible to continue with this method.
You may be able to use Xyne's package detection script to recreate the
database. If not, then the likely solution is to re-install the entire
system.

Log filter script

    pacrecover

    #!/bin/bash -e

    . /etc/makepkg.conf

    PKGCACHE=$((grep -m 1 '^CacheDir' /etc/pacman.conf || echo 'CacheDir = /var/cache/pacman/pkg') | sed 's/CacheDir = //')

    pkgdirs=("$@" "$PKGDEST" "$PKGCACHE")

    while read -r -a parampart; do
      pkgname="${parampart[0]}-${parampart[1]}-*.pkg.tar.xz"
      for pkgdir in ${pkgdirs[@]}; do
        pkgpath="$pkgdir"/$pkgname
        [ -f $pkgpath ] && { echo $pkgpath; break; };
      done || echo ${parampart[0]} 1>&2
    done

Make the script executable:

    $ chmod +x pacrecover

Generating the package recovery list

Warning:If for some reason your pacman cache or makepkg package
destination contain packages for other architectures, remove them before
continuation.

Run the script (optionally passing additional directories with packages
as parameters):

    $ paclog-pkglist /var/log/pacman.log | ./pacrecover >files.list 2>pkglist.orig

This way two files will be created: files.list with package files, still
present on machine and pkglist.orig, packages from which should be
downloaded. Later operation may result in mismatch between files of
older versions of package, still present on machine, and files, found in
new version. Such mismatches will have to be fixed manually.

Here is a way to automatically restrict second list to packages
available in a repository:

    $ { cat pkglist.orig; pacman -Slq; } | sort | uniq -d > pkglist

Check if some important base package are missing, and add them to the
list:

    $ comm -23 <(pacman -Sgq base) pkglist.orig >> pkglist

Proceed once the contents of both lists are satisfactory, since they
will be used to restore pacman's installed package database;
/var/lib/pacman/local/.

Performing the recovery

Define bash alias for recovery purposes:

    # recovery-pacman() {
        pacman "$@"       \
        --log /dev/null   \
        --noscriptlet     \
        --dbonly          \
        --force           \
        --nodeps          \
        --needed          \
        #
    }

--log /dev/null allows to avoid needless pollution of pacman log,
--needed will save some time by skipping packages, already present in
database, --nodeps will allow installation of cached packages, even if
packages being installed depend on newer versions. Rest of options will
allow pacman to operate without reading/writing filesystem.

Populate the sync database:

    # pacman -Sy

Start database generation by installing locally available package files
from files.list:

    # recovery-pacman -U $(< files.list)

Install the rest from pkglist:

    # recovery-pacman -S $(< pkglist)

Update the local database so that packages that are not required by any
other package are marked as explicitly installed and the other as
dependences. You will need be extra careful in the future when removing
packages, but with the original database lost is the best we can do.

    # pacman -D --asdeps $(pacman -Qq)
    # pacman -D --asexplicit $(pacman -Qtq)

Optionally check all installed packages for corruption:

    # pacman -Qk

Optionally #Identify files not owned by any package.

Update all packages:

    # pacman -Su

> Recovering a USB key from existing install

If you have Arch installed on a USB key and manage to mess it up (e.g.
removing it while it is still being written to), then it is possible to
re-install all the packages and hopefully get it back up and working
again (assuming USB key is mounted in /newarch)

    # pacman -S $(pacman -Qq --dbpath /newarch/var/lib/pacman) --root /newarch --dbpath /newarch/var/lib/pacman

> Extracting contents of a .pkg file

The .pkg files ending in .xz are simply tar'ed archives that can be
decompressed with:

    $ tar xvf package.tar.xz

If you want to extract a couple of files out of a .pkg file, this would
be a way to do it.

> Viewing a single file inside a .pkg file

For example, if you want to see the contents of /etc/conf.d/ntpd.conf
supplied within the ntp package:

    $ tar -xOf /var/cache/pacman/pkg/ntp-4.2.6.p5-6-i686.pkg.tar.xz etc/conf.d/ntpd.conf

Or you can use vim, then browse the archive:

    $ vim /var/cache/pacman/pkg/ntp-4.2.6.p5-6-i686.pkg.tar.xz

Retrieved from
"https://wiki.archlinux.org/index.php?title=Pacman_Tips&oldid=256106"

Category:

-   Package management
