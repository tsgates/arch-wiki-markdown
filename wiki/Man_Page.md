Man Page
========

  Summary
  ------------------------------------------------------------------------------------
  Information on man pages, along with recommendations on how to improve their usage

man pages (abbreviation for "manual pages") are the extensive
documentation that comes preinstalled with almost all substantial
UNIX-like operating systems, including Arch Linux. The command used to
display them is man.

In spite of their scope, man pages are designed to be self-contained
documents, consequentially limiting themselves to referring to other man
pages when discussing related subjects. This is in sharp contrast with
the hyperlink-aware info files, GNU's attempt at replacing the
traditional man page format.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Accessing Man Pages                                                |
| -   2 Format                                                             |
| -   3 Searching manuals                                                  |
| -   4 Colored man pages                                                  |
|     -   4.1 Using less (Recommended)                                     |
|     -   4.2 Using most (Not recommended)                                 |
|     -   4.3 Colored man pages on xterm or rxvt-unicode                   |
|         -   4.3.1 xterm                                                  |
|         -   4.3.2 rxvt-unicode                                           |
|                                                                          |
| -   5 Reading man pages with a browser                                   |
|     -   5.1 Using Local Man Pages                                        |
|     -   5.2 Using Online Man Pages                                       |
|                                                                          |
| -   6 Viewing man pages as PDFs                                          |
| -   7 Noteworthy manpages                                                |
| -   8 See also                                                           |
+--------------------------------------------------------------------------+

Accessing Man Pages
-------------------

To read a man page, simply enter:

    $ man page_name

Manuals are sorted into several sections:

1.  General commands
2.  System calls (functions provided by the kernel)
3.  Library calls (C library functions)
4.  Special files (usually found in /dev) and drivers
5.  File formats and conventions
6.  Games
7.  Miscellaneous (including conventions)
8.  System administration commands (usually requiring root privileges)
    and daemons

Man pages are usually referred to by their name, followed by their
section number in parentheses. Often there are multiple man pages of the
same name, such as man(1) and man(7). In this case, give man the section
number followed by the name of the man page, for example:

    $ man 5 passwd

to read the man page on /etc/passwd, rather than the passwd utility.

Very brief descriptions of programs can be read out of man pages without
displaying the whole page using the whatis command. For example, for a
brief description of ls, type:

    $ whatis ls

and whatis will output "list directory contents."

Format
------

Man pages all follow a fairly standard format, which helps in navigating
them. Some sections which are often present include:

-   NAME - The name of the command and a one-line statement of its
    purpose.
-   SYNOPSIS - A list of the options and arguments a command takes or
    the parameters the function takes and its header file.
-   DESCRIPTION - A more in depth description of a command or function's
    purpose and workings.
-   EXAMPLES - Common examples, usually ranging from the simple to the
    relatively complex.
-   OPTIONS - Descriptions of each of the options a command takes and
    what they do.
-   EXIT STATUS - The meanings of different exit codes.
-   FILES - Files related to a command or function.
-   BUGS - Problems with the command or function that are pending
    repair. Also known as KNOWN BUGS.
-   SEE ALSO - A list of related commands or functions.
-   AUTHOR, HISTORY, COPYRIGHT, LICENSE, WARRANTY - Information about
    the program, its past, its terms of use, and its creator.

Searching manuals
-----------------

Whilst the man utility allows users to display man pages, a problem
arises when one knows not the exact name of the desired manual page in
the first place! Fortunately, the -k or --apropos options can be used to
search the manual page descriptions for instances of a given keyword.

The research feature is provided by a dedicated cache. By default you
may not have any cache built and all your searches will give you the
nothing appropriate result. You can generate the cache or update it by
running

    # mandb

You should run it everytime a new manpage is installed.

Now you can begin your search. For example, to search for man pages
related to "password":

    $ man -k password

or:

    $ man --apropos password

This is equivalent to calling the apropos command:

    $ apropos password

The given keyword is interpreted as a regular expression by default.

If you want to do a more in-depth search by matching the keywords found
in the whole articles, you can use the -K option:

    $ man -K password

