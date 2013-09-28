Bug Day/2012
============

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 About                                                              |
| -   2 Bug stats                                                          |
| -   3 System                                                             |
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
|         -   4.2.4 Orphan bugs                                            |
|                                                                          |
|     -   4.3 [community]                                                  |
|         -   4.3.1 Status?                                                |
|         -   4.3.2 Trivial fixes                                          |
|         -   4.3.3 Orphan Bugs                                            |
|                                                                          |
| -   5 Upstream bugs                                                      |
|     -   5.1 No response                                                  |
|     -   5.2 Status?                                                      |
|                                                                          |
| -   6 Website                                                            |
|     -   6.1 Status?                                                      |
|                                                                          |
| -   7 Pacman                                                             |
| -   8 Old Bugs (Bugs open before 2012-01-01)                             |
|     -   8.1 [extra]                                                      |
|     -   8.2 [Community]                                                  |
|                                                                          |
| -   9 See also                                                           |
+--------------------------------------------------------------------------+

About
-----

Be prepared for Bug Day, the 17st of November 2012!

Bug stats
---------

Number of bugs:

  --------------------- -------------- -------- --------
  Project               At beginning   At end   Closed
  Arch Linux            599            417      182
  Community             193            160      33
  Pacman                149            150      0
  AUR                   37             34       3
  Release Engineering   75             74       1
  Total                 1053           835      218
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

System
------

Packages
--------

> [core]

Decision?

-   FS#NNNNN - BUGTITLE

Status?

-   FS#NNNNN - BUGTITLE

Trivial fixes

-   FS#31287 - [pptpclient] missing binutils dependency
-   FS#32720 - [openldap] /usr/lib/tmpfiles.d/slapd.conf permissions too
    tight for /run/openldap/ldapi access
-   FS#32719 - [openldap] /usr/lib/systemd/system/slapd.service is
    incomplete
-   FS#32575 - [mkinitcpio] re-enable autodetection of hid modules in
    usbinput?
-   FS#32437 - [iptables] Units should support reload
-   FS#31843 - [iptables] iptables-flush is missing empty rulesfiles for
    ip6tables
-   FS#31543 - [dhcpcd] Provide dhcpcd.service for systemd
-   FS#31286 - [archlinux-keyring] update signature database
    automatically in the install ISO
-   FS#30770 - [grub-common] memtest86+ options

> [extra]

Decision?

-   FS#NNNNN - BUGTITLE

Status?

-   FS#NNNNN - BUGTITLE

Trivial fixes

-   FS#31478 - [transmission-cli] Add "After=network.target" in the
    .service file dof systemd
-   FS#30996 - [libgdiplus] Segfault on x86_64, rebuild required
-   FS#26012 - [kdebase-workspace] Missing dependency on a ttf- package
-   FS#31768 - [poppler] make dependency on poppler-data optional
-   FS#31494 - [cyrus-sasl] typo in saslauthd.service systemd unit
-   FS#31385 - [gimp-ufraw] Please enable all features for ufraw
-   FS#31056 - [usbmuxd] systemd cant enable usbmuxd
-   FS#29720 - [pm-utils] Add optional dependency on wireless_tools
-   FS#27655 - [licenses] Add OFL to the list of the common licenses
-   FS#32576 - [totem] Unneeded dependency: mx
-   FS#32552 - [mono] PKGBUILD is pointing to wrong source
-   FS#32550 - [rhythmbox] Reduce dependencies
-   FS#32543 - [suitesparse] depends on intel-tbb
-   FS#32462 - [samba] Add inetd-style smbd units (attached)
-   FS#32359 - [postgresql] /var/lib/postgres/data not created when
    installed
-   FS#31604 - [ffmpeg] add --enable-avresample when configure
-   FS#31547 - [licenses] please add version 2.0 of MPL (Mozilla Public
    License)
