BURG
====

BURG, Brand-new Universal loadeR from GRUB, is an alternative boot
loader forked from GRUB. It uses a new object format which allows it to
be built in a wider range of OS's, including Linux, Windows, OS X,
Solaris, FreeBSD, etc. BURG features superior theming and has a highly
configurable menu system which works at boot time in both text and
graphical mode.

Warning:BURG seems to be no longer actively maintained as the upstream
bzr repo at https://code.launchpad.net/~bean123ch/burg/trunk does not
seem to be updated after October 2010. Users are recommended to switch
to GRUB(2) or Syslinux instead.

Contents
--------

-   1 Installation
    -   1.1 Compile options
    -   1.2 Initial setup
-   2 Configuration
    -   2.1 Generation of a configuration
    -   2.2 Defaults
    -   2.3 burg.d scripts
    -   2.4 Preview and runtime configuration
-   3 Theming
-   4 Tips and tricks
    -   4.1 Shortcuts
    -   4.2 Important files
    -   4.3 Other OS detection
    -   4.4 Folding (grouping)
    -   4.5 Linux 3.0 detection
-   5 See also

Installation
------------

Note:Crunick's binary repository is no longer up-to-date and all users
should use the packages from AUR.

All BURG packages are currently found in the AUR and can be built using
normal methods.

Only two packages are required:

-   burg-bios-bzr or burg-efi-x86_64-bzr
-   burg-themes

Tip:When upgrading, be sure to read the changelog which is provided in
the tarball. New features and configuration options may be listed there.

> Compile options

Tunables can be found at the top of the PKGBUILD for customizing the
building process in addition to the usual options:

1.  _mk_burg_emu (only in burg-bios-bzr) (default=y) - Setting this to y
    enables burg-emu and will double the build time. Users who have no
    need for burg-emu and wish to speed things up should probably set
    this to n.
2.  _rm_build_dirs (default=n) - When set to y the build directories are
    deleted saving precious space. This will not affect the Bazaar
    checkout tree or anything else in ${srcdir}.

> Initial setup

The main configuration file burg.cfg is not provided by any package.
Users must obtain one by copying an existing one, manual construction or
automatic generation using update-burg (see the section on
configuration).

If installing for the first time, enter the following command to install
to the MBR,

    # burg-install /dev/sda --no-floppy

Substitute /dev/sda with the device name for the disk.

Configuration
-------------

Since BURG is derived from GRUB, its configuration is similar in most
respects. The main configuration file is /boot/burg/burg.cfg and is
usually generated automatically. It is possible to create one by hand.
However, this would be very tedious especially when adding the graphical
features. It is more feasible to tweak and edit an existing one.

Generation is configured by the file /etc/default/burg and scripts are
located in /etc/burg.d/.

> Generation of a configuration

Creating a new burg.cfg is done by the command:

    # burg-mkconfig -o /boot/burg/burg.cfg

Arch Linux provides a handy shortcut:

    # update-burg

Warning:These commands overwrite any preexisting file at that path.

> Defaults

The file /etc/default/burg is a Bash script that is sourced by
burg-mkconfig when generating a configuration file. The defaults file is
meant to be an easy way for users to control this process. The entries
are Bash variables and arrays and are the same as those used in GRUB.

> burg.d scripts

The directory /etc/burg.d/ contains scripts used when creating burg.cfg.
They are called in order of the numbers in the filenames.

The scripts can be turned on or off by flipping the executable bit in
the file permission modes.

The script 40_custom is intended to be user editable. Users are also
free to create more scripts to their liking. Remember that everything
sent to stderr is viewed in the terminal and everything sent to stdout
is appended to burg.cfg verbatim.

> Preview and runtime configuration

When editing a configuration, one does not need to reboot to see
changes. If enabled in the PKGBUILD at compile time, the command
burg-emu should be available. Run it as root to preview what BURG would
look like at boot. burg-emu allows the user to do most things that can
be done at boot (except for, you know, booting).

BURG also allows runtime configuration, such as changing themes, through
menus and BURG's commandline. The settings are set as variables which
are saved in /boot/burg/burgenv.

