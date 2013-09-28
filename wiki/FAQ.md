FAQ
===

Besides the questions covered below, you may find The Arch Way and Arch
Linux helpful. Both articles contain a good deal of information about
Arch Linux.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 General                                                            |
|     -   1.1 Q) What is Arch Linux?                                       |
|     -   1.2 Q) Why would I want to use Arch?                             |
|     -   1.3 Q) Why would I not want to use Arch?                         |
|     -   1.4 Q) What distribution is Arch based on?                       |
|     -   1.5 Q) I am a complete GNU/Linux beginner. Should I use Arch?    |
|     -   1.6 Q) Arch requires too much time and effort to install and     |
|         use. Also, the community keeps telling me to RTFM in so many     |
|         words                                                            |
|     -   1.7 Q) Is Arch designed to be used as a server? A desktop? A     |
|         workstation?                                                     |
|     -   1.8 Q) I really like Arch, except the development team needs to  |
|         implement "feature X"                                            |
|     -   1.9 Q) When will the new release be made available?              |
|     -   1.10 Q) Is Arch Linux a stable distribution? Will I get frequent |
|         breakage?                                                        |
|     -   1.11 Q) Arch needs more press (i.e. advertisement)               |
|     -   1.12 Q) Arch needs more developers                               |
|     -   1.13 Q) Why is my internet so slow compared to other operating   |
|         systems?                                                         |
|     -   1.14 Q) Why is Arch using all my RAM?                            |
|     -   1.15 Q) Where did all my free space go?                          |
|                                                                          |
| -   2 Package Management                                                 |
|     -   2.1 Q) In which package is X in?                                 |
|     -   2.2 Q) I've found an error with Package X. What should I do?     |
|     -   2.3 Q) Arch packages need to use a unique naming convention.     |
|         ".pkg.tar.gz" and ".pkg.tar.xz" are too long and/or confusing    |
|     -   2.4 Q) Pacman needs a library so other applications can easily   |
|         access package information                                       |
|     -   2.5 Q) Why doesn't pacman have an official GUI front-end?        |
|     -   2.6 Q) Pacman needs "feature X"!                                 |
|     -   2.7 Q) Arch needs a stable package branch                        |
|     -   2.8 Q) What is the difference between all these repositories?    |
|     -   2.9 Q) I just installed Package X. How do I start it?            |
|     -   2.10 Q) Why is there only a single version of each shared        |
|         library in the official repositories?                            |
|     -   2.11 Q) What if I run "pacman -Syu" and there will be an update  |
|         for a shared library, but not for the apps that depend on it?    |
|     -   2.12 Q) Is it possible that there's a major kernel update in the |
|         repository, and that some of the driver packages haven't been    |
|         updated?                                                         |
|     -   2.13 Q) Does Arch use package signing?                           |
|                                                                          |
| -   3 Installation                                                       |
|     -   3.1 Q) Arch needs an installer. Maybe a GUI installer            |
|     -   3.2 Q) I installed Arch, and now I am at a shell! What now?      |
|     -   3.3 Q) Which desktop environment or window manager should I use? |
|     -   3.4 Q) What makes Arch unique amongst other "minimal"            |
|         distributions?                                                   |
|                                                                          |
| -   4 Other                                                              |
|     -   4.1 Q) What is this AUR thing I keep hearing about?              |
|     -   4.2 Q) Why do I get a green screen whenever I try to watch a     |
|         video?                                                           |
|     -   4.3 Q) Spellcheck is marking all of my text as incorrect!        |
+--------------------------------------------------------------------------+

General
-------

> Q) What is Arch Linux?

A) See the article entitled Arch Linux.

> Q) Why would I want to use Arch?

A) If, after reading about the The Arch Way philosophy, you wish to
embrace the 'do-it-yourself' approach and require or desire a simple,
elegant, highly customizable, bleeding edge, general purpose GNU/Linux
distribution, you may like Arch.

> Q) Why would I not want to use Arch?

A) You may not want to use Arch, if:

-   after reading The Arch Way, you disagree with the philosophy.
-   you do not have the ability/time/desire for a 'do-it-yourself'
    GNU/Linux distribution.
-   you require support for an architecture other than x86_64 or i686.
-   you take a strong stand on using a distribution which only provides
    free software as defined by GNU.
-   you believe an operating system should configure itself, run out of
    the box, and include a complete default set of software and desktop
    environment on the installation media.
-   you do not want a bleeding edge, rolling release GNU/Linux
    distribution.
