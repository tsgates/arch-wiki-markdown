Perl Package Guidelines
=======================

Package creation guidelines

* * * * *

CLR – Cross – Eclipse – Free Pascal – GNOME – Go – Haskell – Java – KDE
– Kernel – Lisp – MinGW – Nonfree – OCaml – Perl – Python – Ruby – VCS –
Web – Wine

Creating PKGBUILDs for software written in Perl.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Package Naming                                                     |
| -   2 File Placement                                                     |
| -   3 Notes                                                              |
| -   4 Example                                                            |
| -   5 Automation                                                         |
| -   6 Module Dependencies                                                |
|     -   6.1 Implementation                                               |
|     -   6.2 Dependency Definition                                        |
|     -   6.3 Meta Information                                             |
|                                                                          |
| -   7 Perl and Pacman Versions                                           |
| -   8 Advanced Topics                                                    |
|     -   8.1 Glossary                                                     |
|         -   8.1.1 Module                                                 |
|         -   8.1.2 Core Module                                            |
|         -   8.1.3 Distributions                                          |
|                                                                          |
|     -   8.2 User-Installed perl                                          |
|     -   8.3 Installation Modules                                         |
|         -   8.3.1 ExtUtils::MakeMaker                                    |
|         -   8.3.2 Module::Build                                          |
|         -   8.3.3 Module::Install                                        |
|                                                                          |
|     -   8.4 Environment Variables                                        |
|         -   8.4.1 PERL_MM_USE_DEFAULT                                    |
|         -   8.4.2 PERL_AUTOINSTALL                                       |
|         -   8.4.3 PERL_MM_OPT                                            |
|         -   8.4.4 PERL_MB_OPT                                            |
|         -   8.4.5 MODULEBUILDRC                                          |
|         -   8.4.6 PERL5LIB                                               |
|         -   8.4.7 PERL_LOCAL_LIB_ROOT                                    |
|                                                                          |
|     -   8.5 Hardened Example                                             |
+--------------------------------------------------------------------------+

Package Naming
--------------

For modules the package name should begin with perl- and the rest of the
name should be constructed from the module name by converting it to
lowercase and then replacing colons with hyphens. For example the
package name corresponding to HTML::Parser will be perl-html-parser.
Perl applications should have the same name as that of the application
but in lowercase.

File Placement
--------------

Perl modules should install module files in /usr/lib/perl5/vendor_perl/
(this is done by setting the INSTALLDIRS variable as shown below). No
files should be stored in /usr/lib/perl5/site_perl/ as that directory is
reserved for use by the system administrator to install Perl packages
outside the package management system. The files perllocal.pod and
.packlist also should not be present; this is taken care of by the
example PKGBUILD described below.

Notes
-----

In most cases, the arch array should contain 'any' because most Perl
packages are architecture independent.

Example
-------

An example PKGBUILD can be found at
/usr/share/pacman/PKGBUILD-perl.proto, which is in the abs package.

Automation
----------

As Perl is centered around the CPAN, there are a few scripts to make the
most of this, and save you writing PKGBUILDs by hand.

A plugin for the second-generation CPAN shell, CPANPLUS, is available in
the perl-cpanplus-dist-arch package from the community repo. This plugin
packages distributions on the fly as they are installed by CPANPLUS.
Online documentation is available at
https://metacpan.org/release/CPANPLUS-Dist-Arch

There is also a script called pacpan, which can recursively generate
PKGBUILDs for a module: http://xyne.archlinux.ca/old_projects/pacpan/

Warning:Pacpan development has been officially discontinued: its latest
version does not work with pacman>=3.5. See [1].

It is worth mentioning that Bauerbill has similar support for generating
PKGBUILDs to pacpan. As well as adding the ability to upgrade all
installed CPAN modules directly from CPAN via a pacman interface. Make
sure to read the Bauerbill man file for usage instructions.

Warning:Bauerbill development has been officially discontinued: its
latest version does not work with pacman>=3.5. See [2].

Module Dependencies
-------------------

Perl has a unique way of defining dependencies compared to similar
systems like python eggs and ruby gems. Eggs define dependencies on
other eggs. Gems depend on gems. Perl dists depend on modules. Modules
are only available from CPAN distributions so in a way perl
distributions depend on distributions only indirectly. Modules can
define their own versions independent from distributions inside the
module source code. This is done by defining a package variable called
$VERSION. When using strict and warnings, this is defined with the our
keyword. For example:

    package Foo::Module;
    use warnings;
    use strict;
    our $VERSION = '1.00';

