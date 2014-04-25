Window manager
==============

Related articles

-   Desktop environment
-   Display manager
-   xinitrc
-   Start X at Login

A window manager (WM) is one component of a system's graphical user
interface (GUI). Users may prefer to install a full-fledged Desktop
environment, which provides a complete user interface, including icons,
windows, toolbars, wallpapers, and desktop widgets.

Contents
--------

-   1 X Window System
-   2 Window managers
    -   2.1 Types
-   3 List of window managers
    -   3.1 Stacking window managers
    -   3.2 Tiling window managers
    -   3.3 Dynamic window managers
-   4 See also

X Window System
---------------

The X Window System provides the foundation for a graphical user
interface. Prior to installing a window manager, a functional X server
installation is required. See Xorg for detailed information.

X provides the basic framework, or primitives, for building such GUI
environments: drawing and moving windows on the screen and interacting
with a mouse and keyboard. X does not mandate the user interface —
individual client programs known as window managers handle this. As
such, the visual styling of X-based environments varies greatly;
different programs may present radically different interfaces. X is
built as an additional (application) abstraction layer on top of the
operating system kernel.

The user is free to configure their GUI environment in any number of
ways.

Window managers
---------------

Window managers (WMs) are X clients that provide the border around a
window. The window manager controls the appearance of an application and
how it is managed: the border, titlebar, size, and ability to resize a
window are handled by window managers. Many window managers provide
other functionality such as places to stick dockapps like Window Maker,
a menu to start programs, menus to configure the WM and other useful
things. Fluxbox, for example, has the ability to tab windows.

Window managers generally do not provide extras like desktop icons,
which are commonly seen in desktop environments (though it is possible
to add icons in a WM with another program).

Because of the lack of extras, WMs are much lighter on system resources.

> Types

-   Stacking (aka floating) window managers provide the traditional
    desktop metaphor used in commercial operating systems like Windows
    and OS X. Windows act like pieces of paper on a desk, and can be
    stacked on top of each other. For available Arch Wiki pages see
    Category:Stacking WMs.
-   Tiling window managers "tile" the windows so that none are
    overlapping. They usually make very extensive use of key-bindings
    and have less (or no) reliance on the mouse. Tiling window managers
    may be manual, offer predefined layouts, or both. For available Arch
    Wiki pages see Category:Tiling WMs.
-   Dynamic window managers can dynamically switch between tiling or
    floating window layout. For available Arch Wiki pages see
    Category:Dynamic WMs.

See Comparison of Tiling Window Managers and Wikipedia:Comparison of X
window managers for comparison of window managers.

List of window managers
-----------------------

> Stacking window managers

-   2bwm — Fast floating WM, with the particularity of having 2 borders,
    written over the XCB library and derived from mcwm written by
    Michael Cardell. In 2bwm everything is accessible from the keyboard
    but a pointing device can be used for move, resize and raise/lower.
    The name has recently changed from mcwm-beast to 2bwm.

https://github.com/venam/2bwm || 2bwm

-   aewm — Modern, minimal window manager for X11. It is controlled
    entirely with the mouse, but contains no visible UI apart from
    window frames. The command set is sort of like vi: designed back in
    the dawn of time (1997) to squeeze speed out of low-memory machines,
    completely unintuitive and new-user-hostile, but quick and elegant
    in its own way.

http://www.red-bean.com/decklin/aewm/ || aewm

-   AfterStep — Window manager for the Unix X Window System. Originally
    based on the look and feel of the NeXTStep interface, it provides
    end users with a consistent, clean, and elegant desktop. The goal of
    AfterStep development is to provide for flexibility of desktop
    configuration, improving aesthetics, and efficient use of system
    resources.

http://www.afterstep.org/ || afterstep

-   Blackbox — Fast, lightweight window manager for the X Window System,
    without all those annoying library dependencies. Blackbox is built
    with C++ and contains completely original code (even though the
    graphics implementation is similar to that of WindowMaker).

http://blackboxwm.sourceforge.net/ || blackbox

-   Compiz — OpenGL compositing manager that uses
    GLX_EXT_texture_from_pixmap for binding redirected top-level windows
    to texture objects. It has a flexible plug-in system and it is
    designed to run well on most graphics hardware.

http://www.compiz.org/ || compiz-core compiz-dev