-   you are happy with your current OS.
-   you want an OS that targets a different userbase.

> Q) What distribution is Arch based on?

A) Arch is independently developed, was built from scratch and is not
based on any other GNU/Linux distribution. Before creating Arch, Judd
Vinet admired and used CRUX, a great, minimalist distribution created by
Per Lidén. Originally inspired by ideas in common with CRUX, Arch was
built from scratch, and pacman was then coded in C.

> Q) I am a complete GNU/Linux beginner. Should I use Arch?

A) This question has had much debate. Arch is targeted more towards
advanced GNU/Linux users, but some people feel that Arch is a good place
to start for the motivated novice. If you are a beginner and want to use
Arch, just be warned that you must be willing to invest significant time
into learning a new system, as well as accept the fact that Arch is
fundamentally designed as a DIY (Do-It-Yourself) distribution. It is the
user who assembles the system and controls what it will become. Before
asking for help, do your own independent research by Googling, searching
the forum (and reading the rest of these FAQs) and searching the superb
documentation provided by the Arch Wiki. There is a reason these
resources were made available to you in the first place. Many thousands
of volunteered hours have been spent compiling this excellent
information.

Recommended reading: The Arch Linux Beginners' Guide.

> Q) Arch requires too much time and effort to install and use. Also, the community keeps telling me to RTFM in so many words

A) Arch is designed for and used by a specifically targeted user base.
Perhaps it is not right for you. See the above.

> Q) Is Arch designed to be used as a server? A desktop? A workstation?

A) Arch is not designed for any particular type of use. Rather, it is
designed for a particular type of user. Arch targets competent users who
enjoy its do-it-yourself nature, and who further exploit it to shape the
system to fit their unique needs. Therefore, in the hands of its target
user base, Arch can be used for virtually any purpose. Many use Arch on
both their desktops and workstations. And of course, archlinux.org runs
on Arch.

> Q) I really like Arch, except the development team needs to implement "feature X"

A) Before going further, did you read The Arch Way? Have you provided
the feature/solution? Does it conform to the Arch philosophy of
minimalism and code-correctness over convenience? Get involved,
contribute your code/solution to the community. If it is well regarded
by the community and development team, perhaps it will be merged. The
Arch community thrives on contribution and sharing of code and tools.

> Q) When will the new release be made available?

A) Arch Linux releases are merely a snapshot of the [core] repository,
and are issued usually in the first half of every month.

The rolling release model keeps every Arch Linux system current and on
the bleeding edge by issuing one command. For this reason, releases are
not terribly important in Arch, because they become out of date as soon
as a package has been updated. If you are looking to obtain the latest
Arch Linux release, you do not need to reinstall. You simply run the
pacman -Syu command, and your system will be identical to what you would
get with a brand-new install. For this same reason, new Arch Linux
releases are not typically full of new and exciting features. New and
exciting features are released as needed with the packages that are
updated, and can be obtained immediately via pacman -Syu.

> Q) Is Arch Linux a stable distribution? Will I get frequent breakage?

A) The short answer is: It is largely as stable as you make it.

You assemble your own Arch system, atop the simple base environment, and
you control system upgrades. Obviously, a larger, more complicated
system incorporating multitudes of customized packages, and a plethora
of toolkits and desktop environments would be more likely to experience
configuration problems due to upstream changes than a slimmer, more
simple system would. Arch is targeted at capable, proactive users.
General UNIX competence and good system maintenance and upgrade
practices also play a large role in system stability. Also recall that
Arch packages are predominantly unpatched, so most application problems
are inherently upstream.

Therefore, it is the user who is ultimately responsible for the
stability of his own rolling release system. The user decides when to
upgrade, and merges necessary changes when required. If the user reaches
out to the community for help, it is often provided in a timely manner.
The difference between Arch and other distributions in this regard is
that Arch is truly a 'do-it-yourself' distribution; complaints of
breakage are misguided and unproductive, since upstream changes are not
the responsibility of Arch devs.

> Q) Arch needs more press (i.e. advertisement)

A) Arch gets plenty of press as it is. The goal of Arch Linux is not to
be large, but rather, to provide an elegant, minimalist and bleeding
edge distribution focused on simplicity and code-correctness. Organic,
sustainable growth occurs naturally amongst the target user base.

> Q) Arch needs more developers

A) Possibly so. Feel free to volunteer your time! Visit the forums, IRC
channels, and mailing lists, and see what needs to be done. Getting
involved in the Community Contributions subforum is a good way to start.

> Q) Why is my internet so slow compared to other operating systems?