Modules can change their versions however they like and even have a
version distinct from the distribution version. The utility of this is
questionable but it is important to keep in mind. Module versions are
more difficult to determine from outside of the perl interpreter and
require parsing the perl code itself and maybe even loading the module
into perl. The advantage is that from inside the perl interpreter module
versions are easy to determine. For example:

    use Foo::Module;
    print $Foo::Module::VERSION, "\n";

> Implementation

The CPAN is a Centralized Network for Perl Authors. Each CPAN mirror
contains indices that list the distributions on CPAN, the modules in the
dists, and the name of the author who uploaded the dist. These are
simply text files. The most useful index is in the
/modules/02packages.details.txt.gz file available from each CPAN mirror.
The term "packages" here refers to the package keyword in the perl
language itself, not something similar to pacman packages. The CPAN
shell, referred to as lowercased, italicized cpan, is simply the
venerable perl script which navigates indices to find the module you
want to install.

Modules are found in the 02packages.details.txt.gz list. On the same
line as the module/package name is the path to the distribution tarball
that contains the module. When you ask cpan to install a module, it will
look up the module and install the relevant distribution. As the
distribution is installing it will generate a list of module
dependencies. Cpan will try to load each module dependency into the perl
interpreter. If a module of the given version cannot be loaded the
process is repeated.

The cpan shell does not have to worry about what version of the required
module it is installing. cpan can rely on the fact that the latest
version of the module must satisfy the requirements of the original
module that it began installing in the first place. Only the latest
versions of modules are listed in the packages details file.
Unfortunately for the perl package author, we cannot always rely on the
fact that our packages offer the most recent version of a perl
distribution and the modules contained within. Pacman dependency
checking is much more static and strongly enforced.

> Dependency Definition

Where are dependencies defined in perl distributions? They are defined
inside of the Makefile.PL or Build.PL script. For example, inside of the
Makefile.PL script the WriteMakeFile function is called to generate the
Makefile like this:

    use ExtUtils::MakeMaker;
    WriteMakeFile(
        'NAME' => 'ArchLinux::Module',
        'VERSION' => '0.01',
        'PREREQ_PM' => { 'POSIX' => '0.01' },
    );

This is a contrived example but it is important to understand the
dependencies aren't final until after the Makefile.PL or Build.PL script
is run. Dependencies are specified at runtime, which means they can be
changed or modified using the full power of perl. This means the module
author can add, remove, or change versions of dependencies right before
the distribution is installed. Some modules authors use this to do
overly clever things like depend on modules only if they are installed.
Some multi-platform dists also depend on system-specific modules when
installed on different operating systems.

As an example, the CPANPLUS distribution looks for CPANPLUS::Dist
plugins that are currently installed. If any plugins are installed for
the currently installed version of CPANPLUS it adds them to the new
CPANPLUS's prerequisites. I'm not quite sure why. Luckily for the perl
packager most dependencies are static like in the above example that
requires the POSIX module with a minimum version of 0.01.

> Meta Information

Meta files are included in recent distributions which contain
meta-information about distributions such as the name, author, abstract
description, and module requirements. Previously there were META.yml
files in the YAML format but more recently the switch has been made to
META.json files in the JSON format. These files can be edited by hand
but more often they are generated automatically by Makefile.PL or
Build.PL scripts when packaging a distribution for release. The latest
specification is described in CPAN::Meta::Spec's online docs.

Remember that dependencies can be changed at runtime! For this reason
another meta file is generated after running the build script. This
second meta file is called MYMETA.json and reflects changes the script
made at runtime and may be different from the meta file generated when
the distribution was packaged for CPAN.

Elderly distributions on the CPAN have no meta file at all. These old
releases predate the idea of the META.yml file and only describe their
prerequisites in their Makefile.PL.

Perl and Pacman Versions
------------------------

In perl versions are numbers. In pacman versions are strings.

Perl allows both decimal versions, like 5.002006, and dotted decimal
versions, like 5.2.6. You might have a hard time comparing between
decimals and dotted decimals, so perl converts dotted decimal versions
to decimal versions by padding with zeros. Each dot separates up to
three digits and 5.2.6 becomes 5.002006. Now its easy to compare with
some simple arithmetic! The internal docs for the version.pm module
describes the conversion of dotted decimal versions in more detail.

The important thing is that perl compares versions exactly the same as
it compares two numbers. Versions are numbers. 5.10 = 5.1. Pretty easy
right? Dotted decimals are not so easy. 5.1.1 == 5.001001. Huh? The bad
part is most other systems think of versions as strings making perl the
odd man out.

Pacman works best with dotted decimal versions and doesn't compare them
numerically. Components are split at non-alphanumeric characters and
compared side-by-side as integers. The first component that is not equal
determines which version string is less than or greater the other. Right
away the component with the longest length, as a string, is considered
the largest. This means that 5.0001 is greater than 5.1. 5.10 is not
equal to 5.1, it is greater.

