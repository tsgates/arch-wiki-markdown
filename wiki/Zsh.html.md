Zsh
===

Zsh is a powerful shell that operates as both an interactive shell and
as a scripting language interpreter. While being compatible with Bash
(not by default, only if issuing "emulate sh"), it offers many
advantages such as:

-   Speed
-   Improved tab completion
-   Improved globbing
-   Improved array handling
-   Fully customisable

The Zsh FAQ offers more reasons to use Zsh.

Contents
--------

-   1 Installation
    -   1.1 Initial configuration
    -   1.2 Making Zsh your default shell
-   2 Configuration files
-   3 ~/.zshrc configuration
    -   3.1 Simple .zshrc
    -   3.2 Configuring $PATH
    -   3.3 Command completion
    -   3.4 The "command not found" hook
    -   3.5 Prevent from putting duplicate lines in the history
    -   3.6 Key bindings
        -   3.6.1 Alternative method without using terminfo
        -   3.6.2 Bind key to ncurses application
    -   3.7 History search
    -   3.8 Prompts
    -   3.9 Customizing the prompt
        -   3.9.1 Prompt variables
        -   3.9.2 Example
    -   3.10 Dirstack
    -   3.11 Sample .zshrc files
-   4 Global configuration
    -   4.1 Autostarting applications
-   5 Uninstallation
-   6 See also

Installation
------------

Before starting users may want to see what shell is currently being
used:

    $ echo $SHELL

Install the zsh package available in the official repositories.

> Initial configuration

Make sure that Zsh has been installed correctly by running the following
in a terminal:

    $ zsh

You should now see zsh-newuser-install, which will walk you through some
basic configuration. If you want to skip this, press q. If you did not
see it, you can invoke it manually with

    $ zsh /usr/share/zsh/functions/Newuser/zsh-newuser-install -f

> Making Zsh your default shell

If the shell is listed in /etc/shells you can use the chsh command to
change your default shell without root access. If you installed Zsh from
the official repositories, it should already have an entry in
/etc/shells.

Change the default shell for the current user:

    $ chsh -s $(which zsh)

Note:Log out and log back in, in order to start using Zsh as the default
shell.

After logging back in, notice Zsh's prompt, which by default looks
different from Bash's. Also verify that Zsh is the current shell by
issuing:

    $ echo $SHELL

Tip:If replacing bash, users may want to move some code from ~/.bashrc
to ~/.zshrc (e.g. the prompt and the aliases) and from ~/.bash_profile
to ~/.zprofile (e.g. the code that starts the X Window System).

Configuration files
-------------------

At login, Zsh sources the following files in this order:

~/.zshenv
    This file should contain commands to set the command search path,
    plus other important environment variables; it should not contain
    commands that produce output or assume the shell is attached to a
    tty.