A) Is your network configured correctly? Have a look at Hostname and
Configure the network from the Beginners' Guide.

Also note that Arch Linux does not come with traffic shaping enabled.
Thus, it is possible that if a program on it somehow utilizes your
internet connection to the full – regardless if it's over P2P or classic
client-server connections – other local ones will find it clogged,
resulting in severe lags and timeouts. Relief can be provided by
firewalls such as Shorewall or Vuurmuur; there are also static scripts
for iproute2 (such as this derivative of Wondershaper), which allow
shaping on the network layer.

> Q) Why is Arch using all my RAM?

A) Essentially, unused RAM is wasted RAM.

Many new users notice how the Linux kernel handles memory differently
than they are used to. Since accessing data from RAM is much faster than
from a storage drive, the kernel caches recently accessed data in
memory. The cached data is only cleared when the system begins to run
out of available memory and new data needs to be loaded.

Perhaps the most common culprit of this confusion is the free command:

    $ free -m

                 total       used       free     shared    buffers     cached
    Mem:          1009        741        267          0        104        359
    -/+ buffers/cache:        278        731
    Swap:         1537          0       1537

It is important to note the -/+ buffers/cache: line -- a representation
of the amount of memory that is actually in "active use" and the amount
of "available" memory, rather than "unused".

In the above example, a laptop with 1G of total RAM appears to be using
741M of it, with naught but a few idling terminals and a web browser
open! However, upon examining the emphasized line, see that only 278M of
it is in "active use", and in fact 731M is "available" for new data.
Apparently, 104M of that "used" memory contains buffered data and 359M
contains cached data, both of which can be cleared away if needed. Only
267M of the total is truly "free" of the burden of data storage.

The result of all this? Performance!

See this wonderful article if your curiosity has been piqued! There's
also a website dedicated to clearing this confusion:
http://www.linuxatemyram.com/

> Q) Where did all my free space go?

A) The answer to this question depends on your system. There are some
fine utilities that may help you find the answer.

Package Management
------------------

> Q) In which package is X in?

A) You can find out with pkgfile.

For example:

    $ pkgfile file_name

> Q) I've found an error with Package X. What should I do?

A) First, you need to figure out if this error is something the Arch
team can fix. Sometimes it's not (e.g. Firefox crashes may be the fault
of the Mozilla team); this is called an upstream error. If it is an Arch
problem, there is a series of steps you can take:

1.  Search the forums for information. See if anyone else has noticed
    it.
2.  Post a bug report with detailed information at
    https://bugs.archlinux.org.
3.  If you'd like, write a forum post detailing the problem and the fact
    that you have reported it already. This will help prevent a lot of
    people from reporting the same error.

> Q) Arch packages need to use a unique naming convention. ".pkg.tar.gz" and ".pkg.tar.xz" are too long and/or confusing

A) This has been discussed on the Arch mailing list. Some proposed a
.pac file extension. As far as is currently known, there is no plan to
change the package extension. As Tobias Kieslich, one of the Arch devs,
put it, "A package is a gzipped [xz] tarball! And it can be opened,
investigated and manipulated by any tar-capable application. Moreover,
the mime-type is automatically detected correctly by most applications."

> Q) Pacman needs a library so other applications can easily access package information

A) Since version 3.0.0, pacman has been the front-end to libalpm, the
"Arch Linux Package Management" library. This library allows alternative
front-ends to be written (for instance, a GUI front-end).

> Q) Why doesn't pacman have an official GUI front-end?

A) Please read The Arch Way and Arch Linux. Basically, the answer is
that the Arch dev team will not be providing one. Feel free to use one
developed by other users. A selective list can be found in Pacman GUI
Frontends.

> Q) Pacman needs "feature X"!

A) Please read The Arch Way and Arch Linux. The Arch philosophy is "Keep
It Simple". If you think the idea has merit, and does not violate this
simple litany, then you may choose to discuss it on the forum here. You
might also like to check here; it is a place for feature requests if you
find it is important.

However, the best way to get a feature added to pacman or Arch Linux is
to implement it yourself. The patch or code may or may not be officially
accepted, but perhaps others will appreciate, test and contribute to
your effort.

> Q) Arch needs a stable package branch

A) Check out ArchServer.

> Q) What is the difference between all these repositories?

A) See Official Repositories.

> Q) I just installed Package X. How do I start it?

A) If you're using a desktop environment like KDE or GNOME, the program
should automatically show up in your menu. If you're trying to run the
program from a terminal and do not know the binary name, use:

    $ pacman -Qlq package_name | grep bin

