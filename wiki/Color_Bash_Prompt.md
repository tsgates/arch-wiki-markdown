Color Bash Prompt
=================

Summary

Discussing and improving Bash graphical customisations.

Related

Environment Variables

Bash

There are a variety of possibilities for Bash's prompt (PS1), and
customizing it can help you be more productive at the command line. You
can add additional information to your prompt, or you can simply add
color to it to make the prompt stand out. See this Forum thread for more
informations and examples.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 A well-established Bash color prompt                               |
|     -   1.1 Installation                                                 |
|         -   1.1.1 /etc/bash.bashrc                                       |
|         -   1.1.2 /etc/DIR_COLORS                                        |
|         -   1.1.3 /etc/pacman.conf                                       |
|         -   1.1.4 /etc/skel/                                             |
|                                                                          |
|     -   1.2 Example of cohabitation of /etc/bash.bashrc and ~/.bashrc    |
|     -   1.3 Random quotations at logon                                   |
|     -   1.4 Colorized Arch latest news at logon                          |
|     -   1.5 Variations on a theme                                        |
|         -   1.5.1 From Arch Forum #1                                     |
|         -   1.5.2 From an italian blog…                                  |
|         -   1.5.3 From Arch Forum #2                                     |
|         -   1.5.4 With directory information                             |
|             -   1.5.4.1 Version #1: with numerical error                 |
|             -   1.5.4.2 Version #2: with unicode error status symbols    |
|             -   1.5.4.3 Version #3: with unicode error status symbol     |
|                 (non-zero only)                                          |
|                                                                          |
|     -   1.6 Restoring the original /etc/bash.bashrc file                 |
|     -   1.7 Original /etc/bash.bashrc from Gentoo                        |
|                                                                          |
| -   2 Step by step                                                       |
|     -   2.1 Basic prompts                                                |
|         -   2.1.1 Slightly fancier prompts                               |
|                                                                          |
|     -   2.2 Advanced prompts                                             |
|         -   2.2.1 Load/Mem Status for 256colors                          |
|         -   2.2.2 List of colors for prompt and Bash                     |
|         -   2.2.3 Prompt escapes                                         |
|         -   2.2.4 Positioning the cursor                                 |
|         -   2.2.5 Return value visualisation                             |
|         -   2.2.6 Wolfman's                                              |
|         -   2.2.7 KitchM's                                               |
|                                                                          |
|     -   2.3 Set window title                                             |
|     -   2.4 Different colors for text entry and console output           |
|     -   2.5 Laptop battery status on prompt                              |
|     -   2.6 See also                                                     |
|     -   2.7 External links                                               |
+--------------------------------------------------------------------------+

A well-established Bash color prompt
====================================

What follows is a well-proven way to color the Bash prompt. It is the
most widespread Bash color scheme in the GNU/Linux world. Here is a
preview of how it will appear:

I am two with nature.  
                -- Woody Allen  
