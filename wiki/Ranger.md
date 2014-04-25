ranger
======

Related articles

-   vifm

ranger is a text-based file manager written in Python with vi-style key
bindings. It has an extensive set of features, and you can accomplish
file management tasks with a few keystrokes with no need for the mouse.

Contents
--------

-   1 Installing
-   2 Running
-   3 Comparison with other file managers
-   4 Documentation
-   5 Customization
    -   5.1 Binding keys
    -   5.2 Defining commands
    -   5.3 Change Colorscheme
    -   5.4 Opening files with a given application
    -   5.5 Syncing path with shell
        -   5.5.1 Starting ranger from a shell or an X session
        -   5.5.2 Starting a shell from ranger
    -   5.6 New tab in current folder
-   6 Useful commands
    -   6.1 External Drives
    -   6.2 Network drives
    -   6.3 Archive related
        -   6.3.1 Extraction
        -   6.3.2 Compression
    -   6.4 Image mounting
-   7 See also

Installing
----------

ranger can be installed from the official repositories. There is also
ranger-git in AUR.

Optional, for file previews with "scope.sh":

-   libcaca (img2txt) for previewing images as ASCII-art
-   highlight for syntax highlighting of code
-   atool for previews of archives
-   lynx, w3m or elinks for previews of html pages
-   poppler (pdftotext) for pdf previews
-   transmission-cli for viewing bit-torrent information
-   mediainfo or perl-image-exiftool for viewing information about media
    files

Running
-------

To start ranger, launch a terminal such as xterm, and type the command
ranger. Or, you can use the command

    xterm -e ranger

Comparison with other file managers
-----------------------------------

Compared to graphical mouse-based file managers, ranger is much more
efficient, but still visually appealing. ranger has one pane with
multiple columns for different directories in the path, and file
previews on the right. Compared to double-pane file managers, ranger
shows more directory and file information. You can quickly move between
directories using keystrokes, bookmarks or the command history. Previews
of files and directory contents automatically show up for the current
selection. ranger's features include: vi-style key bindings, bookmarks,
selections, tagging, tabs, command history, the ability to make symbolic
links, several console modes, and a task view. ranger has customizable
commands and key bindings, including bindings to external scripts. The
closest competitor is Vifm, which has two panes and vi-style key
bindings, but has fewer features overall.

Documentation
-------------

ranger's man page can be opened by typing ?. You can also press 1? for a
list of key bindings, 2? for a list of commands and 3? for a list of
settings.

Customization
-------------

After startup, ranger creates a directory ~/.config/ranger/. You can
copy the default configuration files to this directory with the
following command:

    ranger --copy-config=all

They can then be customized. Some basic knowledge of python is useful.

-   rc.conf controls startup commands and key bindings
-   commands.py controls the commands which are launched with the ":"
    key
-   rifle.conf controls the applications used when a given type of file
    is launched.

You can launch files with "l" (ell) or "<Enter>". For rc.conf, you need
only include changes from the default file, since both are loaded. For
commands.py, if you do not include the whole file, put this line at the
top:

    from ranger.api.commands import *

> Binding keys

Use the file ~/.config/ranger/rc.conf to modify key bindings. There are
many keybindings already defined, and you can learn the syntax by
reading the file.

The following example shows how to use "DD" to move selected files to a
directory ~/.Trash/. Put this code in ~/.config/ranger/rc.conf

    # move to trash
    map DD shell mv -t /home/myname/.config/ranger/Trash %s

> Defining commands

Continuing the above example, adding the following entry to
~/.config/ranger/commands.py would define a command to empty the trash
directory ~/.Trash.

    class empty(Command):
        """:empty

        Empties the trash directory ~/.Trash
        """

        def execute(self):
            self.fm.run("rm -rf /home/myname/.Trash/{*,.[^.]*}")

To use it, you would type ":empty<Enter>", using tab completion if
desired.

Warning:Note that [^.] is an essential part of the above command.
Otherwise, it will remove all files and directories of the form ..*,
thereby wiping out everything in your home directory.

> Change Colorscheme

You can add your own color schemes by creating the colorschemes
subfolder in .config/ranger/colorschemes

    mkdir .config/ranger/colorschemes

then copy your new newscheme.py into that folder. Then you alter the
default coloscheme in .config/ranger/rc.conf file:

    set colorscheme newscheme

> Opening files with a given application

Modify ~/.config/ranger/rifle.conf. Since the beginning lines are
executed first, you should put your modifications at the beginning of
the file. For example, the following entry will open a tex file with
kile.

    ext tex = kile "$@"

> Syncing path with shell

Starting ranger from a shell or an X session

ranger provides a shell function
/usr/share/doc/ranger/examples/bash_automatic_cd.sh you can source or
copy into your shell configuration file. Now running rangercd instead of
ranger will sync the paths, i.e. when quitting ranger the shell will
automatically cd to the last browsed folder.

If you launch ranger from a graphical launcher (e.g. using
$TERMCMD -e ranger, TERMCMD being an X terminal), you cannot use
rangercd here because it is a shell function. The trick is to create an
executable script:

    ranger-launcher.sh

    #!/bin/sh
    export RANGERCD=true
    $TERMCMD

and add this at the very end of your shell configuration:

    shellrc

    $RANGERCD && unset RANGERCD && rangercd

Note that it is important to unset the variable, otherwise launching a
subshell from this terminal will automatically re-launch ranger.

Starting a shell from ranger

With the previous method you can switch to a shell in last browsed path
simply by leaving ranger. However you may not want to quit ranger for
several reasons (numerous opened tabs, copy in progress, etc.). You can
start a shell from ranger (S by default) without losing your ranger
session. Unfortunately, the shell will not switch to the current folder
automatically. Again, this can be solved with an executable script:

    shellcd

    #!/bin/sh
    export AUTOCD="$(realpath "$1")"

    $SHELL

