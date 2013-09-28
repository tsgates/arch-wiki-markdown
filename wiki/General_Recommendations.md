General Recommendations
=======================

Summary

An annotated index of recommended readings. Covers a wide variety of
subjects relevant to both new and experienced users alike.

Related

FAQ

Beginners' Guide

List of Applications

This document is an annotated index of other popular articles and
important information for improving and adding functionalities to the
installed Arch system. Various pages listed here will require using
pacman to install additional packages present in the official
repositories, and those in the unofficial Arch User Repository by
employing makepkg with the optional aid of an AUR helper. As such, the
concept of package management should be fully understood before
continuing. Readers are assumed to have read and followed the Beginners'
Guide or Installation Guide to obtain a basic Arch Linux installation.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Appearance                                                         |
|     -   1.1 Colored output                                               |
|         -   1.1.1 Console prompt                                         |
|         -   1.1.2 Core utilities                                         |
|         -   1.1.3 Emacs shell                                            |
|         -   1.1.4 Man pages                                              |
|                                                                          |
|     -   1.2 Fonts                                                        |
|         -   1.2.1 Console fonts                                          |
|         -   1.2.2 Patched font packages                                  |
|                                                                          |
| -   2 Audio/video                                                        |
|     -   2.1 Browser plugins                                              |
|     -   2.2 Codecs                                                       |
|     -   2.3 Sound                                                        |
|                                                                          |
| -   3 Booting                                                            |
|     -   3.1 Hardware auto-recognition                                    |
|     -   3.2 Num Lock activation at boot                                  |
|     -   3.3 Retaining boot messages                                      |
|     -   3.4 Start X at boot                                              |
|                                                                          |
| -   4 Console improvements                                               |
|     -   4.1 Aliases                                                      |
|     -   4.2 Bash additions                                               |
|     -   4.3 Compressed files                                             |
|     -   4.4 Mouse support                                                |
|     -   4.5 Scrollback buffer                                            |
|     -   4.6 Session management                                           |
|                                                                          |
| -   5 Input                                                              |
|     -   5.1 Configure all mouse buttons                                  |
|     -   5.2 Keyboard layouts                                             |
|     -   5.3 Laptop touchpads                                             |
|     -   5.4 TrackPoints                                                  |
|                                                                          |
| -   6 Networking                                                         |
|     -   6.1 Clock synchronization                                        |
|     -   6.2 DNS speed improvement                                        |
|     -   6.3 DNSSEC validation                                            |
|     -   6.4 Setting up a firewall                                        |
|                                                                          |
| -   7 Optimization                                                       |
|     -   7.1 Benchmarking                                                 |
|     -   7.2 Maximizing performance                                       |
|                                                                          |
| -   8 Package management                                                 |
|     -   8.1 Aliases for pacman                                           |
|     -   8.2 Arch Build System                                            |
|     -   8.3 Arch User Repository                                         |
|     -   8.4 Mirrors                                                      |
|                                                                          |
| -   9 Power management                                                   |
|     -   9.1 acpid                                                        |
|     -   9.2 CPU frequency scaling                                        |
|     -   9.3 Laptops                                                      |
|     -   9.4 Suspending and hibernation                                   |
|                                                                          |
| -   10 System administration                                             |
|     -   10.1 Privilege escalation                                        |
|     -   10.2 Users and groups                                            |
|     -   10.3 Windows networking                                          |
|     -   10.4 System maintenance                                          |
|                                                                          |
| -   11 System service                                                    |
|     -   11.1 File index and search                                       |
|     -   11.2 Local mail delivery                                         |
|     -   11.3 Printing                                                    |
|                                                                          |
| -   12 X Window System                                                   |
|     -   12.1 Desktop environments                                        |
|     -   12.2 Display drivers                                             |
|     -   12.3 Window managers                                             |
+--------------------------------------------------------------------------+

Appearance
----------

This section contains frequently-sought "eye candy" tweaks for an
aesthetically pleasing Arch experience. For more, please see
Category:Eye candy.

> Colored output

