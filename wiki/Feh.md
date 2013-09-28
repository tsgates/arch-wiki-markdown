Feh
===

feh is a lightweight and powerful image viewer that can also be used to
manage the desktop wallpaper for standalone window managers lacking such
features.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Usage                                                              |
|     -   2.1 As an image viewer                                           |
|         -   2.1.1 File Browser Image Launcher                            |
|                                                                          |
|     -   2.2 As a desktop wallpaper manager                               |
|                                                                          |
| -   3 Tips and tricks                                                    |
|     -   3.1 Random background image                                      |
|         -   3.1.1 Using a script                                         |
|             -   3.1.1.1 For dual screen no-xinerama                      |
|                                                                          |
|         -   3.1.2 Using a cron job                                       |
|         -   3.1.3 Using systemd user session                             |
|                                                                          |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Install feh, which is available in the official repositories.

Usage
-----

feh is highly configurable. For a full list of options, run feh --help.

> As an image viewer

To quickly browse images in a specific directory, you can launch feh
with the following arguments:

    $ feh -g 640x480 -d -S filename /path/to/directory

-   The -g flag forces the images to appear no larger than 640x480
-   The -d flag draws the file name
-   The -S filename flag sorts the images by file name

This is just one example; there are many more options available should
you desire more flexibility.

File Browser Image Launcher

The following script is useful for file browsers. It will display your
selected image in feh, but it will enable you to browse all other images
in the directory as well, in their default order, i.e. as if you had run
"feh *" and cycled through to the selected image.

The script assumes the first argument is the filename.

    feh_browser.sh

    #!/bin/bash

    shopt -s nullglob

    if [[ ! -f $1 ]]; then
    	echo "$0: first argument is not a file" >&2
    	exit 1
    fi

    file=$(basename -- "$1")
    dir=$(dirname -- "$1")
    arr=()
    shift

    cd -- "$dir"

    for i in *; do
    	[[ -f $i ]] || continue
    	arr+=("$i")
    	[[ $i == $file ]] && c=$((${#arr[@]} - 1))
    done

    exec feh "$@" -- "${arr[@]:c}" "${arr[@]:0:c}"

Invoke the script with the selected image's path, followed by any
additional arguments to feh. Here is an example of a launcher that you
can use in a file browser:

    $ /path/to/script/feh_browser.sh %f -F -Z

-F and -Z are feh arguments. -F opens the image in fullscreen mode, and
-Z automatically zooms the image. Adding the -q flag (quiet) suppresses
error messages to the terminal when feh tries loading non-image files
from the current folder.

A simple but less versatile alternative is

    feh_browser.sh

    #! /bin/sh
    feh -. "$(dirname "$1")" --start-at "$1"

This one does not seem to accept options.

> As a desktop wallpaper manager

feh can be used to manage the desktop wallpaper for window managers that
lack desktop features, such as Openbox, Fluxbox, and xmonad.

When using GNOME, you must disable Nautilus from controlling the
desktop. The easiest way is to run this command:

    $ gconftool-2 --set /apps/nautilus/preferences/show_desktop --type boolean false

The following command is an example of how to set the initial
background:

    $ feh --bg-scale /path/to/image.file

Other scaling options include:

    --bg-tile FILE
    --bg-center FILE
    --bg-max FILE
    --bg-fill FILE

To restore the background on the next session, add the following to your
startup file (e.g. ~/.xinitrc, ~/.config/openbox/autostart, etc.):

    $ sh ~/.fehbg &

To change the background image, edit the file ~/.fehbg which gets
created after running the command feh --bg-scale /path/to/image.file
mentioned above.

Tips and tricks
---------------

> Random background image

Using a script

To rotate the wallpaper randomly, create a script with the code below
(e.g. wallpaper.sh). Make the script executable:

    $ chmod +x wallpaper.sh

and call it from ~/.xinitrc. You can also put the source directly in
~/.xinitrc instead of in a separate file.

Change the ~/.wallpaper directory to fit your setup and the 15m delay as
you please (see man sleep for options).

    wallpaper.sh

    #!/bin/sh

    while true; do
    	find ~/.wallpaper -type f \( -name '*.jpg' -o -name '*.png' \) -print0 |
    		shuf -n1 -z | xargs -0 feh --bg-max
    	sleep 15m
    done

You may have to change find ~/.wallpaper to find ~/.wallpaper/ to make
the above work.

This version does not fork as much, but this version does not recurse
through directories:

    wallpaper.sh

    #!/bin/bash

    shopt -s nullglob
    cd ~/.wallpaper

    while true; do
    	files=()
    	for i in *.jpg *.png; do
    		[[ -f $i ]] && files+=("$i")
    	done
    	range=${#files[@]}

    	((range)) && feh --bg-scale "${files[RANDOM % range]}"

    	sleep 15m
    done

For dual screen no-xinerama

This script replace the call to feh for add a wallpaper on systems with
dual screen nvidia twinview (for example).

    wallpaper.sh

    #!/bin/sh
    exec feh --bg-max --no-xinerama "$@"

Using a cron job

Using a cron job, you can get a similar result, and it does not require
having a script constantly sleeping.

Just do $ crontab -e and add:

    * * * * *  DISPLAY=:0.0 feh --bg-max "$(find ~/.wallpaper/|shuf -n1)"

Using systemd user session

Note:This is useful only if you are using systemd user session. Read
Systemd/User for more details.

Create the unit service file:

    $HOME/.config/systemd/user/feh-wallpaper.service

    [Unit]
    Description=Random wallpaper with feh

    [Service]
    Type=oneshot
    EnvironmentFile=%h/.wallpaper
    ExecStart=/bin/bash -c '/usr/bin/feh --bg-max "$(find ${WALLPATH}|shuf|head -n 1)"'

    [Install]
    WantedBy=default.target

Now create the timer file. Change the time as necessary. In this example
is 15 seconds.

    $HOME/.config/systemd/user/feh-wallpaper.timer

    [Unit]
    Description=Random wallpaper with feh

    [Timer]
    OnUnitActiveSec=15s
    Unit=feh-wallpaper.service

    [Install]
    WantedBy=default.target

In this example the configuration is one hidden file on the home
directory with the path of the directory where the images are stored

    $HOME/.wallpaper

    WALLPATH=/home/user/.wallpaper/

Activate the feh-wallpaper.timer and feh-wallpaper.service daemons. Read
Daemons for more details.

Note:Remember that under systemd user session, you should use the --user
flag on systemctl.

See also
--------

-   Forum post with original script for feh_browser

Retrieved from
"https://wiki.archlinux.org/index.php?title=Feh&oldid=244830"

Category:

-   Graphics and desktop publishing
