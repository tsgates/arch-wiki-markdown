Color Bash Prompt
=================

Related articles

-   Bash
-   Environment variables

There are a variety of possibilities for Bash's prompt (PS1), and
customizing it can help you be more productive at the command line. You
can add additional information to your prompt, or you can simply add
color to it to make the prompt stand out.

Contents
--------

-   1 Applying changes
-   2 Basic prompts
    -   2.1 Regular user
    -   2.2 Root
-   3 Slightly fancier prompts
    -   3.1 Regular user
    -   3.2 Root
-   4 Advanced prompts
    -   4.1 Load/Mem Status for 256colors
    -   4.2 List of colors for prompt and Bash
    -   4.3 Prompt escapes
    -   4.4 Positioning the cursor
    -   4.5 Return value visualisation
-   5 Tips and tricks
    -   5.1 Different colors for text entry and console output
    -   5.2 Laptop battery status on prompt
    -   5.3 Random quotations at logon
    -   5.4 Colorized Arch latest news at logon
    -   5.5 Colors overview
-   6 See also

Applying changes
----------------

To apply changes from this article to your .bashrc (without ending
subshells), do:

    $ source ~/.bashrc

Basic prompts
-------------

The following settings are useful for distinguishing the root prompt
from non-root users.

> Regular user

A green prompt for regular users:

[chiri@zetsubou ~]$ _

    ~/.bashrc

    #PS1='[\u@\h \W]\$ '  # Default
    PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[0m\] '

> Root

A red prompt for root (copy from /etc/skel/, if not already):

[root@zetsubou ~]# _

    /root/.bashrc

    #PS1='[\u@\h \W]\$ '  # Default
    PS1='\[\e[1;31m\][\u@\h \W]\$\[\e[0m\] '

Slightly fancier prompts
------------------------

> Regular user