Even though a number of applications have built-in color capabilities,
using a general-purpose colorizing wrapper, such as cope, is another
route. Install cope-git from the AUR. acoc and cw are similar
alternatives.

Console prompt

The console prompt (PS1) can be customized to a great extent. See the
What's your PS1? forum thread for ideas. Also see Color Bash Prompt or
Zsh#Prompts if using Bash or Zsh, respectively.

Core utilities

Colorizing the output of specific core utilities such as grep and ls is
covered in the Core Utilities article.

Emacs shell

Emacs is known for featuring options beyond the duties of regular text
editing, one of these being a full shell replacement. Consult
Emacs#Colored output issues for a fix regarding garbled characters that
may result from enabling colored output.

Man pages

Man pages (or manual pages) are one of the most useful resources
available to GNU/Linux users. To aid readability, the pager can be
configured to render colored text as explained in Man Page#Colored man
pages.

> Fonts

A plethora of information on the subject can be found in the Fonts and
Font Configuration articles.

Console fonts

If spending a significant amount of time working from the virtual
console (i.e. outside an X server), users may wish to change the console
font to improve readability; see Fonts#Console fonts.

Patched font packages

Font rendering libraries can be patched to provide improved rendering
compared to the standard packages; see Font Configuration#Patched
packages.

Audio/video
-----------

Category:Audio/Video includes additional multimedia resources.

> Browser plugins

To enjoy media-rich web content and for a complete browsing experience,
browser plugins such as Adobe Acrobat Reader, Adobe Flash Player, and
Java can be installed.

> Codecs

Codecs are utilized by multimedia applications to encode or decode audio
or video streams. In order to play encoded streams, users must ensure an
appropriate codec is installed.

> Sound

Sound is provided by kernel sound drivers (ALSA and OSS). Users may
additionally wish to install and configure a sound server.

Booting
-------

This section contains information pertaining to the boot process. An
overview of the Arch boot process can be found at Arch Boot Process. For
more, please see Category:Boot process.

> Hardware auto-recognition

Hardware should be auto-detected by udev during the boot process by
default. A potential improvement in boot time can be achieved by
disabling module auto-loading and specifying required modules manually,
as described in Kernel modules#Loading. Additionally, Xorg should be
able to auto-detect required drivers using udev, but users have the
option to configure the X server manually too.

> Num Lock activation at boot

Num Lock is a toggle key found in most keyboards. For activating Num
Lock's number key-assignment during startup, see Activating Numlock on
Bootup.

> Retaining boot messages

Once it concludes, the screen is cleared and the login prompt appears,
leaving users unable to gather feedback from the boot process. Disable
clearing of boot messages to overcome this limitation.

> Start X at boot

If utilizing an X server to provide a graphical user interface, users
may wish to start this server during the boot process rather than
starting it manually after login. See Display Manager if desiring a
graphical login or Start X at Boot for methods that do not involve a
display manager.

Console improvements
--------------------

This section applies to small modifications that better console
programs' practicality. For more, please see Category:Command shells.

> Aliases

Users can define shortcuts for frequently-used commands using a built-in
shell command. Common time-saving aliases can be found in Bash#Aliases.

> Bash additions

A list of miscellaneous Bash settings, including completion
enhancements, history search and readline macros is available in
Bash#Tips and tricks.

> Compressed files

Compressed files, or archives, are frequently encountered on a GNU/Linux
system. Tar is one of the most commonly used archiving tools, and users
should be familiar with its syntax (Arch Linux packages, for example,
are simply xzipped tarballs). See Core Utilities#extract for other
helpful commands.

> Mouse support

Using a mouse with the console for copy-paste operations can be
preferred over GNU screen's traditional copy mode. Refer to Console
Mouse Support for comprehensive directions.

> Scrollback buffer

To be able to save and view text which has scrolled off the screen,
refer to Scrollback buffer.

> Session management

Using terminal multiplexers like tmux or screen, programs may be run
under sessions composed of tabs and panes that can be detached at will,
so when the user either kills the terminal emulator, terminates X, or
logs off, the programs associated with the session will continue to run
in the background as long as the terminal multiplexer server is active.
Interacting with the programs requires reattaching to the session.

