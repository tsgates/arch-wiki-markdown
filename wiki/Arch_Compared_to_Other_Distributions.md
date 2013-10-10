Arch Compared to Other Distributions
====================================

> Summary

A brief comparison of Arch Linux with other popular GNU/Linux
distributions and BSDs.

> Related

Arch Linux

The Arch Way

External links

DistroWatch.com

This page attempts to draw a comparison between Arch Linux and other
popular GNU/Linux distributions and UNIX-like operating systems. The
summaries that follow are brief descriptions that may help a person
decide if Arch Linux will suit their needs. Although reviews and
descriptions can be useful, first-hand experience is invariably the best
way to compare distributions.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Source-based                                                       |
|     -   1.1 Gentoo Linux                                                 |
|     -   1.2 Sorcerer/Lunar-Linux/Source Mage                             |
|                                                                          |
| -   2 Minimalist                                                         |
|     -   2.1 LFS                                                          |
|     -   2.2 CRUX                                                         |
|     -   2.3 Slackware                                                    |
|                                                                          |
| -   3 General                                                            |
|     -   3.1 Debian GNU/Linux                                             |
|     -   3.2 Fedora                                                       |
|     -   3.3 Frugalware                                                   |
|                                                                          |
| -   4 Beginner-friendly                                                  |
|     -   4.1 Ubuntu                                                       |
|     -   4.2 Mandriva                                                     |
|     -   4.3 openSUSE                                                     |
|     -   4.4 PCLinuxOS                                                    |
|                                                                          |
| -   5 The *BSDs                                                          |
|     -   5.1 FreeBSD                                                      |
|     -   5.2 NetBSD                                                       |
|     -   5.3 OpenBSD                                                      |
+--------------------------------------------------------------------------+

Source-based
------------

Source-based distributions are highly portable, giving the advantage of
controlling and compiling the entire OS and applications for a
particular machine architecture and usage scheme, with the disadvantage
of the time-consuming nature of source compilation. The Arch base and
all packages are compiled for i686 and x86-64 architectures, offering a
potential performance boost over i386/i486/i586 binary distributions,
with the added advantage of expedient installation.

> Gentoo Linux

Both Arch Linux and Gentoo Linux are rolling release systems, making
packages available to the distribution a short time after they are
released upstream. The Gentoo packages and base system are built
directly from source code according to user-specified 'USE flags'. Arch
provides a ports-like system for building packages from source, though
the Arch base system is designed to be installed as pre-built
i686/x86_64 binary. This generally makes Arch quicker to build and
update, and allows Gentoo to be more systemically customizable. Arch
supports i686 and x86_64 while Gentoo officially supports x86, PPC,
SPARC, Alpha, AMD64, ARM, MIPS, HP/PA, S/390, sh, and Itanium
architectures. Because both the Gentoo and Arch installations only
include a base system, both are considered to be highly customizable.
Gentoo users will generally feel quite comfortable with most aspects of
Arch.

> Sorcerer/Lunar-Linux/Source Mage

Sorcerer/Lunar-Linux/Source Mage (SLS) are all source-based
distributions originally related to one another. SLS distributions use a
rather simple set of script files to create package descriptions, and
use a global configuration file to configure the compilation process,
much like the Arch Build System. The SLS tools do full dependency
checking, including handling optional features, package tracking,
removal and upgrading. There are no binary packages for any of the SLS
family, although they all provide the ability to roll back to earlier
installed packages easily.

The installation process involves configuring a simple base system from
the shell and ncurses menus, then optionally recompiling the base system
afterward. Like Arch, there is no default WM/DE/DM, and Xorg is not
included in the base installation. Several X server alternatives are
available (X.Org 6.8 or 7, XFree86).

SLS has a very complicated history. Perhaps the best write-up about it
can be found at the SourceMage wiki.

Minimalist
----------

The minimalist distributions are quite comparable to Arch, sharing
several similarities. All are considered 'simple' from a technical
standpoint.

> LFS

LFS, (or Linux From Scratch) exists simply as documentation. The book
instructs the user on obtaining the source code for a minimal base
package set for a functional GNU/Linux system, and how to manually
compile, patch and configure it from scratch. LFS is as minimal as it
gets, and offers an excellent and educational process of building and
customizing a base system. Arch provides these very same packages, plus
systemd, a few extra tools and the powerful pacman package manager as
its base system, already compiled for i686/x86-64. LFS provides no
online repositories; sources are manually obtained, compiled and
installed with make. (Several manual methods of package management
exist, and are mentioned in LFS Hints). Along with the minimal Arch base
system, the Arch community and developers provide and maintain many
thousands of binary packages installable via pacman as well as PKGBUILD
build scripts for use with the Arch Build System. Arch also includes the
makepkg tool for expediently building or customizing .pkg.tar.xz
packages, readily installable by pacman. Judd Vinet built Arch from
scratch, and then wrote pacman in C. Historically, Arch was sometimes
humorously described simply as "Linux, with a nice package manager."

