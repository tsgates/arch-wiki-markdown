Namcap
======

Namcap is a tool for Arch Linux which checks binary packages and source
PKGBUILDs for common packaging errors which can be automatically
checked. Namcap was written by Jason Chu.

Latest Release: 3.2.3 (4 March 2012)

Changes: The NEWS file in the git repository contains the changes from
the previous version concisely.

Development Branch:
https://projects.archlinux.org/?p=namcap.git;a=summary

To report a bug or a feature request for namcap, file a bug in the
Packages:Extra section of the Arch Linux bugtracker and the set the
importance accordingly. If you are reporting a bug, please give concrete
examples of packages where the problem occurs.

If you have a patch (fixing a bug or a new namcap module), then you can
send it to the arch-projects mailing list. Namcap development is managed
with git, so git-formatted patches are preferred.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 How to use it                                                      |
| -   3 Understanding the output                                           |
| -   4 Tags                                                               |
|     -   4.1 Symbolic Links                                               |
|     -   4.2 Dependencies                                                 |
|     -   4.3 Licenses                                                     |
|     -   4.4 Files                                                        |
|     -   4.5 Miscellaneous                                                |
|     -   4.6 PKGBUILDs                                                    |
|     -   4.7 Unreleased                                                   |
|                                                                          |
| -   5 Making a namcap module                                             |
| -   6 Namcap reports                                                     |
+--------------------------------------------------------------------------+

Installation
------------

Install package namcap from official repositories.

How to use it
-------------

To run namcap on a PKGBUILD or a binary pkg.tar.xz:

    $ namcap FILENAME

If you want to see extra informational messages, then invoke namcap with
the -i flag:

    $ namcap -i FILENAME

You can also see the namcap(1) manual by typing man namcap at the
command line.

Understanding the output
------------------------

Namcap uses a system of tags to classify the output. Currently, tags are
of three types, errors (denoted by E), warnings (denoted by W) and
informational (denoted by I). An error is important and should be fixed
immediately; mostly they relate to insufficient security, missing
licenses or permission problems.

Normally namcap prints a human-readable explanation (sometimes with
suggestions on how to fix the problem). If you want output which can be
easily parsed by a program, then pass the -m (machine-readable) flag to
namcap (this feature is currently in the developmental branch).

Tags
----

> Symbolic Links

-   symlink-found (informational) Reports any symbolic links present in
    the package.
-   hardlink-found (informational) Reports any hard links present in the
    package.
-   dangling-symlink (error) Reports occurrences of symbolic links which
    point to a file which is not present in the package.
-   dangling-hardlink (error) Reports occurrences of hard links which
    point to a file which is not present in the package.

> Dependencies

-   link-level-dependence (informational) Informs about a library to
    which a package is dynamically linked.
-   dependency-is-testing-release (warning) The package dependency
    listed is in the [testing] repository. While packages are being
    built for the official Arch Linux repositories (core, extra and
    community), then they should not be built against packages from
    [testing]. For [core] and [extra] packages, packages built against
    [testing] should be put in the [testing] repository.
-   dependency-covered-by-link-dependence (informational) Dependency
    covered by dependencies from link dependence. Thus this is a
    redundant dependency.
-   dependency-detected-not-included (error) The file referred to has a
    dependency which is not listed in the depends array. Ignore this
    error if the named dependency is listed in the optdepends array.
-   dependency-already-satisfied (warning) The dependency is already
    satisfied (as the dependency of some package already listed as a
    dependency for example) and thus is redundant. You can use the
    pactree tool from pacman to view the dependency tree of your
    package.
-   dependency-not-needed (warning) This dependency is not required by
    any file present in the program (as far as namcap could deduce).
    This does not work properly yet for scripts (like python or perl
    packages) though; there you will have to figure out the dependencies
    on your own.
-   depends-by-namcap-sight (informational) A list of dependencies
    according to namcap.

> Licenses

-   missing-license (error) This package is missing a license. Licenses
    should be put in the license=() array of the PKGBUILD. See the Arch
    Packaging Standards for more information. It is very important to
    fix this error as soon as possible, since not including a license is
    a copyright violation in many cases.
-   missing-custom-license-dir (error) The license specified is custom
    but no license directory was found under /usr/share/licenses/ as
    specified in the packaging guidelines.
-   missing-custom-license-file (error) The license specified is custom
    but no license file was found in /usr/share/licenses/$pkgname.
