Unison
======

Unison is a bidirectional file-synchronization tool for Unix and
Windows. It allows two replicas of a collection of files and directories
to be stored on different hosts (or different disks on the same host),
modified separately, and then brought up to date by propagating the
changes in each replica to the other.

Not only can Unison sync between Windows and Unix ( OSX, Solaris, Linux
etc.) systems, it also unrestricted in terms of which system can be the
host.

Common uses include syncing configuration files, photos, and other
content.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
| -   3 Usage                                                              |
| -   4 Version Incompatibility                                            |
| -   5 Tips & Tricks                                                      |
|     -   5.1 Save human time and keystrokes                               |
|     -   5.2 Common config sync                                           |
|                                                                          |
| -   6 See Also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

    # pacman -S unison

This provides a CLI and GTK+ 1 & 2 frontends.

Offline documentation is available in the unison-doc AUR package.

Configuration
-------------

In order to use Unison, you need to create a profile. You can use the
supplied GUI tool or you can manually create a profile in ~/.unison.

If you want to use the GUI configuration, run:

    $ unison-gtk2

Otherwise, edit the default config file:

    # nano ~/.unison/default.prf

First, define the root of what you want to sync:

    root=/home/user/

Then, define the root of where to sync it to:

    root=ssh://example.com//path/to/server/storage

Optionally, you can give arguments to SSH:

    sshargs=-p 4000

Now you are going to define which directories and files to include in
the sync:

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

For further references check the Unison documentation.

Usage
-----

Once your profile is set up, you can start syncing:

    $ unison <profilename>

or using the GUI tool:

    unison-gtk2

and select the profile. Unison has a nice interface where you can view
the progress and changes.

Version Incompatibility
-----------------------

For Unison to function properly, the same version must be installed on
all clients. If, for example, one computer has version 2.40 and the
other has 2.32, they will not be able to sync with each other. This
applies to all computers that share a directory to be synchronized
across your machines.

Due to the staggered releases with varying Linux distros, you might be
stuck with older versions of Unison, while Arch Linux has the latest
upstream version in the Extra repository. There are unofficial PKGBUILDs
for versions 2.32 and 2.27 on the AUR that allow users of multiple
distros to continue using Unison with their existing systems.

Tips & Tricks
-------------

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

See Also
--------

-   Official User Manual and Reference Guide, Section "Running Unison"
-   Useful advice

Retrieved from
"https://wiki.archlinux.org/index.php?title=Unison&oldid=237308"

Category:

-   Internet Applications