-   Enlightenment — Enlightenment is not just a window manager for
    Linux/X11 and others, but also a whole suite of libraries to help
    you create beautiful user interfaces with much less work than doing
    it the old fashioned way and fighting with traditional toolkits, not
    to mention a traditional window manager.

http://www.enlightenment.org/ || enlightenment

-   evilwm — Minimalist window manager for the X Window System.
    'Minimalist' here does not mean it is too bare to be usable - it
    just means it omits a lot of the stuff that make other window
    managers unusable.

http://www.6809.org.uk/evilwm/ || evilwm

-   Fluxbox — Window manager for X that was based on the Blackbox 0.61.1
    code. It is very light on resources and easy to handle but yet full
    of features to make an easy and extremely fast desktop experience.
    It is built using C++ and licensed under the MIT License.

http://www.fluxbox.org/ || fluxbox

-   Flwm — Attempt to combine the best ideas I have seen in several
    window managers. The primary influence and code base is from wm2 by
    Chris Cannam.

http://flwm.sourceforge.net/ || flwm

-   FVWM — Extremely powerful ICCCM-compliant multiple virtual desktop
    window manager for the X Window system. Development is active, and
    support is excellent.

http://www.fvwm.org/ || fvwm

-   Goomwwm — X11 window manager implemented in C as a cleanroom
    software project. It manages windows in a minimal floating layout,
    while providing flexible keyboard-driven controls for window
    switching, sizing, moving, tagging, and tiling. It is also fast,
    lightweight, modeless, Xinerama-aware, and EWMH compatible wherever
    possible.

http://aerosuidae.net/goomwwm/ || goomwwm

-   Hackedbox — Stripped down version of Blackbox - The X11 Window
    Manager. The toolbar and Slit have been removed. The goal of
    Hackedbox is to be a small "feature-set" window manager, with no
    bloat. There are no plans to add any functionality, only bugfixes
    and speed enhancements whenever possible.

http://scrudgeware.org/projects/Hackedbox/ || hackedbox

-   IceWM — Window manager for the X Window System. The goal of IceWM is
    speed, simplicity, and not getting in the user's way.

http://www.icewm.org/ || icewm

-   JWM — Window manager for the X11 Window System. JWM is written in C
    and uses only Xlib at a minimum.

http://joewing.net/programs/jwm/ || jwm

-   Karmen — Window manager for X, written by Johan Veenhuizen. It is
    designed to "just work." There is no configuration file and no
    library dependencies other than Xlib. The input focus model is
    click-to-focus. Karmen aims at ICCCM and EWMH compliance.

http://karmen.sourceforge.net/ || karmen

-   KWin — The standard KDE window manager in KDE 4.0, ships with the
    first version of built-in support for compositing, making it also a
    compositing manager. This allows KWin to provide advanced graphical
    effects, similar to Compiz, while also providing all the features
    from previous KDE releases (such as very good integration with the
    rest of KDE, advanced configurability, focus stealing prevention, a
    well-tested window manager, robust handling of misbehaving
    applications/toolkits, etc.).

http://techbase.kde.org/Projects/KWin || kdebase-workspace

-   lwm — Window manager for X that tries to keep out of your face.
    There are no icons, no button bars, no icon docks, no root menus, no
    nothing: if you want all that, then other programs can provide it.
    There is no configurability either: if you want that, you want a
    different window manager; one that helps your operating system in
    its evil conquest of your disc space and its annexation of your
    physical memory.

http://www.jfc.org.uk/software/lwm.html || lwm

-   Metacity — This window manager strives to be quiet, small, stable,
    get on with its job, and stay out of your attention.

http://blogs.gnome.org/metacity/ || metacity

-   Mutter — Window and compositing manager for GNOME, based on Clutter,
    uses OpenGL.

http://git.gnome.org/browse/mutter/ || mutter

-   Openbox — Highly configurable, next generation window manager with
    extensive standards support. The *box visual style is well known for
    its minimalistic appearance. Openbox uses the *box visual style,
    while providing a greater number of options for theme developers
    than previous *box implementations. The theme documentation
    describes the full range of options found in Openbox themes.

http://openbox.org/wiki/Main_Page || openbox

-   pawm — Window manager for the X Window system. So it is not a
    'desktop' and does not offer you a huge pile of useless options,
    just the facilities needed to run your X applications and at the
    same time having a friendly and easy to use interface.

http://www.pleyades.net/pawm/ || pawm

