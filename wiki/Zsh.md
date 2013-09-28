Zsh
===

Zsh is a powerful shell that operates as both an interactive shell and
as a scripting language interpreter. While being compatible with Bash
(not by default, only if you issue "emulate sh"), it offers many
advantages such as:

-   Faster
-   Improved tab completion
-   Improved globbing
-   Improved array handling
-   Fully customisable

The Zsh FAQ offers more reasons to use Zsh as your shell.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Initial configuration                                        |
|     -   1.2 Making Zsh your default shell                                |
|                                                                          |
| -   2 Configuration files                                                |
| -   3 ~/.zshrc configuration                                             |
|     -   3.1 Simple .zshrc                                                |
|     -   3.2 Command Completion                                           |
|     -   3.3 The "command not found" hook                                 |
|     -   3.4 Key Bindings                                                 |
|     -   3.5 History search                                               |
|     -   3.6 Prompts                                                      |
|     -   3.7 Customizing your prompt                                      |
|         -   3.7.1 Prompt variables                                       |
|             -   3.7.1.1 General                                          |
|             -   3.7.1.2 Times                                            |
|             -   3.7.1.3 Directories                                      |
|             -   3.7.1.4 Formatting                                       |
|             -   3.7.1.5 Colors                                           |
|                                                                          |
|         -   3.7.2 Example                                                |
|                                                                          |
|     -   3.8 Sample .zshrc files                                          |
|                                                                          |
| -   4 Global configuration                                               |
|     -   4.1 Autostarting applications                                    |
|                                                                          |
| -   5 Uninstallation                                                     |
| -   6 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Before starting you may want to see what shell is currently being used:

    $ echo $SHELL

Install the zsh package available in the official repositories.

> Initial configuration

Make sure that Zsh has been installed correctly by running the following
in a terminal:

    $ zsh

You should now see zsh-newuser-install, which will walk you through some
basic configuration. If you want to skip this, press q.

> Making Zsh your default shell

If the shell is listed in /etc/shells you can use the chsh command to
change your default shell without root access. If you installed Zsh from
the official repositories, it should already have an entry in
/etc/shells.

Change the default shell for the current user:

    $ chsh -s $(which zsh)

Note:You have to log out and log back in, in order to start using Zsh as
your default shell.

After logging back in, you should notice Zsh's prompt, which by default
looks different from Bash's. However you can verify that Zsh is the
current shell by issuing:

    $ echo $SHELL

Tip:If you are replacing bash, you may want to move some code from
~/.bashrc to ~/.zshrc (e.g. the prompt and the aliases) and from
~/.bash_profile to ~/.zprofile (e.g. the code that starts your X Window
System).

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

Note:

-   The paths used in Arch's zsh package are different from the default
    ones used in the man pages.
-   $ZDOTDIR defaults to $HOME
-   /etc/profile is not a part of the regular list of startup files run
    for Zsh, but is sourced from /etc/zsh/zprofile in the zsh package.
    Users should take note that /etc/profile sets the $PATH variable
    which will overwrite any $PATH variable set in ~/.zshenv. To prevent
    this, either replace the /etc/zsh/zprofile file with your own, or
    set your $PATH variable from ~/.zshrc.

~/.zshrc configuration
----------------------

Although Zsh is usable out of the box, it is almost certainly not set up
the way you would like to use it, but due to the sheer amount of
customisation available in Zsh, configuring Zsh can be a daunting and
time-consuming experience.

Included below is a sample configuration file, it provides a decent set
of default options as well as giving examples of many ways that Zsh can
be customised. In order to use this configuration save it as a file
named .zshrc. You can then apply the changes without needing to logout
and then back in by running:

    $ source ~/.zshrc

> Simple .zshrc

Here is a simple .zshrc, that should be sufficient to get you started:

    ~/.zshrc

    autoload -U compinit promptinit
    compinit
    promptinit
     
    # This will set the default prompt to the walters theme
    prompt walters

> Command Completion

Perhaps the most compelling feature of Zsh is its advanced
autocompletion abilities. At the very least, you will want to enable
autocompletion in your .zshrc. To enable autocompletion, add the
following to:

    ~/.zshrc

    autoload -U compinit
    compinit