and - as before - add this to at the very end of your shell
configuration:

    shellrc

    cd "$AUTOCD"

Now you can change your shell binding for ranger:

    rc.conf

    map S shell shellcd %d

Alternatively, you can make use of your shell history file if it has
any. For instance, you could do this for zsh:

    shellcd

    ## Prepend argument to zsh dirstack.
    BUF="$(realpath "$1")
    $(grep -v "$(realpath "$1")" "$ZDIRS")"
    echo "$BUF" > "$ZDIRS"

    zsh

Change ZDIRS for you dirstack.

> New tab in current folder

You may have noticed there are two shortcuts for opening a new tab in
home (gn and Ctrl+n). Let us rebind Ctrl+n:

    rc.conf

    map <c-n>  eval fm.tab_new('%d')

Useful commands
---------------

> External Drives

External drives can be automatically mounted with a udev rule or with
the help of an automounting Udev wrapper. Drives mounted under /media
can be easily accessed by pressing gm (go, media).

> Network drives

> Archive related

These commands use atool to perform archive operations.

Extraction

The following command implements archive extraction by copying (yy) one
or more archive files and then executing :extracthere on the desired
directory.

    import os
    from ranger.core.loader import CommandLoader

    class extracthere(Command):
        def execute(self):
            """ Extract copied files to current directory """
            copied_files = tuple(self.fm.env.copy)

            if not copied_files:
                return

            def refresh(_):
                cwd = self.fm.env.get_directory(original_path)
                cwd.load_content()

            one_file = copied_files[0]
            cwd = self.fm.env.cwd
            original_path = cwd.path
            au_flags = ['-X', cwd.path]
            au_flags += self.line.split()[1:]
            au_flags += ['-e']

            self.fm.env.copy.clear()
            self.fm.env.cut = False
            if len(copied_files) == 1:
                descr = "extracting: " + os.path.basename(one_file.path)
            else:
                descr = "extracting files from: " + os.path.basename(one_file.dirname)
            obj = CommandLoader(args=['aunpack'] + au_flags \
                    + [f.path for f in copied_files], descr=descr)

            obj.signal_bind('after', refresh)
            self.fm.loader.add(obj)

Compression

The following command allows the user to compress several files on the
current directory by marking them and then calling
:compress package name. It supports name suggestions by getting the
basename of the current directory and appending several possibilities
for the extension. You need to have atool installed. Otherwise you will
see an error message when you create the archive.

    import os
    from ranger.core.loader import CommandLoader

    class compress(Command):
        def execute(self):
            """ Compress marked files to current directory """
            cwd = self.fm.env.cwd
            marked_files = cwd.get_selection()

            if not marked_files:
                return

            def refresh(_):
                cwd = self.fm.env.get_directory(original_path)
                cwd.load_content()

            original_path = cwd.path
            parts = self.line.split()
            au_flags = parts[1:]

            descr = "compressing files in: " + os.path.basename(parts[1])
            obj = CommandLoader(args=['apack'] + au_flags + \
                    [os.path.relpath(f.path, cwd.path) for f in marked_files], descr=descr)

            obj.signal_bind('after', refresh)
            self.fm.loader.add(obj)

        def tab(self):
            """ Complete with current folder name """

            extension = ['.zip', '.tar.gz', '.rar', '.7z']
            return ['compress ' + os.path.basename(self.fm.env.cwd.path) + ext for ext in extension]

> Image mounting

The following command assumes you are using cdemu as your image mounter
and some kind of system like autofs which mounts the virtual drive to a
specified location ('/media/virtualrom' in this case). Do not forget to
change mountpath to reflect your system settings.

To mount an image (or images) to a cdemud virtual drive from ranger you
select the image files and then type ':mount' on the console. The
mounting may actually take some time depending on your setup (in mine it
may take as long as one minute) so the command uses a custom loader that
waits until the mount directory is mounted and then opens it on the
background in tab 9.

    import os, time
    from ranger.core.loader import Loadable
    from ranger.ext.signals import SignalDispatcher
    from ranger.ext.shell_escape import *

    class MountLoader(Loadable, SignalDispatcher):
        """
        Wait until a directory is mounted
        """
        def __init__(self, path):
            SignalDispatcher.__init__(self)
            descr = "Waiting for dir '" + path + "' to be mounted"
            Loadable.__init__(self, self.generate(), descr)
            self.path = path

        def generate(self):
            available = False
            while not available:
                try:
                    if os.path.ismount(self.path):
                        available = True
                except:
                    pass
                yield
                time.sleep(0.03)
            self.signal_emit('after')

    class mount(Command):
        def execute(self):
            selected_files = self.fm.env.cwd.get_selection()

            if not selected_files:
                return

            space = ' '
            self.fm.execute_command("cdemu -b system unload 0")
            self.fm.execute_command("cdemu -b system load 0 " + \
                    space.join([shell_escape(f.path) for f in selected_files]))
     
            mountpath = "/media/virtualrom/"

            def mount_finished(path):
                currenttab = self.fm.current_tab
                self.fm.tab_open(9, mountpath)
                self.fm.tab_open(currenttab)

            obj = MountLoader(mountpath)
            obj.signal_bind('after', mount_finished)
            self.fm.loader.add(obj)

See also
--------

-   ranger web page.
-   ranger mailing list
-   Arch Linux Forum thread.
-   GitHub-page
-   DotShare.it configurations.
-   Ranger Tutorial
-   Some colorschemes

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ranger&oldid=294643"

Category:

-   File managers

-   This page was last modified on 27 January 2014, at 14:16.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