-   pekwm — Window manager that once upon a time was based on the aewm++
    window manager, but it has evolved enough that it no longer
    resembles aewm++ at all. It has a much expanded feature-set,
    including window grouping (similar to Ion, PWM, or Fluxbox),
    auto-properties, Xinerama, keygrabber that supports keychains, and
    much more.

http://www.pekwm.org/projects/pekwm || pekwm

-   Sawfish — Extensible window manager using a Lisp-based scripting
    language. Its policy is very minimal compared to most window
    managers. Its aim is simply to manage windows in the most flexible
    and attractive manner possible. All high-level WM functions are
    implemented in Lisp for future extensibility or redefinition.

http://sawfish.wikia.com/wiki/Main_Page || sawfish

-   TinyWM — Tiny window manager that I created as an exercise in
    minimalism. It is also maybe helpful in learning some of the very
    basics of creating a window manager. It is only around 50 lines of
    C. There is also a Python version using python-xlib.

http://incise.org/tinywm.html || tinywm

-   twm — Window manager for the X Window System. It provides titlebars,
    shaped windows, several forms of icon management, user-defined macro
    functions, click-to-type and pointer-driven keyboard focus, and
    user-specified key and pointer button bindings.

http://cgit.freedesktop.org/xorg/app/twm/ || xorg-twm

-   UWM — The ultimate window manager for UDE.

http://udeproject.sourceforge.net/ || ude

-   WindowLab — Small and simple window manager of novel design. It has
    a click-to-focus but not raise-on-focus policy, a window resizing
    mechanism that allows one or many edges of a window to be changed in
    one action, and an innovative menubar that shares the same part of
    the screen as the taskbar. Window titlebars are prevented from going
    off the edge of the screen by constraining the mouse pointer, and
    when appropriate the pointer is also constrained to the
    taskbar/menubar in order to make target menu items easier to hit.

http://nickgravgaard.com/windowlab/ || windowlab

-   Window Maker — X11 window manager originally designed to provide
    integration support for the GNUstep Desktop Environment. In every
    way possible, it reproduces the elegant look and feel of the
    NEXTSTEP user interface. It is fast, feature rich, easy to
    configure, and easy to use. It is also free software, with
    contributions being made by programmers from around the world.

http://windowmaker.org/ || windowmaker

-   WM2 — Window manager for X. It provides an unusual style of window
    decoration and as little functionality as its author feels
    comfortable with in a window manager. wm2 is not configurable,
    except by editing the source and recompiling the code, and is really
    intended for people who do not particularly want their window
    manager to be too friendly.

http://www.all-day-breakfast.com/wm2/ || wm2

-   Xfwm — The Xfce window manager manages the placement of application
    windows on the screen, provides beautiful window decorations,
    manages workspaces or virtual desktops and natively supports
    multiscreen mode. It provides its own compositing manager (from the
    X.Org Composite extension) for true transparency and shadows. The
    Xfce window manager also includes a keyboard shortcuts editor for
    user specific commands and basic windows manipulations and provides
    a preferences dialog for advanced tweaks.

http://www.xfce.org/projects/xfwm4/ || xfwm4

> Tiling window managers

-   Bspwm — bspwm is a tiling window manager that represents windows as
    the leaves of a full binary tree. It has support for EWMH and
    multiple monitors, and is configured and controlled through
    messages.

https://github.com/baskerville/bspwm || bspwm

-   dswm — Deep Space Window Manager is an offshoot of Stumpwm.

https://github.com/dss-project/dswm || dswm

-   Herbstluftwm — Manual tiling window manager for X11 using Xlib and
    Glib. The layout is based on splitting frames into subframes which
    can be split again or can be filled with windows (similar to i3/
    musca). Tags (or workspaces or virtual desktops or …) can be
    added/removed at runtime. Each tag contains an own layout. Exactly
    one tag is viewed on each monitor. The tags are monitor independent
    (similar to xmonad). It is configured at runtime via ipc calls from
    herbstclient. So the configuration file is just a script which is
    run on startup. (similar to wmii/musca).

http://herbstluftwm.org || herbstluftwm-git

-   Ion3 — Tiling tabbed X11 window manager designed with keyboard users
    in mind. It was one of the first of the “new wave" of tiling
    windowing environments (the other being LarsWM, with quite a
    different approach) and has since spawned an entire category of
    tiling window managers for X11 – none of which really manage to
    reproduce the feel and functionality of Ion. It uses Lua as an
    embedded interpreter which handles all of the configuration.

