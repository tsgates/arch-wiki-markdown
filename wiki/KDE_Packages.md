KDE Packages
============

> Summary

An explanation of KDE package groups and meta-packages.

Related articles

KDE

Since KDE SC 4.3, separate (split) packages for each application are
provided. This article describes the concepts of groups and
meta-packages.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Terminology                                                        |
| -   2 Using Package groups                                               |
|     -   2.1 Why use groups?                                              |
|         -   2.1.1 Advantages                                             |
|         -   2.1.2 Disadvantages                                          |
|                                                                          |
|     -   2.2 Who is it for?                                               |
|                                                                          |
| -   3 Using Meta-Packages                                                |
|     -   3.1 Why use meta-packages?                                       |
|         -   3.1.1 Advantages                                             |
|         -   3.1.2 Disadvantages                                          |
|                                                                          |
|     -   3.2 Who is it for?                                               |
|                                                                          |
| -   4 Listing the member packages                                        |
+--------------------------------------------------------------------------+

Terminology
-----------

 module
    The KDE software compilation source code is organized into several
    categories called modules. Examples include kdebase, kdeutils etc.
    The KDE project releases one source archive per module. See the
    Coordinator List for more details.
 package group
    A package group is simply a group of packages. Pacman is able to
    select multiple packages by their group(s) during installation or
    removal.
 meta-package
    A meta-package is an empty package which just connects several
    packages by using dependencies.

Using Package groups
--------------------

There are groups for each KDE module, such as kdebase, kdeutils etc.
Installing a package group will install all packages that belong to that
module at the time of the installation. For instance, to install all
packages that are part of a module such as kdebase or kdeutils in the
current release, use:

    # pacman -S kdebase kdeutils ...

In addition to this, there is a kde group which includes all these
groups. Installing the kde package group will effectively install the
current KDE software compilation release in its entirety:

    # pacman -S kde

> Why use groups?

Advantages

-   Using groups makes it easier to install or remove a set of packages.
    This allows you to use a single command (like above) to install or
    remove all packages in a module.
-   There is no hard dependency between a group and its packages. This
    means that there is no reason to have all member packages in a group
    installed. You may freely remove member packages that belong to a
    group without touching other member packages of the same group.

Disadvantages

-   Pacman will not install any new packages that may be added to a
    group at a later date. For instance, if the next release of the KDE
    software compilation includes new applications in one or more
    modules, these new applications will not be automatically installed
    when you upgrade your system. You will have to manually install
    these new packages. To overcome this, use meta-packages (see next
    section).

> Who is it for?

Install package groups if you only want some modules of the current KDE
software compilation release. Groups are also useful for those users who
only want to retain some packages from a group, while opting to remove
the others.

Using Meta-Packages
-------------------

Just like groups, there are meta-packages for each KDE module, such as
kde-meta-kdebase, kde-meta-kdeutils etc. Installing these meta-packages
will install or upgrade all packages that belong to the module. If new
applications are added to the module in a future release, they will
automatically be installed when you upgrade your system. To install a
specific module such as kdebase or kdeutils using meta-packages, use:

    # pacman -S kde-meta-kdebase kde-meta-kdeutils ...

In addition to this, there is a kde-meta group that includes all these
meta-packages. Installing the kde-meta group will install the entire KDE
software compilation:

    # pacman -S kde-meta

> Why use meta-packages?

Advantages

-   Like package groups, meta-packages make it easy to install and
    maintain a set of packages. This allows you to use a single command
    (like above) to install all packages in a module.
-   Use of meta-packages ensures that pacman will install any new member
    packages automatically when you upgrade your system. This emulates
    the behavior of the monolithic set of packages that were used before
    KDE SC 4.3.

Disadvantages

-   Meta-packages have a hard dependency on all the member packages that
    are part of it. This means that you cannot freely remove member
    packages that are part of a meta-package without removing the
    meta-package first. For example, if you installed kde-meta-kdebase
    and would now like to remove a member package such as,
    kdebase-kwrite, you will first need to remove the meta-package
    before removing the member package:

    # pacman -R kde-meta-kdebase
    # pacman -R kdebase-kwrite

Doing this will not remove other member packages in the kde-meta-kdebase
meta-package, but it will also no longer automatically add new packages
in that module (possibly from the next release) when you upgrade the
system using pacman -Syu. You may re-install kde-meta-kdebase
meta-package at any time to return to the monolithic package behavior.

If you installed the kde-meta package, you can remove all meta-packages
at once by using:

    # pacman -R kde-meta

This will only remove the meta-packages and not the actual member
packages.

> Who is it for?

Use meta-packages if you desire to install the entire KDE software
compilation or one or more of its modules in its entirety. This ensures
a smooth upgrade path by automatically adding new split packages from
subsequent releases.

Listing the member packages
---------------------------

To get a complete list of KDE applications use

    pacman -Sg kde

Get a list of all meta packages:

    pacman -Sg kde-meta

Get a list of all KDE module groups:

    for i in $(pacman -Sqg kde-meta); do echo ${i#kde-meta-};done

Get a list of all KDE packages and their module group:

    for i in $(pacman -Sqg kde-meta); do pacman -Sg ${i#kde-meta-};done

You could also use the web interface at archlinux.de to browse package
groups.

Retrieved from
"https://wiki.archlinux.org/index.php?title=KDE_Packages&oldid=246688"

Categories:

-   Arch development
-   Desktop environments
