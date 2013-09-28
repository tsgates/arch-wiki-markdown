nano
====

GNU nano (or nano) is a text editor which aims to introduce a simple
interface and intuitive command options to console based text editing.
nano is the default console editor in distributions such as Ubuntu and
supports features including colorized syntax highlighting, DOS/Mac file
type conversions, spellchecking and UTF-8 encoding. nano opened with an
empty buffer typically occupies under 1.5 MB of resident memory. nano
Screenshot.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Package installation                                               |
| -   2 Configuration                                                      |
|     -   2.1 Creating ~/.nanorc                                           |
|     -   2.2 Syntax highlighting                                          |
|         -   2.2.1 for PKGBUILD files                                     |
|         -   2.2.2 Other definitions                                      |
|                                                                          |
|     -   2.3 Suggested configuration                                      |
|         -   2.3.1 Suspension                                             |
|         -   2.3.2 Do not wrap text                                       |
|                                                                          |
| -   3 nano usage                                                         |
|     -   3.1 Special functions                                            |
|         -   3.1.1 Shortcut lists overview                                |
|         -   3.1.2 Selected toggle functions                              |
|                                                                          |
| -   4 Tips & tricks                                                      |
|     -   4.1 Replacing vi with nano                                       |
|         -   4.1.1 Method one                                             |
|             -   4.1.1.1 Example usage                                    |
|                                                                          |
|         -   4.1.2 Method two                                             |
|             -   4.1.2.1 Example .bash_profile                            |
|                                                                          |
|         -   4.1.3 Method three                                           |
|             -   4.1.3.1 Symbolic linking                                 |
|             -   4.1.3.2 Restoration of vi                                |
|                                                                          |
|         -   4.1.4 Method four                                            |
|             -   4.1.4.1 Removal & symbolic linking                       |
|             -   4.1.4.2 Restoration of vi                                |
|                                                                          |
| -   5 Additional resources                                               |
+--------------------------------------------------------------------------+

Package installation
--------------------

nano is part of the Arch Linux [core] repository, usually installed by
default by AIF.

Configuration
-------------

> Creating ~/.nanorc

The look, feel and function of nano is typically controlled by way of
either command-line arguments, or configuration commands within the file
~/.nanorc.  
 A sample configuration file is installed upon program installation and
is located at /etc/nanorc.The file ~/.nanorc must be first created by
the user:

    $ cd ~
    $ touch .nanorc

or

    $ cp /etc/nanorc ~/.nanorc

Proceed to establish the nano console environment by setting and/or
unsetting commands within .nanorc file.

Tip:NANORC details the complete list configuration commands available
for nano.

Note:Command-line arguments override and take precedence over the
configuration commands established in .nanorc

> Syntax highlighting

for PKGBUILD files

This new version highlights like the Arch Linux "svntogit-server".

    # Arch PKGBUILD files
    #
    syntax "pkgbuild" "^.*PKGBUILD*"
    # commands
    color red "\<(cd|echo|enable|exec|export|kill|popd|pushd|read|source|touch|type)\>"
    color brightblack "\<(case|cat|chmod|chown|cp|diff|do|done|elif|else|esac|exit|fi|find|for|ftp|function|grep|gzip|if|in)\>"
    color brightblack "\<(install|ln|local|make|mv|patch|return|rm|sed|select|shift|sleep|tar|then|time|until|while|yes)\>"
    # ${*}
    icolor blue "\$\{?[0-9A-Z_!@#$*?-]+\}?"
    # numerics
    color blue "\ [0-9]*"
    color blue "\.[0-9]*"
    color blue "\-[0-9]*"
    color blue "=[0-9]"
    # spaces
    color ,green "[[:space:]]+$"
    # strings; multilines are not supported
    color brightred ""(\\.|[^"])*"" "'(\\.|[^'])*'"
    # comments
    color brightblack "#.*$"