> CRUX

Before creating Arch, Judd Vinet admired and used CRUX; a minimalist
distribution created by Per Lidén. Originally inspired by ideas in
common with CRUX and BSD, Arch was built from scratch, and pacman was
then coded in C. Arch and CRUX share some guiding principles: for
instance, both are architecture-optimized, minimalist and
K.I.S.S.-oriented. Both ship with ports-like systems, and, like *BSD,
both provide a minimal base environment to build upon. Arch features
pacman, which handles binary system package management and works
seamlessly with the Arch Build System. CRUX uses a community contributed
system called prt-get, which, in combination with its own ports system,
handles dependency resolution, but builds all packages from source
(though the CRUX base installation is binary). Arch officially supports
x86-64 and i686 only, whereas CRUX officially offers only x86_64.

Arch uses a rolling-release system and features a large array of binary
package repositories as well as the Arch User Repository. CRUX provides
a more slimmed-down officially supported ports system in addition to a
comparatively modest community repository.

> Slackware

-   Slackware and Arch are quite similar in that both are simple
    distributions focused on elegance and minimalism.

-   Slackware is famous for its lack of branding and completely vanilla
    packages, from the kernel up. Arch typically applies patching only
    to avoid severe breakage or to ensure packages will compile cleanly.

-   Slackware uses BSD-style init scripts, Arch uses systemd.

-   Arch supplies a package management system in pacman which, unlike
    Slackware's standard tools, offers automatic dependency resolution
    and allows for more automated system upgrades. Slackware users
    typically prefer their method of manual dependency resolution,
    citing the level of system control it grants them, as well as
    Slackware's excellent supply of pre-installed libraries and
    dependencies.

-   Arch is a rolling-release system. Slackware is seen as more
    conservative in its release cycle, preferring proven stable
    packages. Arch is more 'bleeding-edge' in this respect.

-   Arch Linux provides many thousands of binary packages within its
    official repositories whereas Slackware official repositories are
    more modest.

-   Arch offers the Arch Build System, an actual ports-like system and
    also the AUR, a very large collection of PKGBUILDs contributed by
    users. Slackware offers a similar, though slimmer system at
    slackbuilds.org which is a semi-official repository of Slackbuilds,
    which are analogous to Arch PKGBUILDs. Slackware users will
    generally be quite comfortable with most aspects of Arch.

General
-------

These distributions offer a broad range of advantages and strengths, and
can be made to serve most operating system uses.

> Debian GNU/Linux

-   Debian is the largerst upstream linux distribution with a bigger
    community and features stable, testing, and unstable branches,
    offering over 30,000 high quality binary packages. The available
    number of Arch binary packages is more modest. However, when
    including the AUR, the quantities are very comparable.

-   Debian has a more vehement stance on free software but still
    includes non-free software in its non-free repos. Arch is more
    lenient, and therefore inclusive, concerning 'non-free' packages as
    defined by GNU, thereby leaving the choice to the users.

-   Debian's design approach focuses more on stability and stringent
    testing and focus based mostly on its famous "Debian social
    contract". Arch is focused more on the philosophy of simplicity,
    minimalism, and offering bleeding edge software. Arch packages are
    more current than Debian Stable and Testing, being more comparable
    to the Debian Unstable branch.

-   Both Debian and Arch offer well-regarded package management systems.

-   Arch is a rolling release, whereas Debian Stable is released with
    "frozen" packages. Debian unstable is rolling.

-   Debian is available for many architectures, including alpha, arm,
    hppa, i386, x86_64, ia64, m68k, mips, mipsel, powerpc, s390, and
    sparc, whereas Arch is officially i686 and x86_64, with community
    ports for arm (for Raspberry Pi for example) only.

-   Arch provides more expedient support for building custom,
    installable packages from outside sources, with a ports-like package
    build system. Debian does not offer a ports system, relying instead
    on its huge binary repositories.

-   The Arch installation system only offers a minimal base,
    transparently exposed during system configuration, whereas Debian's
    methods offer a more automatically configured approach as well as
    several alternative methods of installation.

-   Debian utilizes the SysVinit by default even though systemd and
    upstart are available for users to configure, whereas Arch uses
    systemd by default for overall better performance.

-   Arch keeps patching to a minimum, thus avoiding problems that
    upstream are unable to review, whereas Debian patches its packages
    more liberally for a wider audience.