The problem is that changing the length of the version string can
seriously confuse pacman. Consider the releases of AnyEvent:

1.  6.01 (2011-08-26)
2.  6.02 (2011-08-26)
3.  6.1 (2011-10-24)
4.  6.11 (2011-11-22)
5.  6.12 (2011-12-12)

That 6.1 in the middle can cause problems because the length of the
version string has decreased. In pacman's world 6.1 is less than 6.02.
If a package depends on perl-anyevent>=6.02 and only 6.1 is available in
the repository, then pacman would be unable to fulfill the dependency.

One solution to this problem is to pad the pkgver with zeroes.
Dependencies might also have to be padded with zeroes to make pacman
happy. Version 6.1 would become 6.10.

Advanced Topics
---------------

If the packager has become comfortable enough with creating perl
packages, the below sections may offer some new ideas to consider. This
information might also help troubleshooting packaging problems.

> Glossary

You should be familiar with the following terms.

Module

Modules are declared with the package keyword in perl. Modules are
contained inside a .pm ("dot-pee-em") file. Though it's possible more
than one module (package) is in the file. Modules have namespaces
separated with :: (double colons), like: Archlinux::Module. When loading
a module, the ::s are replaced with directory separators. For example:
Archlinux/Module.pm will be loaded for the module Archlinux::Module.

Core Module

Core modules are included with an installation of perl. Some core
modules are only available bundled with perl. Other modules can still be
downloaded and installed separately from CPAN.

Distributions

(aka dist, package) This is the equivalent of an Archlinux package in
CPAN-lingo. Distributions are .tar.gz archives full of files. These
archives contain primarily .pm module files, tests for the included
modules, documentation for the modules, and whatever else is deemed
necessary.

Usually a distribution contains a primary module with the same name.
Sometimes this is not true, like with the Template-Toolkit distribution.
The latest package, Template-Toolkit-2.22.tar.gz, for the
Template-Toolkit dist, contains no Template::Toolkit module!