Input
-----

This section contains popular input device configuration tips. For more,
please see Category:Input devices.

> Configure all mouse buttons

Owners of advanced or unusual mice may find that not all mouse buttons
are recognized by default, or may wish to assign different actions for
extra buttons. Instructions can be found in Get All Mouse Buttons
Working.

> Keyboard layouts

Non-English or otherwise non-standard keyboards may not function as
expected by default. To define the keymap in virtual consoles, the
KEYMAP variable must be set in /etc/vconsole.conf. For Xorg users, the
required changes are described in Xorg#Keyboard layout.

> Laptop touchpads

Many laptops use Synaptics or ALPS "touchpad" pointing devices. These,
and several other touchpad models, use the Synaptics input driver; see
Touchpad Synaptics for installation and configuration details.

> TrackPoints

To configure your TrackPoint device refer to ThinkWiki.

Networking
----------

This section is confined to small networking procedures. Head over to
Network for a full guide. For more, please see Category:Networking.

> Clock synchronization

The Network Time Protocol (NTP) is a protocol for synchronizing the
clocks of computer systems over packet-switched, variable-latency data
networks.

> DNS speed improvement

To improve load time by caching queries, use pdnsd, a very simple DNS
server that does not attempt to fill every need. Or install dnsmasq, a
broader choice which also supports turning the system into a DHCP
server.

> DNSSEC validation

For better security while browsing web, paying online, connecting to SSH
services and similar tasks you should consider using DNSSEC-enabled
client software which can validate signed DNS records...

> Setting up a firewall

A firewall can provide an extra layer of protection on top of the Linux
networking stack. The Linux kernel includes iptables, a stateful
firewall, as part of the Netfilter project. It can be configured
directly or through a front end. Arch ships with no ports open and
network daemons will not be started automatically without explicit
configuration, so a firewall is usually not very useful if you aren't
running services that need to be protected.

Optimization
------------

This section aims to summarize tweaks, tools and available options
useful to improve system and application performance.

> Benchmarking

Benchmarking is the act of measuring performance and comparing the
results to another system's results or a widely accepted standard
through a unified procedure.

> Maximizing performance

The Maximizing Performance article gathers information and is a basic
rundown about gaining performance in Arch Linux.

Package management
------------------

This section contains helpful information related to package management.
All users should at least be familiar with the pacman package manager.
For more, please see Category:Package management.

> Aliases for pacman

Aliasing a command, or a group thereof, is a way of saving time when
using the console. This is specially helpful for repetitive tasks that
do not need significant alteration to their parameters between
executions. Various time saving pacman aliases are organized in pacman
Tips, besides other suggested tools.

> Arch Build System

Ports is a system initially used by BSD distributions consisting of
build scripts that reside in a directory tree on the local system.
Simply put, each port contains a script within a directory intuitively
named after the installable third-party application.

The ABS tree offers the same functionality by providing build scripts
called PKGBUILDs, which are populated with information for a given piece
of software; integrity hashes, project URL, version, license and build
instructions. These PKGBUILDs are later parsed by makepkg, the actual
program that generates packages cleanly manageable by pacman.

Every package in the repositories along with those present in the AUR
are subject to recompilation with makepkg.

> Arch User Repository

While the ABS tree allows the ability of building software available in
the official repositories, the AUR is the equivalent for user submitted
packages. It is an unsupported repository of build scripts accessible
through the web interface or by an AUR helper.

An AUR helper can add seamless access to the AUR. They may vary in
features, but all ease in searching, fetching, building, and installing
from over 40'000 PKGBUILDs found in the unofficial repository.

> Mirrors

Visit Mirrors for steps on taking full advantage of using the fastest
and most up to date pacman mirrors. As explained in the article, a
particularly good advice is to routinely check the Mirror Status page
and/or Mirror-Status for a list of mirrors that have been recently
synced.

Power management
----------------

This section may be of use to laptop owners or users otherwise seeking
power management controls. For more, please see Category:Power
management.