> Fedora

-   Fedora is community developed, yet corporately backed by Red Hat; it
    is often presented as a bleeding edge testbed release system; Fedora
    packages and projects migrate to RHEL and some eventually become
    adopted by other distributions. Arch too is generally considered
    bleeding edge, although it is a rolling-release and does not serve
    as a testing branch for another distribution.

-   Fedora packages are RPM format, using the YUM package manager, and
    official graphical package tools are also available. Arch uses
    pacman to manage tar.xz packages and does not officially support a
    graphical frontend.

-   Fedora refuses to include MP3 media support and other non-free
    software in official repositories due to its dedication to free
    software, though third-party repositories are available for such
    packages. Arch is more lenient in its disposition toward MP3 and
    non-free software, leaving the discernment to the user.

-   Fedora offers many installation options including a graphical
    installer as well as a minimal option. Fedora "spins" also provide
    alternative assortments of desktop environments to choose from, each
    with a modest assortment of default packages. Arch, on the other
    hand, only provides a few scripts meant to ease the process of a
    minimal base system install.

-   Fedora has a scheduled release cycle, but officially supports
    discrete version upgrades with the FedUp tool. Arch is a
    rolling-release system.

-   The Arch Way focuses on simplicity, lightweight elegance and
    empowering the user, whereas Fedora Core Values focus on free
    software, community development and bleeding edge systemic
    innovation.

-   Arch features a ports system, whereas Fedora does not.

-   Both Arch and Fedora are targeted at experienced users and
    developers. Both strongly encourage their users to contribute to
    project development.