The above configuration includes ssh/scp/sftp hostnames completion but
in order for this feature to work you will need to prevent ssh from
hashing hosts names in ~/.ssh/known_hosts.

Warning:This makes your computer vulnerable to "Island-hopping" attacks.
In that intention, comment the following line or set the value to no:

    /etc/ssh/ssh_config

    #HashKnownHosts yes

And move your ~/.ssh/known_hosts somewhere else so that ssh creates a
new one with un-hashed hostnames (previously known hosts will thus be
lost).

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

The pkgfile package includes a "command not found" hook that will
automatically search the official repositories when you enter an
unrecognized command. Then it will display something like this:

    $ abiword

    abiword may be found in the following packages:
      extra/abiword 2.8.6-7	usr/bin/abiword

An alternative "command not found" hook is also provided by the AUR
package command-not-found, which will generate an output like the
following:

    $ abiword

    The command 'abiword' is been provided by the following packages:
    abiword (2.8.6-7) from extra
    	[ abiword ]
    abiword (2.8.6-7) from staging
    	[ abiword ]
    abiword (2.8.6-7) from testing
    	[ abiword ]

for it to work, add the following to a zshrc:

    [ -r /etc/profile.d/cnf.sh ] && . /etc/profile.d/cnf.sh

> Key Bindings

