Bug Day/2010
============

Number of bugs:

  --------------------- -------------- -------- --------
  Project               At beginning   At end   Closed
  Arch Linux            572            542      30
  Community             106            106      0
  Pacman                142            141      1
  AUR                   36             31       5
  Release Engineering   63             64       -1
  Total                 919            884      35
  --------------------- -------------- -------- --------

  
 Indications:

-   Please use the bug title for the links' names, so that we do not
    need to click on the link to know what a bug is about.

Little helper script

-   If you have fixed a bug, enclose it with <s></s> tags.
-   Ensure bugs are assigned to the right person (package maintainers do
    change sometimes).
-   Ensure bugs are in the right top-level project (Release Engineering,
    Pacman, etc.).
-   If fixes are provided for some bugs, please test and report them as
    fixed.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installer                                                          |
| -   2 System                                                             |
| -   3 [initscripts]                                                      |
|     -   3.1 Read-only root/live-friendly support                         |
|     -   3.2 Encrypted setups                                             |
|                                                                          |
| -   4 Packages                                                           |
|     -   4.1 [core]                                                       |
|         -   4.1.1 Decision?                                              |
|         -   4.1.2 Status?                                                |
|         -   4.1.3 Trivial fixes                                          |
|                                                                          |
|     -   4.2 [extra]                                                      |
|         -   4.2.1 Decision?                                              |
|         -   4.2.2 Status?                                                |
|         -   4.2.3 Trivial fixes                                          |
|                                                                          |
|     -   4.3 [community]                                                  |
|         -   4.3.1 Status?                                                |
|         -   4.3.2 Trivial fixes                                          |
|                                                                          |
| -   5 Upstream bugs                                                      |
|     -   5.1 No response                                                  |
|     -   5.2 Status?                                                      |
|                                                                          |
| -   6 Website                                                            |
|     -   6.1 Status?                                                      |
|                                                                          |
| -   7 Pacman                                                             |
| -   8 Old Bugs (Bugs open before 2010-06-01)                             |
| -   9 See also                                                           |
+--------------------------------------------------------------------------+

Installer
---------

System
------

[initscripts]
-------------

> Read-only root/live-friendly support

-   FS#9384 - [initscripts] request for read-only root support

> Encrypted setups

-   FS#17131 - [initscripts] encrypted swap is set up before random seed
    is restored

Packages
--------

> [core]

Decision?

-   FS#13357 - {core} l2tp support needed (xl2tp from community)
-   FS#13591 - [pam] Use sha512 hash for passwords for improve local
    security
-   FS#16807 - [groff] Replace groff in core by mdocml
-   FS#18417 - {core} Make a "wifi-drivers" group
-   FS#16702 - [kernel26] Versioned Kernel installs - sounds like a good
    idea, but nobody has said they'll do it yet
-   FS#22480 - [ppp] remove from base group
-   FS#22482 - [wpa_supplicant] remove from base group

  

Status?

-   FS#22046 - [kernel26] xhci-hcd + ehci-hcd (USB 3.0) kernel module
    prevents suspend
-   FS#17753 - [ppp] bogus DNS server problem with 3G modems
-   FS#23096 - [grub] 0.97-17 fails to load os with quickboot enabled in
    bios using crucial real ssd.
-   FS#19321 - [util-linux-ng|shadow] agetty -> login **problems***
-   FS#15738 - [cryptsetup] initcpio-hook enhancement

Trivial fixes

> [extra]

Decision?

-   FS#17157 - [kdebase-workspace] kdm allows logins even if shell is
    set to /sbin/nologin
-   FS#17326 - [ssmtp] setgid mail
-   FS#21141 - [archboot] arch_wireless does not include wireless
    modules
-   FS#19082 - [eclipse] make xulrunner optional
-   FS#24225 - [python-sip] Split sip package into sip and python-sip
-   FS#25098 - [hdf5] Enable CXX binding for hdf5
-   FS#25052 - [python-sqlalchemy] include docs in splitpackage

Status?

-   FS#14252 - [kdebase-workspace] rewrites Xsetup
-   FS#18917 - [ghc] ghc.install :: test if directory exists
-   FS#19642 - [guile] ignores emacs support files (gds.el,
    gds-server.el, gds-client.el)
-   FS#16974 - [xf86-video-intel] 845GM/855GM kernel panic with DRI
    enabled, KMS disabled
-   FS#15747 - [kismet] kismet_client - blank Last comment says our
    terminfo maybe broken for xterm
-   FS#19580 - [kdeplasma-addons-applets-kimpanel] ibus backend
-   FS#19376 - [openvpn] package should contain update-resolv-conf
    script

Trivial fixes

-   FS#24491 - [libmtp] duplicate udev rules installed

> [community]

Status?

-   FS#16206 - [pcmanfm] Mime type configuration defaults
-   FS#19570 - [terminator] bash children do not exit when terminal is
    closed
-   FS#18965 - [cgmail] crashing since updated gnome to 2.30

Trivial fixes

-   FS#22326 - [cython] cannot find numpy header files
-   FS#23654 - [gdal] 1.8.0-3 WMS layers not working - no curl support

Upstream bugs
-------------

> No response

> Status?

-   FS#21228 - [texlive-core] Document compile problem

Website
-------

Status?

-   FS#15865 - {bugtracker} attached files should have a MIME type
    attached/sent

Pacman
------

No promises on fixing these on bug day, but if any of the pacman devs or
ML readers are around these would be good candidates to look at,
especially if you like C and shell script coding more than fixing the
above bugs.

