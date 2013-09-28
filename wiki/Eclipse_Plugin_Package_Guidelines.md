Eclipse Plugin Package Guidelines
=================================

Package creation guidelines

* * * * *

CLR – Cross – Eclipse – Free Pascal – GNOME – Go – Haskell – Java – KDE
– Kernel – Lisp – MinGW – Nonfree – OCaml – Perl – Python – Ruby – VCS –
Web – Wine

There are many ways to install working Eclipse plugins, especially since
the introduction of the dropins directory in Eclipse 3.4, but some or
them are messy, and having a standardized and consistent way of
packaging is very important to lead to a clean system structure. It's
not easy, however, to achieve this without the packager knowing every
detail about how Eclipse plugins work. This page aims to define a
standard and simple structure for Eclipse plugin PKGBUILDs, so that the
filesystem structure can remain consistent between all plugins without
having the packager to start again for every new package.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Eclipse plugin structure and installation                          |
| -   2 Packaging                                                          |
|     -   2.1 Sample PKGBUILD                                              |
|     -   2.2 How to customize the build                                   |
|     -   2.3 In-depth PKGBUILD review                                     |
|         -   2.3.1 Package naming                                         |
|         -   2.3.2 Files                                                  |
|             -   2.3.2.1 Extraction                                       |
|             -   2.3.2.2 Locations                                        |
|                                                                          |
|         -   2.3.3 The build() function                                   |
+--------------------------------------------------------------------------+

Eclipse plugin structure and installation
-----------------------------------------

The typical Eclipse plugin contains two directories, features and
plugins, and since Eclipse 3.3 they could only be placed in
/usr/share/eclipse/. The content of these two directories could be mixed
with that of other plugins, and it created a mess and rendered the
structure difficult to manage. It was also very difficult to tell at a
glance which package contained which file.

This installation method is still supported in Eclipse 3.4, but the
preferred one is now using the /usr/share/eclipse/dropins/ directory.
Inside this directory can live an unlimited number of subdirectories,
each one containing its own features and plugins subdirectories. This
allows to keep a tidy and clean structure, and should be the standard
packaging way.

Packaging
---------

> Sample PKGBUILD

Here is an example, we will detail how to customize it below.

    PKGBUILD-eclipse.proto

    pkgname=eclipse-mylyn
    pkgver=3.0.3
    pkgrel=1
    pkgdesc="A task-focused interface for Eclipse"
    arch=('i686' 'x86_64')
    url="http://www.eclipse.org/mylyn/"
    license=('EPL')
    depends=('eclipse')
    optdepends=('bugzilla: ticketing support')
    source=(http://download.eclipse.org/tools/mylyn/update/mylyn-${pkgver}-e3.4.zip)
    md5sums=('e98cd7ab3c5d5aeb7c32845844f85c22')

    build() {
      _dest=${pkgdir}/usr/share/eclipse/dropins/${pkgname/eclipse-}/eclipse

      cd ${srcdir}

      # Features
      find features -type f | while read _feature ; do
        if [[ ${_feature} =~ (.*\.jar$) ]] ; then
          install -dm755 ${_dest}/${_feature%*.jar}
          cd ${_dest}/${_feature/.jar}
          jar xf ${srcdir}/${_feature} || return 1
        else
          install -Dm644 ${_feature} ${_dest}/${_feature}
        fi
      done

      # Plugins
      find plugins -type f | while read _plugin ; do
        install -Dm644 ${_plugin} ${_dest}/${_plugin}
      done
    }

> How to customize the build

The main variable which needs to be customized is the pkgname. If you
are packaging a typical plugin, then this is the only thing you need to
do: most plugins are distributed in zip files which only contain the two
features and plugins subdirectories. So, if you are packaging the foo
plugin and the source file only contains the features and plugins, you
just need to change pkgname to eclipse-foo and you are set.

Read on to get to the internals of the PKGBUILD, which help to
understand how to setup the build for all the other cases.

> In-depth PKGBUILD review

Package naming

Packages should be named eclipse-pluginname, so that they are
recognizable as Eclipse-related packages and it is easy to extract the
plugin name with a simple shell substitution like ${pkgname/eclipse-},
not having to resort to an unneeded ${_realname} variable. The plugin
name is necessary to tidy up everything during installation and to avoid
conflicts.

Files

Extraction

Some plugins need the features to be extracted from jar files. The jar
utility, already included in the JRE, is used to do this. However, jar
cannot extract to directories other than the current one: this means
that, after every directory creation, it is necessary to cd inside it
before extracting. The ${_dest} variable is used in this context to
improve readability and PKGBUILD tidiness.

Locations

As we said, source archives provide two directories, features and
plugins, each one packed up with jar files. The preferred dropins
structure should look like this:

    /usr/share/eclipse/dropins/pluginname/eclipse/features/feature1/...
    /usr/share/eclipse/dropins/pluginname/eclipse/features/feature2/...
    /usr/share/eclipse/dropins/pluginname/eclipse/plugins/plugin1.jar
    /usr/share/eclipse/dropins/pluginname/eclipse/plugins/plugin2.jar

This structure allows for mixing different versions of libraries that
may be needed by different plugins while being clear about which package
owns what. It will also avoid conflicts in case different packages
provide the same library. The only alternative would be splitting every
package from its libraries, with all the extra fuss it requires, and it
would not even be guaranteed to work because of packages needing older
library versions. Features have to be unjarred since Eclipse will not
detect them otherwise, and the whole plugin installation will not work.
This happens because Eclipse treats update sites and local installations
differently (do not ask why, it just does).

The build() function

First thing to be noticed is the cd ${srcdir} command. Usually source
archives extract the features and plugins folders directly under
${srcdir}, but this is not always the case. Anyway, for most non-(de
facto)-standard plugins this is the only line that needs to be changed.
Next is the features section. It creates the necessary directories, one
for every jar file, and extracts the jar in the corresponding directory.
Similarly, the plugins section installs the jar files in their
directory. A while cycle is used to prevent funny-named files.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Eclipse_Plugin_Package_Guidelines&oldid=206480"

Category:

-   Package development
