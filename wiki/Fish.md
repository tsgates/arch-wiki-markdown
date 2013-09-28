Fish
====

fish is a user friendly commandline shell intended mostly for
interactive use.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation instructions                                          |
| -   2 Pacman and fish                                                    |
| -   3 Troubleshooting                                                    |
| -   4 Configuration Suggestions                                          |
| -   5 Current state of fish development                                  |
| -   6 Licenses                                                           |
| -   7 External Links                                                     |
+--------------------------------------------------------------------------+

Installation instructions
-------------------------

To install the package for fish using pacman (the package is in the
community repository) run:

    # pacman -S fish

To verify that it has been installed you can run:

    $ less /etc/shells

If you wanted to make fish your default shell run:

    $ chsh -s /usr/bin/fish

Pacman and fish
---------------

Context-aware completions for pacman and makepkg are built into fish,
since the policy of the fish development is to include all the existent
completions in the upstream tarball. The memory management is clever
enough to avoid any negative impact on resources.

Troubleshooting
---------------

In arch, there are a lot of shell scripts written for bash, and these
have not been translated to fish. It is advisable not to set fish as
your default shell because of this. The best option is to open your
terminal emulator (gnome-terminal, konsole, sakura, etc...) with a
command line option that executes fish. For most terminals this is the
-e switch, so for example, to open gnome-terminal using fish, change
your shortcut to use:

    gnome-terminal -e fish

With LilyTerm and other light terminal emulators that don't support
setting the shell it would look like this:

    SHELL=/usr/bin/fish lilyterm

Another option is to set fish as the default shell for the terminal in
the terminal's configuration or for a terminal profile if your terminal
emulator has a profiles feature. This is contrast to changing the
default shell for the user which would cause the above mentioned
problem.

To set fish as the shell started in tmux, put this into your .tmux.conf:

    set-option -g default-shell "/usr/bin/fish"

Not setting fish as system wide default allows the arch scripts to run
on startup, ensure the environment variables are set correctly, and
generally reduces the issues associated with using a non-bash compatible
terminal like fish.

If you decide to set fish as your default shell, you may find that you
no longer have very much in your path. You can add a section to your
~/.config/fish/config.fish file that will set your path correctly on
login. This is much like .profile or .bash_profile as it is only
executed for login shells.

    if status --is-login
        set PATH $PATH /usr/bin /sbin
    end

Note that you will need to manually add various other environment
variables, such as $MOZ_PLUGIN_PATH. It is a huge amount of work to get
a seamless experience with fish as your default shell.

Configuration Suggestions
-------------------------

If you would like fish to display the branch and dirty status when you
are in a git directory, you can add the following to your
~/.config/fish/config.fish:

    set fish_git_dirty_color red
    function parse_git_dirty 
             git diff --quiet HEAD ^&-
             if test $status = 1
                echo (set_color $fish_git_dirty_color)"Δ"(set_color normal)
             end
    end
    function parse_git_branch
             # git branch outputs lines, the current branch is prefixed with a *
             set -l branch (git branch --color ^&- | awk '/*/ {print $2}') 
             echo $branch (parse_git_dirty)     
    end

    function fish_prompt
             if test -z (git branch --quiet 2>| awk '/fatal:/ {print "no git"}')
                printf '%s@%s %s%s%s (%s) $ ' (whoami) (hostname|cut -d . -f 1) (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) (parse_git_branch)            
             else
                printf '%s@%s %s%s%s $ '  (whoami) (hostname|cut -d . -f 1) (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
             end 
    end

If su starts with bash (because bash is the default shell), define a
function in fish:

    ~> funced su
    su> function su
           /bin/su --shell=/usr/bin/fish $argv
        end
    ~> funcsave su

Some useful tab completion scripts that are not included into the
official fish package:

-   https://github.com/esodax/fishystuff
-   http://gitorious.org/fish-nuggets

Current state of fish development
---------------------------------

The original developer, Axel Liljencrantz has abandoned the project. The
rest of his team slowly took over and transferred the codebase to
gitorius.

So far several bug fixes are available from the git repository. Also,
there is an AUR package for the git master branch, which is considered
stable for everyday use: fish-git.

On May 30, 2012 ridiculous_fish has announced a new fork of fish which
has been adopted as mainstream later, and development is now relocated
to github. The AUR package fish-shell-git follows the head branch of
that, while the fish package in the [community] repository provides
latest stable milestones as announced on the webpage.

Upstream git head already contains full completions for
archlinux-specific commands like pacman, pacman-key, makepkg, cower,
pbget, pacmatic.

Licenses
--------

Fish Copyright (C) 2005-2006 Axel Liljencrantz.

Fish is released under the GNU General Public License, version 2.

Fish contains code under the BSD license, namely versions of the two
functions strlcat and strlcpy, modified for use with wide character
strings. This code is copyrighted by Todd C. Miller.

The XSel command, written and copyrighted by Conrad Parker, is
distributed together with, and used by fish. It is released under the
MIT license.

The xdgmime library, written and copyrighted by Red Hat, Inc, is used by
the mimedb command, which is a part of fish. It is released under the
LGPL.

Fish contains code from the glibc library, namely the wcstok function.
This code is licensed under the LGPL.

External Links
--------------

-   Home Page
-   Documentation

Retrieved from
"https://wiki.archlinux.org/index.php?title=Fish&oldid=235370"

Category:

-   Command shells