Colored man pages
-----------------

Color-enabled man pages allow for a clearer presentation and easier
digestion of the content. There are two prevalent methods for achieving
colored man pages: using less, or opting for most.

> Using less (Recommended)

Source: nion's blog - less colors for man pages

This method has the advantage that less has a bigger feature set than
most, and is the default for viewing man pages.

Add the following to a shell configuration file. For Bash it would be:

    ~/.bashrc

    man() {
        env LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    	LESS_TERMCAP_md=$(printf "\e[1;31m") \
    	LESS_TERMCAP_me=$(printf "\e[0m") \
    	LESS_TERMCAP_se=$(printf "\e[0m") \
    	LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    	LESS_TERMCAP_ue=$(printf "\e[0m") \
    	LESS_TERMCAP_us=$(printf "\e[1;32m") \
    	man "$@"
    }

To customize the colors, see Wikipedia:ANSI escape code for reference.

> Using most (Not recommended)

The basic function of 'most' is similar to less and more, but it has a
smaller feature set. Configuring most to use colors is easier than using
less, but additional configuration is necessary to make most behave like
less. Install most using pacman:

    # pacman -S most

Edit /etc/man_db.conf, uncomment the pager definition and change it to:

    DEFINE     pager     most -s

Test the new setup by typing:

    $ man whatever_man_page

Modifying the color values requires editing ~/.mostrc (creating the file
if it is not present) or editing /etc/most.conf for system-wide changes.
Example ~/.mostrc:

    % Color settings
    color normal lightgray black
    color status yellow blue
    color underline yellow black
    color overstrike brightblue black

Another example showing keybindings similar to less (jump to line is set
to 'J'):

    % less-like keybindings
    unsetkey "^K"
    unsetkey "g"
    unsetkey "G"
    unsetkey ":"

    setkey next_file ":n"
    setkey find_file ":e"
    setkey next_file ":p"
    setkey toggle_options ":o"
    setkey toggle_case ":c"
    setkey delete_file ":d"
    setkey exit ":q"

    setkey bob "g"
    setkey eob "G"
    setkey down "e"
    setkey down "E"
    setkey down "j"
    setkey down "^N"
    setkey up "y"
    setkey up "^Y"
    setkey up "k"
    setkey up "^P"
    setkey up "^K"
    setkey page_down "f"
    setkey page_down "^F"
    setkey page_up "b"
    setkey page_up "^B"
    setkey other_window "z"
    setkey other_window "w"
    setkey search_backward "?"
    setkey bob "p"
    setkey goto_mark "'"
    setkey find_file "E"
    setkey edit "v"

> Colored man pages on xterm or rxvt-unicode

Source: XFree resources file for XTerm program

A quick way to add color to manual pages viewed on xterm/uxterm or
rxvt-unicode can be made modifying ~/.Xresources or ~/.Xdefaults.

xterm

    *VT100.colorBDMode:     true
    *VT100.colorBD:         red
    *VT100.colorULMode:     true
    *VT100.colorUL:         cyan

which replaces the decorations with the colors. Also add:

    *VT100.veryBoldColors: 6

if you want colors and decorations (bold or underline) at the same time.
See man xterm for a description of the veryBoldColors resource.

rxvt-unicode

    URxvt.colorIT:      #87af5f
    URxvt.colorBD:      #d7d7d7
    URxvt.colorUL:      #87afd7

Run:

    $ xrdb -load ~/.Xresources

Launch a new xterm/uxterm or rxvt-unicode and you should see colorful
man pages. This combination puts colors to bold and underlined words in
xterm/uxterm or to bold, underlined, and italicized text in
rxvt-unicode. You can play with different combinations of these
attributes (see the sources of this item).

Reading man pages with a browser
--------------------------------

Instead of the standard interface, using browsers such as lynx and
Firefox to view man pages allows users to reap info pages' main benefit:
hyperlinked text. Additionally, KDE users can read man pages in
Konqueror using:

    man:<name>

> Using Local Man Pages

First, install man2html from the Official Repositories.

