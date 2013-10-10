Core Utilities
==============

> Summary

Tips and tricks related to so-called "core" utilities on a GNU/Linux
system.

> Related

Commandline Tools

General Recommendations

GNU Project

This article deals with so-called "core" utilities on a GNU/Linux
system, such as less, ls, and grep. The scope of this article includes
-- but is not limited to -- those utilities included with the GNU
coreutils package. What follows are various tips and tricks and other
helpful information related to these utilities. If sections grow too
detailed, please split into separate articles.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 grep                                                               |
| -   2 less                                                               |
| -   3 ls                                                                 |
| -   4 Additional resources                                               |
+--------------------------------------------------------------------------+

grep
----

grep is a command line text search utility originally written for Unix.
The grep command searches files or standard input globally for lines
matching a given regular expression, and prints them to the program's
standard output.

Beyond aesthetics, grep's color output is immensely useful for learning
regexp and grep's functionality.

To use the default colors for grep, write the following entry to
~/.bashrc:

    alias grep='grep --color=auto' 

Alternatively, you can set the GREP_OPTIONS environment variable [1]
bearing in mind this may break some scripts that use grep [2]:

    export GREP_OPTIONS='--color=auto'

To include file line numbers in the output, add "-n":

    alias grep='grep -n --color=auto' 

The environment variable GREP_COLORS may be used to specify different
colors than the defaults.

less
----

less is a terminal pager program used to view the contents of a text
file one screen at a time. Whilst similar to other pages such as more
and pg, less offers a more advanced interface and complete
feature-set.[3]

You can enable code syntax coloring in less. First, install
source-highlight. Then add these lines to your ~/.bashrc:

    export LESSOPEN="| /usr/bin/source-highlight-esc.sh %s"
    export LESS=' -R '

Frequent users of the command line interface might want to install
lesspipe:

    # pacman -S lesspipe

Users may now list the compressed files inside of an archive using their
pager:

    $ less compressed_file.tar.gz

    ==> use tar_file:contained_file to view a file in the archive
    -rw------- username/group  695 2008-01-04 19:24 compressed_file/content1
    -rw------- username/group   43 2007-11-07 11:17 compressed_file/content2
    compressed_file.tar.gz (END)

lesspipe also grants less the ability of interfacing with files other
than archives; serving as an alternative for the specific command
associated for that file-type (such as viewing HTML via html2text).

Re-login after installing lesspipe in order to activate it, or source
/etc/profile.d/lesspipe.sh.

ls
--

ls is a command to list files in Unix and Unix-like operating systems.

Colored output can be enabled with a simple alias. File ~/.bashrc should
already have the following entry copied from /etc/skel/.bashrc:

    alias ls='ls --color=auto'

The next step will further enhance the colored ls output; for example,
broken (orphan) symlinks will start showing in a red hue. Add the
following to ~/.bashrc and relogin, or source the file:

    eval $(dircolors -b)

Additional resources
--------------------

-   A sampling of coreutils part 2 part 3 an overview of commands in
    coreutils

Retrieved from
"https://wiki.archlinux.org/index.php?title=Core_Utilities&oldid=251730"

Categories:

-   System administration
-   Command shells