This is another version from this forum thread.

    ## Arch PKGBUILD files
    ##
    syntax "pkgbuild" "^.*PKGBUILD$"
    color green start="^." end="$"
    color cyan "^.*(pkgbase|pkgname|pkgver|pkgrel|pkgdesc|arch|url|license).*=.*$"
    color brightcyan "\<(pkgbase|pkgname|pkgver|pkgrel|pkgdesc|arch|url|license)\>"
    color brightcyan "(\$|\$\{|\$\()(pkgbase|pkgname|pkgver|pkgrel|pkgdesc|arch|url|license)(|\}|\))"
    color cyan "^.*(depends|makedepends|optdepends|conflicts|provides|replaces).*=.*$"
    color brightcyan "\<(depends|makedepends|optdepends|conflicts|provides|replaces)\>"
    color brightcyan "(\$|\$\{|\$\()(depends|makedepends|optdepends|conflicts|provides|replaces)(|\}|\))"
    color cyan "^.*(groups|backup|noextract|options).*=.*$"
    color brightcyan "\<(groups|backup|noextract|options)\>"
    color brightcyan "(\$|\$\{|\$\()(groups|backup|noextract|options)(|\}|\))"
    color cyan "^.*(install|source|md5sums|sha1sums|sha256sums|sha384sums|sha512sums).*=.*$"
    color brightcyan "\<(install|source|md5sums|sha1sums|sha256sums|sha384sums|sha512sums)\>"
    color brightcyan "(\$|\$\{|\$\()(install|source|md5sums|sha1sums|sha256sums|sha384sums|sha512sums)(|\}|\))"
    color brightcyan "\<(startdir|srcdir|pkgdir)\>"
    color cyan "\.install"
    color brightwhite "=" "'" "\(" "\)" "\"" "#.*$" "\," "\{" "\}"
    color brightred "build\(\)"
    color brightred "package_.*.*$"
    color brightred "\<(configure|make|cmake|scons)\>"
    color red "\<(DESTDIR|PREFIX|prefix|sysconfdir|datadir|libdir|includedir|mandir|infodir)\>"

To use, save as /usr/share/nano/pkgbuild.nanorc and add:

    include "/usr/share/nano/pkgbuild.nanorc"

to your ~/.nanorc or to /etc/nanorc.

Other definitions

Syntax highlighting enhancements which replace and expand the defaults
can be found in the AUR, nano-syntax-highlighting-git.

> Suggested configuration

Suspension

Unlike most interactive programs, suspension is not enabled by default.
To change this, uncomment the 'set suspend' line in /etc/nanorc. This
will allow you to use the keys Ctrl+z to send nano to the background.

Do not wrap text

If you are coming from another distribution, you might wonder about
nano's strange behaviour, so just edit /etc/nanorc like this:

    ## Do not wrap text at all.
    set nowrap

nano usage
----------

> Special functions

-   Ctrl key modified shortcuts (^) representing commonly used functions
    are listed along the bottom two lines of the nano screen.
-   Additional functions can be interactively toggled by way of Meta
    (typically Alt) and/or Esc key modified sequences.

Shortcut lists overview

-   ^G Get Help (F1)

Displays the online help files within the session window. A suggested
read for nano users of all levels

-   ^O WriteOut (F3)

Save the contents of the current file buffer to a file on the disk

-   ^R Read File (F5)

Inserts another file into the current one at the cursor location

-   ^Y Prev Page (F7)

Display the previous buffered screen

-   ^K Cut Text (F9)

Cut and store the current line from the beginning of the line to the end
of the line

-   ^C Cur Pos (F11)

Display line, column and character position information at the current
location of the cursor

-   ^X Exit (F2)

Close and exit nano

-   ^J Justify (F4)

Aligns text according to the geometry of the console window

-   ^W Where (F6)

Perform a case-insensitive string, or regular expression search

-   ^V Next Page (F8)

Display the next buffered screen

-   ^U UnCut Text (F10)

