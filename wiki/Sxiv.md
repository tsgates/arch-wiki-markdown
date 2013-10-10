sxiv
====

> Summary

This article discusses the installation and basic configuration of sxiv.

External Links

sxiv on github

sxiv, Simple X Image Viewer is a lightweight image viewer written in C.
It is a lightweight image viewer that is scriptable.

Installation
------------

sxiv can be found in the Community repositories.

Assigning keyboard shortcuts to sxiv
------------------------------------

sxiv is scriptable, but to do this, you have to edit config.h and
compile sxiv as follows:

As an example we will assign the following command to ^d:
mv file ~/.trash, and echo file  to put the full path and filename of
the current image into the clipboard with ^c.

So when sxiv is started in thumbnail mode on a folder, one can see all
files in that folder, select random thumbnails, and hit ^d to move them
to a custom "trash" folder.

> Tutorial

Get latest PKGBUILD from abs

    # abs community/sxiv

Note:The prompt above is a root prompt, denoted by a pound-sign (#), so
you may have to use sudo, for example.

copy source to your own workspace:

    $ cp -r /var/abs/community/sxiv ~/sources

move to source directory to start the work:

    $ cd ~/sources/sxiv

edit config.h, to add the line for the "d" and "c" shortcut:

    config.h

            /* run shell command line on current file ("$SXIV_IMG"): */
            { true,   XK_less,          it_shell_cmd,         (arg_t) \
                            "mogrify -rotate -90 \"$SXIV_IMG\"" },
            { true,   XK_greater,       it_shell_cmd,         (arg_t) \
                            "mogrify -rotate +90 \"$SXIV_IMG\"" },
            { true,   XK_comma,         it_shell_cmd,         (arg_t) \
                            "jpegtran -rotate 270 -copy all -outfile \"$SXIV_IMG\" \"$SXIV_IMG\"" },
            { true,   XK_period,        it_shell_cmd,         (arg_t) \
                            "jpegtran -rotate  90 -copy all -outfile \"$SXIV_IMG\" \"$SXIV_IMG\"" },
    //insert the lines below
            { true,   XK_d,             it_shell_cmd,         (arg_t) \
                            "mv \"$SXIV_IMG\" ~/.trash" },
            { true,   XK_c,             it_shell_cmd,         (arg_t) \
                            "echo \"$SXIV_IMG\" | xclip" },
    };

After saving config.h, create new checksums for modified files (config.h
in this case):

    $ makepkg -g >> PKGBUILD

Extract the source files; you can just run makepkg to do it for you:

    $ makepkg

Compile sxiv and install it:

    $ makepkg -efi

Create .trash folder if it doesn't exist:

    $ mkdir ~/.trash

Now when you start sxiv in thumbnail mode on a folder of pictures, i.e.:

    $ sxiv -tsr ~/pictures

Congratulations, you can now delete selected pictures by hitting CTRL+D.
This will move your selected pic to ~/.trash. Pressing CTRL+C copies the
full path and file name of the current picture to the clipboard.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sxiv&oldid=254715"

Category:

-   Graphics and desktop publishing