Theming
-------

The primary reason to use BURG over other boot loaders is its theming
system. To add a theme to BURG, copy its directory to /boot/burg/themes/
and then update the configuration.

To change themes, press T when running BURG. A list of available themes
will be shown. Use the arrow keys to highlight the theme you want and
press Enter to make the selection. This can be done from within burg-emu
and rebooting is not required.

Theme packages can be found in the AUR. Currently only four packages are
available:

-   burg-themes
-   burg-themes-extras
-   persia-theme-burg
-   arch-theme-burg

Tips and tricks
---------------

> Shortcuts

     F1 / h - Help
     F2 / t - Change theme
     F3 / r - Change resolution
     F5 / Ctrl-x - Finish edit
     F6 - Next window
     F7 - Show folded items
     F8 - Toggle between text and graphic mode
     F9 - Shutdown
     F10 - Reboot
     f - Toggle between folded and unfolded mode
     c - Open terminal
     2 - Open two terminals
     e - Edit current command
     q - Quit graphic mode
     i - Show theme information
     n - Next item with the same class
     w - Next Windows item
     u - Next Ubuntu item
     ESC - Exit from windows or menu

For full list of keyboard shortcuts, in BURG you can press F1.

> Important files

These files and directories control much of how BURG is configured and
run.

-   /boot/burg/
-   /boot/burg/burg.cfg
-   /boot/burg/burgenv
-   /etc/default/burg
-   /etc/burg.d/

> Other OS detection

In some cases, you may have other operating systems installed on other
hard drives or partitions and you may want them to be listed in BURG.
You can manually append their entries to /etc/burg.d/40_custom,
something like:

For Windows:

     menuentry "Windows 7" --class windows --class os {
     	insmod ntfs
     	set root='(hd0,1)'
     	search --no-floppy --fs-uuid --set f28620c186208865
     	chainloader +1
     }

For Debian with plymouth enable:

     menuentry 'Debian' --class debian --class gnu-linux --class gnu --class os --group group_main {
     	insmod ext2
     	set root='(hd0,4)'
     	search --no-floppy --fs-uuid --set c5e0fb03-5cbe-4b79-acdc-518e33e814ac
     	echo	'Loading Linux 2.6.35-trunk-amd64 ...'
     	linux	/boot/vmlinuz-2.6.35-trunk-amd64 root=UUID=c5e0fb03-5cbe-4b79-acdc-518e33e814ac ro quiet splash
     	echo	'Loading initial ramdisk ...'
     	initrd	/boot/initrd.img-2.6.35-trunk-amd64
     }

Or you can install os-prober and regenerate /boot/burg/burg.cfg:

    # burg-mkconfig -o /boot/burg/burg.cfg

Now BURG should display icons for the other systems.

> Folding (grouping)

If you want to use BURG's folding feature (folding categorises the menu
items, e.g. Arch and Arch Fallback will be collected under one
category), you can press F when burg is loaded.

In burg.cfg, entries which has the same group will be folded when you
enable folding.

Icons of entries will be set according to an entry's class. For example,
--class arch makes an entry Arch Linux and the Arch logo will be
displayed.

> Linux 3.0 detection

burg-mkconfig might not add an initrd line for Linux 3.0 to menu
entries. You can add the line manually by editing /boot/burg/burg.cfg,
for example:

     menuentry 'Arch GNU/Linux, with Linux linux' --class arch --class gnu-linux --class gnu --class os --group group_main {
     {
         # ...
         # ...
         # ...
         initrd    /boot/initramfs-linux.img # for normal boot entry
         initrd    /boot/initramfs-linux-fallback.img # for fallback boot entry
     }

Warning:Add just one of the above lines, not both!

See also
--------

-   Discussion thread on Arch BBS
-   burg at Google Code
-   burg - Ubuntu Community Documentation (Wiki)

Retrieved from
"https://wiki.archlinux.org/index.php?title=BURG&oldid=278797"

Category:

-   Boot loaders

-   This page was last modified on 15 October 2013, at 19:01.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
