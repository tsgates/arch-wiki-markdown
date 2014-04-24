Wayland
=======

Related articles

-   KMS
-   Xorg
-   Mir

Wayland is a new windowing protocol for Linux. Utilization of Wayland
requires changes to and re-installation of parts of your system's
software. For more information on Wayland see its homepage.

Warning:Wayland is under heavy development. Support can not be
guaranteed and it may not function as you expect.

Contents
--------

-   1 Requirements
-   2 Installation
-   3 Usage
-   4 Weston
    -   4.1 Installation
    -   4.2 Usage
    -   4.3 Configuration
        -   4.3.1 XWayland
-   5 GUI libraries
    -   5.1 GTK+
    -   5.2 Qt5
    -   5.3 Clutter
    -   5.4 SDL
    -   5.5 EFL
-   6 Window managers and desktop shells
    -   6.1 KDE
    -   6.2 GNOME
    -   6.3 i3
    -   6.4 Pure Wayland
        -   6.4.1 Wayland, DRM, Pixman, libxkbcommon
        -   6.4.2 Mesa
        -   6.4.3 cairo
        -   6.4.4 weston
-   7 Troubleshooting
    -   7.1 LLVM assertion failure
-   8 See also

Requirements
------------

Currently Wayland will only work on systems utilizing KMS.

Installation
------------

Wayland is most probably installed on your system already as it is an
indirect dependency of gtk2 and gtk3. If it is not installed, you will
find the wayland package in the official repositories.

Usage
-----

As Wayland is only a library, it is useless on its own. To use it, you
need a compositor (like Weston), Weston demo applications, Qt5 with
Wayland plugin, and/or GTK+ with Wayland support.

Weston
------

> Installation

You need to install weston from the official repositories.

> Usage

  Cmd                                   Action
  ------------------------------------- ------------------------------------------
  Ctrl + Alt + Backspace                Quit Weston
  Super + Scroll (or PageUp/PageDown)   Zoom in/out of desktop
  Super + Tab                           Switch windows
  Super + LMB                           Move Window
  Super + MMB                           Resize Window
  Super + RMB                           Rotate Window !
  Super + Tab                           Switch windows
  Super + K                             Force Kill Active Window
  Super + KeyUp/KeyDown                 Switch Prev/Next Workspace
  Super + Shift + KeyUp/KeyDown         Grab Current Window and Switch Workspace
  Super + Fn                            Switch to Workspace n

  :  Keyboard Shortcuts (super = windows key - can be changed, see
  weston.ini) Ctrl-b

Now that Wayland and its requirements are installed you should be ready
to test it out.

> Note:

You need to be in the video group for Weston to start; this command is
not supposed to be run as root and doing so may freeze your VT !

It is possible to run Weston inside a running X session:

    $ weston

Alternatively, to launch Weston natively, try switching to a terminal
and running:

    $ weston-launch

Then at a TTY within Weston, you can run the demos. To launch a terminal
emulator:

    $ weston-terminal

To move flowers around the screen:

    $ weston-flower 

To test the frame protocol (runs glxgears):

    $ weston-gears

To display images:

    $ weston-image image1.jpg image2.jpg...

To display PDF Files:

    $ weston-view doc1.pdf doc2.pdf...

> Configuration

Example configuration file for keyboard layout, module selection and UI
modifications. See man weston.ini for full details:

    ~/.config/weston.ini

    [core]
    ### uncomment this line for xwayland support ###
    #modules=desktop-shell.so,xwayland.so

    [shell]
    background-image=/usr/share/backgrounds/gnome/Aqua.jpg
    background-color=0xff002244
    panel-color=0x90ff0000
    locking=true
    animation=zoom
    #binding-modifier=ctrl
    #num-workspaces=6
    ### for cursor themes install xcursor-themes pkg from Extra. ###
    #cursor-theme=whiteglass
    #cursor-size=24

    ### tablet options ###
    #lockscreen-icon=/usr/share/icons/gnome/256x256/actions/lock.png
    #lockscreen=/usr/share/backgrounds/gnome/Garden.jpg
    #homescreen=/usr/share/backgrounds/gnome/Blinds.jpg
    #animation=fade

    [keyboard]
    keymap_rules=evdev
    #keymap_layout=gb
    #keymap_options=caps:ctrl_modifier,shift:both_capslock_cancel
    ### keymap_options from /usr/share/X11/xkb/rules/base.lst ###


    [terminal]
    #font=DroidSansMono
    #font-size=14



    [launcher]
    icon=/usr/share/icons/gnome/24x24/apps/utilities-terminal.png
    path=/usr/bin/gnome-terminal

    [launcher]
    icon=/usr/share/icons/gnome/24x24/apps/utilities-terminal.png
    path=/usr/bin/weston-terminal

    [launcher]
    icon=/usr/share/icons/hicolor/24x24/apps/firefox.png
    path=/usr/bin/firefox

    [launcher]
    icon=/usr/share/icons/gnome/24x24/apps/arts.png
    path=./clients/flower

    [screensaver]
    # Uncomment path to disable screensaver
    path=/usr/libexec/weston-screensaver
    duration=600

    [input-method]
    path=/usr/libexec/weston-keyboard

    ###  for Laptop displays  ###
    #[output]
    #name=LVDS1
    #mode=1680x1050
    #transform=90

    #[output]
    #name=VGA1
    # The following sets the mode with a modeline, you can get modelines for your preffered resolutions using the cvt utility
    #mode=173.00 1920 2048 2248 2576 1080 1083 1088 1120 -hsync +vsync
    #transform=flipped

    #[output]
    #name=X1
    #mode=1024x768
    #transform=flipped-270