-   FS#31313 - [hdf5] Enable C++ and Fortran support
-   FS#31271 - [net-tools] fails to compile
-   FS#31251 - [rsync] use $RSYNCD_ARGS instead of ${RSYNCD_ARGS} in
    systemd service file
-   FS#30883 - [network-manager-applet] add gnome-keyring as optdepend
-   FS#30651 - [hugin] make autopano-sift-c optional
-   FS#30010 - [qhull] recompile with -fPIC
-   FS#28635 - [libbonobo] remove pidof from install file
-   FS#28496 - [mod_mono] .conf located elsewhere
-   FS#26715 - [kdesdk-poxml] Many KDE non-application packages have
    wrong upstream URL
-   FS#26627 - [lighttpd] fam stat cache support
-   FS#22542 - [wpa_supplicant_gui] CFLAGS and CXXFLAGS
-   FS#32568 - [namcap] Namcap on PKGBUILD incorrectly reports missing
    checksums error
-   FS#31661 - [texlive-latexextra] /usr/bin/pdfthumb is a broken
    symlink
-   FS#28619 - [qhull] Docs installed in /usr/share/doc instead of
    /usr/share/doc/qhull

Orphan bugs

-   FS#31071 [pmount] Add bash completion

> [community]

Status?

-   FS#NNNNN - BUGTITLE

Trivial fixes

-   FS#31487 - [cksfv] wrong url field
-   FS#31821 - [rsyslog] default rsyslog.conf contains deprecated syntax
-   FS#32283 - [expac] wrong license field
-   FS#28704 - [ntp] run as non-root user
-   FS#28702 - [openntpd] delete ntp user
-   FS#31266 - [ntop] python support
-   FS#31468 - [adesklets] project is dead
-   FS#32422 - [unbound] systemd service needs After=network.target
-   FS#32135 - [xnee] no optional dep for xosd
-   FS#32534 - [ettercap] Development has been moved to GitHub
-   FS#32542 - [znc] PKGBUILD cleanup (systemd support, unneeded
    options)
-   FS#32570 - [widelands-data] missing makedepends ggz-client-libs
-   FS#31228 - [snort] systemd service file
-   FS#31371 - [noip] support request for systemd
-   FS#31875 - [terminus-font] better PKGBUILD
-   FS#32579 - [ncmpcpp] PKGBUILD source-url is wrong
-   FS#32414 - [gtk-engine-unico] md5sum mismatch
-   FS#32274 - [clementine] Add google drive support
-   FS#32134 - [libgda3] [libgda4] Drop legacy packages
-   FS#32133 - [pessulus] Drop package
-   FS#31895 - [swftools] should not depend on avifile
-   FS#31315 - [privoxy] enable comprssion
-   FS#31273 - [redshift] compile with geoclue support
-   FS#31106 - [tvtime] change .desktop filename
-   FS#28909 - [gdal] build with hdf4 support
-   FS#28888 - [bashrun] is deprecated; replace community package with
    bashrun2?
-   FS#28384 - [quassel] split package: core and client
-   FS#27954 - [task] /usr/bin/tasknote has by default EDITOR set to
    sensible-editor, should be $EDITOR
-   FS#27910 - [ttytter] please add perl-term-readline-ttytter as an
    optional dependency
-   FS#27905 - [vym] language files are not compiled
-   FS#26590 - [lmms] broken support for VST plugins
-   FS#26662 - [libcompizconfig] remove dependency on libxml++?
-   FS#26820 - [man-pages-de] man pages from directory "generated" are
    missing
-   FS#31611 - [ibus-qt] Segfault when trying to unlock a GPG key with
    pinentry-qt4

Orphan Bugs

-   FS#32521 [dcron] Restart on crash

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

Old Bugs (Bugs open before 2012-01-01)
--------------------------------------

> [extra]

-   FS#26573 [srcpac] spins around gcc-libs all the time
-   FS#26363 [firefox] crash libc.so.6
-   FS#26208 [transcode] error at end of pass 1 when called from dvdrip
-   FS#26012 [kdebase-workspace] Missing dependency on a ttf- package
-   FS#25303 Waiting on Response | [texlive-core,bin] ConTeXt compile
    error
