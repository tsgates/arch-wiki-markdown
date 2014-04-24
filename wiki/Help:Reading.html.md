Help:Reading
============

Related articles

-   Help:Searching
-   Help:Style

Because the vast majority of the ArchWiki contains indications that may
need clarification for users new to GNU/Linux, this rundown of basic
procedures was written both to avoid confusion in the assimilation of
the articles and to deter repetition in the content itself.

Contents
--------

-   1 Regular user or root
-   2 Append, create, edit and source
-   3 System-wide versus user-specific configuration
    -   3.1 Common shell files
        -   3.1.1 Bash
        -   3.1.2 Zsh

Regular user or root
--------------------

Some lines are written like so:

    # pacman -S kernel26

Others have a different prefix:

    $ makepkg -s

The numeral or hash sign (#) indicates that the line is to be entered as
root, whereas the dollar sign ($) shows that the line is to be entered
as a regular user.

Note:The commands prefixed with # are intended to be executed from a
root shell, which can for example be easily accessed with sudo -i.
Running sudo command from an unprivileged shell instead of command from
a root shell will also work in most cases, with some notable exceptions
such as redirection, which strictly requires a root shell. See also
sudo.

A notable exception to watch out for:

    # This alias makes ls colorize the listing
    alias ls='ls --color=auto'

In this example, the context surrounding the numeral sign communicates
that this is not to be run as a command; it should be edited into a file
instead. So in this case, the numeral sign denotes a comment. A comment
can be explanatory text that will not be interpreted by the associated
program. Bash scripts denotation for comments happens to coincide with
the root PS1.

After further examination, "give away" signs include the uppercase
character following the # sign. Usually, Unix commands are not written
this way and most of the time they are short abbreviations instead of
full-blown English words (e.g., Copy becomes cp).

Regardless, most articles make this easy to discern by notifying the
reader:

Append to ~/path/to/file:

    # This alias makes ls colorize the listing
    alias ls='ls --color=auto

Append, create, edit and source
-------------------------------

When prompted to append, add, create or edit, consider it an indication
for using a text editor, such as nano, in order to make changes to
configuration file(s):

    # nano /etc/bash.bashrc

In programs, be it shells or otherwise, sourcing applies settings
specified in a file. For Bash, sourcing can be done in a command prompt:

    $ source /etc/bash.bashrc

and it can also happen in a file itself:

    # This line includes settings from another file
    source /etc/bash.bashrc

As a result, sourcing a file after alteration is an implied omission in
the case of shell files.

However, not all articles will specify the nature of the changes to be
made, nor which file to alter in the first place. This wiki builds-up on
previous knowledge, such as common locations for files that are prone to
sporadic editing.

System-wide versus user-specific configuration
----------------------------------------------

It is important to remember that there are two different kinds of
configurations on a GNU/Linux system. System-wide configuration affects
all users. Since system-wide settings are generally located in the /etc
directory, root privileges are required in order to alter them. E.g., to
apply a Bash setting that affects all users, /etc/bash.bashrc should be
modified.

User-specific configuration affects only a single user. Dotfiles are
used for user-specific configuration. For example, the file ~/.bashrc is
the user-specific configuration file. The idea is that each user can
define their own settings, such as aliases, functions and other
interactive features like the prompt, without affecting other users'
preferences.

Note:~/ is a shortcut for the user's home directory, usually
/home/username/.

> Common shell files

For ease of use, here is a selective listing of basic configuration
files and their locations.

Bash

See also: Bash and man bash

Within Bash and other bourne-compatible shells, such as Zsh, there is
even further differentiation in the purposes of the configuration files.
Some files only get sourced when Bash is starting as a login shell,
whereas other files only do so when Bash is an interactive shell.

When Bash is run in a virtual console, for instance, it is started as a
login shell. Bash shells started in a Xorg session, such as those
employed by xterm, are interactive shells.

Common files:

-   /etc/bash.bashrc: System-wide settings; sourced only by a login
    shell
-   ~/.bashrc: Personal shell settings; sourced only by an interactive
    shell

Zsh

See also: Zsh and man zsh

Common files:

-   /etc/zsh/zprofile: System-wide settings; sourced only by a login
    shell
-   ~/.zshrc: Personal shell settings; sourced only by an interactive
    shell

Retrieved from
"https://wiki.archlinux.org/index.php?title=Help:Reading&oldid=303950"

Category:

-   Help

-   This page was last modified on 10 March 2014, at 22:55.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
