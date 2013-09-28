Automated Package Build System
==============================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 What is an Automated Build System                                  |
| -   2 Naming                                                             |
| -   3 Design Proposal                                                    |
|     -   3.1 Proposed Features                                            |
|                                                                          |
| -   4 Programming Language                                               |
| -   5 Builder Process                                                    |
| -   6 Component Build Out                                                |
|     -   6.1 Master Server Components                                     |
|         -   6.1.1 Core Loop                                              |
|         -   6.1.2 Determine Packages Which are Ready to be Built         |
|         -   6.1.3 Maintain Package Repositories                          |
|         -   6.1.4 Package Parsers                                        |
|             -   6.1.4.1 SVN Parser                                       |
|                                                                          |
|         -   6.1.5 Package Manipulators                                   |
|                                                                          |
|     -   6.2 Build Server Components                                      |
|         -   6.2.1 Master Queries                                         |
|         -   6.2.2 Peer Review System                                     |
|         -   6.2.3 Main Loop                                              |
|         -   6.2.4 Chroot Builders                                        |
|                                                                          |
|     -   6.3 Builder Considerations                                       |
|         -   6.3.1 Threading                                              |
|         -   6.3.2 Builder Security                                       |
|                                                                          |
|     -   6.4 Standalone Components                                        |
|         -   6.4.1 Https Server                                           |
|         -   6.4.2 Pacman Module                                          |
|         -   6.4.3 PKGBUILD Parser                                        |
|         -   6.4.4 Standard Utils Module                                  |
+--------------------------------------------------------------------------+

What is an Automated Build System
---------------------------------

One of the best examples of an automated package build systems is the
Fedora Koji project, Koji is a continuous build system for all of the
rpms in the Fedora and RHEL projects. The main benefit of an automated
build system is that all of the packages need to pass through a common
gate, a common checkpoint for quality and consistency.

While the Koji build server is referenced heavily the Arch equivalent
will need to be very different, in both architecture and the general
goals of the project.

Naming
------

The proposed name for the Arch package build system is Quarters, the
logic being that what really feeds pacman is quarters.

Alternative naming options will be considered

Design Proposal
---------------

One of the main aspects of the Arch distribution compared to
distributions like Fedora is money. The Fedora project can go out and
buy servers by the arm full, but Arch will need to continue to rely on
volunteer equipment and working with what we can get our hands on. While
these aspects will effect the nature of the package build system, they
cannot allow for the compromise of the quality of the Arch Linux
distribution.

> Proposed Features

1.  Simplicity
    1.  Avoid requiring too many daemons
    2.  No Authentication systems
    3.  No database dependencies
    4.  Simple https communication
    5.  Able to interact with distributed components over any reasonable
        link quality

2.  Distributed
    1.  Need to be able to distribute the build load to systems all over
        the world
    2.  All communication needs to be encrypted (duh)
    3.  Builders make decisions by peer review

3.  Data Model
    1.  Information on the available packages is made by parsing live
        pacman data (pacman is fast enough)
    2.  Packages to build is presented to the builders via serialized
        format (probably json)

4.  Communication
    1.  All build communication is based on gathering presented data,
        all pulls, not puts
    2.  All servers are state machines, the status of the distributed
        build environment is assessed by parsing the "global" state
        machine
    3.  Command system to move packages manually from the build repos to
        the final repos

5.  Build Cleanliness
    1.  Every package is built in its own clean chroot environment

6.  Packages can be pulled and polled from many sources
    1.  SVN
    2.  AUR (plugable?)
    3.  GIT
    4.  Other scms ()
    5.  Web interface

7.  Building Requirements
    1.  All packages need to be build-able, this includes the base
        toolchain
    2.  Trigger mass rebuilds of package, with version bumps
    3.  Track Packager data through the build process, do not allow the
        packager to be lost to the builder

8.  System Interaction points
    1.  Detached cli interface sends signals to the master
    2.  Master server reads signals and acts on them

Programming Language
--------------------

It has been proposed that the application be developed in Python. Python
is fast enough, has the libs we need, and who doesn't understand python?

Sorry, but this project is too big for bash, and bash is too slow.

I thought about OCaml, but I figured that it should be something that
everyone can hack on.

Try and go for python3

Builder Process
---------------

The process that the builders will use is based on state information,
the master server presents the master state, which is the list validated
builders and the packages to be built; Only packages which have met all
deps and makeedeps in binary repos will be presented. The master server
will only present packages which are ready to be built. The builders
then download the master server's state information. The builders pick
package(s) to build, post the package that they have claimed and then
query the other builders to see if any other builder has claimed it. If
the builder needs to change the package to build then it will just post
a claim on a new package. Unless it is the first build on the builder
then the peer process of determining which package needs to be built
will be done while a package is already being built.

The master will regularly poll the states of the builders, the builders
will post their states for the master and for the peers. The builder
states will have all the information that the master needs to retrieve
the built packages or the information for the failed build.

Component Build Out
-------------------