Minimal weston.ini :

    ~/.config/weston.ini

    [core]
    modules=desktop-shell.so,xwayland.so

    [keyboard]
    keymap_layout=gb

    [launcher]
    icon=/usr/share/icons/gnome/24x24/apps/utilities-terminal.png
    path=/usr/bin/weston-terminal

    [launcher]
    icon=/usr/share/icons/hicolor/24x24/apps/firefox.png
    path=/usr/bin/firefox


    [output]
    name=LVDS1
    mode=1680x1050
    transform=90

XWayland

XWayland is an XOrg server and compiles as a drop in replacement. The
only difference is that it is sourced from the Wayland branch of the
xorg-server repository and as such has the Wayland extensions. These
extensions allow it to run as a client of Weston.

When you want to run an X application from within Weston, it spins up
this modified X server to service the request.

Warning:The steps in this section set out to replace your graphics
stack. An incomplete installation could result in a broken graphical
environment.

If you plan to run native X-applications inside Wayland, then you have
to install xorg-server-xwayland and either patched graphic drivers
according to your system, e.g. xf86-video-intel-xwayland-git, or the
generic wlglamor fallback found at xf86-video-wlglamor-git. After that,
create or modify following configuration file:

    ~/.config/weston.ini

    [core]
    modules=xwayland.so,desktop-shell.so

Now you can also run X applications in some kind of "compatibility
mode". Final XWayland support should be available with the version 1.16
X-server release which is not due to land until mid 2014.

The AUR packages may require some modification in order to compile
successfully though (see this thread). An alternative is to compile
directly from source. This can be done in 3 steps (it is assumed you
already have the base-devel group installed).

First install the standard XOrg packages and the appropriate video
driver, this will pull in the required dependencies.

Note:Unless you are on a fresh installation, you likely already have
these. Just ensure you have the latest versions and if using ATI or
NVIDIA that you are using the open source drivers. Wayland graphics
hardware support seems to go Intel > ATI > NVidia so YMMV on non-Intel
hardware. However the new xf86-video-wlshm driver has been produced with
the purpose of having high compatibility across all hardware stacks.

    # pacman -S xorg-server xorg-server-utils xorg-xinit mesa
    # pacman -S xf86-video-yourdriver

Second, checkout and compile the XWayland xorg server.

Note:If you have 3GB of RAM or more, performing these operations in
memory (e.g. /tmp) is probably a good idea.

    $ git clone git://anongit.freedesktop.org/xorg/xserver -b xwayland
    $ cd xserver
    $ ./autogen.sh --prefix=/usr/  --enable-xorg --enable-wayland
    $ make

    # make install

Third, checkout and compile your video driver. The repos can be found on
the official Wayland website. As noted above, xf86-video-wlshm is likely
a good option for non-Intel graphics. Following are the instructions for
Intel hardware.

    $ git clone git://anongit.freedesktop.org/xorg/driver/xf86-video-intel -b xwayland
    $ cd xf86-video-intel
    $ ./autogen.sh --prefix=/usr/ --enable-dri --disable-xaa --with-default-accel=sna
    $ make

    # make install

If your Intel graphics are pre-Sandybridge use --with-default-accel=uxa
instead.