Now, convert a man page:

    $ man free | man2html -compress -cgiurl man$section/$title.$section$subsection.html > ~/man/free.html

Another use for man2html is exporting to raw, printer-friendly text:

    $ man free | man2html -bare > ~/free.txt

The GNU implementation of man in the Arch repositories also has the
ability to do this on its own:

    $ man -H free

This will read your BROWSER environment variable to determine the
browser. You can override this by passing the binary to the -H option.

> Using Online Man Pages

There are several online databases of man pages, including:

-   Debian GNU/Linux man pages
-   DragonFlyBSD manual pages
-   FreeBSD Hypertext Man Pages
-   Linux and Solaris 10 Man Pages
-   Linux/FreeBSD Man Pages with user comments
-   Linux man pages at die.net
-   The Linux man-pages project at kernel.org
-   Man-Wiki: Linux / Solaris / UNIX / BSD
-   NetBSD manual pages
-   Mac OS X Manual Pages
-   On-line UNIX manual pages
-   OpenBSD manual pages
-   Plan 9 Manual — Volume 1
-   Inferno Manual — Volume 1
-   Storage Foundation Man Pages
-   The UNIX and Linux Forums Man Page Repository
-   Ubuntu Manpage Repository

Viewing man pages as PDFs
-------------------------

man pages have always been printable: they are written in troff, which
is fundamentally a typesetting language. If you have ghostscript
installed, converting a man page to PDF is actually very easy:
man -t <manpage> | ps2pdf - <pdf>. This google image search should give
you an idea of what the result looks like; it may not be to everybody's
liking.

Caveats: Fonts are generally limited to Times at hardcoded sizes. There
are no hyperlinks. Some man pages were specifically designed for
terminal viewing, and won't look right in PS or PDF form.

The following perl script converts man pages to PDFs, caches the PDFs in
the $HOME/.manpdf/ directory, and calls a PDF viewer, specifically
mupdf.

    Usage: manpdf [<section>] <manpage>

    #!/usr/bin/perl
    use File::stat;

    $pdfdir = $ENV{"HOME"}."/.manpdf";
    -d $pdfdir || mkdir $pdfdir || die "can't create $pdfdir";
    $manpage = $ARGV[0];
    chop($manpath = `man -w $manpage`);
    die if $?;

    $maninfo = stat($manpath) or die;
    $manpath =~ s@.*/man./(.*)(\.(gz|bz2))?$@$1@;
    $pdfpath = "$pdfdir/$manpath.pdf";
    $pdftime = 0;
    if (-f $pdfpath) {
        $pdfinfo = stat($pdfpath) or die;
        $pdftime = $pdfinfo->mtime;
    }
    if (!-f $pdfpath || $maninfo->mtime > $pdftime) {
        system "man -t $manpage | ps2pdf -dPDFSETTINGS=/screen - $pdfpath";
    }
    die if !-f $pdfpath;
    if (!fork) {
        open(STDOUT, "/dev/null");
        open(STDERR, "/dev/null");
        exec "mupdf", "-r", "96", $pdfpath;
        #exec "acroread", $pdfpath;
    }

Noteworthy manpages
-------------------

Here follows a non-exhaustive list of noteworthy pages that might help
you understand a lot of things more in-depth. Some of them might serve
as a good reference (like the ascii table).

-   ascii(7)
-   boot(7)
-   charsets(7)
-   chmod(1)
-   credentials(7)
-   fstab(5)
-   hier(7)
-   systemd(1)
-   locale(1P)(5)(7)
-   printf(3)
-   proc(5)
-   regex(7)
-   signal(7)
-   term(5)(7)
-   termcap(5)
-   terminfo(5)
-   utf-8(7)

More generally, have a look at category 7 pages:

    $ man -s 7 -k ".*" 

Arch Linux specific pages:

-   archlinux(7)
-   mkinitcpio(8)
-   pacman(8)
-   pacman-key(8)
-   pacman.conf(5)

See also
--------

-   General Recommendations - General Recommendations for Arch

Retrieved from
"https://wiki.archlinux.org/index.php?title=Man_Page&oldid=255065"

Category:

-   System administration