-   not-a-common-license (error) The license specified is not custom but
    it is not present in the common licenses package shipped in the Arch
    Linux distribution.

> Files

This section describes the tags which relate to incorrect permissions of
files or files not being installed in accordance with the FHS
guidelines.

-   script-link-detected (informational) The following file is a script.
-   file-in-non-standard-dir (warning) The following file is in a
    non-standard directory as defined by the FHS guidelines. The allowed
    directories are: bin/, etc/, usr/bin/, usr/sbin/, usr/lib,
    usr/include/, usr/share/, opt/, lib/, sbin/, srv/, var/lib/,
    var/opt/, var/spool/, var/lock/, var/state/, var/run/, var/log/.
-   elffile-not-in-allowed-dirs (error) ELF files should only be in
    these directories: /lib, /bin, /sbin, /usr/bin, /usr/sbin, /lib,
    /usr/lib, /opt/$pkgname/.
-   empty-directory (warning) The following directory in the package is
    empty.
-   non-fhs-man-page (error) The package installs manual pages into a
    location other than /usr/share/man which is the directory for manual
    pages according to the FHS guidelines.
-   potential-non-fhs-man-page (warning) This file seems to be a manual
    page which is not installed in /usr/share/man but namcap is not too
    sure about it.
-   non-fhs-info-page (error) The package installs info pages into a
    location other than /usr/share/info which is where architecture
    independent data should be installed according to the FHS
    guidelines.
-   potential-non-fhs-info-page (warning) This file seems to be a info
    page which is not installed in /usr/share/info but namcap is not too
    sure about it.
-   incorrect-permissions (error) This file has incorrect ownership. The
    ownership of files in binary packages should be root/root.
-   file-not-world-readable (warning) The file is not readable by
    everyone; usually this should not be the case.
-   file-world-writable (warning) Anyone can write to this file; again
    not a typical case.
-   directory-not-world-executable (warning) The directory does not have
    the world executable bit set. This disallows access to the directory
    for programs running under user privileges.
-   incorrect-library-permissions (warning) The library file does not
    have permission 644 (readable and writable by root, readable by
    anyone else).
-   libtool-file-present (warning) This file is a libtool (.la) file and
    should not be normally present. One can use the !libtool option in
    the options array of the PKGBUILD to remove these files
    automatically.
-   perllocal-pod-present (error) The file perllocal.pod should not be
    present in a perl package; see the Perl Package Guidelines for more
    information.
-   scrollkeeper-dir-exists (error) A scrollkeeper directory was found
    in the package. scrollkeeper should not be run till
    post_{install,upgrade,remove}.
-   info-dir-file-present (error) The info directory file
    /usr/share/info/dir was found in the package. This file should not
    be present.
-   gnome-mime-file (error) The file is an autogenerated GNOME mime file
    and should not be present in the package.

> Miscellaneous

-   mime-cache-not-updated (error) The package installs mime files but
    does not call update-mime-database to update them.
-   hicolor-icon-cache-not-updated (error) There are files in
    /usr/share/icons/hicolor but the hicolor icon cache has not been
    updated. One should use gtk-update-icon-cache (for packages
    depending on gtk) or xdg-icon-resource to update the icon cache. If
    you use xdg-icon-resource then you should declare a dependency on
    xdg-utils.
-   insecure-rpath (error) An RPATH (for an executable) is outside
    /usr/lib. An RPATH to an insecure location is a potential security
    issue. See FS#14049 for discussion.

> PKGBUILDs

These are the tags related to the PKGBUILDs. Some of these might also
apply for binary packages.

-   variable-not-array (warning) The variable should be a bash array
    instead of a string. These are the variables which should be written
    as arrays: arch, license, depends, makedepends, optdepends,
    provides, conflicts, replaces, backup, source, noextract, md5sums.
-   backups-preceding-slashes (error) The file mentioned in the backup
    array begins with a slash ('/').
-   package-name-in-uppercase (error) There should not be any upper case
    letters in package names.
-   specific-host-type-used (warning) Instead of using a specific host
    type (like i686 or x86_64) use the generic $CARCH variable.
-   extra-var-begins-without-underscore (warning) The variable is not
    one of the standard variables defined in the PKGBUILD manual, yet it
    does not begin with an underscore.
-   file-referred-in-startdir (error) A file was referenced in $startdir
    outside of $startdir/pkg and $startdir/src.