andy@alba ~ $ ls  
Desktop Documents Music public.desktop  
andy@alba ~ $ I\ will\ try\ to\ type\ a\ wrong\ command...  
bash: I will try to type a wrong command...: command not found  
andy@alba ~ :( $ echo 'Hello world!'  
Hello world!  
andy@alba su  
Password:  
Two can Live as Cheaply as One for Half as Long.  
                 -- Howard Kandel  
alba ~ $ _

Installation
------------

It's a generalized scheme for all users, so you should start removing
your ~/.bashrc file and then modify the /etc/bash.bashrc file and create
a /etc/DIR_COLORS file (but ~/.bashrc and /etc/bash.bashrc can also
cohabitate). Here is our possible version of this scheme for Arch
(originally this scheme was created for Gentoo, but here are some
important additions).

> /etc/bash.bashrc

    # /etc/bash.bashrc
    #
    # https://wiki.archlinux.org/index.php/Color_Bash_Prompt
    #
    # This file is sourced by all *interactive* bash shells on startup,
    # including some apparently interactive shells such as scp and rcp
    # that can't tolerate any output. So make sure this doesn't display
    # anything or bad things will happen !

    # Test for an interactive shell. There is no need to set anything
    # past this point for scp and rcp, and it's important to refrain from
    # outputting anything in those cases.

    # If not running interactively, don't do anything!
    [[ $- != *i* ]] && return

    # Bash won't get SIGWINCH if another process is in the foreground.
    # Enable checkwinsize so that bash will check the terminal size when
    # it regains control.
    # http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
    shopt -s checkwinsize

    # Enable history appending instead of overwriting.
    shopt -s histappend

    case ${TERM} in
    	xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
    		PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
    		;;
    	screen)
    		PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
    		;;
    esac

    # fortune is a simple program that displays a pseudorandom message
    # from a database of quotations at logon and/or logout.
    # Type: "pacman -S fortune-mod" to install it, then uncomment the
    # following line:

    # [[ "$PS1" ]] && /usr/bin/fortune

    # Set colorful PS1 only on colorful terminals.
    # dircolors --print-database uses its own built-in database
    # instead of using /etc/DIR_COLORS. Try to use the external file
    # first to take advantage of user additions. Use internal bash
    # globbing instead of external grep binary.

    # sanitize TERM:
    safe_term=${TERM//[^[:alnum:]]/?}
    match_lhs=""

    [[ -f ~/.dir_colors ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
    [[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
    [[ -z ${match_lhs} ]] \
    	&& type -P dircolors >/dev/null \
    	&& match_lhs=$(dircolors --print-database)

    if [[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] ; then
    	
    	# we have colors :-)

    	# Enable colors for ls, etc. Prefer ~/.dir_colors
    	if type -P dircolors >/dev/null ; then
    		if [[ -f ~/.dir_colors ]] ; then
    			eval $(dircolors -b ~/.dir_colors)
    		elif [[ -f /etc/DIR_COLORS ]] ; then
    			eval $(dircolors -b /etc/DIR_COLORS)
    		fi
    	fi

    	PS1="$(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;32m\]\u@\h'; fi)\[\033[01;34m\] \w \$([[ \$? != 0 ]] && echo \"\[\033[01;31m\]:(\[\033[01;34m\] \")\\$\[\033[00m\] "

    	# Use this other PS1 string if you want \W for root and \w for all other users:
    	# PS1="$(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h\[\033[01;34m\] \W'; else echo '\[\033[01;32m\]\u@\h\[\033[01;34m\] \w'; fi) \$([[ \$? != 0 ]] && echo \"\[\033[01;31m\]:(\[\033[01;34m\] \")\\$\[\033[00m\] "

    	alias ls="ls --color=auto"
    	alias dir="dir --color=auto"
    	alias grep="grep --color=auto"

    	# Uncomment the "Color" line in /etc/pacman.conf instead of uncommenting the following line...!

    	# alias pacman="pacman --color=auto"

    else

    	# show root@ when we do not have colors

    	PS1="\u@\h \w \$([[ \$? != 0 ]] && echo \":( \")\$ "

    	# Use this other PS1 string if you want \W for root and \w for all other users:
    	# PS1="\u@\h $(if [[ ${EUID} == 0 ]]; then echo '\W'; else echo '\w'; fi) \$([[ \$? != 0 ]] && echo \":( \")\$ "

    fi

    PS2="> "
    PS3="> "
    PS4="+ "

    # Try to keep environment pollution down, EPA loves us.
    unset safe_term match_lhs

    # Try to enable the auto-completion (type: "pacman -S bash-completion" to install it).
    [ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

    # Try to enable the "Command not found" hook ("pacman -S pkgfile" to install it).
    # See also: https://wiki.archlinux.org/index.php/Bash#The_.22command_not_found.22_hook
    [ -r /usr/share/doc/pkgfile/command-not-found.bash ] && . /usr/share/doc/pkgfile/command-not-found.bash

> /etc/DIR_COLORS

    # Configuration file for the color ls utility
    # This file goes in the /etc directory, and must be world readable.
    # You can copy this file to .dir_colors in your $HOME directory to override
    # the system defaults.

    # COLOR needs one of these arguments: 'tty' colorizes output to ttys, but not
    # pipes. 'all' adds color characters to all output. 'none' shuts colorization
    # off.
    COLOR all

    # Extra command line options for ls go here.
    # Basically these ones are:
    #  -F = show '/' for dirs, '*' for executables, etc.
    #  -T 0 = don't trust tab spacing when formatting ls output.
    OPTIONS -F -T 0

    # Below, there should be one TERM entry for each termtype that is colorizable
    TERM linux
    TERM console
    TERM con132x25
    TERM con132x30
    TERM con132x43
    TERM con132x60
    TERM con80x25
    TERM con80x28
    TERM con80x30
    TERM con80x43
    TERM con80x50
    TERM con80x60
    TERM xterm
    TERM xterm-color
    TERM vt100
    TERM rxvt
    TERM rxvt-256color
    TERM rxvt-cygwin
    TERM rxvt-cygwin-native
    TERM rxvt-unicode
    TERM rxvt-unicode-256color
    TERM rxvt-unicode256
    TERM screen

    # EIGHTBIT, followed by '1' for on, '0' for off. (8-bit output)
    EIGHTBIT 1

    # Below are the color init strings for the basic file types. A color init
    # string consists of one or more of the following numeric codes:
    # Attribute codes: 
    # 00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed
    # Text color codes:
    # 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
    # Background color codes:
    # 40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white
    NORMAL 00	# global default, although everything should be something.
    FILE 00 	# normal file
    DIR 01;34 	# directory
    LINK 01;36 	# symbolic link
    FIFO 40;33	# pipe
    SOCK 01;35	# socket
    BLK 40;33;01	# block device driver
    CHR 40;33;01 	# character device driver

    # This is for files with execute permission:
    EXEC 01;32 

    # List any file extensions like '.gz' or '.tar' that you would like ls
    # to colorize below. Put the extension, a space, and the color init string.
    # (and any comments you want to add after a '#')
    .cmd 01;32 # executables (bright green)
    .exe 01;32
    .com 01;32
    .btm 01;32
    .bat 01;32
    .tar 01;31 # archives or compressed (bright red)
    .tgz 01;31
    .arj 01;31
    .taz 01;31
    .lzh 01;31
    .zip 01;31
    .z   01;31
    .Z   01;31
    .gz  01;31
    .jpg 01;35 # image formats
    .gif 01;35
    .bmp 01;35
    .xbm 01;35
    .xpm 01;35
    .tif 01;35

> /etc/pacman.conf

As of version 4.1, Pacman has a color option. In order to activate it,
please, uncomment the #Color line in /etc/pacman.conf.

> /etc/skel/

This tip shows you how to use /etc/skel/ directory to ensure that all
new users on your system get the same initial settings.

The /etc/skel/ directory is the directory used by useradd to create the
default settings in a new user's home directory.

To change the location of /etc/skel/, edit /etc/default/useradd.

    # useradd defaults file 
    GROUP=100 
    HOME=/home 
    INACTIVE=-1 
    EXPIRE= 
    SHELL=/bin/bash 
    SKEL=/etc/skel

Typically files included in /etc/skel/ are .rc files for shell
initialization, but you could also include a public_html directory, a
custom .dir_colors file, or anything else.

andy@alba /etc/skel $ ls -A  
.bash_logout .bash_profile .bashrc .xinitrc .xsession  
andy@alba /etc/skel $ _

For more information on customizing the /etc/skel/ directory, type:
$ man useradd. See also:
http://www.gentoo.org/news/en/gwn/20031222-newsletter.xml.

Now, the /etc/skel/.bashrc file is the .bashrc file copyied into the
home directory of each new user. It will look something like this:

    #
    # ~/.bashrc
    #

    # If not running interactively, don't do anything
    [[ $- != *i* ]] && return

    alias ls='ls --color=auto'
    PS1='[\u@\h \W]\$ '

As you can see, a PS1 variable (i.e.: the prompt) is exported. So, if
you had previously created a color prompt through the /etc/bash.bashrc
file, each user newly created, to see it, should delete the line

    PS1='[\u@\h \W]\$ '

from his own ~/.bashrc. Accordingly, if you want to grant to newly
created users to have the same colorfull PS1, you should delete that
line from /etc/skel/.bashrc.

Example of cohabitation of /etc/bash.bashrc and ~/.bashrc
---------------------------------------------------------

~/.bashrc and /etc/bash.bashrc can also cohabitate. Here is a possible
example of a typical Arch user's ~/.bashrc file which can cohabit with
the /etc/bash.bashrc file proposed here, valid for all users. The output
will remain coloured.

    #
    # ~/.bashrc
    #

    # If not running interactively, don't do anything
    [[ $- != *i* ]] && return

    # pacman/yaourt aliases
    alias pac="sudo /usr/bin/pacman -S"		# default action	- install one or more packages
    alias paca="/usr/bin/yaourt -S"			# default yaourt action	- install one or more packages including AUR
    alias pacu="/usr/bin/yaourt -Syua"		# '[u]pdate'		- upgrade all packages to their newest version
    alias pacr="sudo /usr/bin/yaourt -Rs"		# '[r]emove'		- uninstall one or more packages
    alias pacs="/usr/bin/pacman -Ss"		# '[s]earch'		- search for a package using one or more keywords
    alias pacys="/usr/bin/yaourt -Ss"		# '[y]aourt [s]earch'	- search for a package or a PKGBUILD using one or more keywords
    alias paci="/usr/bin/yaourt -Si"		# '[i]nfo'		- show information about a package
    alias paclo="/usr/bin/pacman -Qdt"		# '[l]ist [o]rphans'	- list all packages which are orphaned
    alias pacc="sudo /usr/bin/pacman -Scc"		# '[c]lean cache'	- delete all not currently installed package files
    alias paclf="/usr/bin/pacman -Ql"		# '[l]ist [f]iles'	- list all files installed by a given package
    alias pacexpl="/usr/bin/yaourt -D --asexplicit"	# 'mark as [expl]icit'	- mark one or more packages as explicitly installed 
    alias pacimpl="/usr/bin/yaourt -D --asdeps"	# 'mark as [impl]icit'	- mark one or more packages as non explicitly installed

    # '[r]emove [o]rphans' - recursively remove ALL orphaned packages
    alias pacro="/usr/bin/pacman -Qtdq > /dev/null && sudo /usr/bin/pacman -Rs \$(/usr/bin/pacman -Qtdq | sed -e ':a;N;$!ba;s/\n/ /g')"

Random quotations at logon
--------------------------

If you want a random quotation at logon (like Slackware) you must
install Fortune. Fortune is a simple program that displays a
pseudorandom message from a database of quotations at logon and/or
logout. Type pacman -S fortune-mod to install it, then uncomment the
following line from our /etc/bash.bashrc file:

    # [[ "$PS1" ]] && /usr/bin/fortune

If you want to colorize (brown in this example) the random message from
fortune, replace the previous commented text with:

    [[ "$PS1" ]] && echo -e "\e[00;33m$(/usr/bin/fortune)\e[00m"

Colorized Arch latest news at logon
-----------------------------------

If you want to read the latest news from the Arch Official Website,
instead of a random quotation from fortune, replace the following lines
from our /etc/bash.bashrc file:

    # fortune is a simple program that displays a pseudorandom message
    # from a database of quotations at logon and/or logout.
    # Type: "pacman -S fortune-mod" to install it, then uncomment the
    # following line:

    # [[ "$PS1" ]] && /usr/bin/fortune

with:

    # Arch latest news

    if [ "$PS1" ]; then
    	# The characters "£, §" are used as metacharacters. They should not be encountered in a feed...
    	echo -e "$(echo $(curl --silent https://www.archlinux.org/feeds/news/ | sed -e ':a;N;$!ba;s/\n/ /g') | \
    		sed -e 's/&amp;/\&/g
    		s/&lt;\|&#60;/</g
    		s/&gt;\|&#62;/>/g
    		s/<\/a>/£/g
    		s/href\=\"/§/g
    		s/<title>/\\n\\n\\n   :: \\e[01;31m/g; s/<\/title>/\\e[00m ::\\n/g
    		s/<link>/ [ \\e[01;36m/g; s/<\/link>/\\e[00m ]/g
    		s/<description>/\\n\\n\\e[00;37m/g; s/<\/description>/\\e[00m\\n\\n/g
    		s/<p\( [^>]*\)\?>\|<br\s*\/\?>/\n/g
    		s/<b\( [^>]*\)\?>\|<strong\( [^>]*\)\?>/\\e[01;30m/g; s/<\/b>\|<\/strong>/\\e[00;37m/g
    		s/<i\( [^>]*\)\?>\|<em\( [^>]*\)\?>/\\e[41;37m/g; s/<\/i>\|<\/em>/\\e[00;37m/g
    		s/<u\( [^>]*\)\?>/\\e[4;37m/g; s/<\/u>/\\e[00;37m/g
    		s/<code\( [^>]*\)\?>/\\e[00m/g; s/<\/code>/\\e[00;37m/g
    		s/<a[^§|t]*§\([^\"]*\)\"[^>]*>\([^£]*\)[^£]*£/\\e[01;31m\2\\e[00;37m \\e[01;34m[\\e[00;37m \\e[04m\1\\e[00;37m\\e[01;34m ]\\e[00;37m/g
    		s/<li\( [^>]*\)\?>/\n \\e[01;34m*\\e[00;37m /g
    		s/<!\[CDATA\[\|\]\]>//g
    		s/\|>\s*<//g
    		s/ *<[^>]\+> */ /g
    		s/[<>£§]//g')\n\n";
    fi

that is a small and coloured RSS escaping script written by the user
grufo which will display an output like this:

   :: Arch Linux: Recent news updates ::  
 [ https://www.archlinux.org/news/ ]  
  
The latest and greatest news from the Arch Linux distribution.  
  
 en-us Sun, 04 Nov 2012 16:09:46 +0000  
  
  
   :: End of initscripts support ::  
 [ https://www.archlinux.org/news/end-of-initscripts-support/ ]  
  
  
Tom Gundersen wrote:  
As systemd is now the default init system, Arch Linux is receiving
minimal testing on initscripts systems. Due to a lack of resources and
interest, we are unlikely to work on fixing initscripts-specific bugs,
and may close them as WONTFIX.  
We therefore strongly encourage all users to migrate to systemd as soon
as possible. See the systemd migration guide [
https://wiki.archlinux.org/index.php/Systemd ].  
To ease the transition, initscripts support will remain in the official
repositories for the time being, unless otherwise stated. As of January
2013, we will start removing initscripts support (e.g., rc scripts) from
individual packages without further notice.  
  
 Tom Gundersen Sun, 04 Nov 2012 16:09:46 +0000
tag:www.archlinux.org,2012-11-04:/news/end-of-initscripts-support/  
  
  
   :: November release of install media available ::  
 [
https://www.archlinux.org/news/november-release-of-install-media-available/
]  
  
  
Pierre Schmitz wrote:  
The latest snapshot of our install and rescue media can be found on our
Download [ https://www.archlinux.org/download/ ] page. The 2012.11.01
ISO image mainly contains minor bug fixes, cleanups and new packages
compared to the previous one:  
 * First media with Linux 3.6  
 * copytoram=n can be used to not copy the image to RAM on network boot.
This is probably unreliable but an option for systems with very low
memory.  
 * cowfile_size boot parameter mainly for persistent COW on VFAT. See
the README [
https://projects.archlinux.org/archiso.git/plain/docs/README.bootparams?id=v4
] file for details.  
  
 Pierre Schmitz Fri, 02 Nov 2012 17:54:15 +0000
tag:www.archlinux.org,2012-11-02:/news/november-release-of-install-media-available/  
  
  
   :: Bug Squashing Day: Saturday 17th November ::  
 [
https://www.archlinux.org/news/bug-squashing-day-saturday-17th-november/
]  
  
  
Allan McRae wrote:  
The number of bugs in the Arch Linux bug tracker is creeping up so it is
time for some extermination.  
This is a great way for the community to get involved and help the Arch
Linux team. The process is simple. First look at a bug for your favorite
piece of software in the bug tracker and check if it still occurs. If it
does, check the upstream project for a fix and test it to confirm it
works. If there is no fix available, make sure the bug has been filed in
the upstream tracker.  
Join us on the #archlinux-bugs IRC channel. We are spread across
timezones, so people should be around all day.  
  
 Allan McRae Thu, 01 Nov 2012 12:28:51 +0000
tag:www.archlinux.org,2012-11-01:/news/bug-squashing-day-saturday-17th-november/  
  
  
   :: ConsoleKit replaced by logind ::  
 [ https://www.archlinux.org/news/consolekit-replaced-by-logind/ ]  
  
  
Allan McRae wrote:  
With GNOME 3.6, polkit and networkmanager moving to [extra], ConsoleKit
has now been removed from the repositories. Any package that previously
depended on it now relies on systemd-logind instead. That means that the
system must be booted with systemd to be fully functional.  
In addition to GNOME, both KDE and XFCE are also affected by this
change.  
  
 Allan McRae Tue, 30 Oct 2012 22:17:39 +0000
tag:www.archlinux.org,2012-10-30:/news/consolekit-replaced-by-logind/  
  
  
   :: systemd is now the default on new installations ::  
 [
https://www.archlinux.org/news/systemd-is-now-the-default-on-new-installations/
]  
  
  
Thomas Bächler wrote:  
The base group now contains the systemd-sysvcompat package. This means
that all new installations will boot with systemd by default.  
As some packages still lack native systemd units, users can install the
initscripts package and use the DAEMONS array in /etc/rc.conf to start
services using the legacy rc.d scripts.  
This change does not affect existing installations. For the time being,
the initscripts and sysvinit packages remain available from our
repositories. However, individual packages may now start relying on the
system being booted with systemd.  
Please refer to the wiki [ https://wiki.archlinux.org/index.php/Systemd
] for how to transition an existing installation to systemd.  
  
 Thomas Bächler Sat, 13 Oct 2012 09:29:38 +0000
tag:www.archlinux.org,2012-10-13:/news/systemd-is-now-the-default-on-new-installations/  
  
  
   :: Install medium 2012.10.06 introduces systemd ::  
 [
https://www.archlinux.org/news/install-medium-20121006-introduces-systemd/
]  
  
  
Pierre Schmitz wrote:  
The October release of the Arch Linux install medium is available for
Download [ https://www.archlinux.org/download/ ] and can be used for new
installs or as a rescue system. It contains a set of updated packages
and the following notable changes:  
 * systemd is used to boot up the live system.  
 * initscripts are no longer available on the live system but are still
installed by default on the target system. This is likely to change in
the near future.  
 * EFI boot and setup has been simplified.  
 * gummiboot is used to display a menu on EFI systems.  
 * The following new packages are available on the live system: ethtool,
fsarchiver, gummiboot-efi, mc, partclone, partimage, refind-efi, rfkill,
sudo, testdisk, wget, xl2tpd  
  
 Pierre Schmitz Sun, 07 Oct 2012 16:58:03 +0000
tag:www.archlinux.org,2012-10-07:/news/install-medium-20121006-introduces-systemd/  
  
  
   :: New install medium 2012.09.07 ::  
 [ https://www.archlinux.org/news/new-install-medium-20120907/ ]  
  
  
Pierre Schmitz wrote:  
As is customary by now there is a new install medium available at the
beginning of this month. The live system can be downloaded from Download
[ https://www.archlinux.org/download/ ] and be used for new installs or
as a rescue system.  
In addition to a couple of updated packages and bug fixes the following
changes stand out:  
 * First medium with Linux 3.5 (3.5.3)  
 * The script boot parameter works again (FS#31022 [
https://bugs.archlinux.org/task/31022 ])  
 * When booting via PXE and NFS or NBD the ISO will be copied to RAM to
ensure a more stable usage.  
 * The live medium contains usb_modeswitch and wvdial which e.g. allows
to establish a network connection using an UMTS USB dongle  
 * Furthermore the newest versions of initscripts, systemd and netcfg
are included.  
  
 Pierre Schmitz Sat, 08 Sep 2012 09:48:52 +0000
tag:www.archlinux.org,2012-09-08:/news/new-install-medium-20120907/  
  
  
   :: Fontconfig 2.10.1 update - manual intervention required ::  
 [
https://www.archlinux.org/news/fontconfig-2101-update-manual-intervention-required/
]  
  
  
Andreas Radke wrote:  
The fontconfig 2.10.1 update overwrites symlinks created by the former
package version. These symlinks need to be removed before the update:  
  
rm /etc/fonts/conf.d/20-unhint-small-vera.conf  
rm /etc/fonts/conf.d/20-fix-globaladvance.conf  
rm /etc/fonts/conf.d/29-replace-bitmap-fonts.conf  
rm /etc/fonts/conf.d/30-metric-aliases.conf  
rm /etc/fonts/conf.d/30-urw-aliases.conf  
rm /etc/fonts/conf.d/40-nonlatin.conf  
rm /etc/fonts/conf.d/45-latin.conf  
rm /etc/fonts/conf.d/49-sansserif.conf  
rm /etc/fonts/conf.d/50-user.conf  
rm /etc/fonts/conf.d/51-local.conf  
rm /etc/fonts/conf.d/60-latin.conf  
rm /etc/fonts/conf.d/65-fonts-persian.conf  
rm /etc/fonts/conf.d/65-nonlatin.conf  
rm /etc/fonts/conf.d/69-unifont.conf  
rm /etc/fonts/conf.d/80-delicious.conf  
rm /etc/fonts/conf.d/90-synthetic.conf  
pacman -Sy fontconfig  
  
Main systemwide configuration should be done by symlinks (especially for
autohinting, sub-pixel and lcdfilter):  
  
cd /etc/fonts/conf.d  
ln -s ../conf.avail/XX-foo.conf  
  
Also check Font Configuration [
https://wiki.archlinux.org/index.php/Font_Configuration ] and Fonts [
https://wiki.archlinux.org/index.php/Fonts ].  
  
 Andreas Radke Thu, 06 Sep 2012 13:54:23 +0000
tag:www.archlinux.org,2012-09-06:/news/fontconfig-2101-update-manual-intervention-required/  
  
  
   :: netcfg-2.8.9 drops deprecated rc.conf compatibility ::  
 [
https://www.archlinux.org/news/netcfg-289-drops-initscripts-compatibility/
]  
  
  
Florian Pritz wrote:  
Users of netcfg should configure all interfaces in /etc/conf.d/netcfg
rather than /etc/rc.conf.  
  
 Florian Pritz Sat, 11 Aug 2012 20:00:02 +0000
tag:www.archlinux.org,2012-08-11:/news/netcfg-289-drops-initscripts-compatibility/  
  
  
   :: Install media 2012.08.04 available ::  
 [ https://www.archlinux.org/news/install-media-20120804-available/ ]  
  
  
Pierre Schmitz wrote:  
The August snapshot of our live and install media comes with updated
packages and the following changes on top of the previous ISO image [
/news/install-media-20120715-released/ ]:  
 * GRUB 2.0 instead of the legacy 0.9 version is available.  
 * The Installation Guide [
https://wiki.archlinux.org/index.php/Installation_Guide ] can be found
at /root/install.txt.  
 * ZSH with Grml's configuration [ http://grml.org/zsh/ ] is used as
interactive shell to provide a user friendly and more convenient
environment. This includes completion support for pacstrap, arch-chroot,
pacman and most other tools.  
 * The network daemon is started by default which will automatically
setup your network if DHCP is available.  
Note that all these changes only affect the live system and not the base
system you install using pacstrap. The ISO image can be downloaded from
our download page [ /download/ ]. The next snapshot is scheduled for
September.  
  
 Pierre Schmitz Sat, 04 Aug 2012 17:24:30 +0000
tag:www.archlinux.org,2012-08-04:/news/install-media-20120804-available/  
  
  
andy@alba _

If you don't want to see months worth of updates but only the latest
item, you can use this::

    # Arch latest news

    if [ "$PS1" ]; then
    	# The characters "£, §" are used as metacharacters. They should not be encountered in a feed...
    	echo -e "$(echo $(curl --silent https://www.archlinux.org/feeds/news/ | awk ' NR == 1 {while ($0 !~ /<\/item>/) {print;getline} sub(/<\/item>.*/,"</item>") ;print}' | sed -e ':a;N;$!ba;s/\n/ /g') | \
    		sed -e 's/&amp;/\&/g
    		s/&lt;\|&#60;/</g
    		s/&gt;\|&#62;/>/g
    		s/<\/a>/£/g
    		s/href\=\"/§/g
    		s/<title>/\\n\\n\\n   :: \\e[01;31m/g; s/<\/title>/\\e[00m ::\\n/g
    		s/<link>/ [ \\e[01;36m/g; s/<\/link>/\\e[00m ]/g
    		s/<description>/\\n\\n\\e[00;37m/g; s/<\/description>/\\e[00m\\n\\n/g
    		s/<p\( [^>]*\)\?>\|<br\s*\/\?>/\n/g
    		s/<b\( [^>]*\)\?>\|<strong\( [^>]*\)\?>/\\e[01;30m/g; s/<\/b>\|<\/strong>/\\e[00;37m/g
    		s/<i\( [^>]*\)\?>\|<em\( [^>]*\)\?>/\\e[41;37m/g; s/<\/i>\|<\/em>/\\e[00;37m/g
    		s/<u\( [^>]*\)\?>/\\e[4;37m/g; s/<\/u>/\\e[00;37m/g
    		s/<code\( [^>]*\)\?>/\\e[00m/g; s/<\/code>/\\e[00;37m/g
    		s/<a[^§|t]*§\([^\"]*\)\"[^>]*>\([^£]*\)[^£]*£/\\e[01;31m\2\\e[00;37m \\e[01;34m[\\e[00;37m \\e[04m\1\\e[00;37m\\e[01;34m ]\\e[00;37m/g
    		s/<li\( [^>]*\)\?>/\n \\e[01;34m*\\e[00;37m /g
    		s/<!\[CDATA\[\|\]\]>//g
    		s/\|>\s*<//g
    		s/ *<[^>]\+> */ /g
    		s/[<>£§]//g')\n\n";
    fi

See this thread for details.

Variations on a theme
---------------------

Here are some PS1 variables (i.e.: prompts) with different layout to be
applyied to our /etc/bash.bashrc file. When you choose a layout you must
replace the following lines from our /etc/bash.bashrc file:

    	PS1="$(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;32m\]\u@\h'; fi)\[\033[01;34m\] \w \$([[ \$? != 0 ]] && echo \"\[\033[01;31m\]:(\[\033[01;34m\] \")\$\[\033[00m\] "

    	# Use this other PS1 string if you want \W for root and \w for all other users:
    	# PS1="$(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h\[\033[01;34m\] \W'; else echo '\[\033[01;32m\]\u@\h\[\033[01;34m\] \w'; fi) \$([[ \$? != 0 ]] && echo \"\[\033[01;31m\]:(\[\033[01;34m\] \")\$\[\033[00m\] "

with the PS1 variable (and possibly other code lines) given by the
choosen layout.

> From Arch Forum #1

Here is an unicode variation of our /etc/bash.bashrc file freely based
on what wrote the user JeSuisNerd and others in the Arch Forum. Here is
a preview of how it will appear:

I am two with nature.  
                -- Woody Allen  
┌─[andy@alba]─[~]  
└──╼ ls  
Desktop Documents Music public.desktop  
┌─[andy@alba]─[~]  
└──╼ I\ will\ try\ to\ type\ a\ wrong\ command...  
bash: I will try to type a wrong command...: command not found  
┌─[✗]─[andy@alba]─[~]  
└──╼ echo 'Hello world!' Hello world!  
┌─[andy@alba]─[~]  
└──╼ su  
Password:  
Two can Live as Cheaply as One for Half as Long.  
                -- Howard Kandel  
┌─[alba]─[~]  
└──╼ _

Note: Some unicode symbols (like ✗ and ╼) are not well supported in some
terminals (in linux console, for example), so this prompt will appear a
bit different depending on where is displayed. If you want to know the
unicode representation of a plain text, here you have a little plain
text converter.

And finally here is the PS1 variable for this effect to be applyied to
our /etc/bash.bashrc file (see above):

    	# https://bbs.archlinux.org/viewtopic.php?pid=1068202#p1068202
    	PS1="\[\033[0;37m\]\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"[\[\033[0;31m\]\342\234\227\[\033[0;37m\]]\342\224\200\")[$(if [[ ${EUID} == 0 ]]; then echo '\[\033[0;31m\]\h'; else echo '\[\033[0;33m\]\u\[\033[0;37m\]@\[\033[0;96m\]\h'; fi)\[\033[0;37m\]]\342\224\200[\[\033[0;32m\]\w\[\033[0;37m\]]\n\[\033[0;37m\]\342\224\224\342\224\200\342\224\200\342\225\274 \[\033[0m\]"

> From an italian blog…

Here is an unicode variation of our /etc/bash.bashrc file freely based
on an italian blog. Here is a preview of how it will appear:

I am two with nature.  
                -- Woody Allen  
┌─[12:03:20]─[andy@alba]  
└──> ~ $ ls  
Desktop Documents Music public.desktop  
┌─[12:03:31]─[andy@alba]  
└──> ~ $ I\ will\ try\ to\ type\ a\ wrong\ command...  
bash: I will try to type a wrong command...: command not found  
┌─[✗]─[12:04:01]─[andy@alba]  
└──> ~ $ echo 'Hello world!'  
Hello world!  
┌─[12:04:13]─[andy@alba]  
└──> ~ $ su  
Password:  
Two can Live as Cheaply as One for Half as Long.  
                 -- Howard Kandel  
┌─[12:04:21]─[root@alba]  
└──> ~ $ _

Note: Some unicode symbols (like ✗) are not well supported in some
terminals (in linux console, for example), so this prompt will appear a
bit different depending on where is displayed. If you want to know the
unicode representation of a plain text, here you have a little plain
text converter.

And finally here is the PS1 variable for this effect to be applyied to
our /etc/bash.bashrc file (see above):

    	if [[ ${EUID} == 0 ]] ; then
    		sq_color="\[\033[0;31m\]"
    	else		
    		sq_color="\[\033[0;34m\]"
    	fi

    	PS1="$sq_color\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"[\[\033[01;37m\]\342\234\227$sq_color]\342\224\200\")[\[\033[01;37m\]\t$sq_color]\342\224\200[\[\033[01;37m\]\u@\h$sq_color]\n\342\224\224\342\224\200\342\224\200> \[\033[01;37m\]\W$sq_color $ \[\033[01;37m\]>>\\[\\033[0m\\] "

    	unset sq_color

> From Arch Forum #2

Here is another variation of our /etc/bash.bashrc file freely based on
what wrote the user shumer1213 and others in the Arch Forum. Here is a
preview of how it will appear:

I am two with nature.  
                -- Woody Allen  
  
██ [ ~ ] [ 18:05:58 ]  
██ ls  
Desktop Documents Music public.desktop  
  
██ [ ~ ] [ 18:06:02 ]  
██ I\ will\ try\ to\ type\ a\ wrong\ command...  
bash: I will try to type a wrong command...: command not found  
  
██ [ ~ ] [ 18:06:12 ]  
██ echo 'Hello world!'  
Hello world!  
  
██ [ ~ ] [ 18:06:17 ]  
██ su  
Password:   
Two can Live as Cheaply as One for Half as Long.  
                 -- Howard Kandel  
  
██ [ andy ] [ 18:06:26 ]  
██ _

Here is the PS1 variable for this effect to be applyied to our
/etc/bash.bashrc file (see above):

    	# https://bbs.archlinux.org/viewtopic.php?pid=1156660#p1156660
    	PS1="\n\$(if [[ \$? == 0 ]]; then echo \"\[\033[0;34m\]\"; else echo \"\[\033[0;31m\]\"; fi)\342\226\210\342\226\210 [ \W ] [ \t ]\n\[\033[0m\]\342\226\210\342\226\210 "

> With directory information

Here are other three variations of our /etc/bash.bashrc file freely
based on the article 8 Useful and Interesting Bash Prompts. Here is a
preview of how they will appear:

Version #1: with numerical error

I am two with nature.  
                -- Woody Allen  
  
┌(andy@alba)─(0)─(02:38 PM Sat Aug 29)  
└─(~)─(4 files, 332Kb)─> ls  
Desktop Documents Music myScript.js  
  
┌(andy@alba)─(0)─(02:38 PM Sat Aug 29)  
└─(~)─(4 files, 332Kb)─> I\ will\ try\ to\ type\ a\ wrong\ command...  
bash: I will try to type a wrong command...: command not found  
  
┌(andy@alba)─(127)─(02:39 PM Sat Aug 29)  
└─(~)─(4 files, 332Kb)─> echo 'Hello world!'  
Hello world!  
  
┌(andy@alba)─(0)─(02:39 PM Sat Aug 29)  
└─(~)─(4 files, 332Kb)─> false  
  
┌(andy@alba)─(1)─(02:39 PM Sat Aug 29)  
└─(~)─(4 files, 332Kb)─> su  
Password:   
Two can Live as Cheaply as One for Half as Long.  
                 -- Howard Kandel  
  
┌(alba)─(0)─(02:39 PM Sat Aug 29)  
└─(/home/andy)─(4 files, 332Kb)─> _

Here is the PS1 variable for this effect to be applyied to our
/etc/bash.bashrc file (see above):

    	# http://maketecheasier.com/8-useful-and-interesting-bash-prompts/2009/09/04
    	PS1="\n\[\033[1;37m\]\342\224\214($(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;34m\]\u@\h'; fi)\[\033[1;37m\])\342\224\200(\[\033[1;34m\]\$?\[\033[1;37m\])\342\224\200(\[\033[1;34m\]\@ \d\[\033[1;37m\])\[\033[1;37m\]\n\342\224\224\342\224\200(\[\033[1;32m\]\w\[\033[1;37m\])\342\224\200(\[\033[1;32m\]\$(ls -1 | wc -l | sed 's: ::g') files, \$(ls -lah | grep -m 1 total | sed 's/total //')b\[\033[1;37m\])\342\224\200> \[\033[0m\]"

  

Version #2: with unicode error status symbols

I am two with nature.  
                -- Woody Allen  
  
┌(andy@alba)─(✓)─(02:38 PM Sat Aug 29)  
└─(~)─(4 files, 332Kb)─> ls  
Desktop Documents Music myScript.js  
  
┌(andy@alba)─(✓)─(02:38 PM Sat Aug 29)  
└─(~)─(4 files, 332Kb)─> I\ will\ try\ to\ type\ a\ wrong\ command...  
bash: I will try to type a wrong command...: command not found  
  
┌(andy@alba)─(✗)─(02:39 PM Sat Aug 29)  
└─(~)─(4 files, 332Kb)─> echo 'Hello world!'  
Hello world!  
  
┌(andy@alba)─(✓)─(02:39 PM Sat Aug 29)  
└─(~)─(4 files, 332Kb)─> false  
  
┌(andy@alba)─(✗)─(02:39 PM Sat Aug 29)  
└─(~)─(4 files, 332Kb)─> su  
Password:   
Two can Live as Cheaply as One for Half as Long.  
                 -- Howard Kandel  
  
┌(alba)─(✓)─(02:39 PM Sat Aug 29)  
└─(/home/andy)─(4 files, 332Kb)─> _

Here is the PS1 variable for this effect to be applyied to our
/etc/bash.bashrc file (see above):

    	# http://maketecheasier.com/8-useful-and-interesting-bash-prompts/2009/09/04
    	PS1="\n\[\033[1;37m\]\342\224\214($(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;34m\]\u@\h'; fi)\[\033[1;37m\])\342\224\200(\$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\"; fi)\[\033[1;37m\])\342\224\200(\[\033[1;34m\]\@ \d\[\033[1;37m\])\[\033[1;37m\]\n\342\224\224\342\224\200(\[\033[1;32m\]\w\[\033[1;37m\])\342\224\200(\[\033[1;32m\]\$(ls -1 | wc -l | sed 's: ::g') files, \$(ls -lah | grep -m 1 total | sed 's/total //')b\[\033[1;37m\])\342\224\200> \[\033[0m\]"

Version #3: with unicode error status symbol (non-zero only)

I am two with nature.  
                -- Woody Allen  
  
┌(andy@alba)─(02:38 PM Sat Aug 29)  
└─(~)─(4 files, 332Kb)─> ls  
Desktop Documents Music myScript.js  
  
┌(andy@alba)─(02:38 PM Sat Aug 29)  
└─(~)─(4 files, 332Kb)─> I\ will\ try\ to\ type\ a\ wrong\ command...  
bash: I will try to type a wrong command...: command not found  
  
┌(andy@alba)─(✗)─(02:39 PM Sat Aug 29)  
└─(~)─(4 files, 332Kb)─> echo 'Hello world!'  
Hello world!  
  
┌(andy@alba)─(02:39 PM Sat Aug 29)  
└─(~)─(4 files, 332Kb)─> false  
  
┌(andy@alba)─(✗)─(02:39 PM Sat Aug 29)  
└─(~)─(4 files, 332Kb)─> su  
Password:   
Two can Live as Cheaply as One for Half as Long.  
                 -- Howard Kandel  
  
┌(alba)─(02:39 PM Sat Aug 29)  
└─(/home/andy)─(4 files, 332Kb)─> _

Here is the PS1 variable for this effect to be applyied to our
/etc/bash.bashrc file (see above):

    	# http://maketecheasier.com/8-useful-and-interesting-bash-prompts/2009/09/04
    	PS1="\n\[\033[1;37m\]\342\224\214($(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;34m\]\u@\h'; fi)\[\033[1;37m\])\$([[ \$? != 0 ]] && echo \"\342\224\200(\[\033[0;31m\]\342\234\227\[\033[1;37m\])\")\342\224\200(\[\033[1;34m\]\@ \d\[\033[1;37m\])\[\033[1;37m\]\n\342\224\224\342\224\200(\[\033[1;32m\]\w\[\033[1;37m\])\342\224\200(\[\033[1;32m\]\$(ls -1 | wc -l | sed 's: ::g') files, \$(ls -lah | grep -m 1 total | sed 's/total //')b\[\033[1;37m\])\342\224\200> \[\033[0m\]"

Restoring the original /etc/bash.bashrc file
--------------------------------------------

If you repent having modified the /etc/bash.bashrc file, you can always
restore the original Arch /etc/bash.bashrc file from the bash package
and remove the /etc/DIR_COLORS file. Note that there is not an
"official" bash.bashrc: each distribution has its own.

Original /etc/bash.bashrc from Gentoo
-------------------------------------

The original not modified Gentoo's /etc/bash.bashrc file can be found
here.

Step by step
============

If you want to create a style all your own, you can take a look at these
tips. This Forum thread could give you more informations and examples.

Basic prompts
-------------

The following settings are useful for distinguishing the root prompt
from non-root users.

-   Edit Bash's personal configuration file:

    $ nano ~/.bashrc

-   Comment out the default prompt:

    # PS1='[\u@\h \W]\$ '

-   Add the following green prompt for regular users:

[chiri@zetsubou ~]$ _

    PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[0m\] '

-   Edit root's .bashrc file; copy it from /etc/skel if the file is not
    present:

    $ nano /root/.bashrc

-   Assign a red prompt for root:

[root@zetsubou ~]# _

    PS1='\[\e[1;31m\][\u@\h \W]\$\[\e[0m\] '

> Slightly fancier prompts

-   A green and blue prompt for regular users:

chiri ~/docs $ echo "sample output text"  
sample output text  
chiri ~/docs $ _

    PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\e[1;37m\]'

This will give a very pleasing, colorful prompt and theme for the
console with bright white text.

The string above contains color-set escape sequences (start coloring:
\[\e[color\], end coloring: \[\e[m\]) and information placeholders:

-   \u - Username. The original prompt also has \h, which prints the
    host name.
-   \w - Current absolute path. Use \W for current relative path.
-   \$ - The prompt character (eg. '#' for root, '$' for regular users).

The last color-set sequence, "\[\e[1;37m\]", is not closed, so the
remaining text (everything typed into the terminal, program output and
so on) will be in that (bright white) color. It may be desirable to
change this color, or to delete the last escape sequence in order to
leave the actual output in unaltered color.

-   A red and blue prompt for root:

root ~/docs # echo "sample output text"  
sample output text  
root ~/docs # _

    PS1='\[\e[0;31m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[0;31m\]\$ \[\e[m\]\[\e[0;32m\]'

This will give you a red designation and green console text.

Once you have made your changes to .bashrc, to execute your changes:

    $ source ~/.bashrc

Advanced prompts
----------------

> Load/Mem Status for 256colors

This is not even pushing the limits. Other than using 'sed' to parse the
memory and load average (using the -u option for non-buffering), and the
builtin history to save your history to your HISTFILE after every
command, which you may find incredibly useful when dealing with crashing
shells or subshells, this is essentially just making BASH print
variables it already knows, making this extremely fast compared to
prompts with non-builtin commands.

This prompt is from AskApache.com's BASH Power Prompt article, which
goes into greater detail. It is especially helpful for those wanting to
understand 256 color terminals, ncurses, termcap, and terminfo.

This is for 256 color terminals, which is where the \033[38;5;22m
terminal escapes come from.

    802/1024MB      1.28 1.20 1.13 3/94 18563
    [5416:17880 0:70] 05:35:50 Wed Apr 21 [srot@host.sqpt.net:/dev/pts/0 +1] ~
    (1:70)$ _

    PROMPT_COMMAND='history -a;echo -en "\033[m\033[38;5;2m"$(( `sed -nu "s/MemFree:[\t ]\+\([0-9]\+\) kB/\1/p" /proc/meminfo`/1024))"\033[38;5;22m/"$((`sed -nu "s/MemTotal:[\t ]\+\([0-9]\+\) kB/\1/Ip" /proc/meminfo`/1024 ))MB"\t\033[m\033[38;5;55m$(< /proc/loadavg)\033[m"'
    PS1='\[\e[m\n\e[1;30m\][$$:$PPID \j:\!\[\e[1;30m\]]\[\e[0;36m\] \T \d \[\e[1;30m\][\[\e[1;34m\]\u@\H\[\e[1;30m\]:\[\e[0;37m\]${SSH_TTY} \[\e[0;32m\]+${SHLVL}\[\e[1;30m\]] \[\e[1;37m\]\w\[\e[0;37m\] \n($SHLVL:\!)\$ '

> List of colors for prompt and Bash

Add this to your Bash file(s) to define colors for prompt and commands:

    txtblk='\e[0;30m' # Black - Regular
    txtred='\e[0;31m' # Red
    txtgrn='\e[0;32m' # Green
    txtylw='\e[0;33m' # Yellow
    txtblu='\e[0;34m' # Blue
    txtpur='\e[0;35m' # Purple
    txtcyn='\e[0;36m' # Cyan
    txtwht='\e[0;37m' # White
    bldblk='\e[1;30m' # Black - Bold
    bldred='\e[1;31m' # Red
    bldgrn='\e[1;32m' # Green
    bldylw='\e[1;33m' # Yellow
    bldblu='\e[1;34m' # Blue
    bldpur='\e[1;35m' # Purple
    bldcyn='\e[1;36m' # Cyan
    bldwht='\e[1;37m' # White
    unkblk='\e[4;30m' # Black - Underline
    undred='\e[4;31m' # Red
    undgrn='\e[4;32m' # Green
    undylw='\e[4;33m' # Yellow
    undblu='\e[4;34m' # Blue
    undpur='\e[4;35m' # Purple
    undcyn='\e[4;36m' # Cyan
    undwht='\e[4;37m' # White
    bakblk='\e[40m'   # Black - Background
    bakred='\e[41m'   # Red
    bakgrn='\e[42m'   # Green
    bakylw='\e[43m'   # Yellow
    bakblu='\e[44m'   # Blue
    bakpur='\e[45m'   # Purple
    bakcyn='\e[46m'   # Cyan
    bakwht='\e[47m'   # White
    txtrst='\e[0m'    # Text Reset

Or if you prefer color names you will know how to spell without a
special decoder ring and want high intensity colors:

    # Reset
    Color_Off='\e[0m'       # Text Reset

    # Regular Colors
    Black='\e[0;30m'        # Black
    Red='\e[0;31m'          # Red
    Green='\e[0;32m'        # Green
    Yellow='\e[0;33m'       # Yellow
    Blue='\e[0;34m'         # Blue
    Purple='\e[0;35m'       # Purple
    Cyan='\e[0;36m'         # Cyan
    White='\e[0;37m'        # White

    # Bold
    BBlack='\e[1;30m'       # Black
    BRed='\e[1;31m'         # Red
    BGreen='\e[1;32m'       # Green
    BYellow='\e[1;33m'      # Yellow
    BBlue='\e[1;34m'        # Blue
    BPurple='\e[1;35m'      # Purple
    BCyan='\e[1;36m'        # Cyan
    BWhite='\e[1;37m'       # White

    # Underline
    UBlack='\e[4;30m'       # Black
    URed='\e[4;31m'         # Red
    UGreen='\e[4;32m'       # Green
    UYellow='\e[4;33m'      # Yellow
    UBlue='\e[4;34m'        # Blue
    UPurple='\e[4;35m'      # Purple
    UCyan='\e[4;36m'        # Cyan
    UWhite='\e[4;37m'       # White

    # Background
    On_Black='\e[40m'       # Black
    On_Red='\e[41m'         # Red
    On_Green='\e[42m'       # Green
    On_Yellow='\e[43m'      # Yellow
    On_Blue='\e[44m'        # Blue
    On_Purple='\e[45m'      # Purple
    On_Cyan='\e[46m'        # Cyan
    On_White='\e[47m'       # White

    # High Intensity
    IBlack='\e[0;90m'       # Black
    IRed='\e[0;91m'         # Red
    IGreen='\e[0;92m'       # Green
    IYellow='\e[0;93m'      # Yellow
    IBlue='\e[0;94m'        # Blue
    IPurple='\e[0;95m'      # Purple
    ICyan='\e[0;96m'        # Cyan
    IWhite='\e[0;97m'       # White

    # Bold High Intensity
    BIBlack='\e[1;90m'      # Black
    BIRed='\e[1;91m'        # Red
    BIGreen='\e[1;92m'      # Green
    BIYellow='\e[1;93m'     # Yellow
    BIBlue='\e[1;94m'       # Blue
    BIPurple='\e[1;95m'     # Purple
    BICyan='\e[1;96m'       # Cyan
    BIWhite='\e[1;97m'      # White

    # High Intensity backgrounds
    On_IBlack='\e[0;100m'   # Black
    On_IRed='\e[0;101m'     # Red
    On_IGreen='\e[0;102m'   # Green
    On_IYellow='\e[0;103m'  # Yellow
    On_IBlue='\e[0;104m'    # Blue
    On_IPurple='\e[0;105m'  # Purple
    On_ICyan='\e[0;106m'    # Cyan
    On_IWhite='\e[0;107m'   # White

To use in commands from your shell environment:

$ echo -e "${txtblu}test"  
test  
$ echo -e "${bldblu}test"  
test  
$ echo -e "${undblu}test"  
test  
$ echo -e "${bakblu}test"  
test  
$ _

To use in a prompt (note double quotes to enable $color variable
expansion and \[ \] escapes around them so they are not counted as
character positions and the cursor position is not wrong):

    PS1="\[$txtblu\]foo\[$txtred\] bar\[$txtrst\] baz : "

If you experience premature line wrapping when entering commands at the
prompt then missing escapes is most likely to be the reason.

> Prompt escapes

The various Bash prompt escapes listed in the manpage:

    Bash allows these prompt strings to be customized by inserting a
    number of ''backslash-escaped special characters'' that are
    decoded as follows:

    	\a		an ASCII bell character (07)
    	\d		the date in "Weekday Month Date" format (e.g., "Tue May 26")
    	\D{format}	the format is passed to strftime(3) and the result
    			  is inserted into the prompt string an empty format
    			  results in a locale-specific time representation.
    			  The braces are required
    	\e		an ASCII escape character (033)
    	\h		the hostname up to the first `.'
    	\H		the hostname
    	\j		the number of jobs currently managed by the shell
    	\l		the basename of the shell's terminal device name
    	\n		newline
    	\r		carriage return
    	\s		the name of the shell, the basename of $0 (the portion following
    			  the final slash)
    	\t		the current time in 24-hour HH:MM:SS format
    	\T		the current time in 12-hour HH:MM:SS format
    	\@		the current time in 12-hour am/pm format
    	\A		the current time in 24-hour HH:MM format
    	\u		the username of the current user
    	\v		the version of bash (e.g., 2.00)
    	\V		the release of bash, version + patch level (e.g., 2.00.0)
    	\w		the current working directory, with $HOME abbreviated with a tilde
    	\W		the basename of the current working directory, with $HOME
    			 abbreviated with a tilde
    	\!		the history number of this command
    	\#		the command number of this command
    	\$		if the effective UID is 0, a #, otherwise a $
    	\nnn		the character corresponding to the octal number nnn
    	\\		a backslash
    	\[		begin a sequence of non-printing characters, which could be used
    			  to embed a terminal control sequence into the prompt
    	\]		end a sequence of non-printing characters

    	The command number and the history number are usually different:
    	the history number of a command is its position in the history
    	list, which may include commands restored from the history file
    	(see HISTORY below), while the command number is the position in
    	the sequence of commands executed during the current shell session.
    	After the string is decoded, it is expanded via parameter
    	expansion, command substitution, arithmetic expansion, and quote
    	removal, subject to the value of the promptvars shell option (see
    	the description of the shopt command under SHELL BUILTIN COMMANDS
    	below).

> Positioning the cursor

The following sequence sets the cursor position:

    \[\033[<row>;<column>f\]

The current cursor position can be saved using:

    \[\033[s\]

To restore a position, use the following sequence:

    \[\033[u\]

The following example uses these sequences to display the time in the
upper right corner:

    PS1=">\[\033[s\]\[\033[1;\$((COLUMNS-4))f\]\$(date +%H:%M)\[\033[u\]"

The environment variable COLUMNS contains the number of columns of the
terminal. The above example substracts 4 from its value in order to
justify the five character wide output of date at the right border.

> Return value visualisation

Use this prompt if you want to see the return value of the last executed
command.

    #return value visualisation
    PS1="\$? \$(if [[ \$? == 0 ]]; then echo \"\[\033[0;32m\];)\"; else echo \"\[\033[0;31m\];(\"; fi)\[\033[00m\] : "

This will give you basic prompt:

0 ;) : true  
0 ;) : false  
1 ;( :

Zero is a green smiley (replace it with anything you want) and non-zero
is a red one. So your prompt will smile if the last operation was
successful.

But you will probably want to use the return value in your own prompt,
like this:

0 ;) andy@alba ~ $ true  
0 ;) andy@alba ~ $ false  
1 ;( andy@alba ~ $ _

with a code like this one:

    #return value visualisation
    PS1="\[\033[01;37m\]\$? \$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\];)\"; else echo \"\[\033[01;31m\];(\"; fi) $(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;32m\]\u@\h'; fi)\[\033[01;34m\] \w \$\[\033[00m\] "

Or, if you want, you can build your prompt using the ✓ unicode symbol
for a zero status and the ✗ unicode symbol for a nonzero status:

0 ✓ andy@alba ~ $ true  
0 ✓ andy@alba ~ $ false  
1 ✗ andy@alba ~ $ I\ will\ try\ to\ type\ a\ wrong\ command...  
bash: I will try to type a wrong command...: command not found  
127 ✗ andy@alba ~ $ _

starting from a code like this other one:

    #return value visualisation
    PS1="\[\033[01;37m\]\$? \$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\"; fi) $(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;32m\]\u@\h'; fi)\[\033[01;34m\] \w \$\[\033[00m\] "

Here's an alternative that only include the error status if it is
nonzero:

    PROMPT_COMMAND='es=$?; [[ $es -eq 0 ]] && unset error || error=$(echo -e "\e[1;41m $es \e[40m")'
    PS1="${error} ${PS1}"

> Wolfman's

After reading through most of the Bash Prompt Howto, the author
developed a color bash prompt that displays the last 25 characters of
the current working directory. This prompt should work well on terminals
with a black background. The following code goes in file ~/.bashrc.

-   Add the bash_prompt_command function. If you have a couple
    directories with long names or start entering a lot of
    subdirectories, this function will keep the command prompt from
    wrapping around the screen by displaying at most the last pwdmaxlen
    characters from the PWD. This code was taken from the Bash Prompt
    Howto's section on Controlling the Size and Appearance of $PWD and
    modified to replace the user's home directory with a tilde.

    ##################################################
    # Fancy PWD display function
    ##################################################
    # The home directory (HOME) is replaced with a ~
    # The last pwdmaxlen characters of the PWD are displayed
    # Leading partial directory names are striped off
    # /home/me/stuff		-> ~/stuff			if USER=me
    # /usr/share/big_dir_name	-> ../share/big_dir_name	if pwdmaxlen=20
    ##################################################

    bash_prompt_command() {
    	# How many characters of the $PWD should be kept
    	local pwdmaxlen=25
    	# Indicate that there has been dir truncation
    	local trunc_symbol=".."
    	local dir=${PWD##*/}
    	pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
    	NEW_PWD=${PWD/#$HOME/\~}
    	local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))
    	if [ ${pwdoffset} -gt "0" ]
    	then
    		NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
    		NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
    	fi
    }

-   The next fragment generates the command prompt and various colors
    are defined. The user's color for the username, hostname, and prompt
    ($ or #) is set to cyan, and if the user is root (root's UID is
    always 0), set the color to red. The command prompt is set to a
    colored version of Arch's default with the NEW_PWD from the last
    function.

Also, make sure that your color variables are enclosed in double and not
single quote marks. Using single quote marks seems to give Bash problems
with line wrapping correctly.

    bash_prompt() {
    	case $TERM in
    		xterm*|rxvt*)
    			local TITLEBAR='\[\033]0;\u:${NEW_PWD}\007\]'
    			;;
    		*)
    			local TITLEBAR=""
    			;;
    	esac
    	local NONE="\[\033[0m\]"	# unsets color to term's fg color
    	
    	# regular colors
    	local K="\[\033[0;30m\]"	# black
    	local R="\[\033[0;31m\]"	# red
    	local G="\[\033[0;32m\]"	# green
    	local Y="\[\033[0;33m\]"	# yellow
    	local B="\[\033[0;34m\]"	# blue
    	local M="\[\033[0;35m\]"	# magenta
    	local C="\[\033[0;36m\]"	# cyan
    	local W="\[\033[0;37m\]"	# white
    	
    	# emphasized (bolded) colors
    	local EMK="\[\033[1;30m\]"
    	local EMR="\[\033[1;31m\]"
    	local EMG="\[\033[1;32m\]"
    	local EMY="\[\033[1;33m\]"
    	local EMB="\[\033[1;34m\]"
    	local EMM="\[\033[1;35m\]"
    	local EMC="\[\033[1;36m\]"
    	local EMW="\[\033[1;37m\]"
    	
    	# background colors
    	local BGK="\[\033[40m\]"
    	local BGR="\[\033[41m\]"
    	local BGG="\[\033[42m\]"
    	local BGY="\[\033[43m\]"
    	local BGB="\[\033[44m\]"
    	local BGM="\[\033[45m\]"
    	local BGC="\[\033[46m\]"
    	local BGW="\[\033[47m\]"
    	
    	local UC=$W			# user's color
    	[ $UID -eq "0" ] && UC=$R	# root's color
    	
    	PS1="$TITLEBAR ${EMK}[${UC}\u${EMK}@${UC}\h ${EMB}\${NEW_PWD}${EMK}]${UC}\\$ ${NONE}"
    	# without colors: PS1="[\u@\h \${NEW_PWD}]\\$ "
    	# extra backslash in front of \$ to make bash colorize the prompt
    }

-   Finally, append this code. This ensures that the NEW_PWD variable
    will be updated when you cd somewhere else, and it sets the PS1
    variable, which contains the command prompt.

    PROMPT_COMMAND=bash_prompt_command
    bash_prompt
    unset bash_prompt

> KitchM's

These prompts offer a little more flash and visual clarity. Note that
the use of red in the root user's prompt should provide ample warning.
That is not to say someone could not use flashing text or arrow to do
even more, but these will give you a good starting point.

First, change the default background in your terminal preferences (this
example uses Xfce's Terminal program) to #D2D2D2, and the text color to
#000000. The font is listed as DejaVu Sans Mono Book 12. The cursor
color is #00AA00, and the tab activity color is #AF0000.

Second, in ~/.bashrc and right after the PS1= line, enter a new line
with the following:

    PS1='\e[1;33;47m\u \e[1;32;47mon \h \e[1;35;47m\d \@\e[0;0m\n\e[1;34m[dir.= \w] \# > \e[0;0m'

And then place a # in front of the first PS1 line to remark it out.

Third, for root user, edit /root/.bashrc in the same manner to include:

    PS1='\e[1;31;47m\u \e[1;32;47mon \h \e[1;35;47m\d \@\e[0;0m\n\e[1;31m[dir.= \w] \# > \e[0;0m'

Do not forget to comment out the old line.

These are double-line prompts, and they should look something like
these:

user

Root on myhost Sun Jan 15 12:30 PM  
[dir.= /etc/rc.d] 1 >

root

Root on myhost Sun Jan 15 12:30 PM  
[dir.= /etc/rc.d] 1 >

You will note that the background colors make them easier to read, and
the text colors just keep things interesting. There is a lot of leeway
to make them personalized, just with the use of colors. Enjoy!

Set window title
----------------

Xterm and many other terminal emulators (including PuTTY) allow you to
set the window title using special escape sequences. You can define the
${XTERM_TITLE} variable as follows, then insert it at the beginning of
the prompt to set xterm title (if available) to directory@user@hostname:

    #set xterm title
    case "$TERM" in
    	xterm | xterm-color)
    		XTERM_TITLE='\[\e]0;\W@\u@\H\a\]'
    	;;
    esac

The text between 0; and \a can be set to anything you like, for example:

    export PS1="\[\e]0;Welcome to ArchLinux\a\]\$>> "

sets the window title to "Welcome to ArchLinux" and displays this simple
prompt:

$>> _

Different colors for text entry and console output
--------------------------------------------------

If you do not reset the text color at the end of your prompt, both the
text you enter and the console text will simply stay in that color. If
you want to edit text in a special color but still use the default color
for command output, you will need to reset the color after you press
enter, but still before any commands get run. You can do this by
installing a DEBUG trap in your ~/.bashrc, like this:

    trap 'echo -ne "\e[0m"' DEBUG

Laptop battery status on prompt
-------------------------------

Read this article and this post for details.

See also
--------

-   gentoo-bashrc from AUR
-   tput(1)
-   Colours and Cursor Movement With tput

External links
--------------

-   Forum Discussions:
    -   BASH prompt
    -   What's your PS1?

-   http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
-   Giles Orr's collection of sample prompts

Retrieved from
"https://wiki.archlinux.org/index.php?title=Color_Bash_Prompt&oldid=255247"

Categories:

-   Eye candy
-   Command shells