/etc/profile
    This file is sourced by all Bourne-compatible shells upon login: it
    sets up an environment upon login and application-specific
    (/etc/profile.d/*.sh) settings.
~/.zprofile
    This file is generally used for automatic execution of user's
    scripts.
~/.zshrc
    This is Zsh's main configuration file.
~/.zlogin
    This file is generally used for automatic execution of user's
    scripts.

At logout it sources ~/.zlogout, which is used for automatic execution
of user's scripts.

> Note:

-   The paths used in Arch's zsh package are different from the default
    ones used in the man pages.
-   $ZDOTDIR defaults to $HOME
-   /etc/profile is not a part of the regular list of startup files run
    for Zsh, but is sourced from /etc/zsh/zprofile in the zsh package.
    Users should take note that /etc/profile sets the $PATH variable
    which will overwrite any $PATH variable set in ~/.zshenv. To prevent
    this, either replace the /etc/zsh/zprofile file with a custom one,
    or set the $PATH variable from ~/.zshrc.

~/.zshrc configuration
----------------------

Although Zsh is usable out of the box, it is almost certainly not set up
the way most users would like to use it, but due to the sheer amount of
customization available in Zsh, configuring Zsh can be a daunting and
time-consuming experience.

> Simple .zshrc

Included below is a sample configuration file, it provides a decent set
of default options as well as giving examples of many ways that Zsh can
be customized. In order to use this configuration save it as a file
named .zshrc. Apply the changes without needing to logout and then back
in by running:

    $ source ~/.zshrc

Here is a simple .zshrc:

    ~/.zshrc

    autoload -U compinit promptinit
    compinit
    promptinit

    # This will set the default prompt to the walters theme
    prompt walters

> Configuring $PATH

Information about setting up the system path per user in zsh can be
found here: http://zsh.sourceforge.net/Guide/zshguide02.html#l24

In short, put the following in ~/.zshenv:

    ~/.zshenv

    typeset -U path
    path=(~/bin /other/things/in/path $path)

> Command completion

Perhaps the most compelling feature of Zsh is its advanced
autocompletion abilities. At the very least, enable autocompletion in
.zshrc. To enable autocompletion, add the following to:

    ~/.zshrc

    autoload -U compinit
    compinit

The above configuration includes ssh/scp/sftp hostnames completion but
in order for this feature to work, users need to prevent ssh from
hashing hosts names in ~/.ssh/known_hosts.

Warning:This makes the computer vulnerable to "Island-hopping" attacks.
In that intention, comment the following line or set the value to no:

    /etc/ssh/ssh_config

    #HashKnownHosts yes

And move ~/.ssh/known_hosts somewhere else so that ssh creates a new one
with un-hashed hostnames (previously known hosts will thus be lost). For
more information, see the SSH readme for hashed-hosts.

For autocompletion with an arrow-key driven interface, add the following
to:

    ~/.zshrc

    zstyle ':completion:*' menu select

To activate the menu, press tab twice.

For autocompletion of command line switches for aliases, add the
following to:

    ~/.zshrc

    setopt completealiases

> The "command not found" hook

See Pkgfile/"Command not found" hook.

> Prevent from putting duplicate lines in the history

It is very convinient to ignore duplicate lines in the history. To do
so, put the following:

    ~/.zshrc

    setopt HIST_IGNORE_DUPS

> Key bindings

Zsh does not use readline, instead it uses its own and more powerful
zle. It does not read /etc/inputrc or ~/.inputrc. Zle has an emacs mode
and a vi mode. By default, it tries to guess whether emacs or vi keys
from the $EDITOR environment variable are desired. If it is empty, it
will default to emacs. Change this with bindkey -v or bindkey -e.

To get some special keys working:

    ~/.zshrc

    # create a zkbd compatible hash;
    # to add other keys to this hash, see: man 5 terminfo
    typeset -A key

    key[Home]=${terminfo[khome]}

    key[End]=${terminfo[kend]}
    key[Insert]=${terminfo[kich1]}
    key[Delete]=${terminfo[kdch1]}
    key[Up]=${terminfo[kcuu1]}
    key[Down]=${terminfo[kcud1]}
    key[Left]=${terminfo[kcub1]}
    key[Right]=${terminfo[kcuf1]}
    key[PageUp]=${terminfo[kpp]}
    key[PageDown]=${terminfo[knp]}

    # setup key accordingly
    [[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
    [[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
    [[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
    [[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
    [[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
    [[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
    [[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
    [[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
    [[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
    [[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

    # Finally, make sure the terminal is in application mode, when zle is
    # active. Only then are the values from $terminfo valid.
    if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
        function zle-line-init () {
            printf '%s' "${terminfo[smkx]}"
        }
        function zle-line-finish () {
            printf '%s' "${terminfo[rmkx]}"
        }
        zle -N zle-line-init
        zle -N zle-line-finish
    fi

Note:To get the proper sequences for certain key combinations, start cat
or read without any parameters and press them; they should then be
printed in the terminal. Both can be closed again via Ctrl+c.

Alternative method without using terminfo

Run autoload zkbd followed by just zkbd. If users cannot press the key
it asks for (e.g.  F11 maximizes the window), press space to skip it.
After finishing with zkbd, add the following to ~/.zshrc:

    ~/.zshrc

    autoload zkbd
    source ~/.zkbd/$TERM-:0.0 # may be different - check where zkbd saved the configuration:

    [[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char
    [[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" overwrite-mode
    [[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
    [[ -n ${key[PageUp]} ]] && bindkey "${key[PageUp]}" up-line-or-history
    [[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
    [[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
    [[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" down-line-or-history
    [[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-search
    [[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
    [[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-search
    [[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char

Bind key to ncurses application

Bind a ncurses application to a keystoke, but it will not accept
interaction. Use BUFFER variable to make it work. The following example
lets users open ncmpcpp using Alt+\:

    ~/.zshrc

    ncmpcppShow() { BUFFER="ncmpcpp"; zle accept-line; }
    zle -N ncmpcppShow
    bindkey '^[\' ncmpcppShow

> History search

Add these lines to .zshrc

    ~/.zshrc

    [[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"    history-beginning-search-backward
    [[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}"  history-beginning-search-forward

Doing this, only past commands beginning with the current input would
have been shown.

> Prompts

There is a quick and easy way to set up a colored prompt in Zsh. Make
sure that prompt is set to autoload in .zshrc. This can be done by
adding these lines to:

    ~/.zshrc

    autoload -U promptinit
    promptinit

Available prompts are listed by running the command:

    $ prompt -l

To try one of the commands that is listed, use the command prompt
followed by the name of the prompt to explore. For example, to use the
walters prompt, enter:

    $ prompt walters

To preview all available themes, use this command:

    $ prompt -p

> Customizing the prompt

For users who are dissatisfied with the prompts mentioned above(or want
to expand their usefulness), Zsh offers the possibility to build a
custom custom prompt. Zsh supports a left- and right-sided prompt
additional to the single, left-sided prompt that is common to all
shells. Customize it by using PROMPT= with the following variables:

Prompt variables

Command

Description

Comment

General

%n

The username

%m

The computer's hostname(truncated to the first period)

%M

The computer's hostname

%l

The current tty

%?

The return code of the last-run application.

%#

The prompt based on user privileges (# for root and % for the rest)

Times

%T

System time(HH:MM)

%*

System time(HH:MM:SS)

%D

System date(YY-MM-DD)

Directories

%d

The current working directory.

Prefix an integer to show only certain parts of the working path. If
users entered %1d and were in /usr/bin it would show bin. This can also
be done with negative integers: %-1d using the same directory as above
would show /.

%~

The current working directory. If in $HOME or its subdirectory, $HOME
part will be replaced by ~.

Formatting

%U [...] %u

Begin and end underlined print

%B [...] %b

Begin and end bold print

%{ [...] %}

Begin and enter area that will not be printed. Useful for setting
colors. In fact, this tag forces Zsh to ignore anything inside them when
making indents for the prompt as well. As such, not to use it can have
some weird effects on the margins and indentation of the prompt.

Colors

$fg[color]

will set the text color (red, green, blue, etc. - defaults to bold)

Zsh sets colors differently than Bash. Add autoload -U colors && colors
before PROMPT= in .zshrc to use them. Usually you will want to put these
inside %{ [...] %}  so the cursor does not move.

$fg_no_bold[color]

will set the non-bold text color

$fg_bold[color]

will set the bold text color

$reset_color

will reset the text color to the default color

Possible color values

black

red

green

yellow

blue

magenta

cyan

white

Note: Bold text does not necessarily use the same colors as normal text.
For example, $fg['yellow'] looks brown or a very dark yellow, while
$fg_no_bold['yellow'] looks like bright or regular yellow.

Example

To have a two-sided promptcould write:

    PROMPT="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg_no_bold[yellow]%}%1~ %{$reset_color%}%#"
    RPROMPT="[%{$fg_no_bold[yellow]%}%?%{$reset_color%}]"

It would equal(without colors):

    username@host ~ %                                                         [0]

> Dirstack

Zsh can be configured to remember the DIRSTACKSIZE last visited folders.
This can then be used to cd them very quickly. You need to add some
lines to you configuration file:

    .zshrc

    DIRSTACKFILE="$HOME/.cache/zsh/dirs"
    if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
      dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
      [[ -d $dirstack[1] ]] && cd $dirstack[1]
    fi
    chpwd() {
      print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
    }

    DIRSTACKSIZE=20

    setopt autopushd pushdsilent pushdtohome

    ## Remove duplicate entries
    setopt pushdignoredups

    ## This reverts the +/- operators.
    setopt pushdminus

Now use

    dirs -v

to print the dirstack. Use cd -<NUM> to go back to a visited folder. Use
autocompletion after the dash. This proves very handy if using the
autocompletion menu.

> Sample .zshrc files

Here is a list of .zshrc files:

-   Prezto - Instantly Awesome Zsh (AUR package: prezto-git) is a
    configuration framework for Zsh. It comes with modules, enriching
    the command line interface environment with sane defaults, aliases,
    functions, auto completion, and prompt themes.
-   Basic setup, with dynamic prompt and window title/hardinfo =>
    http://github.com/MrElendig/dotfiles-alice/blob/master/.zshrc;
-   An Arch package named grml-zsh-config comes from http://grml.org/zsh
    and provides a zshrc file that includes many tweaks for Zshell.
-   https://github.com/slashbeast/things/blob/master/configs/DOTzshrc -
    zshrc with multiple features, be sure to check out comments into it.
    Notable features: confirm function to ensure that user wnat to run
    poweroff, reboot or hibernate, support for GIT in prompt (done
    without vcsinfo), tab completion with menu, printing current
    executed command into window's title bar and more.

Global configuration
--------------------

Occasionally users might want to have some settings applied globally to
all Zsh users. The Zsh wiki tells us that there are some global
configuration files, for example /etc/zshrc. This however is slightly
different on ArchLinux, since it has been compiled with flags
specifically to target /etc/zsh/ instead.

So, for global configuration use /etc/zsh/zshrc, not /etc/zshrc. The
same goes for /etc/zsh/zshenv, /etc/zsh/zlogin and /etc/zsh/zlogout.
Note that these files are not installed by default, so create them if
desired.

The only exception is zprofile, use /etc/profile instead.

> Autostarting applications

Zsh always executes /etc/zsh/zshenv and $ZDOTDIR/.zshenv so do not bloat
these files.

If the shell is a login shell, commands are read from /etc/profile and
then $ZDOTDIR/.zprofile. Then, if the shell is interactive, commands are
read from /etc/zsh/zshrc and then $ZDOTDIR/.zshrc. Finally, if the shell
is a login shell, /etc/zsh/zlogin and $ZDOTDIR/.zlogin are read.

See also the STARTUP/SHUTDOWN FILES section of man zsh.

Uninstallation
--------------

Change the default shell back to bash or csh or whatever, before
removing the Zsh package.

Warning:Failure to follow the below procedures will result in all kinds
of problems: users will no longer have a working shell program.

Paste the following command in terminal as root:

    # chsh -s /bin/bash user

Use it for every user using Zsh.

Now the Zsh package can be removed.

Alternatively, change the default shell back to Bash by editing
/etc/passwd as root.

Warning:It is strongly recommended to use vipw when editing user
information as it prevents badly formatted entries.

For example:

from:

    username:x:1000:1000:Full Name,,,:/home/username:/bin/zsh

to:

    username:x:1000:1000:Full Name,,,:/home/username:/bin/bash

See also
--------

-   Zsh introduction
-   Users guide
-   Zsh Docs (choose a different format for the doc in
    http://zsh.sourceforge.net/Doc/)
-   Zsh FAQ
-   Zsh wiki
-   Zsh-lovers
-   Bash2Zsh Reference Card
-   Oh My Zshell by Robby Russell
-   Gentoo Linux Documentation -- Zsh configuration and installation
    guide
-   Setting up the Zsh prompt

-   IRC channel: #zsh at irc.freenode.org

Retrieved from
"https://wiki.archlinux.org/index.php?title=Zsh&oldid=305706"

Category:

-   Command shells

-   This page was last modified on 20 March 2014, at 01:29.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
