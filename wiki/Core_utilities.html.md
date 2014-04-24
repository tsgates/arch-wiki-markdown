Core utilities
==============

Related articles

-   Bash
-   Zsh
-   General recommendations
-   GNU Project

This article deals with so-called core utilities on a GNU/Linux system,
such as less, ls, and grep. The scope of this article includes, but is
not limited to, those utilities included with the GNU coreutils package.
What follows are various tips and tricks and other helpful information
related to these utilities.

Contents
--------

-   1 cat
-   2 cron
-   3 dd
    -   3.1 Checking progress of dd while running
    -   3.2 dd spin-offs
-   4 grep
    -   4.1 Colored output
-   5 iconv
-   6 ip
-   7 less
    -   7.1 Colored output through environment variables
    -   7.2 Colored output through wrappers
    -   7.3 Vim as alternative pager
-   8 locate
-   9 ls
-   10 man
-   11 mkdir
-   12 mv
-   13 rm
-   14 sed
-   15 seq
-   16 shred
-   17 sudo
-   18 Permissions related utilities
-   19 See also

cat
---

cat (catenate) is a standard Unix utility that concatenates and lists
files.

-   As cat is not a shell built-in, on many occasions you may find more
    convenient to use a redirection, for example in scripts, or if you
    care a lot about performance. In fact < file does the same of
    cat file.

-   cat is able to work with multiple lines, although this is sometimes
    regarded as bad practice:

    $ cat << EOF >> path/file
    first line
    ...
    last line
    EOF

A better alternative is the echo command:

    $ echo "\
    first line
    ...
    last line" \
    >> path/file

-   If you need to list file lines in reverse order, there is a utility
    called tac (cat reversed).

cron
----

cron is a time-based job scheduler in Unix-like computer operating
systems.

See the main article.

Note:systemd is able to handle many cron use cases. See the related
article.

dd
--

See the Wikipedia article on this subject for more information: dd
(Unix)

Note:cp does the same as dd without any operands but is not designed for
more versatile disk wiping procedures.

> Checking progress of dd while running

By default, there is no output of dd until the task has finished. With
kill and the USR1 signal you can force status output without actually
killing the program. Open up a second root terminal and issue the
following command:

    # killall -USR1 dd

Note:This will affect all other running dd processes as well.

Or:

    # kill -USR1 pid_of_dd_command

For example:

    # kill -USR1 $(pidof dd)

This causes dd to output immediate progress into the terminal. For
example:

    605+0 records in
    605+0 records out
    634388480 bytes (634 MB) copied, 8.17097 s, 77.6 MB/s

> dd spin-offs

Other dd-like programs feature periodical status output, e.g. a simple
progress bar.

 dcfldd 
    dcfldd is an enhanced version of dd with features useful for
    forensics and security. It accepts most of dd's parameters and
    includes status output. The last stable version of dcfldd was
    released on December 19, 2006.[1]

 ddrescue 
    GNU ddrescue is a data recovery tool. It's capable of ignoring read
    errors what is a useless feature for disk wiping in almost any case.
    See the official manual for details.

grep
----

