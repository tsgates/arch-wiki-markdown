KDevelop 4
==========

"KDevelop is a free, open source IDE (Integrated Development
Environment) for MS Windows, Mac OS X, Linux, Solaris and FreeBSD. It is
a feature-full, plugin extensible IDE for C/C++ and other programming
languages. It is based on KDevPlatform, and the KDE and Qt libraries and
is under development since 1998."

Contents
--------

-   1 Installation
-   2 Building additional plugins
    -   2.1 First: install dependency
    -   2.2 PHP
    -   2.3 Other plugins
-   3 List of available plugins

Installation
------------

Install kdevelop from the official repositories.

Building additional plugins
---------------------------

> First: install dependency

The KDevelop Parser Generator in the official repositories
(kdevelop-pg-qt) is required to build additional plugins. Plugins will
not compile if this package is not installed beforehand.

> PHP

The PHP plugin (kdevelop-php) from the official repositories provides
autocompletion and other PHP-specific features.

Restart KDevelop 4 and you should now have improved PHP support,
including autocomplete for both the PHP functions as well as for your
project's functions and classes.

> Other plugins

Other plugins are available from AUR: kdevelop-extra-plugins

List of available plugins
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

Warning:As of June 17 2009, do not install the php-docs plugin because
it causes the php plugin to stop working.

Retrieved from
"https://wiki.archlinux.org/index.php?title=KDevelop_4&oldid=284980"

Category:

-   Development

-   This page was last modified on 27 November 2013, at 23:32.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