-   Fedora has earned much community recognition for integration of
    SELinux, GCJ compiled packages (to remove the need for Sun's JRE),
    and prolific upstream contribution; Red Hat and thus, Fedora
    developers by extension, contribute the highest percentage of Linux
    kernel code as compared to any other project.

-   Arch Linux provides what is widely regarded as the most thorough and
    comprehensive distribution wiki. The Fedora wiki is used in the
    original sense of the word "wiki", or a way to exchange information
    between developers, testers and users rapidly. It is not meant to be
    an end-user knowledge base like Arch's. Fedora's wiki resembles an
    issue tracker or a corporate wiki.

> Frugalware

-   Arch is command-line oriented.

-   Frugalware does not support the JFS filesystem by default.

-   Both Arch and Frugalware are promoted as i686 optimized.

-   Arch can be installed as a minimal environment first and later
    expanded with pacman according to the user's choices and needs.
    Frugalware is installed from a DVD, with default software choices
    and desktop environment chosen for the user already.

-   Frugalware has a scheduled release cycle. Again, Arch is more
    focused on simplicity, minimalism, code-correctness and bleeding
    edge packages within a rolling-release model.

Beginner-friendly
-----------------

Sometimes called "newbie distros", the beginner-friendly distributions
share a lot of similarities, though Arch is quite different from them.
Arch may be a better choice if you want to learn about GNU/Linux by
building up from a very minimal base, as an installation of Arch
installs very few packages in comparison. Specific differences between
distributions are described below.

> Ubuntu

-   Ubuntu is an immensely popular Debian-based distribution
    commercially sponsored by Canonical Ltd., while Arch is an
    independently developed system built from scratch.

-   Both projects have very different goals and are targeted at a
    different user base. Arch is designed for users who desire a
    do-it-yourself approach, whereas Ubuntu provides an autoconfigured
    system which is meant to be more user-friendly. Arch is presented as
    a much more minimalist design from the base installation onward,
    relying heavily on the user to customize it to their own specific
    needs. In general, developers and tinkerers will probably like Arch
    better than Ubuntu, though many Arch users have started on Ubuntu
    and eventually migrated to Arch.

-   Current Ubuntu development and promotion seem to be heavily
    embracing the touch screen device market, whereas Arch development
    is more generally focused on a user-centric model which empowers its
    community to create customized solutions to be developed
    collaboratively.

-   Ubuntu moves between discrete releases every 6 months, whereas Arch
    is a rolling-release system with a new snapshot issued every month.

-   Arch offers a ports-like package build system, while Ubuntu does
    not.

-   The two communities differ in some ways as well. The Arch community
    is much smaller and is strongly encouraged to contribute to the
    distribution. In contrast, the Ubuntu community is relatively large
    and can therefore tolerate a much larger percentage of users who do
    not actively contribute to development, packaging, or repository
    maintenance.

> Mandriva

Mandriva Linux (formerly Mandrake Linux) was created in 1998 with the
goal of making GNU/Linux easy to use for everyone. It is RPM-based and
uses the urpmi package manager. Again, Arch takes a simpler approach,
being text-based and relying on more manual configuration and is aimed
at intermediate to advanced users.

> openSUSE

openSUSE is centered around the RPM package format and its well-regarded
YaST2 GUI-driven configuration tool, which is a one-stop shop for most
users' system configuration needs, including package management. Arch
does not offer such a facility as it goes against The Arch Way.
openSUSE, therefore, is widely regarded as more appropriate for
less-experienced users, or those who want a more GUI-driven environment,
auto-configuration and expected functionality out of the box.

> PCLinuxOS

-   PCLinuxOS is a popular Mandriva-based distribution providing a
    complete DE, designed for user-friendliness and is described as
    "simple", though its definition of simple is quite different than
    the Arch definition. Arch is designed as a simple base system to be
    customized from the ground up and is aimed more toward advanced
    users.

-   PCLOS uses the apt package manager as a wrapper for RPM packages.
    Arch uses its own independently-developed pacman package manager
    with .pkg.tar.xz packages.

-   PCLOS is very GUI-driven, provides GUI hardware configuration tools
    and the Synaptic package management front-end, and claims to have
    little or no reliance on the shell. Arch is command-line oriented
    and designed for more simple approaches to system configuration,
    management and maintenance.

-   PCLOS recommends 256 MB RAM as part of its minimum system
    requirements. Being more lightweight, Arch can run on systems with
    much less system memory, requiring only 64 MB of RAM for a base i686
    install, and will run flawlessly on more modern systems.

The *BSDs
---------

*BSDs share a common origin and descend directly from the work done at
UC Berkeley to produce a freely redistributable, free of cost, UNIX
system. They are not GNU/Linux distributions, but rather, UNIX-like
operating systems. Therefore, although Arch and the *BSDs share the
concept of a tightly-integrated base and ports system, along with a
similar init framework, they are absolutely not related from a code
standpoint, except for perhaps vi, as Arch's vi is the original BSD vi
(most *BSDs do not use the original BSD vi anymore). *BSDs were derived
from the original AT&T UNIX code and have a true UNIX heritage. To learn
more about the *BSD variants, visit the vendor's site.

> FreeBSD

-   Both Arch and FreeBSD offer software which can be obtained using
    binaries or compiled using 'ports' systems.

-   Like other *BSDs, the FreeBSD base is developed fundamentally as a
    system designed as a whole, with each application 'ported' over to
    FreeBSD and made sure to work in the process. In contrast, GNU/Linux
    distributions such as Arch exist as amalgams combined from many
    separate sources.

-   The FreeBSD license is generally more protective of the coder, in
    contrast to the GPL, which favors protection of the code itself.
    Arch is released under the GPL.

-   In FreeBSD, like Arch, decisions are delegated to you, the power
    user. This may be the most interesting comparison to Arch since it
    goes head-to-head in package modernity and has a somewhat sizable,
    smart, active, no-nonsense community.

-   Both systems share many similarities and FreeBSD users will
    generally feel quite comfortable with most aspects of Arch.

> NetBSD

-   NetBSD is a free, secure, and highly portable UNIX-like open-source
    operating system available for over 50 platforms, from 64-bit
    Opteron machines and desktop systems to hand-held and embedded
    devices. Its clean design and advanced features make it excellent in
    both production and research environments, and it is user-supported
    with complete source. Many applications are easily available through
    pkgsrc, the NetBSD Packages Collection.

-   Arch may not operate on the vast number of devices NetBSD operates
    on, but for an i686 system it may offer more applications.

-   NetBSD's pkgsrc provides a source based method of installation
    similar to Arch's ABS; however binary packages are also available
    using pkg_tools.

-   Arch does share similarities with NetBSD: both require manual
    configuration, they are minimalist and lightweight, both offer ports
    systems as well as binaries and both have active, no-nonsense
    developers and communities.

> OpenBSD

The OpenBSD project produces a free, multi-platform 4.4BSD-based
UNIX-like operating system.

-   OpenBSD focuses on portability, standardization, code correctness,
    proactive security, and integrated cryptography. In contrast, Arch
    focuses more on simplicity, elegance, minimalism and bleeding edge
    software. OpenBSD is self-described as "perhaps the #1 security OS".

-   Both Arch and OpenBSD offer a small, elegant, base install.

-   Both offer a ports and packaging system to allow for easy
    installation and management of programs which are not part of the
    base operating system.

-   In contrast to a GNU/Linux system like Arch, but in common with most
    other BSD-based operating systems, the OpenBSD kernel and userland
    programs, such as the shell and common tools (like ls, cp, cat and
    ps), are developed together in a single source repository.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Arch_Compared_to_Other_Distributions&oldid=255074"

Category:

-   About Arch
