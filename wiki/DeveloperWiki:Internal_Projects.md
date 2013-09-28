DeveloperWiki:Internal Projects
===============================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Infrastructure Projects                                            |
|     -   2.1 Developer Tooling                                            |
|         -   2.1.1 TODO Items                                             |
|                                                                          |
|     -   2.2 Mirror Control                                               |
|         -   2.2.1 Automated tests                                        |
|                                                                          |
|     -   2.3 Packaging Automation                                         |
|     -   2.4 Server Administration                                        |
|     -   2.5 Developer Communication Team                                 |
|                                                                          |
| -   3 Packaging Projects                                                 |
|     -   3.1 Bug Squashing                                                |
|     -   3.2 Rebuild Team                                                 |
|     -   3.3 Package Review Team                                          |
|     -   3.4 Orphan Team                                                  |
|                                                                          |
| -   4 Web Projects                                                       |
|     -   4.1 AUR                                                          |
|     -   4.2 BBS                                                          |
|     -   4.3 Flyspray (bugtracker)                                        |
|     -   4.4 Main Site                                                    |
|     -   4.5 Planet                                                       |
|     -   4.6 Wiki                                                         |
|                                                                          |
| -   5 Coding Projects                                                    |
|     -   5.1 Arch Linux Init Scripts                                      |
|     -   5.2 Arch Linux Release Engineering (Installer)                   |
|     -   5.3 mkinitcpio                                                   |
|     -   5.4 namcap                                                       |
|     -   5.5 netcfg                                                       |
|     -   5.6 srcpac                                                       |
|     -   5.7 Pacman                                                       |
|         -   5.7.1 Development Team                                       |
|         -   5.7.2 Translation Team                                       |
+--------------------------------------------------------------------------+

Introduction
============

This article is part of the DeveloperWiki.

This page is meant to list a lot of the projects Arch developers keep
busy with. Yes, there are things to do outside of packaging. If you are
interested in anything, this page should help you get in contact with
the right people. If you are looking for something to do, this is always
a good place to start.

Some of these projects have dedicated discussion areas, such as the
release engineering and pacman development mailing lists. Other ones are
less formal- some of the communication may just be person to person
emails or on the arch-dev lists if it appeals to a larger crowd.
Remember that if you are interested in these less-formal projects, you
should let the names listed below know so they will include you on any
communication regarding the project.

Infrastructure Projects
=======================

Developer Tooling
-----------------

Primarily developer-side tools (devtools, namcap) and server-side
(db-scripts) work.

-   Aaron Griffin
-   Eric Bélanger
-   François Charette
-   Pierre Schmitz
-   Hugo Doria

  

> TODO Items

-   dbscripts: Rewrite db-move to allow multiple packages, getting rid
    of the testing2* convienence scripts
-   dbscripts: Add community repo support to db-move to let us move
    packages from community to core/extra and vice versa.
-   dbscripts: Add community support to the sourceballs script - needs
    additional logic to use alternate SVN repos
-   dbscripts: When a package is completely removed from repo, e.g.
    amarok-base, its sourceball remains on the server. I have a script
    for that. Will send it soon. Snowman 04:32, 6 October 2009 (EDT)
-   dbscripts/devtools: Add support for using different compression
    types for packages. This way we could migrate to xz compression
    while keeping the old gz compressed packages.
-   dbscripts/devtools: Implement a common storage dir for packages and
    just link from the repo dirs. This way mirrors wont need to download
    every package again when it is moved from testing to extra/core.

Mirror Control
--------------

Keep track of existing mirrors and ensure they are doing their job as
good as possible (e.g. staying current). Ensure we have up to date
contact information for as many mirrors as possible. Work on a tiered
mirror system to relieve some stress from our primary rsync server.

-   Roman Kyrylych
-   Gerhard Brauer

> Automated tests

-   sync state: http://users.archlinux.de/~gerbra/mirrorcheck.html
-   additional performance tests:
    http://www.archlinux.de/?page=MirrorStatus
-   Gerhard Brauer
-   Pierre Schmitz

Packaging Automation
--------------------

Automatic package generation based on changes in svn trunk. Errors
should be reported to some mailing list, successful builds moved to a
staging directory. Some guidelines of package moving into
[extra]/[testing] should be created, for [core] we can use the current
signoff procedure.

-   Ronald van Haren
-   Daniel Isenmann
-   Hugo Doria

Server Administration
---------------------

-   Thomas Bächler
-   Aaron Griffin
-   Jan de Groot
-   Dan McGee
-   Pierre Schmitz
-   Loui Chang (sigurd)

Developer Communication Team
----------------------------