Paste the contents of the cut buffer to the current cursor location

-   ^T To Spell (F12)

Spellcheck the contents of the buffer with the built-in spell, if
available

Tip:See the nano online help files via Ctrl+g within nano and the nano
Command Manual for complete descriptions and additional support.

Selected toggle functions

-   Meta+c (or Esc+c)

Toggles support for line, column and character position information.

-   Meta+i (or Esc+i)

Toggles support for the auto indentation of lines

-   Meta+k (or Esc+k)

Toggles support for cutting text from the current cursor position to the
end of the line

-   Meta+m (or Esc+m)

Toggles mouse support for cursor placement, marking and shortcut
execution

-   Meta+x (or Esc+x)

Toggles the display of the shortcut list at the bottom of the nano
screen for additional screen space

Tip:Feature Toggles lists the global toggles available for nano.

Tips & tricks
-------------

> Replacing vi with nano

Casual users may prefer the use of nano over vi for its simplicity and
ease of use and may opt to replace vi with nano as the default text
editor for commands such as visudo.

Method one

Warning:From man 8 visudo: Note that this can be a security hole since
it allows the user to execute any program they wish simply by setting
VISUAL or EDITOR.

sudo from the core repository is compiled with --with-env-editor by
default and honors the use of the VISUAL and EDITOR variables. To
establish nano as the visudo editor for the duration of the current
shell session, set and export the EDITOR variable before calling visudo.

    export EDITOR=nano 

Example usage

     export EDITOR=nano && sudo visudo

Method two

Warning:From man 8 visudo: Note that this can be a security hole since
it allows the user to execute any program they wish simply by setting
VISUAL or EDITOR.

The EDITOR variable can also be set within the following files for
persistent use:

-   ~/.bash_profile (login shell)
-   ~/.bashrc (interactive, non-login shell)
-   /etc/profile (global settings for all system users except root)

Example .bash_profile

    . $HOME/.bashrc

Method three

Note:This method can be considered draconian and may not be suitable for
all users. Nonetheless, the following procedure exists as a viable
example solution.

Symbolic linking

As root, or with su -

Rename the vi executable to vi.old for ease of restoration:

    # mv /usr/bin/vi /usr/bin/vi.old

Create a symbolic link from /usr/bin/nano to /usr/bin/vi

    # ln -s /usr/bin/nano /usr/bin/vi

Assuming sudo is installed and properly configured. You will need to add
vi to the IgnorePkg list in pacman.conf to make this permanent.
Otherwise it will revert back to vi the next time it is updated.

Restoration of vi

Remove the /usr/bin/vi symbolic link:

    unlink /usr/bin/vi

Rename the vi.old executable back to vi:

    mv /usr/bin/vi.old /usr/bin/vi

Method four

Note:This method can be considered draconian and may not be suitable for
all users. Nonetheless, the following procedure exists as a viable
example solution.

Removal & symbolic linking

Use pacman to remove the vi package, its configuration, and all unneeded
dependencies:

    pacman -Rns vi

Create a symbolic link from /usr/bin/nano to /usr/bin/vi:

    ln -s /usr/bin/nano /usr/bin/vi

Restoration of vi

Remove the /usr/bin/vi symbolic link:

    unlink /usr/bin/vi

Use pacman to install the previously deinstallled vi package:

    pacman -S vi

Note:Do not clean -c or refresh -y the package database if you wish to
retain the previously installed version of the vi package.  
If this case, subsequent updates will also require the judicious use of
the --ignore vi switch (and optionally
--ignore glibc ncurses coreutils).

Additional resources
--------------------

-   nano (text editor) - Wikipedia Entry
-   GNU nano Homepage - Official Site
-   GNU nano Bugs Bug Reporting
-   Better syntax highlighting definitions

Retrieved from
"https://wiki.archlinux.org/index.php?title=Nano&oldid=250879"

Category:

-   Text editors