Quarters will consist of a number of individual components. These
components are all pieces of the distributed system, the components will
also interact via a common language independent medium and https.

> Master Server Components

The components required for the operation of the master server

Core Loop

The core loop or the core of the master does what most daemons do, takes
in the config information, does the double pid form magic, etc.

The core loop will primarily act by continually querying the distributed
components for changes, thee components are the builders and the package
parsers.

Determine Packages Which are Ready to be Built

The master will need to query the pacman repositories available,
primarily the live repositories and the build repository. The names and
versions of all available packages will be queried, then presented as a
dictionary: {<packages name>: <version>}. This information is then
compared to the information returned by the SCMS, then compiling a list
of packages that need to be built is a simple task.

Maintain Package Repositories

A number of package repos will need to be maintained, a build repo will
be maintained which simply contains all of the build packages, this is
not to be a public repo, but is used by the builders to meed build
dependencies.

Once a package has been signed off it can be moved from the build repo
to the live repo with a command. The command will ensure that the
package that is entering the live repository has all deps met. If the
package that is being moved to a live repository does not have all deps
met the dependent packages will be presented for the move as well.

This method satisfies both automatic building from scms and maintaining
the manual process of moving packages into the live repos.

Package Parsers

The package parsers will be pluggable modules that return predictable
data about the state of source package data stored in either a source
control manager or an interface such as the abs or the AUR.

The idea here is that as long as the data queried from the source is
uniform there can be any number of usable interfaces. The primary system
will need to be svn, since this is what the main package tree is stored
in, then git and then an AUR parser. More interfaces can be added on
later if we or anyone else wants them.

All parsers need to return a similar data structure and may need to do
some package preparation. The data structure will need to be defined and
static, but it should just be a python dict, something json likes.

SVN Parser

This is the main package parser, the parser needs to be able to ready
the PKGBUILDS for specific info, particularly pkgver, pkgname and
pkgrel, then compare the values to the list of packages that are already
built. Once the packages that need updating have been found the parser
needs to return a data structure containing the packages that need to be
built. The main challenge here is figuring out the fastest way to parse
an SVN repo, they can be somewhat slow.

Package Manipulators

For full functionality most parsers will need companion manipulators,
these are interfaces that can manipulate the PKGBUILDS in the underlying
SCM. This is needed for mass rebuilds, so that certain packages can
trigger deps to auto increment in the SCM. Once the PKGBUILDS have been
auto incremented then they will be picked up for rebuilding.

> Build Server Components

The build server will run on a host of different nodes. The build server
needs to have a number of capabilities. Primarily it will need ample
disk space to maintain multiple chroot environments as well as have
enough ram and free cpu power.

Master Queries

The Build Server will need to be able to continually get a fresh state
from the master.

Peer Review System

The builders will need to be able to download the build state from all
of the peer builders. The list of builders will be provided by the
master.

After download the builder will need to analyze the state of the other
builders and determine what package(s) that this builder should claim.
The builder should always have package names ready, so long as packages
are being presented by the master.

I am still debating on this, I might have the master just present
packages for the builders, but I still think that a peer system might be
better.

Main Loop

The builder will need to maintain a single top level loop that controls
all of the builder processes and continually queries the master and
executes peer reviews.

Chroot Builders

The main loop will be able to spawn the configured number of chroot
builders at the same time. These builders need to be maintained,
inasmuch that the number of available packages to build needs to be kept
ahead of the builders.

> Builder Considerations

The builders will need to support many simultaneous chroots. A savvy
admin for instance could use tmpfs file systems or ssd cards to maintain
more and higher speed chroots. So the number of simultaneous package
builders needs to be configurable with no limit. Disk IO will be the
holding factor for many builds, since fresh chroot copies and updates
need to be performed frequently.

Threading

When spawning a package builder, the python threading module cannot be
used, Quarters as a whole will require multiple processes to operate
properly. The threading module, and subsequently the python GIL should
be avoided. Instead the multiprocessing module should be used.

Builder Security

While unexpected, the builders need to be protected from malicious code
intended to compromise the system. When chroots are constructed the top
chroot dir needs to have the barrier attribute test with setattr. Also
the builds should be run as an unprivileged user inside the chroot.
These precautions will defend against the two main ways to break a
chroot, pwd manipulation and dev node hijacking.

> Standalone Components

These components are used by multiple services

Https Server

Each component will need to be able to present files via an https
server. The package will require a standalone https server written in
python.

Quarters will also need to be able to allow for any http server to be
used if the admin choses to use something other than the python https
server

Pacman Module

Nearly all components will need to interact with pacman, he last I
checked there we problems with the python bindings for alpm, if I am
mistaken, I am all ears.

Some standard functions with respect to pacman will need to be made
available.

PKGBUILD Parser

I know, this is a bottomless pit, the requirements for the PKGBUILD
parser are not extensive, although a number of parameters will need to
be reliably extracted.

Standard Utils Module

That anoying module that sets up logging and other more globally needed
functions.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Automated_Package_Build_System&oldid=207017"

Category:

-   Package development
