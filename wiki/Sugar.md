Sugar
=====

A product of the OLPC initiative, Sugar is a Desktop Environment akin to
KDE and GNOME, but geared towards children and education. If you have a
young son, daughter, brother, sister, puppy or alien, the best way to
introduce them to the world of Arch Linux is by deploying an Arch/Sugar
platform and then forgetting about it.

But wait..where art thou, O Sugar?

That's right. To lead such a good life, you need at least some
Sugar-related packages in at least AUR.

Sugar has a special Taxonomy to name the parts of its system. The
desktop itself constitute the glucose group. This is the basic system an
activity can reasonably expect to be present when installing Sugar. But
to really use the environment, you need activities. Basic and sample
activities are part of fructose. Then, sucrose is constituted by both
glucose and fructose and represents what should be distributed as a
basic sugar desktop environment. Note that ribose (the underlaying
operating system) is here replaced by Arch.Honey (the extra activities)
are not currently provided in AUR but can be installed as shown in the
#Building section.

Contents
--------

-   1 Getting started: Glucose
    -   1.1 Building from AUR
    -   1.2 Building a Bundle
    -   1.3 Depedency tree
    -   1.4 Building a Modular Group
-   2 Activities
    -   2.1 Fructose
    -   2.2 Etoys
    -   2.3 Building
    -   2.4 Notes

Getting started: Glucose
------------------------

> Building from AUR

Install sugar from the AUR.

> Building a Bundle

This is a cool build system provided by the developers that allows one
to download and build Sugar almost in its entirety. You will be told
what you need, and of course, it will not help if what you need has not
yet been packaged for us mighty Archers.

The resulting project can then be offered as a bundle. This method of
building should not be encouraged, since it is not "modular". A likely
analogy is the easy-e17 script, except that we are in the opposite
situation whereby there are no modular packages and thus no group - yet.
Adding the provision is a safety measure, .eg:

    pkgname=sugar-bundle
    pkgdesc="The Sugar environment and applications built with jhbuild"
    provides=('sugar-desktop') # as in provides=('e')
    conflicts=('sugar-desktop')

But as soon as someone uploads a component of the build/Sugar as a
separate package, it must be part of the group (and the bundle package
will automatically conflict), eg.:

    pkgname=sugar-toolkit
    pkgdesc="The Sugar environment toolkit"
    groups=('sugar-desktop' 'sugar-desktop-base')

Note: It might be possible to use the new split functions of makepkg
here, in which case it will end up as a modular build :)

> Depedency tree

Below is the dependency tree of sugar 0.86

    |--sugar
       |--hicolor-icon-theme
       |--shared-mime-info
       |--metacity
       |--libwnck
       |--pygtksourceview2
       |--sugar-artwork
       |--python-xklavier
       |  |--libxklavier
       |  |--pygobject
       |  |--gtk2
       |--sugar-toolkit
          |--alsa-lib
          |--gnome-python-desktop
          |--hippo-canvas
          |  |--librsvg
          |     |--gtk2
          |     |--libcroco
          |--sugar-datastore
          |  |--dbus-python
          |  |--xapian-python-bindings
          |  |--python-cjson
          |  |--sugar-base
          |     |--pygobject
          |     |--python-decorator
          |--sugar-presence-service
             |--telepathy-gabble
             |--telepathy-salut
             |--python-telepathy
             |--sugar-base
             |  |--pygobject
             |  |--python-decorator
             |--gnome-python
                |--pygtk
                |--pyorbit
                |--libgnomeui
                   |--libsm

> Building a Modular Group

This is the more appropriate route to take. Here is the current list of
noted dependencies, acquired by inspecting the build trees of
distributions supported by Sugar (Gentoo in particular):

    # Syntax: pkgname .. :-> location + comment1 + comment2 ..

    espeak			 :-> [community]
    squeak			 :-> [unsupported]
    evince			 :-> [extra]
    pyabiword		 :-> [unsupported]
    python-cjson		 :-> [community]
    python-telepathy	 :-> [community]
    gstreamer0.10-espeak	 :-> [unsupported]
    olpcsound		 :-> [unsupported]
    telepathy-glib		 :-> [community]
    xulrunner		 :-> [extra]
    telepathy-gabble	 :-> [community]
    telepathy-salut		 :-> [community]
    hippo-canvas		 :-> [unsupported]

Activities
----------

> Fructose

All fructose activities are available from the AUR as
sugar-activity-activity:

-   sugar-activity-browse
-   sugar-activity-calculate
-   sugar-activity-chat
-   sugar-activity-imageviewer
-   sugar-activity-jukebox
-   sugar-activity-log
-   sugar-activity-pippy
-   sugar-activity-read
-   sugar-activity-terminal
-   sugar-activity-turtleart
-   sugar-activity-write

> Etoys

etoys is provided separately as it is part of glucose but also include
the fructose activity. It is available as etoys in the AUR.

> Building

Now you have a working Sugar environment, it is time to populate it with
activities such as a browser, a calculator, an image viewer or games and
toys. They almost all have the same building procedure, a setup.py that
calls functions shipped with sugar. Below is a typical PKGBUILD:

    PKGBUILD

    # Contributor: Name <name@mail.com>
    pkgname=sugar-activity-calculate
    _realname=Calculate
    pkgver=30
    pkgrel=1
    pkgdesc="A calculator for Sugar."
    arch=('i686' 'x86_64')
    url="http://www.sugarlabs.org/"
    license=('GPL')
    groups=('sucrose' 'fructose')
    depends=('sugar')
    source=(http://download.sugarlabs.org/sources/sucrose/fructose/${_realname}/${_realname}-$pkgver.tar.bz2)
    md5sums=('011bd911516f27d05194320164c7dcd7')

    build() {
      cd "$srcdir/${_realname}-$pkgver"
      ./setup.py install --prefix="$pkgdir/usr" || return 1
    }
    # vim:set ts=2 sw=2 et:

You may need squeak to run some activities (like etoys).

> Notes

-   Activity building procedure is not made for packaging and using
    --prefix can be dangerous if the application uses this path
    internally. I think the correct way to do this would be to patch the
    installation procedure in sugar so it accepts an argument such as
    --destdir=.

-   I suggest that we prefix sugar activities packages in AUR with
    sugar-activity-.

-   You may need to install python-pygame if activities do not start up.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sugar&oldid=260984"

Category:

-   Desktop environments

-   This page was last modified on 3 June 2013, at 20:33.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