> Q) Why is there only a single version of each shared library in the official repositories?

A) Several distributions, such as Debian, have different versions of
shared libraries packaged as different packages: libfoo1, libfoo2,
libfoo3 and so on. In this way it is possible to have apps compiled
against different versions of libfoo installed on the same system.

Unlike Debian, Arch is a rolling-release cutting-edge distribution. The
most visible trait of a cutting-edge distribution is availability of the
latest versions of software in the repositories; in case of a
distribution like Arch, it also means that only the latest versions of
all packages are officially supported. By dropping support for outdated
software, package maintainers are able to spend more time ensuring that
the newest versions work as expected. As soon as a new version of a
shared library becomes available from upstream, it is added to the
repositories and affected packages are rebuilt to utilize the new
version.

> Q) What if I run "pacman -Syu" and there will be an update for a shared library, but not for the apps that depend on it?

A) This scenario should not happen at all. Assuming an application
called foobaz is in one of the official repositories and builds
successfully against a new version of a shared library called libbaz, it
will be updated along with libbaz. If, however, it doesn't build
successfully, foobaz package will have a versioned dependency (e.g.
libbaz 1.5), and will be removed by pacman during libbaz upgrade, due to
a conflict.

If foobaz is a package that you built yourself and installed from AUR,
you should try rebuilding foobaz against the new version of libbaz. If
the build fails, report the bug to the foobaz developers.

> Q) Is it possible that there's a major kernel update in the repository, and that some of the driver packages haven't been updated?

A) No, it is not possible. Major kernel updates (e.g. linux 3.5.0-1 to
linux 3.6.0-1) are always accompanied by rebuilds of all supported
kernel driver packages. On the other hand, if you have an unsupported
driver package installed on your system, such as catalyst, then a kernel
update might break things for you if you do not rebuild it for the new
kernel. Users are responsible for updating any unsupported driver
packages that they have installed.

> Q) Does Arch use package signing?

A) Yes. Package signing in pacman has been implemented since version 4.
See package signing for more information.

Installation
------------

> Q) Arch needs an installer. Maybe a GUI installer

A) Since installation doesn't occur often (read the rest of this article
to know more about what rolling release means), it is not a high
priority for developers or users. The Installation Guide and Beginners'
Guide have been fully updated to use the command-line method. If you're
still interested in using an installer, consider using Archboot.

> Q) I installed Arch, and now I am at a shell! What now?

A) Have a look at the Arch Linux Beginners' Guide.

> Q) Which desktop environment or window manager should I use?

A) Since many are available to you, use the one you like the most to fit
your needs. Have a look at the Desktop Environment and Window Manager
articles.

> Q) What makes Arch unique amongst other "minimal" distributions?

A) Some distributions may provide minimal installation methods, sharing
some similarities to the Arch installation process. However, a few
points must be noted:

1.  Arch has been fundamentally designed as a lightweight, minimal base
    environment upon which to build.
2.  The only way to install Arch is by building up from this minimal
    base.
3.  The base system and the entire distribution are inherently a
    K.I.S.S. design approach, which makes it uniquely suitable for its
    target base of users.
4.  Installing services and packages requires manual, interactive user
    configuration. Unlike other distributions which automatically
    configure services and startup behavior, the Arch philosophy puts
    emphasis on the power user's competence and prerogative to handle
    such responsibilities.
5.  Arch packaging is designed to be minimal, and optional package
    dependencies are never automatically installed. Rather, the user is
    simply notified of their existence during package installation,
    resulting in a slimmer system.
6.  Arch provides excellent, thorough documentation, aiding in the
    process of system assembly.

Other
-----

> Q) What is this AUR thing I keep hearing about?

A) See Arch User Repository#FAQ.

> Q) Why do I get a green screen whenever I try to watch a video?

A) Your color depth is set wrong. It may need to be 24 instead of 16,
for example.

> Q) Spellcheck is marking all of my text as incorrect!

A) Have you installed an aspell dictionary? Use pacman -Ss aspell to see
available dictionaries for downloading.

If installing the dictionary files did not resolve the problem, it is
most likely a problem with enchant. Check for known dictionary files:

    $ aspell dicts

    en
    en_GB
    ...etc

If your respective language dictionary is listed, add it to
/usr/share/enchant/enchant.ordering. From the above example, it would
be:

    en_GB:aspell

Retrieved from
"https://wiki.archlinux.org/index.php?title=FAQ&oldid=252714"

Category:

-   About Arch