grep (from ed's g/re/p, global/regular expression/print) is a command
line text search utility originally written for Unix. The grep command
searches files or standard input globally for lines matching a given
regular expression, and prints them to the program's standard output.

-   Remember that grep handles files, so a construct like
    cat file | grep pattern is replaceable with grep pattern file

-   Optimized for VCS source code grep alternatives exist, such as
    the_silver_searcher and ack.

> Colored output

Beyond aesthetics, grep's color output is immensely useful for learning
regexp and grep's functionality.

To use the default colors for grep, write the following entry to your
shell configuration file, e.g. if using Bash:

    ~/.bashrc

    alias grep='grep --color=auto'

Alternatively, you can set the GREP_OPTIONS environment variable bearing
in mind this may break some scripts that use grep [2]:

    export GREP_OPTIONS='--color=auto'

To include file line numbers in the output, add -n:

    alias grep='grep -n --color=auto'

The environment variable GREP_COLORS may be used to specify different
colors than the defaults.

iconv
-----

iconv converts the encoding of characters from one codeset to another.

The following command will convert the file foo from ISO-8859-15 to
UTF-8 saving it to foo.utf:

    $ iconv -f ISO-8859-15 -t UTF-8 foo >foo.utf

See man iconv for more details.

ip
--

ip allows you to show information about network devices, IP addresses,
routing tables, and other objects in the Linux IP software stack. By
appending various commands, you can also manipulate or configure most of
these objects.

Note:The ip utility is provided by the iproute2 package, which is
included in the base group.

  Object           Purpose                                Manual Page Name
  ---------------- -------------------------------------- ------------------
  ip addr          protocol address management            ip-address
  ip addrlabel     protocol address label management      ip-addrlabel
  ip l2tp          tunnel Ethernet over IP (L2TPv3)       ip-l2tp
  ip link          network device configuration           ip-link
  ip maddr         multicast addresses management         ip-maddress
  ip monitor       watch for netlink messages             ip-monitor
  ip mroute        multicast routing cache management     ip-mroute
  ip mrule         rule in multicast routing policy db    
  ip neigh         neighbour/ARP tables management        ip-neighbour
  ip netns         process network namespace management   ip-netns
  ip ntable        neighbour table configuration          ip-ntable
  ip route         routing table management               ip-route
  ip rule          routing policy database management     ip-rule
  ip tcp_metrics   management for TCP Metrics             ip-tcp_metrics
  ip tunnel        tunnel configuration                   ip-tunnel
  ip tuntap        manage TUN/TAP devices                 
  ip xfrm          manage IPsec policies                  ip-xfrm

The help command is available for all objects. For example, typing
ip addr help will show you the command syntax available for the address
object.

The Network configuration article shows how the ip command is used in
practice for various common tasks.

Note:You might be familiar with the ifconfig command, which was used in
older versions of Linux for interface configuration. It is now
deprecated in Arch Linux; you should use ip instead.

less
----

less is a terminal pager program used to view the contents of a text
file one screen at a time. Whilst similar to other pages such as more
and pg, less offers a more advanced interface and complete feature-set.

> Colored output through environment variables

Add the following lines to your shell configuration file:

    ~/.bashrc

    export LESS=-R
    export LESS_TERMCAP_me=$(printf '\e[0m')
    export LESS_TERMCAP_se=$(printf '\e[0m')
    export LESS_TERMCAP_ue=$(printf '\e[0m')
    export LESS_TERMCAP_mb=$(printf '\e[1;32m')
    export LESS_TERMCAP_md=$(printf '\e[1;34m')
    export LESS_TERMCAP_us=$(printf '\e[1;32m')
    export LESS_TERMCAP_so=$(printf '\e[1;44;1m')

Change values as you like. References: ANSI escape code.

> Colored output through wrappers

You can enable code syntax coloring in less. First, install
source-highlight, then add these lines to your shell configuration file:

    ~/.bashrc

    export LESSOPEN="| /usr/bin/source-highlight-esc.sh %s"
    export LESS='-R '

Frequent users of the command line interface might want to install
lesspipe.

Users may now list the compressed files inside of an archive using their
pager:

    $ less compressed_file.tar.gz

    ==> use tar_file:contained_file to view a file in the archive
    -rw------- username/group  695 2008-01-04 19:24 compressed_file/content1
    -rw------- username/group   43 2007-11-07 11:17 compressed_file/content2
    compressed_file.tar.gz (END)

lesspipe also grants less the ability of interfacing with files other
than archives, serving as an alternative for the specific command
associated for that file-type (such as viewing HTML via html2text).

Re-login after installing lesspipe in order to activate it, or source
/etc/profile.d/lesspipe.sh.

> Vim as alternative pager

Vim (visual editor improved) has a script to view the content of text
files, compressed files, binaries, directories. Add the following line
to your shell configuration file to use it as a pager:

    ~/.bashrc

    alias less='/usr/share/vim/vim74/macros/less.sh'

There is also an alternative to less.sh macro, which may work as the
PAGER environment variable. Install vimpager-git and add the following
to your shell configuration file:

    ~/.bashrc

    export PAGER='vimpager'
    alias less=$PAGER

Now programs that use the PAGER environment variable, like git, will use
vim as pager.

locate
------

locate serves to find files on filesystems. It searches through a
prebuilt database of files generated by updatedb or by a daemon and
compressed using incremental encoding. It operates significantly faster
than find, but requires regular updating of the database.

See the main article.

ls
--

ls (list) is a command to list files in Unix and Unix-like operating
systems.

-   ls can list file permissions.

-   Colored output can be enabled with a simple alias. File ~/.bashrc
    should already have the following entry copied from
    /etc/skel/.bashrc:

alias ls='ls --color=auto'

The next step will further enhance the colored ls output; for example,
broken (orphan) symlinks will start showing in a red hue. Add the
following to your shell configuration file:

eval $(dircolors -b)

man
---

man (manual page) is a form of online software documentation usually
found on a Unix or Unix-like operating system. Topics covered include
computer programs (including library and system calls), formal standards
and conventions, and even abstract concepts. See Man Pages.

mkdir
-----

mkdir (make directory) is a command to create directories.

-   To create a directory and its whole hierarchy, -p switch is used, if
    not a error is printed. As users are supposed to know what they
    want, -p switch may be used as a default.

    alias mkdir='mkdir -p -v'

The -v switch make it verbose.

-   Changing mode of a just created directory using chmod is not
    necessary as the -m option lets you define the access permissions.

Tip:If you want just a temporary directory a better alternative may be
mktemp (make termporary): mktemp -p.

mv
--

mv (move) is a command to move and rename files and directories. It can
be very dangerous so it is prudent to limit its scope:

    alias mv=' timeout 8 mv -iv'

This alias suspends mv after eight seconds, asks confirmation to delete
three or more files, lists the operations in progress and does not store
itself in the shell history file if the shell is configured to ignore
space starting commands.

rm
--

rm (remove) is a command to delete files and directories.

-   It can be very dangerous so it is prudent to limit its scope:

    alias rm=' timeout 3 rm -Iv --one-file-system'

This alias suspends rm after three seconds, asks confirmation to delete
three or more files, lists the operations in progress, does not involve
more than one file systems and does not store itself in the shell
history file if the shell is configured to ignore space starting
commands. Substitute -I with -i if you prefer to confirm even for one
file.

Zsh users may want to put noglob before timeout to avoid implicit
expansions.

-   To remove directories known to be empty, use rmdir as it fails in
    case of files inside the target.

sed
---

sed (stream editor) is a Unix utility that parses and transforms text.

Here is a handy list of sed one-liners examples.

Tip:More powerful alternatives are AWK and even Perl language.

seq
---

seq (sequence) is a utility for generating a sequence of numbers. Shell
built-in alternatives are available, so it is good practice to use them
as explained on Wikipedia.

shred
-----

shred is a Unix command that can be used to securely delete files and
devices so that they can be recovered only with great difficulty with
specialised hardware, if at all. shred uses three passes, writing
pseudo-random data to the device during each pass. This can be reduced
or increased.

The following command invokes shred with its default settings and
displays the progress.

    # shred -v /dev/sdX

Alternatively, shred can be instructed to do only one pass, with entropy
from e.g. /dev/urandom.

    # shred --verbose --random-source=/dev/urandom -n1 /dev/sdX

shred can be very dangerous so it is prudent to limit its scope:

    alias shred=' timeout 3 shred -v'

This alias suspends shred after three seconds, lists the operations in
progress, and does not store itself in the shell history file if the
shell is configured to ignore space starting commands.

Zsh users may want to put noglob before timeout to avoid implicit
expansions.

sudo
----

Sudo (as superuser do) is a program for Unix-like computer operating
systems that allows users to run programs with the security privileges
of another user (normally the superuser, or root). See Sudo.

Permissions related utilities
-----------------------------

-   chmod (change mode) is the name of a Unix shell command and a system
    call, which both change the access permissions to file system
    objects (including files and directories), as well as specifying
    special flags.

-   chown (change owner) is used on Unix-like systems to change the
    owner of a file.

-   chattr (change attributes) is a command in the Linux operating
    system that allows a user to set certain attributes on a file
    residing on many Linux filesystems.

-   lsattr (list attributes) is a command-line program for listing the
    attributes on a Linux extended file system.

-   ls -l lists files attributes.

These utilities are explained in the File permissions and attributes
article. More advanced permission use cases are satisfied by
capabilities and ACL.

See also
--------

-   A sampling of coreutils , part 2 , part 3 - Overview of commands in
    coreutils

-   GNU Coreutils Manpage

-   Learn the DD command

Retrieved from
"https://wiki.archlinux.org/index.php?title=Core_utilities&oldid=304775"

Categories:

-   System administration
-   Command shells

-   This page was last modified on 16 March 2014, at 07:12.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
