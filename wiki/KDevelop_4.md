KDevelop 4
==========

"KDevelop is a free, open source IDE (Integrated Development
Environment) for MS Windows, Mac OS X, Linux, Solaris and FreeBSD. It is
a feature-full, plugin extensible IDE for C/C++ and other programming
languages. It is based on KDevPlatform, and the KDE and Qt libraries and
is under development since 1998."

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Building Additional Plugins                                        |
|     -   2.1 First: Install Dependency                                    |
|     -   2.2 PHP                                                          |
|     -   2.3 Other Plugins                                                |
|                                                                          |
| -   3 List of Available Plugins                                          |
+--------------------------------------------------------------------------+

Installation
------------

KDevelop is available in the Extra repository:

    # pacman -S kdevelop

Building Additional Plugins
---------------------------

> First: Install Dependency

The KDevelop Parser Generator in Extra (kdevelop-pg-qt) is required to
build additional plugins. Plugins will not compile if this package is
not installed beforehand.

    # pacman -S kdevelop-pg-qt

> PHP

The PHP plugin (kdevelop-php) from Extra provides autocompletion and
other PHP-specific features.

    # pacman -S kdevelop-php

Restart KDevelop 4 and you should now have improved PHP support,
including autocomplete for both the PHP functions as well as for your
project's functions and classes.

> Other Plugins

Other plugins are available from AUR: kdevelop-extra-plugins

List of Available Plugins
-------------------------

As of June 18 2009, the following plugins are available from KDE's svn
repository.

-   automake
-   bazaar
-   check
-   controlflowgraph
-   cppunit
-   csharp
-   ctest
-   duchainviewer
-   java
-   metrics
-   oldgdb
-   php
-   php-docs
-   python
-   qmake
-   qtdesigner
-   ruby
-   sloc
-   teamwork
-   xdebug

Note: As of June 17 2009, do not install the php-docs plugin because it
causes the php plugin to stop working.

Retrieved from
"https://wiki.archlinux.org/index.php?title=KDevelop_4&oldid=206474"

Category:

-   Development