-   missing-md5sums (error) MD5sums corresponding to the source files
    are missing. These can be added to the PKGBUILD using
    makepkg -g >> PKGBUILD.
-   not-enough-md5sums (error) There are more source files than MD5sums
    provided in the PKGBUILD.
-   too-many-md5sums (error) There are more MD5sums than source files in
    the PKGBUILD.
-   improper-md5sum (error) An improper MD5sum was found. MD5sums are of
    32 characters in length.
-   specific-sourceforge-mirror (warning) The PKGBUILD uses a specific
    sourceforge mirror. http://downloads.sourceforge.net should be used
    instead.
-   using-dl-sourceforge (warning) The deprecated
    http://dl.sourceforge.net domain is being used in the source array.
    http://downloads.sourceforge.net should be used instead.
-   missing-contributor (warning) The contributor tag is missing.
-   missing-maintainer (warning) The maintainer tag is missing.
-   missing-url (error) The package does not have an upstream homepage
    set. Use the url variable for this.
-   pkgname-in-description (warning) Description should not contain the
    package name.
-   recommend-use-pkgdir (informational) $startdir/pkg is deprecated,
    use $pkgdir instead.
-   recommend-use-srcdir (informational) $startdir/src is deprecated,
    use $srcdir instead.

> Unreleased

There are currently no new tags in the development version.

Making a namcap module
----------------------

This section documents the innards of namcap and specifies how to create
a new namcap module.

The main namcap program namcap.py takes as parameters the filename of a
package or a PKGBUILD and makes a pkginfo object, which it passes to a
list of rules defined in __tarball__ and __pkgbuild__.

-   __tarball__ defines the rules which process binary packages.
-   __pkgbuild__ defines the rules which process PKGBUILDs.

Once your module is finalized, remember to add it to the appropriate
array (__tarball__ or __pkgbuild__) defined in Namcap/__init__.py

A sample namcap module is like this (Namcap/url.py):

    import pacman

      class package:
      	def short_name(self):
    		return "url"
    	def long_name(self):
    		return "Verifies url is included in a PKGBUILD"
    	def prereq(self):
    		return ""
    	def analyze(self, pkginfo, tar):
    		ret = [[],[],[]]
    		if not hasattr(pkginfo, 'url'):
    			ret[0].append(("missing-url", ()))
    		return ret
    	def type(self):
    		return "pkgbuild"

Mostly, the code is self-explanatory. The following are the list of the
methods that each namcap module must have:

-   short_name(self) Returns a string containing a short name of the
    module. Usually,this is the same as the basename of the module file.
-   long_name(self) Returns a string containing a concise description of
    the module. This description is used when listing all the rules
    using namcap -r list.
-   prereq(self) Return a string containing the prerequisites needed for
    the module to operate properly. Usually "" for modules processing
    PKGBUILDs and "tar" for modules processing package files. "extract"
    should be specified if the package contents should be extracted to a
    temporary directory before further processing.
-   analyze(self, pkginfo, tar) Should return a list comprising in turn
    of three lists: of error tags, warning tags and information tags
    respectively. Each member of these tag lists should be a tuple
    consisting of two components: the short, hyphenated form of the tag
    with the appropriate format specifiers (%s, etc.) The first word of
    this string must be the tag name. The human readable form of the tag
    should be put in the tags file. The format of the tags file is
    described below; and the parameters which should replace the format
    specifier tokens in the final output.

-   type(self) "pkgbuild" for a module processing PKGBUILDs, "tarball"
    for a module processing a binary package file.

The tags file consists of lines specifying the human readable form of
the hyphenated tags used in the namcap code. A line beginning with a '#'
is treated as a comment. Otherwise the format of the file is:

     machine-parseable-tag %s :: This is machine parseable tag %s

Note that a double colon (::) is used to separate the hyphenated tag
from the human readable description.

Have fun hacking on namcap!

Namcap reports
--------------

namcap-reports is an automatically generated report obtained after
running namcap against the core, extra and community trees.

How it works:

-   namcap is run against the entire ABS tree to make namcap.log.
-   The packages in core, extra and community are put in files named
    core, extra and community respectively (using pacman -Slq).
-   namcap-report.py takes the code and prepares the report and RSS
    feeds, which is then copied to the webserver.

The code can be found in Git: https://projects.archlinux.org/namcap.git/

Retrieved from
"https://wiki.archlinux.org/index.php?title=Namcap&oldid=252947"

Category:

-   Package management
