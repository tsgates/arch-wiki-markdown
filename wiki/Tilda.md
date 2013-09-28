Tilda
=====

  Summary
  ----------------------------------------------------------------
  This article describes installation and configuration of Tilda

Tilda is a "pop-up virtual terminal" for X, just like Yakuake (KDE) or
Guake (GNOME), but a little more lightweight and a little more
maintained than sjterm.

Why Tilda
---------

You may find it very convenient to drop into a shell quickly without
wasting screen estate. Tilda allows you to do that, as it is already
open and therefore can be accessed very quickly, while staying
unobtrusively in the "background" when you do not need it.

Installation
------------

tilda is available in the [community] repository.

Using with dwm
--------------

dwm is a tiling window manager, which manages placement of windows
automatically, so it takes some configuration to make Tilda work
properly.

You have to edit dwm's config.h and recompile/reinstall dwm to properly
account for Tilda.

Get the latest PKGBUILD for dwm:

    # abs community/dwm

Copy newest sources to your working directory, I am using ~/sources:

    $ cp -r /var/abs/community/dwm ~/sources

Get into working directory to start config:

    $ cd ~/sources/dwm

Edit config.h:

    static const Rule rules[] = {
    	/* class      instance    title       tags mask     isfloating   monitor */
    	{ "Gimp",     NULL,       NULL,       0,            True,        -1 },
    	{ "Firefox",  NULL,       NULL,       1 << 8,       False,       -1 },
    //add the line below
    	{ "Tilda",  NULL,       NULL,       0,       True,       -1 },
    	{ "Volumeicon",  NULL,       NULL,       0,       True,       -1 },
    };

The above makes all windows with the WM_CLASS "Tilda" floating. The word
"Tilda" has to be uppercase, as shown by

    $ xprop |grep WM_CLASS

Save config.h, then compile and install dwm:

    $ makepkg -g >> PKGBUILD && makepkg -efi

Start dwm or restart dwm if it is already active, either by MOD+SHIFT+Q
or killing dwm and restarting it.

Launch tilda with -C option:

    $ tilda -C

Now you can configure Tilda, I recommend the following options:

    Font: Clean 9
    Appearance: Height: 50%, Width: 70%, Centered Horizontally
    Extras: Enable Transparency Level 15
    Animated Pulldown: 1500 usec, Orientation: Top
    Colors: Built-in Scheme "Green on Black"
    Scrolling: Scrollbar is on the left, 2000 lines scrollback
    Key Binding: F9

Here is what my config looks like after those settings in
~/.tilda/config_0:

    tilda_config_version = "0.9.6"
    # image = ""
    # command = ""
    font = "Clean 9"
    key = "F9"
    title = "Tilda"
    background_color = "white"
    # working_dir = ""
    web_browser = "firefox"
    lines = 2000
    max_width = 956
    max_height = 384
    min_width = 1
    min_height = 1
    transparency = 15
    x_pos = 205
    y_pos = 1
    tab_pos = 0
    backspace_key = 0
    delete_key = 1
    d_set_title = 3
    command_exit = 2
    scheme = 1
    slide_sleep_usec = 1500
    animation_orientation = 0
    scrollbar_pos = 0
    back_red = 0
    back_green = 0
    back_blue = 0
    text_red = 0
    text_green = 65535
    text_blue = 0
    scroll_background = true
    scroll_on_output = false
    notebook_border = false
    antialias = true
    scrollbar = false
    use_image = false
    grab_focus = true
    above = true
    notaskbar = true
    bold = true
    blinks = true
    scroll_on_key = true
    bell = false
    run_command = false
    pinned = true
    animation = true
    hidden = true
    centered_horizontally = true
    centered_vertically = false
    enable_transparency = true
    double_buffer = false

It is important you enable the pulldown-animation, otherwise Tilda will
keep jumping down each time you unhide it, must be a dwm issue.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Tilda&oldid=207108"

Category:

-   Terminal emulators
