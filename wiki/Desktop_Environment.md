Desktop Environment
===================

Summary

In graphical computing, a desktop environment (DE) commonly refers to a
style of graphical user interface (GUI) derived from the desktop
metaphor that is seen on most modern personal computers. This article
provides a general overview of popular desktop environments.

Overview

The Xorg project provides an open source implementation of the X Window
System – the foundation for a graphical user interface. Desktop
environments such as Enlightenment, GNOME, KDE, LXDE, and Xfce provide a
complete graphical environment. Various window managers offer
alternative and novel environments, and may be used standalone to
conserve system resources. Display managers provide a graphical login
prompt.

Resources

Wikipedia:Desktop environment

Wikipedia:X Window System

Desktop environments provide a complete graphical user interface (GUI)
for a system by bundling together a variety of X clients written using a
common widget toolkit and set of libraries.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 X Window System                                                    |
| -   2 Desktop environments                                               |
|     -   2.1 List of desktop environments                                 |
|     -   2.2 Comparison of desktop environments                           |
|         -   2.2.1 Resource use                                           |
|         -   2.2.2 Environment familiarity                                |
|                                                                          |
| -   3 Custom environments                                                |
+--------------------------------------------------------------------------+

X Window System
---------------

The X Window System provides the foundation for a graphical user
interface. Prior to installing a desktop environment, a functional X
server installation is required. See Xorg for detailed information.

X provides the basic framework, or primitives, for building such GUI
environments: drawing and moving windows on the screen and interacting
with a mouse and keyboard. X does not mandate the user interface —
individual client programs known as window managers handle this. As
such, the visual styling of X-based environments varies greatly;
different programs may present radically different interfaces. X is
built as an additional (application) abstraction layer on top of the
operating system kernel.

The user is free to configure their GUI environment in any number of
ways. Desktop environments simply provide a complete and convenient
means of accomplishing this task.

Desktop environments
--------------------

A desktop environment bundles together a variety of X clients to provide
common graphical user interface elements such as icons, windows,
toolbars, wallpapers, and desktop widgets. Additionally, most desktop
environments include a set of integrated applications and utilities.

Note that users are free to mix-and-match applications from multiple
desktop environments. For example, a KDE user may install and run GNOME
applications such as the Epiphany web browser, should he/she prefer it
over KDE's Konqueror web browser. One drawback of this approach is that
many applications provided by desktop environment projects rely heavily
upon their DE's respective underlying libraries. As a result, installing
applications from a range of desktop environments will require
installation of a larger number of dependencies. Users seeking to
conserve disk space and avoid software bloat often avoid such mixed
environments, or look into lightweight alternatives.

Furthermore, DE-provided applications tend to integrate better with
their native environments. Superficially, mixing environments with
different widget toolkits will result in visual discrepancies (that is,
interfaces will use different icons and widget styles). In terms of user
experience, mixed environments may not behave similarly (e.g.
single-clicking versus double-clicking icons; drag-and-drop
functionality) potentially causing confusion or unexpected behavior.

> List of desktop environments

-   GNOME — The GNOME project provides two things: The GNOME desktop
    environment, an attractive and intuitive desktop for users, and the
    GNOME development platform, an extensive framework for building
    applications that integrate into the rest of the desktop. GNOME is
    free, usable, accessible, international, developer-friendly,
    organized, supported, and a community.

http://www.gnome.org/about/ || gnome

-   Mate — Mate is a fork of Gnome 2. Mate provides an intuitive and
    attractive desktop to Linux users using traditional metaphors.

http://www.mate-desktop.org/ ||

-   Cinnamon — Cinnamon is a fork of Gnome 3. Cinnamon strives to
    provide a traditional user experience, similar to Gnome 2.

http://cinnamon.linuxmint.com/ || cinnamon

-   KDE — KDE software consists of a large number of individual
    applications and a desktop workspace as a shell to run these
    applications. You can run KDE applications just fine on any desktop
    environment as they are built to integrate well with your system's
    components. By also using the KDE workspace, you get even better
    integration of your applications with the working environment while
    lowering system resource demands.

http://www.kde.org/ || kde

-   Xfce — Xfce embodies the traditional UNIX philosophy of modularity
    and re-usability. It consists of a number of components that provide
    the full functionality one can expect of a modern desktop
    environment, while remaining relatively light. They are packaged
    separately and you can pick among the available packages to create
    the optimal personal working environment.

http://www.xfce.org/ || xfce4

-   Enlightenment — The Enlightenment desktop shell provides an
    efficient yet breathtaking window manager based on the Enlightenment
    Foundation Libraries along with other essential desktop components
    like a file manager, desktop icons and widgets. It boasts a
    unprecedented level of theme-ability while still being capable of
    performing on older hardware or embedded devices.

http://www.enlightenment.org/ || enlightenment17