Zsh does not use readline, instead it uses its own and more powerful
zle. It does not read /etc/inputrc or ~/.inputrc. zle has an emacs mode
and a vi mode. By default, it tries to guess whether you want emacs or
vi keys from the $EDITOR environment variable. If it is empty, it will
default to emacs. You can change this with bindkey -v or bindkey -e.

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
    [[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
    [[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
    [[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
    [[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
    [[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
    [[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
    [[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
    [[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

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
printed in the terminal. Both can be closed again via Ctrl+C.

> History search

You can add these lines to your .zshrc

    ~/.zshrc

    [[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"    history-beginning-search-backward
    [[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}"  history-beginning-search-forward

Doing this, only past commands beginning with the current input would
have been shown.

> Prompts

There is a quick and easy way to set up a colored prompt in Zsh. Make
sure that prompt is set to autoload in your .zshrc. This can be done by
adding these lines to:

    ~/.zshrc

    autoload -U promptinit
    promptinit

You can now see available prompts by running the command:

    $ prompt -l

To try one of the commands that is listed, use the command prompt
followed by the name of the prompt you like. For example, to use the
walters prompt, you would enter:

    $ prompt walters

> Customizing your prompt

In case you are dissatisfied with the prompts mentioned above(or want to
expand their usefulness), zsh offers the possibility to build your own
custom prompt. Zsh supports a left- and right-sided prompt additional to
the single, left-sided prompt that is common to all shells. You can
customize it by using PROMPT= with the following variables:

Prompt variables

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

 %~ 
    The current working directory. If you are in you are in your $HOME,
    this will be replaced by ~.
 %d 
    The current working directory.

For the options mentioned above: You can prefix an integer to show only
certain parts of your working path. If you entered %1d and found
yourself in /usr/bin it would show bin. This can also be done with
negative integers: %-1d using the same directory as above would show /.

Formatting

 %U [...] %u 
    Begin and end underlined print
 %B [...] %b 
    Begin and end bold print
 %{ [...] %} 
    Begin and enter area that will not be printed. Useful for setting
    colors.
    In fact, this tag forces Zsh to ignore anything inside them when
    making indents for the prompt as well.
    As such, not to use it can have some weird effects on the margins
    and indentation of the prompt.

Colors

Zsh has a different approach to setting colors on the terminal than the
one depicted here. First you write before PROMPT= in your .zshrc:

    autoload -U colors && colors

Following commands would now produce the color escape sequence needed to
set the requested color when the prompt is printed:

 $fg[color] 
    will set the text color (red, green, blue, etc. - defaults to bold)
 $fg_no_bold[color]
    will set the non-bold text color
 $fg_bold[color]
    will set the bold text color
 $reset_color 
    will reset the text color to white

It is useful to put these color commands inside %{ [...] %} , so the
shell knows there is no output from these sequences and the cursor
hasn't moved.

Possible color values

  ------- ---------
  black   red
  green   yellow
  blue    magenta
  cyan    white
  ------- ---------

Note that bold text doesn't necessarily use the same colors as normal
text. For example, $fg['yellow'] looks brown or a very dark yellow,
while $fg_no_bold['yellow'] looks like bright or regular yellow.

Example

To have a two-sided prompt you could write:

    PROMPT="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg_no_bold[yellow]%}%1~ %{$reset_color%}%#"
    RPROMPT="[%{$fg_no_bold[yellow]%}%?%{$reset_color%}]"

It would equal(without colors):

    username@host ~ %                                                         [0]

> Sample .zshrc files

Here is a list of .zshrc files. Feel free to add your own:

-   Prezto - Instantly Awesome Zsh (AUR package: prezto-git) is a
    configuration framework for Zsh. It comes with modules, enriching
    the command line interface environment with sane defaults, aliases,
    functions, auto completion, and prompt themes.
-   Oh-my-zsh Plugin and Theme system for Zsh can help you manage your
    zshrc file and has a huge community of over 2000 forks on github;
-   Basic setup, with dynamic prompt and window title/hardinfo =>
    http://github.com/MrElendig/dotfiles-alice/blob/master/.zshrc;
-   An Arch package named grml-zsh-config comes from http://grml.org/zsh
    and provides a zshrc file that includes many tweaks for your zshell.
-   https://github.com/slashbeast/things/blob/master/configs/DOTzshrc -
    zshrc with multiple features, be sure to check out comments into it.
    Notable features: confirm function to ensure that user wnat to run
    poweroff, reboot or hibernate, support for GIT in prompt (done
    without vcsinfo), tab completion with menu, printing current
    executed command into window's title bar and more.

Global configuration
--------------------

Occasionally you might want to have some settings applied globally to
all zsh users. The zsh wiki tells us that there are some global
configuration files, for example /etc/zshrc. This however is slightly
different on ArchLinux, since it has been compiled with flags
specifically to target /etc/zsh/ instead.

So, for global configuration use /etc/zsh/zshrc, not /etc/zshrc. The
same goes for /etc/zsh/zshenv, /etc/zsh/zlogin and /etc/zsh/zlogout.
Note that these files are not installed by default, so you need to
create them yourself if you want to use them.

The only exception is zprofile, use /etc/profile instead.

> Autostarting applications

Zsh always executes /etc/zsh/zshenv and $ZDOTDIR/.zshenv so do not bloat
these files.

If the shell is a login shell, commands are read from /etc/profile and
then $ZDOTDIR/.zprofile. Then, if the shell is interactive, commands are
read from /etc/zsh/zshrc and then $ZDOTDIR/.zshrc. Finally, if the shell
is a login shell, /etc/zsh/zlogin and $ZDOTDIR/.zlogin are read.

Uninstallation
--------------

If you decide that Zsh is not the shell for you and you want to return
to Bash, you must first change the default shell, before removing the
Zsh package.

Warning: Failure to follow the below procedures will result in all kinds
of problems.

Paste the following command in terminal as root:

    # chsh -s /bin/bash user

Use it for every user using Zsh.

Now you can safely remove the Zsh package.

If you did not follow the above, you can still change the default shell
back to Bash by editing /etc/passwd as root.

Warning: It is strongly recommended to use vipw when editing user
information as it prevents badly formatted entries.

For example:

from:

    username:x:1000:1000:Full Name,,,:/home/username:/bin/zsh

to:

    username:x:1000:1000:Full Name,,,:/home/username:/bin/bash

See also
--------

-   Zsh Introduction
-   Users Guide
-   Zsh Docs (you can choose a different format for the doc in
    http://zsh.sourceforge.net/Doc/)
-   Zsh FAQ
-   Zsh Wiki
-   Zsh-lovers
-   Bash2Zsh Reference Card
-   Oh My Zshell by Robby Russell
-   Gentoo Linux Documentation -- zsh Configuration and Installation
    Guide
-   Setting up the zsh prompt

-   IRC channel: #zsh at irc.freenode.org

Retrieved from
"https://wiki.archlinux.org/index.php?title=Zsh&oldid=256103"

Category:

-   Command shells
