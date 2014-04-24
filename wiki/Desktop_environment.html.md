Desktop environment
===================

Related articles

-   Display manager
-   Window manager
-   Default applications

A desktop environment provides a complete graphical user interface (GUI)
for a system by bundling together a variety of X clients written using a
common widget toolkit and set of libraries.

Contents
--------

-   1 X Window System
-   2 Desktop environments
    -   2.1 List of desktop environments
        -   2.1.1 Officially supported
        -   2.1.2 Unofficially supported
    -   2.2 Comparison of desktop environments
        -   2.2.1 Resource use
        -   2.2.2 Environment familiarity
-   3 Custom environments

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

Officially supported

-   Cinnamon — Cinnamon is a fork of GNOME 3. Cinnamon strives to
    provide a traditional user experience, similar to GNOME 2.

http://cinnamon.linuxmint.com/ || cinnamon

-   Enlightenment — The Enlightenment desktop shell provides an
    efficient yet breathtaking window manager based on the Enlightenment
    Foundation Libraries along with other essential desktop components
    like a file manager, desktop icons and widgets. It boasts a
    unprecedented level of theme-ability while still being capable of
    performing on older hardware or embedded devices.

http://www.enlightenment.org/ || enlightenment

-   GNOME — The GNOME project provides two things: The GNOME desktop
    environment, an attractive and intuitive desktop for users, and the
    GNOME development platform, an extensive framework for building
    applications that integrate into the rest of the desktop. GNOME is
    free, usable, accessible, international, developer-friendly,
    organized, supported, and a community.

http://www.gnome.org/about/ || gnome

-   KDE — KDE software consists of a large number of individual
    applications and a desktop workspace as a shell to run these
    applications. You can run KDE applications just fine on any desktop
    environment as they are built to integrate well with your system's
    components. By also using the KDE workspace, you get even better
    integration of your applications with the working environment while
    lowering system resource demands.

http://www.kde.org/ || kdebase

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

-   MATE — MATE is a fork of GNOME 2. Mate provides an intuitive and
    attractive desktop to Linux users using traditional metaphors.

http://www.mate-desktop.org/ || mate

-   Xfce — Xfce embodies the traditional UNIX philosophy of modularity
    and re-usability. It consists of a number of components that provide
    the full functionality one can expect of a modern desktop
    environment, while remaining relatively light. They are packaged
    separately and you can pick among the available packages to create
    the optimal personal working environment.

http://www.xfce.org/ || xfce4

Unofficially supported

-   Deepin — Deepin desktop interface and apps feature an intuitive and
    elegant design. Moving around, sharing and searching etc. has become
    simply a joyful experience.

http://www.linuxdeepin.com/ || deepin-desktop-environment

-   EDE — The "Equinox Desktop Environment" is a DE designed to be
    simple, extremely light-weight and fast.

http://equinox-project.org/ || ede

-   GNOME Flashback — GNOME Flashback is a shell for GNOME 3 which was
    initially called GNOME fallback mode. The desktop layout and the
    underlying technology is similar to GNOME 2.

https://wiki.gnome.org/GnomeFlashback || gnome-panel

-   GNUstep — GNUstep is a free, object-oriented, cross-platform
    development environment that strives for simplicity and elegance.

http://gnustep.org/ || windowmaker gworkspace

-   Hawaii — Hawaii is a lightweight, coherent and fast desktop
    environment that relies on Qt 5, QtQuick and Wayland and is designed
    to offer the best UX for the device where it is running.

http://www.maui-project.org/ || hawaii-meta-git

-   LXDE-Qt — LXDE-Qt is the development version of a new desktop
    environment written by LXDE and Razor-qt developers. It is based on
    Qt technologies.

http://wiki.lxde.org/en/LXDE-Qt || lxqt-common-git

-   Pantheon — Pantheon is the default desktop environment originally
    created for the elementary OS distribution. It is written from
    scratch using Vala and the GTK3 toolkit. With regards to usability
    and appearance, the desktop has some similarities with GNOME Shell
    and Mac OS X.

http://elementaryos.org/ || pantheon-session-bzr

-   Razor-qt — Razor-qt is an advanced, easy-to-use, and fast desktop
    environment based on Qt technologies. It has been tailored for users
    who value simplicity, speed, and an intuitive interface. While still
    a new project, Razor-qt already contains all the key DE components.

http://razor-qt.org/ || razor-qt

-   ROX — ROX is a fast, user friendly desktop which makes extensive use
    of drag-and-drop. The interface revolves around the file manager,
    following the traditional UNIX view that 'everything is a file'
    rather than trying to hide the filesystem beneath start menus,
    wizards, or druids. The aim is to make a system that is well
    designed and clearly presented. The ROX style favors using several
    small programs together instead of creating all-in-one
    mega-applications.

http://rox.sourceforge.net/desktop/ || not packaged? search in AUR

