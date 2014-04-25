Unison
======

Unison is a bidirectional file synchronization tool that runs on
Unix-like operating systems (including Linux, Mac OS X, and Solaris) and
Windows. It allows two replicas of a collection of files and directories
to be stored on different hosts (or different disks on the same host),
modified separately, and then brought up to date by propagating the
changes in each replica to the other. It also unrestricted in terms of
which system can be the host.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 GUI
    -   2.2 Manual
-   3 Usage
-   4 Version incompatibility
-   5 Tips and tricks
    -   5.1 Save human time and keystrokes
    -   5.2 Common config sync
-   6 See also

Installation
------------

Installing unison from the official repositories, which provides CLI,
GTK+ and GTK+ 2.0 interfaces. For offline documentation install
unison-doc from the AUR.

Configuration
-------------

In order to use Unison, you need to create a profile.

> GUI

To configure Unison with the GUI run:

    $ unison-gtk2

> Manual

Alternatively, manually create a profile in ~/.unison and add the
following lines to the default configuration file,
~/.unison/profilename.prf.

Define the root directory to be synchronized.

    root=/home/user/

Define the remote directory where the files should be sychronized to.

    root=ssh://example.com//path/to/server/storags

Optionally, provide arguments to SSH.

    sshargs=-p 4000

Define which directories and files should be synchronized:

    # dirs
    path=Documents
    path=Photos
    path=Study
    # files
    path=.bashrc
    path=.vimrc

You can also define which files to ignore:

    ignore=Name temp.*
    ignore=Name .*~
    ignore=Name *.tmp

Note:For more information see the Sample profiles in the User Manual and
Reference Guide.

Usage
-----

Once your profile is set up, you can start syncing:

    $ unison profilename

or using the GUI tool:

    $ unison-gtk2

and select the profile. Unison has a nice interface where you can view
the progress and changes.

Version incompatibility
-----------------------

For Unison to function properly, the same version must be installed on
all clients. If, for example, one computer has version 2.40 and the
other has 2.32, they will not be able to sync with each other. This
applies to all computers that share a directory to be synchronized
across your machines.

Due to the staggered releases with varying Linux distros, you might be
stuck with older versions of Unison, while Arch Linux has the latest
upstream version in the Extra repository. There are unofficial PKGBUILDs
for versions 2.32 (unison-232) and 2.27 (unison-227) on the AUR that
allow users of multiple distros to continue using Unison with their
existing systems.

Tips and tricks
---------------

> Save human time and keystrokes

If one runs unison within a VDT emulator capable of maintaining a
suitable scrollback buffer, there is no purpose in having to confirm
every non-conflicting change; set the auto option to true to avoid these
prompts.

> Common config sync

When syncing configuration files which would vary (e.g., due to endemic
applications, security-sensitive configuration) among systems (servers,
workstations, laptops, smartphones, etc.) but nevertheless contain
common constructs (e.g., key bindings, basic shell aliases), it would be
apt to separate such content into separate config files (e.g.,
.bashrc_common), and sync only these.

Warning:Bidirectional syncing of config files can lend itself to become
an avenue for an attack, by enabling the peer syncing system to receive
malicious changes to config files (and perhaps even other peers the
system syncs with). This is an attractive option for adversaries,
especially when the conceptual security levels of the two systems differ
(e.g., public shell server vs. personal workstation), since it would
likely be simpler to compromise a system of lower security. Always use
the noupdate option when bidirectional syncing between two particular
systems is deemed unnecessary; when necessary, verify each change when
syncing. Automatic bidirectional syncs should be done with extreme
caution.

See also
--------

See the Wikipedia article on this subject for more information: Unison
(file synchronizer)

-   Official website
-   Yahoo! user group
-   Liberation through data replication by Philip Guo
-   Setting up Unison for your mom by Philip Guo
-   Replication using Unison on TWiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=Unison&oldid=302672"

Category:

-   Internet applications

-   This page was last modified on 1 March 2014, at 04:31.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