http://tuomov.iki.fi/software || ion3

-   Notion — Tiling, tabbed window manager for the X window system that
    utilizes 'tiles' and 'tabbed' windows.
    -   Tiling: you divide the screen into non-overlapping 'tiles'.
        Every window occupies one tile, and is maximized to it
    -   Tabbing: a tile may contain multiple windows - they will be
        'tabbed'.
    -   Static: most tiled window managers are 'dynamic', meaning they
        automatically resize and move around tiles as windows appear and
        disappear. Notion, by contrast, does not automatically change
        the tiling.

Notion is a fork of Ion3.

http://notion.sf.net/ || notion

-   Ratpoison — Simple Window Manager with no fat library dependencies,
    no fancy graphics, no window decorations, and no rodent dependence.
    It is largely modeled after GNU Screen which has done wonders in the
    virtual terminal market. Ratpoison is configured with a simple text
    file. The information bar in Ratpoison is somewhat different, as it
    shows only when needed. It serves as both an application launcher as
    well as a notification bar. Ratpoison does not include a system
    tray.

http://www.nongnu.org/ratpoison/ || ratpoison

-   Stumpwm — Tiling, keyboard driven X11 Window Manager written
    entirely in Common Lisp. Stumpwm attempts to be customizable yet
    visually minimal. It does have various hooks to attach your personal
    customizations, and variables to tweak, and can be reconfigured and
    reloaded while running. There are no window decorations, no icons,
    no buttons, and no system tray. Its information bar can be set to
    show constantly or only when needed.

http://www.nongnu.org/stumpwm/ || stumpwm-git

-   subtle — Manual tiling window manager with a rather uncommon
    approach of tiling: Per default there is no typical layout
    enforcement, windows are placed on a position (gravity) in a custom
    grid. The user can change the gravity of each window either directly
    per grabs or with rules defined by tags in the config. It has
    workspace tags and automatic client tagging, mouse and keyboard
    control as well as an extendable statusbar.

http://subforge.org/projects/subtle || subtle

-   WMFS — Window Manager From Scratch is a lightweight and highly
    configurable tiling window manager for X. It can be configured with
    a configuration file, supports Xft (FreeType) fonts and is compliant
    with the Extended Window Manager Hints (EWMH) specifications,
    Xinerama and Xrandr. WMFS can be driven with Vi based commands
    (ViWMFS).

https://github.com/xorg62/wmfs || wmfs

-   WMFS2 — Incompatible successor of WMFS. It's even more minimalistic
    and brings some new stuff.

https://github.com/xorg62/wmfs || wmfs2-git

> Dynamic window managers

-   awesome — Highly configurable, next generation framework window
    manager for X. It is very fast, extensible and licensed under the
    GNU GPLv2 license. Configured in Lua, it has a system tray,
    information bar, and launcher built in. There are extensions
    available to it written in Lua. Awesome uses XCB as opposed to Xlib,
    which may result in a speed increase. Awesome has other features as
    well, such as an early replacement for notification-daemon, a
    right-click menu similar to that of the *box window managers, and
    many other things.

http://awesome.naquadah.org/ || awesome

-   catwm — Small window manager, even simpler than dwm, written in C.
    Configuration is done by modifying the config.h file and
    recompiling.

https://github.com/pyknite/catwm || catwm-git

-   dwm — Dynamic window manager for X. It manages windows in tiled,
    monocle and floating layouts. All of the layouts can be applied
    dynamically, optimising the environment for the application in use
    and the task performed. does not include a tray app or automatic
    launcher, although dmenu integrates well with it, as they are from
    the same author. It has no text configuration file. Configuration is
    done entirely by modifying the C source code, and it must be
    recompiled and restarted each time it is changed.

http://dwm.suckless.org/ || dwm

-   echinus — Simple and lightweight tiling and floating window manager
    for X11. Started as a dwm fork with easier configuration, echinus
    became full-featured re-parenting window manager with EWMH support.
    It has an EWMH-compatible panel/taskbar, called ourico.

http://plhk.ru/echinus || echinus

-   euclid-wm — Simple and lightweight tiling and floating window
    manager for X11, with support for minimizing windows. A text
    configuration file controls key bindings and settings. It started as
    a dwm fork with easier configuration, and became a full-featured
    reparenting window manager with EWMH support. It has an
    EWMH-compatible panel/taskbar called ourico.