This isn't quite infrastructure, but it almost belongs here. Responsible
for organizing developer meetings and making sure people attempt to be
present; you newer guys might have no idea, but we used to actually
schedule and have 80% of the developer staff present in IRC for 1-2 hour
meetings. Responsible for any other coordination between developers,
TUs, and maybe even the front page news.

-   Aaron Griffin
-   James Rayner -I can work on the Status Reports too if Aaron doesn't
    have time. I'll do dev meetings if nobody steps up.

Packaging Projects
==================

Bug Squashing
-------------

Responsible for assigning bugs to package maintainers. If something is
trivial and a fix can be easily made, then goes and does it. Organizes
bug squashing days.

-   Andrea Scarpino
-   Paul Mattal
-   Roman Kyrylych
-   ...
-   (needs several people)

Rebuild Team
------------

Responsible for communicating and determining what rebuilds will cycle
through [testing] and in what order. They are probably also the people
doing large portions of the rebuilds.

-   Allan McRae (because my packages seem to cause big rebuilds...)
-   Eric Bélanger
-   James Rayner - may be able to do some building for rebuilds if it's
    not near exams/assessment.
-   Andreas Radke - when OpenOffice is done all the rest is fun - quad
    core + tmpfs ftw :)

Package Review Team
-------------------

Some packages in our repos receive little attention due to not being
updated frequently. These need to be checked for being able to build
(especially after major toolchain updates) and compliance with current
packaging standards. It would be good for packages that have not been
rebuilt in a long time to be rebuilt to take advantage of new
optimisations.

-   Andrea Scarpino

Orphan Team
-----------

Responsible for caring for those packages that no one seems to want and
are being neglected. This may involve adoption by themselves or finding
a foster caregiver, moving them to a willing maintainer in [community],
or sending them to the AUR (or the trash).

-   Eric Bélanger (for trivial upstream update)
-   Andrea Scarpino
-   Giovanni Scafora
-   Daniel Griffiths

Web Projects
============

This is meant to be a quick overview of the web projects we have and who
works on them. For more technical details, you will want to check out
the DeveloperWiki:Gudrun (web) and Category:DeveloperWiki:Server
Configuration pages.

-   Pierre Schmitz

AUR
---

Responsible for coding and deploying the AUR.

-   Loui Chang
-   Andrea Scarpino

BBS
---

Responsible for keeping our BBS install up to date and secure.

-   Andrea Scarpino

Flyspray (bugtracker)
---------------------

Responsible for keeping our flyspray install up to date and secure.

-   Roman Kyrylych

Main Site
---------

There are a lot of issues, things that need cleaned up, etc. Take a look
at the bug tracker Web Site category.

-   Dusty Phillips
-   Dan McGee
-   Paul Mattal

Planet
------

Responsible for keeping the planet scripts updated and running.

-   Andrea Scarpino
-   Hugo Doria

Wiki
----

Responsible for keeping our wiki install up to date and secure.

-   Pierre Schmitz

Coding Projects
===============

Arch Linux Init Scripts
-----------------------

The all-important scripts that make your machine go when you turn it on

-   Thomas Bächler
-   Aaron Griffin
-   Roman Kyrylych

Arch Linux Release Engineering (Installer)
------------------------------------------

The Arch Linux Install Framework (AIF) and official installation ISOs

-   Dieter Plaetinck
-   Gerhard Brauer

mkinitcpio
----------

We have a program to create initrds for Arch systems.

-   Thomas Bächler
-   Aaron Griffin

namcap
------

Responsible for maintaining and adding features to namcap.

-   Hugo Doria

netcfg
------

Network connection and profiles

-   James Rayner

srcpac
------

-   Andrea Scarpino

Pacman
------

> Development Team

This team is responsible for general development, including new features
and bugfixes, for the package manager that is a core part of Arch.
Although many people contribute patches and code, the people listed here
are generally the people that will be reviewing patches and making the
final say as to what gets in the codebase.

-   Dan McGee
-   Xavier Chantry
-   Nagy Gabor
-   Allan McRae (focusing on makepkg)

> Translation Team

Pacman, as of September 2009, has been translated to 15 languages. The
upkeep and maintenance of these translations is pretty much a job in
itself, with the times immediately preceding a release being the
busiest. Ideally this team is responsible for creating a translations
branch when a string freeze is set, and then takes incoming
translations, ensures they are valid, and merges them into their branch.
When a release is not imminent, their focus may be on improving clarity
and usefulness of existing messages.

-   Giovanni Scafora

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:Internal_Projects&oldid=238702"

Category:

-   DeveloperWiki