-   Sugar — The Sugar Learning Platform is a computer environment
    composed of Activities designed to help children from 5 to 12 years
    of age learn together through rich-media expression. Sugar is the
    core component of a worldwide effort to provide every child with the
    opportunity for a quality education — it is currently used by nearly
    one-million children worldwide speaking 25 languages in over 40
    countries. Sugar provides the means to help people lead fulfilling
    lives through access to a quality education that is currently missed
    by so many.

http://wiki.sugarlabs.org/ || sugar

-   Trinity — The Trinity Desktop Environment (TDE) project is a
    computer desktop environment for Unix-like operating systems with a
    primary goal of retaining the overall KDE 3.5 computing style.

http://www.trinitydesktop.org/ || See Trinity

-   Unity — Unity is a shell for GNOME designed by Canonical for Ubuntu.

http://unity.ubuntu.com/ || unity

> Comparison of desktop environments

This section attempts to draw a comparison between popular desktop
environments. Note that first-hand experience is the only effective way
to truly evaluate whether a desktop environment best suits your needs.

See the Wikipedia article on this subject for more information:
Comparison of X Window System desktop environments

  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Desktop environment   Widget toolkit   Window manager      Taskbar                      Terminal emulator         File manager       Calculator                    Text editor                   Image viewer                  Media player                  Web browser             Display manager
  --------------------- ---------------- ------------------- ---------------------------- ------------------------- ------------------ ----------------------------- ----------------------------- ----------------------------- ----------------------------- ----------------------- -----------------------------------
  Cinnamon              GTK+ 3           Muffin              Cinnamon                     GNOME Terminal            Nemo               Calculator                    gedit                         Eye of GNOME                  Totem                         Firefox                 LightDM GTK+ Greeter  
                        gtk3             muffin              cinnamon                     gnome-terminal            nemo               gnome-calculator              gedit                         eog                           totem                         firefox                 lightdm-gtk3-greeter

  Deepin                GTK+ 2/3         Compiz              Dock                         Deepin Terminal           Nautilus           Calculator                    gedit                         Eye of GNOME                  DPlayer                       Firefox                 LightDM Deepin Greeter  
                        gtk2 gtk3        compiz-devel        deepin-desktop-environment   deepin-terminal           nautilus           gnome-calculator              gedit                         eog                           deepin-media-player           firefox                 deepin-desktop-environment

  EDE                   FLTK             PekWM               EDE Panel                    XTerm                     Fluff              Calculator                    Editor                        Image Viewer                  flmusic                       Dillo                   XDM  
                        fltk             ede                 ede                          xterm                     fluff              ede                           fltk-editor                   ede                           flmusic                       dillo                   xorg-xdm

  Enlightenment         Elementary       Enlightenment       Enlightenment                Terminology               EFM                Equate                        Ecrire                        Ephoto                        Enjoy                         Eve                     XDM  
                        elementary       enlightenment       enlightenment                terminology               enlightenment      equate-git                    ecrire-git                    ephoto-git                    enjoy-git                     eve-git                 xorg-xdm

  GNOME                 GTK+ 3           Mutter              GNOME Shell                  GNOME Terminal            Nautilus           Calculator                    gedit                         Eye of GNOME                  Totem                         Epiphany                GDM  
                        gtk3             mutter              gnome-shell                  gnome-terminal            nautilus           gnome-calculator              gedit                         eog                           totem                         epiphany                gdm

  GNOME Flashback       GTK+ 2/3         Metacity            GNOME Panel                  GNOME Terminal            Nautilus           Calculator                    gedit                         Eye of GNOME                  Totem                         Epiphany                GDM  
                        gtk2 gtk3        metacity            gnome-panel                  gnome-terminal            nautilus           gnome-calculator              gedit                         eog                           totem                         epiphany                gdm

  GNUstep               GNUstep          Window Maker        Window Maker                 Terminal                  GWorkspace         Calculator                    Ink                           LaternaMagica                 Cynthiune                     SWK Browser             XDM  
                        gnustep-core     windowmaker         windowmaker                  gnustep-terminal          gworkspace         gnustep-examples              gnustep-examples              laternamagica                 cynthiune                     swkbrowser-svn          xorg-xdm

  Hawaii                Qt 5             Weston              Hawaii Shell                 Terminal                  Swordfish          Calculator                    TEA                           EyeSight                      Cinema                        QupZilla                SDDM  
                        qt5              weston              hawaii-shell-git             hawaii-terminal-git       swordfish-git      not packaged? search in AUR   not packaged? search in AUR   eyesight-git                  not packaged? search in AUR   qupzilla-qt5            sddm-qt5

  KDE                   Qt 4             KWin                Plasma Desktop               Konsole                   Dolphin            KCalc                         KWrite/Kate                   Gwenview                      Dragon Player                 Konqueror               KDM  
                        qt4              kdebase-workspace   kdebase-workspace            kdebase-konsole           kdebase-dolphin    kdeutils-kcalc                kdebase-kwrite kdesdk-kate    kdegraphics-gwenview          kdemultimedia-dragonplayer    kdebase-konqueror       kdebase-workspace

  LXDE                  GTK+ 2           Openbox             LXPanel                      LXTerminal                PCManFM            Galculator                    Leafpad                       GPicView                      LXMusic                       Firefox                 LXDM  
                        gtk2             openbox             lxpanel                      lxterminal                pcmanfm            galculator-gtk2               leafpad                       gpicview                      lxmusic                       firefox                 lxdm

  MATE                  GTK+ 2           Marco               MATE Panel                   MATE Terminal             Caja               Galculator                    pluma                         Eye of MATE                   Whaaw!                        Midori                  LightDM GTK+ Greeter  
                        gtk2             marco               mate-panel                   mate-terminal             caja               galculator-gtk2               pluma                         eom                           whaawmp                       midori                  lightdm-gtk2-greeter

  Pantheon              GTK+ 3           Gala                Plank/Wingpanel              Pantheon Terminal         Pantheon Files     Calculator                    Scratch                       Shotwell                      Totem                         Midori                  LightDM Pantheon Greeter  
                        gtk3             gala-bzr            plank wingpanel              pantheon-terminal         pantheon-files     gnome-calculator              scratch-text-editor           shotwell                      totem                         midori-gtk3             lightdm-pantheon-greeter

  Razor-qt (LXDE-Qt)    Qt 4             Openbox             Razor Panel                  QTerminal                 PCManFM-Qt         SpeedCrunch                   JuffEd                        LxImage-Qt                    Qmmp                          QupZilla                LightDM Razor-qt Greeter (SDDM)  
                        qt4              openbox             razor-qt                     qterminal-git             pcmanfm-qt-git     speedcrunch                   juffed                        lximage-qt-git                qmmp                          qupzilla                lightdm-razor-greeter  
                                                             (lxqt-panel-git)                                                                                                                                                                                                          (sddm)

  ROX                   GTK+ 2           OroboROX            ROX-Filer                    ROXTerm                   ROX-Filer          Galculator                    Edit                          Picky                         MusicBox                      Midori                  LightDM GTK+ Greeter  
                        gtk2             oroborox            rox                          roxterm (roxterm-gtk2)    rox                galculator-gtk2               rox-edit                      not packaged? search in AUR   not packaged? search in AUR   midori                  lightdm-gtk2-greeter

  Sugar                 GTK+ 2/3         Metacity            Sugar                        Terminal                  Sugar Journal      Calculate                     Write                         ImageViewer                   Jukebox                       Browse                  LightDM GTK+ Greeter  
                        gtk2 gtk3        metacity            sugar                        sugar-activity-terminal   sugar              sugar-activity-calculate      sugar-activity-write          sugar-activity-imageviewer    sugar-activity-jukebox        sugar-activity-browse   lightdm-gtk3-greeter

  Trinity               Qt 3             TWin                Kicker                       Konsole                   Konqueror          KCalc                         Kwrite / Kate                 Kuickshow                     Kaffeine                      Konqueror               TDM

  Unity                 GTK+ 2/3         Compiz              Unity                        GNOME Terminal            Nautilus           Calculator                    gedit                         Eye of GNOME                  Totem                         Firefox                 LightDM Unity Greeter  
                        gtk2 gtk3        compiz-devel        unity                        gnome-terminal            nautilus           gnome-calculator              gedit                         eog                           totem                         firefox                 lightdm-unity-greeter

  Xfce                  GTK+ 2           Xfwm4               Xfce Panel                   Terminal                  Thunar             Galculator                    Mousepad                      Ristretto                     Parole                        Midori                  LightDM GTK+ Greeter  
                        gtk2             xfwm4               xfce4-panel                  xfce4-terminal            thunar             galculator-gtk2               mousepad                      ristretto                     parole                        midori                  lightdm-gtk2-greeter
  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

  :  Overview of desktop environments

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
Is KDE 'more Windows-like' than GNOME? and KDE vs GNOME for more
information. (Linux is Not Windows is also an excellent resource.)

Custom environments
-------------------

Desktop environments represent the simplest means of installing a
complete graphical environment. However, users are free to build and
customize their graphical environment in any number of ways should none
of the popular desktop environments meet their requirements. Generally,
building a custom environment involves selection of a suitable window
manager, a taskbar and a number of applications (a minimalist selection
usually includes a terminal emulator, file manager, and text editor).

Retrieved from
"https://wiki.archlinux.org/index.php?title=Desktop_environment&oldid=305689"

Category:

-   Desktop environments

-   This page was last modified on 20 March 2014, at 00:22.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