Old Bugs (Bugs open before 2010-06-01)
--------------------------------------

-   FS#18292 Assigned | [dcron] Should create ID Flag when not given to
    be compatible to
-   FS#17705 Assigned | [xf86-video-intel] Hangcheck timer elapsed...
    GPU hung
-   FS#17131 Assigned | [initscripts] crypt: restore random seed before
    using for decryp
-   FS#16974 Assigned | [xf86-video-intel] 845GM/855GM kernel panic with
    DRI enabled, KM
-   FS#19642 Assigned | [guile] ignores emacs support files (gds.el,
    gds-server.el, gds-
-   FS#19392 Assigned | [xterm] w/who does not show my login shell
-   FS#19330 Assigned | [xorg] System doesn't remember screen resolution
-   FS#19321 Assigned | [util-linux-ng|shadow] agetty -> login
    **problems**
-   FS#19051 Assigned | [net-tools] netstat doesn't show complete
    addresses with ipv6 aw
-   FS#18691 Assigned | [unzip] iconv patch needed to support UTF-8
    filenames created in
-   FS#17821 Waiting on Response | [kernel26] (2.6.32-*): bug on kernel
    ACPI
-   FS#17753 Assigned | [ppp] bogus DNS server problem with 3G modems
-   FS#17390 Assigned | {dbscripts} Add support for split packages of
    different arches
-   FS#17157 Assigned | [kdebase-workspace] kdm allows logins even if
    shell is set to /s
-   FS#16702 Assigned | [kernel26] Versioned Kernel installs
-   FS#15865 Assigned | {bugtracker} attached files should have a MIME
    type attached/sen
-   FS#11147 Assigned | [mkinitcpio] req: resume from encrypted swap.
-   FS#9396 Assigned | [namcap] fails to detect dependencies on
    uninstalled shared libs
-   FS#19440 Assigned | [apache-ant] doen't meet Java Package Guidelines
-   FS#19428 Assigned | [docbook-xml] Provide a 'catalog' file for each
    version
-   FS#19409 Assigned | [initscripts] locale: support all the LC_*
    variables
-   FS#19376 Assigned | [openvpn] package should contain
    update-resolv-conf script
-   FS#19313 Assigned | [ifplugd] ifplugd.action script is not really a
    /bin/sh script
-   FS#19175 Waiting on Response | [qca] kopete and psi not able to
    connect to jabber/xmpp (openfir
-   FS#19082 Assigned | [eclipse] make xulrunner optional
-   FS#18999 Assigned | [xorg-server] Xfvb doesn't handle transparent
    pixels properly in
-   FS#18931 Assigned | [netcfg] [patch] Add WWAN support (UMTS/3G)
-   FS#18917 Assigned | [ghc] ghc.install :: test if directory exists
-   FS#18836 Assigned | [netcfg] wpa_actiond doesn't function properly
    on resume
-   FS#18590 Assigned | {repo} enable Delta support in repositories
-   FS#18555 Assigned | [xawtv] streamer segfault
-   FS#18542 Assigned | [ifplugd] Wrong way to launch ntpdate
-   FS#18485 Assigned | {archweb} Search doesn't trim leading/trailing
    spaces
-   FS#18344 Assigned | [xf86-video-intel] can't wake from suspend
-   FS#18244 Assigned | [dansguardian] Remove dependency: squid
-   FS#18157 Assigned | [filesystem] symlink /var/{run,lock} to
    /run/{,lock}
-   FS#17965 Assigned | [nautilus] Places displays links to
    (ntfs)partitions twice with
-   FS#17837 Assigned | [xorg] Xserver display blanks to single color,
    fixed by suspend
-   FS#17580 Assigned | {wiki} interwiki interlanguage links
-   FS#17447 Assigned | {mailman} Incorrect support email on page
-   FS#17389 Assigned | [openssh] SSH session hangs, when remote machine
    reboots.
-   FS#17326 Assigned | [ssmtp] setgid mail
-   FS#17188 Assigned | [pam] Introduce a common-auth pam file for use
    in login managers
-   FS#16865 Assigned | [thinkfinger] issue with linux kernel > 2.6.28
-   FS#16807 Assigned | [groff] Replace groff in core by mdocml
-   FS#16206 Waiting on Response | [pcmanfm] Mime type configuration
    defaults
-   FS#15747 Assigned | [kismet] kismet_client - blank
-   FS#15738 Assigned | [cryptsetup] initcpio-hook enhancement
-   FS#14252 Assigned | [kdebase-workspace] rewrites Xsetup
-   FS#13591 Assigned | [pam] Use sha512 hash for passwords for improve
    local security
-   FS#13357 Assigned | {core} l2tp support needed (xl2tp from
    community)
-   FS#13026 Assigned | {archweb} Add a json interface for ABS as we
    have for AUR
-   FS#10703 Assigned | Implement OpenID to link Arch pages.
-   FS#19580 Assigned | [kdeplasma-addons-applets-kimpanel] ibus backend
-   FS#18417 Assigned | {core} Make a "wifi-drivers" group
-   FS#13441 Assigned | {archweb} Display new packages somewhere in the
    website
-   FS#11604 Assigned | {archweb} Package Colours - better visual
    information
-   FS#9384 Assigned | [initscripts] allow read only root

See also
--------

-   Bug Day

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bug_Day/2010&oldid=238704"

Categories:

-   Arch development
-   Package development
-   Events