> acpid

Users can configure how the system reacts to ACPI events such as
pressing the power button or closing a laptop's lid using acpid.

> CPU frequency scaling

Modern processors can decrease their frequency and voltage to reduce
heat and power consumption. Less heat leads to a quieter system and
prolongs the life of hardware. cpupower is a set of utilities designed
to assist CPU frequency scaling.

> Laptops

For articles related to portable computing along with model-specific
installation guides, please see Category:Laptops. For a general overview
of laptop-related articles and recommendations, see Laptop.

> Suspending and hibernation

Several options are available to users desiring suspend-to-RAM
(sleep/stand-by) and suspend-to-disk (hibernate) functionality. pm-utils
describes one popular method, while hibernate-script is an older
alternative that does not depend on Xorg packages. Tuxonice is an option
growing in popularity and, while it claims to have more features than
the other two options, requires kernel patching or the use of linux-ice
available in the AUR.

System administration
---------------------

This section deals with administrative tasks and system management. For
more, please see Category:System administration.

> Privilege escalation

A new installation leaves users with only the super user account, better
known as root. Logging in as root for prolonged periods of time is
widely considered to be foolish and insecure. Instead, users should
create and use unprivileged user accounts for most tasks, only using the
root account for system administration. The su (substitute user) command
allows assuming the identity of another user on the system (usually
root) from an existing login, whereas the sudo command grants temporary
privilege escalation for a specific command.

> Users and groups

Users and groups are used on GNU/Linux for access control;
administrators may fine-tune group membership and ownership to grant or
deny users and services access to system resources. Access to peripheral
devices such as optical (CD/DVD) drives and sound hardware often
requires membership in an appropriate group.

> Windows networking

To enable communication between Windows and Arch Linux machines across a
network, users can use Samba; a re-implementation of the SMB/CIFS
networking protocol.

To configure an Arch Linux machine to join and use Active Directory for
authentication, read the article on Active Directory Integration.

> System maintenance

Arch is a rolling release system and has rapid package turnover, so
users have to take some time to do system maintenance. And Enhancing
Arch Linux Stability page provides tips on how to make an Arch Linux
system as stable as possible.

System service
--------------

This section relates to daemons. For more, please see Category:Daemons
and system services.

> File index and search

Most distributions have a locate command available to be able to quickly
search for files. To get this functionality mlocate is the recommended
install. After the install you should run updatedb to index the
filesystems.

> Local mail delivery

A default base setup bestows no means for mail syncing. To configure
Postfix for simple local mailbox delivery, see Local Mail Delivery with
Postfix. Other options are SSMTP, MSMTP and fdm.

> Printing

CUPS is a standards-based, open source printing system developed by
Apple. See Category:Printers for printer-specific articles.

X Window System
---------------

Xorg is the public, open-source implementation of the X Window System
version 11. If a graphical user interface is desired, the majority of
users will use Xorg. See Category:X Server for additional resources.

> Desktop environments

Whilst Xorg provides the basic framework for building a graphical
environment, there are additional components that may be considered
necessary for a complete user experience. Desktop environments such as
GNOME, KDE, LXDE, and Xfce bundle together a wide range of X clients,
such as a window manager, panel, file manager, terminal emulator, text
editor, icons, and other utilities. See Category:Desktop environments
for a complete list and additional resources.

> Display drivers

The default vesa display driver will work with most video cards, but
performance can be significantly improved and additional features
harnessed by installing the appropriate driver for ATI, Intel, or NVIDIA
products.

> Window managers

A full-fledged desktop environment provides a complete and consistent
graphical user interface, but tends to consume a considerable amount of
system resources. Users seeking to maximize performance or otherwise
simplify their environment may opt to install a window manager instead
and hand-pick desired extras. An alternative window manager can also be
used with most desktop environments. Dynamic, stacking, and tiling
window managers differ in their handling of window placement.

Retrieved from
"https://wiki.archlinux.org/index.php?title=General_Recommendations&oldid=254260"

Category:

-   Getting and installing Arch
