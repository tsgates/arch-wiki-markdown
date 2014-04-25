Environment variables
=====================

An environment variable is a named object that contains data used by one
or more applications. In simple terms, it is a variable with a name and
a value. The value of an environmental variable can for example be the
location of all executable files in the filesystem, the default editor
that should be used, or the system locale settings. Users new to Linux
may often find this way of managing settings a bit unmanageable.
However, environment variables provides a simple way to share
configuration settings between multiple applications and processes in
Linux.

Contents
--------

-   1 Utilities
-   2 Examples
-   3 Defining variables globally
-   4 Defining variables locally
-   5 Session specific variables
-   6 See also

Utilities
---------

The coreutils package contains printenv and env. To list the current
environmental variables, use printenv to print the names and the values
of each.

Note:Some environment variables are user-specific - check by comparing
the printenv output as root.

    $ printenv

The env utility can be used to run a command under a modified
environment. In the simplest case:

    $ env EDITOR=vim xterm

will set the default editor to vim in the new xterm session. This will
not affect the EDITOR outside this session.

The Bash builtin set allows you to change the values of shell options
and set the positional parameters, or to display the names and values of
shell variables. For more information see documentation on set built-in
command.

Examples
--------

The following section lists a number of common environment variables
used by a Linux system and describes their values.

-   DE indicate the Desktop Environment being used. xdg-open will use it
    to chose more user-friendly file-opener application that desktop
    environment provides. Some packages need to be installed to use this
    feature. For GNOME, that would be libgnome. For Xfce, 'exo'.
    Recognised values of DE variable are: gnome, kde, xfce, lxde and
    mate.

The $DE environment variable needs to be exported before starting the
window manager. For example:

    ~/.xinitrc

    export DE="xfce"
    exec openbox

This will make xdg-open use the more user-friendly exo-open, because it
assumes it is inside Xfce. Use exo-preferred-applications for
configuring.

-   DESKTOP_SESSION. In LXDE desktop enviroment, when DESKTOP_SESSION is
    set to LXDE, xdg-open will use pcmanfm file associations.

-   PATH Contains a colon-separated list of directories in which your
    system looks for executable files. When a regular command (i.e. ls,
    rc-update or emerge) is interpreted by the shell (i.e. bash, zsh),
    the shell looks for an executable file with same name as your
    command in the listed directories, and executes it. To run
    executables that are not listed in PATH, the absoute path to the
    executable must be given: /bin/ls.

Note:It is advised not to include the current working directory (.) into
your PATH for security reasons, as it may trick the user to execute
vicious commands.

-   HOME Contains the path to the home directory of the current user.
    This variable can be used by applications to associate configuration
    files and such like with the user running it.

-   PWD Contains the path to your working directory.

-   OLDPWD Contains the path to your previous working directory, that
    is, the value of PWD before last cd was executed.

-   SHELL Contains the name of the running, interactive shell, i.e bash

-   TERM Contains the name of the running terminal, i.e xterm

-   PAGER Contains the path to the program used to list the contents of
    files, i.e. /bin/less.

-   EDITOR Contains the path to the lightweight program used for editing
    files, i.e. /usr/bin/nano, or an interactive switch (between gedit
    under X or nano in this example):

    export EDITOR="$(if [[ -n $DISPLAY ]]; then echo 'gedit'; else echo 'nano'; fi)"

-   VISUAL Contains the path to full-fledged editor that is used for
    more demanding tasks, such as editing mail; e.g., vi, vim, emacs,
    etc.

-   MAIL Contains the location of incoming email. The traditional
    setting is /var/spool/mail/$LOGNAME.

-   BROWSER Contains the path to the web browser. Helpful to set in an
    interactive shell configuration file so that it may be dynamically
    altered depending on the availability of a graphic environment, such
    as X:

    if [ -n "$DISPLAY" ]; then
    	export BROWSER=firefox
    else
    	export BROWSER=links
    fi

-   ftp_proxy and http_proxy Contains FTP and HTTP proxy server,
    respectively:

    ftp_proxy="ftp://192.168.0.1:21"
    http_proxy="http://192.168.0.1:80"

-   MANPATH Contains a colon-separated list of directories in which man
    searches for the man pages.

Note:In /etc/profile, there is a comment that states "Man is much better
than us at figuring this out", so this variable should generally be left
as default, i.e. /usr/share/man:/usr/local/share/man

-   INFODIR Contains a colon-separated list of directories in which the
    info command searches for the info pages, i.e.
    /usr/share/info:/usr/local/share/info

Defining variables globally
---------------------------

Most Linux distributions tell you to change or add environment variable
definitions in /etc/profile or other locations. Be sure to maintain and
manage the environment variables and pay attention to the numerous files
that can contain environment variables. In principle, any shell script
can be used for initializing environmental variables, but following
traditional UNIX conventions, these statements should be only be present
in some particular files. The following files should be used for
defining global environment variables on your system: /etc/profile,
/etc/bash.bashrc and /etc/environment.

An example that sets all users ~/bin in their respective path, put this
in your preferred global environment variable config file:

    # If user ID is greater than or equal to 1000 & if ~/bin exists and is a directory & if ~/bin is not already in your $PATH
    # then export ~/bin to your $PATH.
    if [[ $UID -ge 1000 && -d $HOME/bin && -z $(echo $PATH | grep -o $HOME/bin) ]]
    then
        export PATH=$HOME/bin:${PATH}
    fi

Defining variables locally
--------------------------

You do not always want to define an environment variable globally. For
instance, you might want to add /home/my_user/bin to the PATH variable
but do not want all other users on your system to have that in their
PATH too. The following files should be used for local environment
variables on your system: ~/.bashrc, ~/.profile, ~/.bash_login and
~/.bash_logout.

To add a directory to PATH for local usage, put following in ~/.bashrc:

    PATH="${PATH}:/home/my_user/bin"

To update the variable, re-login or source the file: $ source ~/.bashrc.

Session specific variables
--------------------------

Sometimes even stricter definitions are required. One might want to
temporarily run executables from a specific directory created without
having to type the absolute path to each one, or editing ~/.bashrc for
the short time needed to run them.

In this case, you can define the PATH variable in your current session,
combined with the export command. As long as you do not log out, the
PATH variable will be using the temporary settings. To add a
session-specific directory to PATH, issue:

    $ export PATH="${PATH}:/home/my_user/tmp/usr/bin"

See also
--------

-   Gentoo Linux Documentation [1]
-   Default applications
-   Xdg-open

Retrieved from
"https://wiki.archlinux.org/index.php?title=Environment_variables&oldid=304541"

Category:

-   System administration

-   This page was last modified on 14 March 2014, at 22:45.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