-   FS#23101 [devtools, db-scripts] add database signatures
-   FS#27695 [initscripts] netfs: fix endless waits for stale timeouts
-   FS#27409 [initscripts] shutdown hangs on Unmounting Non-API
    Filesystems
-   FS#26985 [openvpn] init script "status" and "vpn_name" options
-   FS#26638 {wiki} Proposal: Translate extension
-   FS#26362 [gnome-themes-standard] GNOME should set the default icon
    theme
-   FS#26245 [firefox] creates additional shortcuts if set as default
-   FS#26200 [gnome-control-center] 3.2.0-1 does not show any items when
    used
-   FS#26104 Waiting on Response | [xorg] consumes 100% CPU after
    suspend
-   FS#26079 [ppp] should backup /etc/ppp/ip-{up,down}.d/00-dns.sh
-   FS#25793 [abs] Add parsing of rsync args from the config file
-   FS#25628 [srcpac] Add support for building packges from Git
-   FS#25003 {archweb} Search for filenames
-   FS#24999 Migrate Arch Linux Flyspray bug tracker to an alternative
    bug tr
-   FS#24898 [dhcpcd] must be run with '-p'
-   FS#24793 [ifplugd] no longer works by itself, it requires
    net-auto-wired
-   FS#24503 [xorg-xdm] Fails if .xinitrc is not executable
-   FS#23673 [lirc-utils] lircd init script should set remote protocol
    to "li
-   FS#23296 [xorg] Several xorg-* packages not in any xorg group
-   FS#22746 [docbook-xsl] Lack of Epub support breaks asciidocs' a2x
-   FS#22563 [mdadm] add a cronjob to scrub data on mdadm arrays
-   FS#22302 [alsa-utils] ALSA daemon script
-   FS#20603 [xf86-video-intel] Fonts broken
-   FS#20515 [glpk] Please include documentation
-   FS#20302 {bugtracker} Password length issue
-   FS#19392 [xterm] w/who does not show my login shell
-   FS#18691 [unzip] iconv patch needed to support UTF-8 filenames
    created in
-   FS#17390 {dbscripts} Add support for split packages of different
    arches
-   FS#16702 [linux] Versioned Kernel installs
-   FS#15865 {bugtracker} attached files should have a MIME type
    attached/sen
-   FS#9396 [namcap] fails to detect dependencies on uninstalled shared
    libs
-   FS#27775 [libpcap] static library is missing
-   FS#27755 [gnome-menus] gmenu-simple-editor is not working properly
-   FS#27745 [texmacs] please add qt interface
-   FS#27674 [qt] ignores fontconfig settings
-   FS#27655 [licenses] Add OFL to the list of the common licenses
-   FS#27589 {bbs} Probably you should "restrict" the forums theme to
    the Arc
-   FS#27544 [devtools] mkarchroot should use mirror specified in chroot
-   FS#27520 Waiting on Response | [akonadi] doesn't properly create its
    mysql database
-   FS#27507 [mdadm] Cannot --grow Raid0 array from 2 devices to three
    in mda