Sometimes because distributions are named after a main module, their
names are used interchangeably and they get muddled together. However it
is sometimes useful to consider them a separate entity (like in
Template-Toolkit's case).

> User-Installed perl

A subtle problem is that advanced perl programmers may like to have
multiple versions of perl installed. This is useful for testing
backwards-compatibility in created programs. There are also speed
benefits to compiling your own custom perl interpreter (i.e. without
threads). Another reason for a custom perl is simply because the
official perl ArchLinux package sometimes lags behind perl releases. The
user may be trying out the latest perl... who knows?

If the user has the custom perl executable in their $PATH, the custom
perl will be run when the user types the perl command on the shell. In
fact the custom perl will run inside the PKGBUILD as well! This can lead
to insidious problems that are difficult to understand.

The problem lies in compiled XS modules. These modules bridge perl and
C. As such they must use perl's internal C API to accomplish this
bridge. Perl's C API changes slightly with different versions of perl.
If the user has a different version of perl than the system perl
(/usr/bin/perl) then any XS module compiled with the user's perl will be
incompatible with the system-wide perl. When trying to use the compiled
XS module with the system perl, the module will fail to load with a link
error.

A simple solution is to always use the absolute path of the system-wide
perl interpreter (/usr/bin/perl) when running perl in the PKGBUILD.

> Installation Modules

One of perl's greatest advantages is the sheer number of modules[/dists]
available on CPAN. Not too surprisingly, there are also several
different modules used for installing... well... modules! TMTOWTDI! I am
not aware of a standard name for these types of modules, so I just
called them "Installation Modules".

All these modules are concerned with is building the package and
installing wherever the user wants. This seems straightforward, but
considering the number of different systems perl runs on, this can get
complex. These modules all place a perl code file inside the dist
tarball. Running this perl script will initiate the build/installation
process. I have called this the "Build script" in the below list.

ExtUtils::MakeMaker

Build script
    Makefile.PL
CPAN link
    http://search.cpan.org/dist/ExtUtils-MakeMaker

The original, oldest module for installing modules is
ExtUtils::MakeMaker. The major downside to this module is that it
requires the make program to build and install everything. This may not
seem like a big deal to linux users but is a real hassle for Windows
people! In the name of progress the perl community is trying to
encourage people to use the newer modules instead.

Module::Build

Build script
    Build.PL
CPAN link
    http://search.cpan.org/dist/Module-Build

The main advantage of Module::Build is that it is pure-perl. This means
it does not require a make program to be installed for you to
build/install modules. Its adoption was rocky because if Module::Build
was not already installed, you could not run the bundled Build.PL
script! This is not a problem with recent versions of perl because
Module::Build is a core module.

Module::Install

Build script
    Makefile.PL
CPAN link
    http://search.cpan.org/dist/Module-Install

Another modern build/installation module, Module::Install still requires
the make program be installed to function. It was designed as a drop-in
replacement for ExtUtils::MakeMaker, to address some of MakeMaker's
shortcomings.

One very interesting feature is that Module::Install bundles a complete
copy of itself into the distribution file. Because of this, unlike
MakeMaker or M::B, you do not need Module::Install to be installed on
your system.

Another very unique feature is auto-install. This appears to be not
recommended, but seems used quite often. When the module author enables
auto-install for his distribution, Module::Install will search for and
install any pre-requisite modules that are not installed when
Makefile.PL is executed. This feature is skipped when Module::Install
detects it is being run by CPAN or CPANPLUS. However, this feature is
not skipped when run inside... oh I don't know... a PKGBUILD! I hope you
can see how a rogue perl program downloading and installing modules
willy-nilly inside a PKGBUILD can be a problem. See the
#PERL_AUTOINSTALL environment variable to see how to fix this.

> Environment Variables

A number of environment variables can affect the way the modules are
built or installed. Some have a very dramatic effect and can cause
problems if misunderstood. An advanced user could be using these
environment variables. Some of these will break an unsuspecting PKGBUILD
or cause unexpected behavior.

PERL_MM_USE_DEFAULT

When this variable is set to a true value, the installation module will
pretend the default answer was given to any question it would normally
ask. This does not always work, but all of the installation modules
honour it. That doesn't mean the module author will!

PERL_AUTOINSTALL

You can pass additional command-line arguments to Module::Install's
Makefile.PL with this variable. In order to turn off auto-install
(highly recommended), assign --skipdeps to this.

    export PERL_AUTOINSTALL='--skipdeps'

PERL_MM_OPT

You can pass additional command-line arguments to Makefile.PL and/or
Build.PL with this variable. For example, you can install modules into
your home-dir by using:

    export PERL_MM_OPT=INSTALLBASE=~/perl5

PERL_MB_OPT

This is the same thing as PERL_MM_OPT except it is only for
Module::Build. For example, you could install modules into your home-dir
by using:

    export PERL_MB_OPT=--install_base=~/perl5

MODULEBUILDRC

Module::Build allows you to override its command-line-arguments with an
rcfile. This defaults to ~/.modulebuildrc. You can override which file
it uses by setting the path to the rcfile in MODULEBUILDRC. The paranoid
might set MODULEBUILDRC to /dev/null... just in case.

PERL5LIB

The directories searched for libraries can be set by the user
(particularly if they are using Local::Lib) by setting PERL5LIB. That
should be cleared before building.

PERL_LOCAL_LIB_ROOT

If the user is using Local::Lib it will set PERL_LOCAL_LIB_ROOT. That
should be cleared before building.

> Hardened Example

Using all of our new accumulated knowledge, we can create a more
hardened PKGBUILD that will resist any environment variables' attempts
to sabotage it:

    PKGBUILD

    # Contributor: Your Name <youremail@domain.com>
    pkgname=perl-foo-bar
    pkgver=VERSION
    pkgrel=1
    pkgdesc='This is the awesome Foo::Bar module!'
    arch=('any')
    url='http://search.cpan.org/dist/Foo-Bar'
    license=('GPL' 'PerlArtistic')
    depends=('perl>=5.10.0')
    makedepends=()
    provides=()
    conflicts=()
    replaces=()
    backup=()
    options=('!emptydirs')
    install=
    source=("http://search.cpan.org/CPAN/authors/id/***/***-$pkgver.tar.gz")
    md5sums=()

    build() {
      cd "$srcdir/***-$pkgver"
      
      # Setting these env variables overwrites any command-line-options we don't want...
      export PERL_MM_USE_DEFAULT=1 PERL_AUTOINSTALL=--skipdeps \
        PERL_MM_OPT="INSTALLDIRS=vendor DESTDIR='$pkgdir'" \
        PERL_MB_OPT="--installdirs vendor --destdir '$pkgdir'" \
        MODULEBUILDRC=/dev/null

      # If using Makefile.PL
      { /usr/bin/perl Makefile.PL &&
        make &&
        make test &&
        make install; } || return 1

      # If using Build.PL
      { /usr/bin/perl Build.PL &&
        ./Build &&
        ./Build test &&
        ./Build install; } || return 1
    }

Retrieved from
"https://wiki.archlinux.org/index.php?title=Perl_Package_Guidelines&oldid=242965"

Category:

-   Package development