-   LXDE — The "Lightweight X11 Desktop Environment" is a fast and
    energy-saving desktop environment. Maintained by an international
    community of developers, it comes with a beautiful interface,
    multi-language support, standard keyboard short cuts and additional
    features like tabbed file browsing. Fundamentally designed to be
    lightweight, LXDE uses less CPU and RAM than other environments. It
    is especially beneficial for cloud computers with low hardware
    specifications, such as netbooks, mobile devices (e.g. MIDs) or
    older computers.

http://lxde.org/ || lxde

-   ROX — ROX is a fast, user friendly desktop which makes extensive use
    of drag-and-drop. The interface revolves around the file manager,
    following the traditional UNIX view that 'everything is a file'
    rather than trying to hide the filesystem beneath start menus,
    wizards, or druids. The aim is to make a system that is well
    designed and clearly presented. The ROX style favors using several
    small programs together instead of creating all-in-one
    mega-applications.

http://roscidus.com/desktop/ || rox

-   Sugar — The Sugar Learning Platform is a computer environment
    composed of Activities designed to help children from 5 to 12 years
    of age learn together through rich-media expression. Sugar is the
    core component of a worldwide effort to provide every child with the
    opportunity for a quality education — it is currently used by nearly
    one-million children worldwide speaking 25 languages in over 40
    countries. Sugar provides the means to help people lead fulfilling
    lives through access to a quality education that is currently missed
    by so many.

http://wiki.sugarlabs.org/ || sugar [unsupported]

-   Razor-qt — Razor-qt is an advanced, easy-to-use, and fast desktop
    environment based on Qt technologies. It has been tailored for users
    who value simplicity, speed, and an intuitive interface. While still
    a new project, Razor-qt already contains all the key DE components.

http://razor-qt.org/ || razor-qt [unsupported]

-   Consort — Consort is a desktop environment for SolusOS, fork of
    GNOME fallback

http://github.org/SolusOS/consort-panel || consort-panel-git

> Comparison of desktop environments

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This section attempts to draw a comparison between popular desktop
environments. Note that first-hand experience is the only effective way
to truly evaluate whether a desktop environment best suits your needs.

See the Wikipedia article on this subject for more information:
Comparison of X Window System desktop environments

  Desktop environment   Widget toolkit   Window manager   Terminal emulator   File manager               Text editor     Web browser
  --------------------- ---------------- ---------------- ------------------- -------------------------- --------------- -------------
  Enlightenment         Elementary       Enlightenment    Terminology         EFM / Entropy / Evidence   N/A             Eve
  GNOME                 GTK+             Mutter           GNOME Terminal      Nautilus                   gedit           Epiphany
  KDE                   Qt               KWin             Konsole             Dolphin                    Kate / KWrite   Konqueror
  LXDE                  GTK+             Openbox          LXTerminal          PCManFM                    Leafpad         N/A
  Razor-qt              Qt               N/A              N/A                 N/A                        N/A             N/A
  ROX                   GTK+             OroboROX         ROXTerm             ROX-Filer                  Edit            N/A
  Xfce                  GTK+             Xfwm             Terminal            Thunar                     N/A *           Midori
  Consort               GTK+             Consortium       N/A                 Athena                     N/A             N/A

  :  Overview of desktop environments

Note:* Mousepad used to be XFCE's recommended text editor, but it is now
discontinued. Many people recommend Leafpad or gEdit instead. See
http://forum.xfce.org/viewtopic.php?id=7066 for more information.

Resource use

In terms of system resources, GNOME and KDE are expensive desktop
environments. Not only do complete installations consume more disk space
than lightweight alternatives (Enlightenment, LXDE, Razor-qt and Xfce)
but also more CPU and memory resources while in use. This is because
GNOME and KDE are relatively full-featured: they provide the most
complete and well-integrated environments.

Enlightenment, LXDE, Razor-qt and Xfce, on the other hand, are
lightweight desktop environments. They are designed to work well on
older or lower-power hardware and generally consume fewer system
resources while in use. This is achieved by cutting back on extra
features (which some would term bloat).

Environment familiarity

Many users describe KDE as more Windows-like and GNOME as more Mac-like.
This is a very subjective comparison, since either desktop environment
can be customized to emulate the Windows or Mac operating systems. See
Is KDE 'more Windows-like' than Gnome? and KDE vs Gnome for more
information. (Linux is Not Windows is also an excellent resource.)

Custom environments
-------------------

Desktop environments represent the simplest means of installing a
complete graphical environment. However, users are free to build and
customize their graphical environment in any number of ways should none
of the popular desktop environments meet their requirements. Generally,
building a custom environment involves selection of a suitable Window
Manager and a number of Lightweight Applications (a minimalist selection
usually includes a terminal emulator, file manager, and text editor).

Retrieved from
"https://wiki.archlinux.org/index.php?title=Desktop_Environment&oldid=251476"

Category:

-   Desktop environments