A green/blue prompt for regular users:

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
-   \$ - The prompt character (eg. # for root, $ for regular users).

The last color-set sequence, \[\e[1;37m\], is not closed, so the
remaining text (everything typed into the terminal, program output and
so on) will be in that (bright white) color. It may be desirable to
change this color, or to delete the last escape sequence in order to
leave the actual output in unaltered color.

> Root

A red/blue prompt for root:

root ~/docs # echo "sample output text"  
sample output text  
root ~/docs # _

    PS1='\[\e[0;31m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[0;31m\]\$ \[\e[m\]\[\e[0;32m\]'

This will give you a red designation and green console text.

Advanced prompts
----------------

> Load/Mem Status for 256colors

This is not even pushing the limits. Other than using sed to parse the
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

    PROMPT_COMMAND='history -a;echo -en "\033[m\033[38;5;2m"$(( $(sed -nu "s/MemFree:[\t ]\+\([0-9]\+\) kB/\1/p" /proc/meminfo)/1024))"\033[38;5;22m/"$(($(sed -nu "s/MemTotal:[\t ]\+\([0-9]\+\) kB/\1/Ip" /proc/meminfo)/1024 ))MB"\t\033[m\033[38;5;55m$(< /proc/loadavg)\033[m"'
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

    PS1="\[$txtblu\]foo\[$txtred\] bar\[$txtrst\] baz : "

Double quotes enable $color variable expansion and the \[ \] escapes
around them make them not count as character positions and the cursor
position is not wrong.

Note:If experiencing premature line wrapping when entering commands,
then missing escapes (\[ \]) is most likely the reason.

> Prompt escapes

The various Bash prompt escapes listed in the manpage:

    Bash allows these prompt strings to be customized by inserting a
    number of backslash-escaped special characters that are
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

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: Does't work.     
                           Seems to have a problem  
                           in                       
                           \[\033[1;\$((COLUMNS-4)) 
                           f\].                     
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

The following example uses these sequences to display the time in the
upper right corner:

    PS1=">\[\033[s\]\[\033[1;\$((COLUMNS-4))f\]\$(date +%H:%M)\[\033[u\]"

The environment variable COLUMNS contains the number of columns of the
terminal. The above example substracts 4 from its value in order to
justify the five character wide output of date at the right border.

> Return value visualisation

Use the following prompt to see the return value of last command:

0 ;) : true  
0 ;) : false  
1 ;( :

    #return value visualisation
    PS1="\$? \$(if [[ \$? == 0 ]]; then echo \"\[\033[0;32m\];)\"; else echo \"\[\033[0;31m\];(\"; fi)\[\033[00m\] : "

Zero is a green smiley and non-zero a red one. So your prompt will smile
if the last operation was successful.

But you will probably want to include the username and hostname as well,
like this:

0 ;) andy@alba ~ $ true  
0 ;) andy@alba ~ $ false  
1 ;( andy@alba ~ $ _

    #return value visualisation
    PS1="\[\033[01;37m\]\$? \$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\];)\"; else echo \"\[\033[01;31m\];(\"; fi) $(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;32m\]\u@\h'; fi)\[\033[01;34m\] \w \$\[\033[00m\] "

Or, if you want, you can build your prompt using the ✓ unicode symbol
for a zero status and the ✗ unicode symbol for a nonzero status:

0 ✓ andy@alba ~ $ true  
0 ✓ andy@alba ~ $ false  
1 ✗ andy@alba ~ $ I\ will\ try\ to\ type\ a\ wrong\ command...  
bash: I will try to type a wrong command...: command not found  
127 ✗ andy@alba ~ $ _

    #return value visualisation
    PS1="\[\033[01;37m\]\$? \$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\"; fi) $(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;32m\]\u@\h'; fi)\[\033[01;34m\] \w \$\[\033[00m\] "

Alternatively, this can be made more readable with PROMPT_COMMAND:

    set_prompt () {
        Last_Command=$? # Must come first!
        Blue='\[\e[01;34m\]'
        White='\[\e[01;37m\]'
        Red='\[\e[01;31m\]'
        Green='\[\e[01;32m\]'
        Reset='\[\e[00m\]'
        FancyX='\342\234\227'
        Checkmark='\342\234\223'

        # Add a bright white exit status for the last command
        PS1="$White\$? "
        # If it was successful, print a green check mark. Otherwise, print
        # a red X.
        if [[ $Last_Command == 0 ]]; then
            PS1+="$Green$Checkmark "
        else
            PS1+="$Red$FancyX "
        fi
        # If root, just print the host in red. Otherwise, print the current user
        # and host in green.
        if [[ $EUID == 0 ]]; then
            PS1+="$Red\\h "
        else
            PS1+="$Green\\u@\\h "
        fi
        # Print the working directory and prompt marker in blue, and reset
        # the text color to the default.
        PS1+="$Blue\\w \\\$$Reset "
    }
    PROMPT_COMMAND='set_prompt'

Here's an alternative that only includes the error status, if non-zero:

    PROMPT_COMMAND='es=$?; [[ $es -eq 0 ]] && unset error || error=$(echo -e "\e[1;41m $es \e[40m")'
    PS1="${error} ${PS1}"

Tips and tricks
---------------

> Different colors for text entry and console output

If you do not reset the text color at the end of your prompt, both the
text you enter and the console text will simply stay in that color. If
you want to edit text in a special color but still use the default color
for command output, you will need to reset the color after you press
Enter, but still before any commands get run. You can do this by
installing a DEBUG trap, like this:

    ~/.bashrc

    trap 'echo -ne "\e[0m"' DEBUG

> Laptop battery status on prompt

See this article and this post for details.

> Random quotations at logon

If you want a random quotation at logon (like Slackware) you must
install fortune-mod:

    ~/.bashrc

    # fortune is a simple program that displays a pseudorandom message
    # from a database of quotations at logon and/or logout.

    [[ "$PS1" ]] && /usr/bin/fortune
    #[[ "$PS1" ]] && echo -e "\e[00;33m$(/usr/bin/fortune)\e[00m"  # Color: Brown

> Colorized Arch latest news at logon

To read 10 latest news items from the Arch official website, user grufo
has written a small and coloured RSS escaping script (scrollable):

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
pacman -Syu fontconfig  
  
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

    ~/.bashrc

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

To only get the absolute latest item, use this:

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

> Colors overview

The page at http://ascii-table.com/ansi-escape-sequences.php describes
the various available color escapes. The following Bash function
displays a table with ready-to-copy escape codes.

    ~/.bashrc

    colors() {
    	local fgc bgc vals seq0

    	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
    	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
    	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
    	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

    	# foreground colors
    	for fgc in {30..37}; do
    		# background colors
    		for bgc in {40..47}; do
    			fgc=${fgc#37} # white
    			bgc=${bgc#40} # black

    			vals="${fgc:+$fgc;}${bgc}"
    			vals=${vals%%;}

    			seq0="${vals:+\e[${vals}m}"
    			printf "  %-9s" "${seq0:-(default)}"
    			printf " ${seq0}TEXT\e[m"
    			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
    		done
    		echo; echo
    	done
    }

See also
--------

If you want to create a style all your own, you can take a look at these
tips:

-   The original not modified Gentoo's /etc/bash.bashrc file can be
    found here. See also the gentoo-bashrc package from AUR.
-   tput(1)
-   Colours and Cursor Movement With tput
-   Forum Discussions:
    -   BASH prompt
    -   What's your PS1?
-   Nice Xresources color schemes collection
-   Bash Prompt HOWTO
-   Giles Orr's collection of sample prompts
-   Bash tips: Colors and formatting

Retrieved from
"https://wiki.archlinux.org/index.php?title=Color_Bash_Prompt&oldid=305111"

Categories:

-   Eye candy
-   Command shells

-   This page was last modified on 16 March 2014, at 14:28.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