-   FS#27485 [namcap] warn on unstripped files
-   FS#27432 [mod_wsgi] build using python version 3
-   FS#27408 [linux] rtc is not corrected if more than 15 minutes off
-   FS#27344 [php] modules in extra are missing a configuration ini
-   FS#27257 [libreoffice] python-uno bridge does not work
-   FS#26956 [devtools] Fix `usage' message to use in all commands
    `usage: ..
-   FS#26927 [netcfg] netcfg should be aware of net-auto-wireless
-   FS#26924 [netcfg] Support for /etc/resolve.conf.head and
    /etc/resolve.con
-   FS#26753 {archweb} Add wip state to todo list
-   FS#26732 [lyx] cannot locate .cls files (python 3)
-   FS#26715 [kdesdk-poxml] Many KDE non-application packages have wrong
    upst
-   FS#26710 [libimobiledevice] Cannot talk to ios5 device
-   FS#26669 {archweb} Add private address information to dev profiles
-   FS#26658 [linux] Regression: 3.1 - 3.3.x breaks some ACPI events on
    Lenov
-   FS#26627 [lighttpd] fam stat cache support
-   FS#26579 [slim] special users "console" and "exit" fail.
-   FS#26499 [netcfg] OpenVPN interfaces are tracked as INTERFACE value,
    not
-   FS#26473 [cmake] precompile /usr/share/emacs/site-lisp/cmake-mode.el
-   FS#26413 [namcap] should also check shell scripts
-   FS#26402 [netcfg] 2.6.8-1 writes a runfile when it shouldn't
-   FS#26383 {archweb} Add "exact match" option to package search
-   FS#26324 [tomboy] slowed session logout
-   FS#26265 [devtools] add support for multiple -I flags to archbuild
-   FS#26173 [pylint] Missing python 3 version
-   FS#26135 [ca-certificates] missing Verisign Class 3 root cert
-   FS#26087 [netcfg] add wireless access point connection type
-   FS#25973 [qwt] doesn't provide qt designer plugin
-   FS#25895 [networkmanager] all-users automatic CDMA connection does
    not st
-   FS#25741 [digikam] Themes configuration dialogue does not open
-   FS#25658 [devtools] move .lock files generated by mkarchroot and
    makechro
-   FS#25499 [fontconfig] 29-replace-bitmap-fonts.conf thwarts gsfonts
-   FS#25427 [netcfg] Make IPv4 ADDR Variable an Array for IP Aliasing?
-   FS#25319 [banshee]Inhibit sleep/screenaver is broken with Gnome 3
-   FS#25256 [ppp] Replace a file "/etc/resolv.conf" by default is a bad
    idea
-   FS#25174 [libmtp] mtp-detect throws PTP_ERROR_IO on Samsung Galaxy
    S2 (GT
-   FS#24953 [zsh] /etc/profile should not replace /etc/zprofile and
    conflict
-   FS#24788 [gobject-introspection] Problem with python's
    gobject-introspect
-   FS#24589 [ppp] package uses its own scripts rather than from
    upstream
-   FS#24556 [gdm] Overwrites default pre- and postsession configuration
    on u
-   FS#24539 [gvfs] gvfsd-http leaks file handles
-   FS#24535 [mirage] does not use translations
-   FS#24301 [gnome-shell] shortcuts not working if there's one
    workspace onl
-   FS#24296 [namcap] detect java-environment dependency intead of the
    corre
-   FS#23978 [enblend-enfuse] bug -> split-package with OpenMP
-   FS#23899 Waiting on Response | [xorg] Synaptics: Trackpad
    inoperable; Xorg registers HDA as syn
-   FS#23896 [pacman-mirrorlist] dynamic mirrorlists
-   FS#23639 [truecrypt] "broken pipe" when trying to mount newly
    created vol
-   FS#23518 [pam] PKGBUILD of pam 1.1.3-1 limits @audio to -10 when
    pulseaud
-   FS#23453 [qemu-kvm] [qemu] Enable spice support when building
    qemu-kvm
-   FS#23404 [inux-firmware] iwlagn firmware problems with each
    linux-firmwar
-   FS#23357 [namcap] detect overlinked libraries
-   FS#23298 {archweb} Add [staging] repos information
-   FS#23228 {archweb} DoesNotExist: ContentType matching query does not
    exis
-   FS#23198 [ppp] Add option to use openresolve to manage
    /etc/resolv.conf
-   FS#23194 [pkgstats] How to obtain the 'pkgstats' data
    programmatically
-   FS#23182 [cryptsetup] Multiple device support for encrypt hook
-   FS#22542 [wpa_supplicant_gui] CFLAGS and CXXFLAGS
-   FS#22480 [ppp] remove from base group
-   FS#22393 [wicd] doesnt support ipv6 dns
-   FS#22131 [archweb] Proposal on how to create one user database for
    all ap
-   FS#21682 [gthumb] still can't import photos after installing
    optdepend ex
-   FS#21550 [xorg] Printing DDC gathered Modelines loop
-   FS#21472 [netcfg] Generate pppd configuration in netcfg
-   FS#21453 [netcfg] Make static /etc/resolv.conf configurable via
    RESOLV_CO
-   FS#20864 [netcfg] Support 3G (HSDPA) cards in network interface mode
-   FS#20721 [thinkfinger] fast entering password using keyboard fails
-   FS#20217 Researching | [makepkg] list dependencies explicitly: two
    suggestions
-   FS#20074 {bugtracker} search term ending with a space gives a 500
    error
-   FS#19428 [docbook-xml] Provide a 'catalog' file for each version
-   FS#18931 [netcfg] [patch] Add WWAN support (UMTS/3G)
-   FS#18590 {repo} enable Delta support in repositories
-   FS#18485 {archweb} Search doesn't trim leading/trailing spaces
-   FS#17326 [ssmtp] setgid mail
-   FS#15747 [kismet] kismet_client - blank
-   FS#15738 [cryptsetup] initcpio-hook enhancement
-   FS#14252 [kdebase-workspace] rewrites Xsetup
-   FS#13026 {archweb} Add a json interface for ABS as we have for AUR
-   FS#10703 Implement OpenID to link Arch pages.
-   FS#26435 [namcap] Print notice when GNU_RELRO is missing in ELF
    file.
-   FS#24537 [abs] Repository Update Policy
-   FS#19789 [mysql] possible to have a /etc/rc.d/mysqld_multi?
-   FS#13441 {archweb} Display new packages somewhere in the website
-   FS#11604 {archweb} Package Colours - better visual information

> [Community]

-   FS#27551 [scribes] does not run as non-root user
-   FS#26920 [couchdb] Three failed tests in Futon's test suite
-   FS#26447 [adesklets] refuses to work, and the installer throws an
    error
-   FS#18292 [dcron] Should create ID Flag when not given to be
    compatible to
-   FS#26510 [amsn] webcam problem
-   FS#25911 [scribes] word completion does not work
-   FS#24544 [dcron] Locale is not set by DCron init script
-   FS#27707 [aircrack-ng] different package splitting
-   FS#27675 [dcron] If a job is scheduled to run within a band of times
    with
-   FS#27587 [openntpd] does not create ntp user during system install
-   FS#27549 [trickle] hogs CPU and does not obey limits
-   FS#27517 [goldendict] apply wiki-images related fix
-   FS#27387 [pkgtools] pkgconflict & whoneeds: can we please have a
    standard
-   FS#27313 [pkgtools] pkgfile-hook hooks should not execute when piped
    or i
-   FS#26820 [man-pages-de] man pages from directory "generated" are
    missing
-   FS#26662 [libcompizconfig] remove dependency on libxml++?
-   FS#26590 [lmms] broken support for VST plugins
-   FS#26420 [packagekit] All updates are the same type
-   FS#26381 [Synergy] bug: Cursor trapped under GNOME 3 (gnome-shell)
-   FS#26268 [gksu] replace with pkexec in application launchers
-   FS#25993 [ipython] IPython.utils.traitlets.TraitError
-   FS#25338 [compiz] graphic bug
-   FS#25286 [pidgin-libnotify] "Show" button doesn't trigger any action
    (lin
-   FS#25240 [compiz-decorator-gtk] Dependency on gnome-control-center?
-   FS#24959 [xmonad] GDM and gnome session
-   FS#24379 [gdal] Consider installing python bindings into python 3 as
    well
-   FS#23873 [compiz-decorator-gtk] compiz.desktop should run compiz ccp
    by d

See also
--------

-   Bug Day

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bug_Day/2012&oldid=238710"

Categories:

-   Arch development
-   Package development
-   Events