Now that you have replaced your xorg-server and graphics driver with the
XWayland patched versions you should be able to run XWayland. To test,
check that you have a small X application like xterm or xclock in your
path, fire up Weston using weston-launch, open weston-terminal and run
the X application.

GUI libraries
-------------

(See details on the official website)

> GTK+

You need to install gtk3 from the official repositories, which now has
the Wayland backend enabled.

With GTK+ 3.0, GTK+ gained support for multiple backends at runtime and
can switch between backends in the same way Qt can with lighthouse.

When both Wayland and X backends are enabled, GTK+ will default to the
X11 backend, but this can be overridden by modifying an environment
variable: GDK_BACKEND=wayland.

> Qt5

You need to either rebuild qt5-base with -opengl es2 (currently not
working, see
http://lists.qt-project.org/pipermail/development/2013-December/014789.html
) or use qtbase-git. Then build the wayland plugin qtwayland-git.

To run a Qt5 app with the Wayland plugin, set
QT_QPA_PLATFORM=wayland-egl.

> Clutter

The Clutter toolkit has a Wayland backend that allows it to run as a
Wayland client. The backend is enabled in the official package in extra.

To run a Clutter app on Wayland, set CLUTTER_BACKEND=wayland.

> SDL

Experimental wayland support is now in SDL 2.0.2 and enabled by default
on Arch Linux.

To run a SDL application on Wayland, set SDL_VIDEODRIVER=wayland.

> EFL

EFL has complete Wayland support. To run a EFL application on Wayland,
see Wayland project page.

Window managers and desktop shells
----------------------------------

> KDE

KDE 4.11 beta supports starting KWin under Wayland system compositor.
There is currently no support for using KWin as a session compositor.

> GNOME

Since version 3.10, Gnome has experimental Wayland support but you have
to install xwayland-git and a equivalent patched graphics driver, e.g.
xf86-video-intel-xwayland-git to get Mutter to work. For details look
into the GNOME wiki .

    gnome-session --session=gnome-wayland

> i3

Some developers from i3 have sprouted a completely new project for
implementing a shell plugin for Weston to implement the same features
and style of i3.

> Pure Wayland

Warning:Some really quick notes on installing a pure (no X11) Wayland
system on Arch Linux. This is from source and installed into /usr/local.
May break your system. You have been warned.

First install a base Arch Linux install with base and base-devel. Do not
install xorg or any of its libraries.

Wayland, DRM, Pixman, libxkbcommon

    $ pacman -S wayland libdrm pixman libxkbcommon

Mesa

    $ sudo pacman -S python2 libxml2 llvm
    $ git clone git://anongit.freedesktop.org/mesa/mesa
    $ cd mesa
    $ CFLAGS=-DMESA_EGL_NO_X11_HEADERS ./autogen.sh --prefix=/usr/local --enable-gles2 --disable-gallium-egl --with-egl-platforms=wayland,drm --enable-gbm --enable-shared-glapi --with-gallium-drivers=r300,r600,swrast,nouveau --disable-glx --disable-xlib
    $ make
    $ sudo make install

cairo

Note - no glx/gl or xcb - EGL only.

    $ pacman -S libpng
    $ git clone git://anongit.freedesktop.org/cairo
    $ cd cairo
    $ CFLAGS=-DMESA_EGL_NO_X11_HEADERS ./autogen.sh --prefix=/usr/local/  --disable-xcb  --enable-glesv2 
    $ make
    $ sudo make install

weston

    $ sudo pacman -S gegl mtdev
    (choose mesa-gl from options for libgl)
    $ git clone git://anongit.freedesktop.org/wayland/weston
    $ cd weston/
    $ CFLAGS="-DMESA_EGL_NO_X11_HEADERS" ./autogen.sh --prefix=/usr/local/ --with-cairo-glesv2 --disable-xwayland --disable-x11-compositor --disable-xwayland-test
    $ make
    $ sudo make install

Troubleshooting
---------------

> LLVM assertion failure

If you get an LLVM assertion failure, you need to rebuild mesa without
Gallium LLVM until this problem is fixed.

This may imply disabling some drivers which require LLVM. You may also
try exporting the following, if having problems with hardware drivers:

    $ export EGL_DRIVER=/usr/lib/egl/egl_gallium.so

See also
--------

-   Cursor Themes
-   Arch Linux forum discussion
-   Wayland documentation online
-   Wayland usability wiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=Wayland&oldid=304975"

Category:

-   X Server

-   This page was last modified on 16 March 2014, at 09:59.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