http://euclid-wm.sourceforge.net/index.php || euclid-wm

-   i3 — Tiling window manager, completely written from scratch. i3 was
    created because wmii, our favorite window manager at the time, did
    not provide some features we wanted (multi-monitor done right, for
    example) had some bugs, did not progress since quite some time and
    was not easy to hack at all (source code comments/documentation
    completely lacking). Notable differences are in the areas of
    multi-monitor support and the tree metaphor. For speed the Plan 9
    interface of wmii is not implemented.

http://i3wm.org/ || i3-wm

-   monsterwm — Minimal, lightweight, tiny but monsterous dynamic tiling
    window manager. It will try to stay as small as possible. Currently
    under 700 lines with the config file included. It provides a set of
    four different layout modes (vertical stack, bottom stack, grid and
    monocle/fullscreen) by default, and has floating mode support. It
    also features multi-monitor support. Each monitor and virtual
    desktop have their own properties, unaffected by other monitors' or
    desktops' settings. Configuration is done entirely by modifying the
    C source code, and it must be recompiled and restarted each time it
    is changed. There are many available patches supported upstream, in
    the form of different git branches.

https://github.com/c00kiemon5ter/monsterwm || monsterwm-git

-   Musca — Simple dynamic window manager for X, with features nicked
    from ratpoison and dwm. Musca operates as a tiling window manager by
    default. The user determines how the screen is divided into
    non-overlapping frames, with no restrictions on layout. Application
    windows always fill their assigned frame, with the exception of
    transient windows and popup dialog boxes which float above their
    parent application at the appropriate size. Once visible,
    applications do not change frames unless so instructed.

http://aerosuidae.net/musca.html || musca

-   snapwm — Lightweight dynamic tiling window manager with an emphasis
    on easy configurability and choice. It has a built in bar with
    clickable workspaces and space for external text. There's five
    tiling modes: vertical, fullscreen, horizontal, grid and stacking.
    It has other features, like color support, independent desktops,
    choice of window placement strategy, reloadable config files,
    transparency support, dmenu integration, multi monitor support and
    more.

https://github.com/moetunes/Nextwm || snapwm-git

-   spectrwm — Small dynamic tiling window manager for X11, largely
    inspired by xmonad and dwm. It tries to stay out of the way so that
    valuable screen real estate can be used for much more important
    stuff. It has sane defaults and is configured with a text file. It
    was written by hackers for hackers and it strives to be small,
    compact and fast. It has a built-in status bar fed from a
    user-defined script.

https://opensource.conformal.com/wiki/spectrwm || spectrwm

-   Qtile — Full-featured, hackable tiling window manager written in
    Python. Qtile is simple, small, and extensible. It's easy to write
    your own layouts, widgets, and built-in commands.It is written and
    configured entirely in Python, which means you can leverage the full
    power and flexibility of the language to make it fit your needs.

https://github.com/qtile/qtile || qtile-git

-   Wingo — Fully featured true hybrid window manager that supports
    per-monitor workspaces, and neither the floating or tiling modes are
    after thoughts. This allows one to have tiling on one workspace
    while floating on the other. Wingo can be scripted with its own
    command language, is completely themeable, and supports user defined
    hooks. Wingo is written in Go and has no runtime dependencies.

https://github.com/BurntSushi/wingo || wingo-git

-   wmii — Small, dynamic window manager for X11. It is scriptable, has
    a 9P filesystem interface and supports classic and tiling
    (Acme-like) window management. It aims to maintain a small and clean
    (read hackable and beautiful) codebase. The default configuration is
    in bash and rc (the Plan 9 shell), but programs exist written in
    ruby, and any program that can work with text can configure it. It
    has a status bar and launcher built in, and also an optional system
    tray (witray).

http://wmii.suckless.org/ || wmii

-   xmonad — Dynamically tiling X11 window manager that is written and
    configured in Haskell. In a normal WM, you spend half your time
    aligning and searching for windows. xmonad makes work easier, by
    automating this. For all configuration changes, xmonad must be
    recompiled, so the Haskell compiler (over 100MB) must be installed.
    A large library called xmonad-contrib provides many additional
    features

http://xmonad.org/ || xmonad

See also
--------

-   http://www.gilesorr.com/wm/

Retrieved from
"https://wiki.archlinux.org/index.php?title=Window_manager&oldid=303406"

Category:

-   Window managers

-   This page was last modified on 6 March 2014, at 19:39.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
