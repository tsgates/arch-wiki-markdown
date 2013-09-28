fbpad
=====

  Summary
  ---------------------------------------------------------
  Information on installing, configuring, and using fbpad

fbpad is a small framebuffer terminal that manages many terminals
through single character tags. It is exceptionally lightweight, being
written in C and using its own font format, tinyfont, which avoids xorg
font dependencies. fbpad optionally supports 256 colors, bold fonts, and
saving the framebuffer contents to memory, all which combined make fbpad
a viable alternative to the X server for many purposes.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Tag Colors                                                   |
|     -   2.2 Fonts                                                        |
|     -   2.3 Color Support                                                |
|                                                                          |
| -   3 Usage                                                              |
|     -   3.1 Copying Text                                                 |
|     -   3.2 Watching YouTube                                             |
|                                                                          |
| -   4 Recommended Programs                                               |
| -   5 External Links                                                     |
+--------------------------------------------------------------------------+

Installation
------------

fbpad-git can be installed from the AUR, which by default imports the
"bold" and "scrsnap" branches of fbpad, which add in 256-colors and bold
fonts, and saving the contents of the framebuffer, respectively. fbpad
is customized via a config.h file, and edits to the config.h file are
incorporated into fbpad after recompiling fbpad, using the command
makepkg --skipinteg -i.

Configuration
-------------

Users most likely will want to edit the definitions in the config.h for
fonts (more on this later), SHELL, MAIL, and EDITOR prior to use, to
their preferred programs.

dwm users should have no problems accustoming to fbpad. fbpad-specific
keybindings are initiated with the modifier key, which is hardcoded as
the Alt key, just like in dwm. Alt+j and Alt+k switch between terminals
in an open tag, Alt+o switches to the last open tag, and Alt+p shows the
list of open tags, to name a few. Users comfortable with manually
patching source code can edit the fbpad.c file to edit/add keybindings.

If you re-compile fbpad often, you would probably like to be able to
reload fbpad without having to manually re-launch it. The following code
starts fbpad post login in tty1 and will reload it if you quit fbpad
with Ctrl+Alt+q.

    if [[ $(tty) = /dev/tty1 ]]; then
      while true; do
        fbpad >/dev/null 2>&1
      done
    fi

Place this at the end of your shellrc file.

> Tag Colors

The default background of the list of tags is hardcoded as white, the
foreground of empty tags as black, the foreground of fully occupied tags
as green (each tag may contain two terminals), and the foreground of
tags that are not fully occupied as blue. This color scheme clearly is
not for everyone, but this is easily remedied with the following patch:

    --- a/fbpad.c	2011-11-11 13:02:22.834825518 -0500
    +++ b/fbpad.c	2011-11-11 13:04:07.016043271 -0500
    @@ -110,7 +110,7 @@
     
     static void showtags(void)
     {
    -	int colors[] = {15, 4, 2};
    +	int colors[] = {8, 2, 9};
     	int c = 0;
     	int r = pad_rows() - 1;
     	int i;
    @@ -128,7 +128,7 @@
     			nt++;
     		pad_put(i == ctag ? '(' : ' ', r, c++, FGCOLOR, BGCOLOR);
     		if (TERMSNAP(i))
    -			pad_put(tags[i], r, c++, !nt ? BGCOLOR : colors[nt], 15);
    +			pad_put(tags[i], r, c++, !nt ? 8 : colors[nt], BGCOLOR);
     		else
     			pad_put(tags[i], r, c++, colors[nt], BGCOLOR);
     		pad_put(i == ctag ? ')' : ' ', r, c++, FGCOLOR, BGCOLOR);

To use, replace "8" with the desired color for empty tags (in both
instances), "2" with the desired color for not fully occupied tags, and
"9" with the desired color for fully occupied tags, where the colors
0-15 are defined in the config.h file. This patch also makes the default
background color the background color of your terminal, which the writer
finds to be a more natural choice.

Note that the second "8" is the color for tags for which fbpad saves the
framebuffer contents. If you choose to define TAGS_SAVED as TAGS, then
you will want your default foreground color and the color for saved tags
to be the same, i.e. "8" in both instances. Otherwise, you may define
TAGS_SAVED as a concatenated string of the tags to be saved, and change
the second "8" to the color you wish to indicate saved tags by. The
writer herself saves all tags for convenience.

Save the patch as fbpad-tagcolor.diff, add 'fbpad-tagcolor.diff' to your
source array, and the following line to the PKGBUILD after the line that
copies the config.h file:

    patch -p1 -i "${srcdir}/${_gitname}-tagcolor.diff" || return 1

> Fonts

The font format for fbpad is the "tinyfont", and there exists a utility,
ft2tf, which converts TTF files to the tinyfont format. You will need to
edit the config.h file in the ft2tf build directory to point to the TTF
file of your desired font. For instance, if the font file
MonteCarloFixed.ttf was located in $HOME/.fonts directory, you would
edit line 10 of the config.h to look like the following:

    {"/home/archie/.fonts/MonteCarloFixed12.ttf", 6},

if your username was "archie", and the font size of Monte Carlo you
wished to create was size 6. Delete other font lines you see other than
this one, unless you wish to supplement your font with the glyphs from
another font, in which case, add lines like the one above for your other
TTF fonts.

Then, run makepkg -skipinteg -i to rebuild and reinstall the package
with your customized settings.

After installing ft2tf, the following command creates a tinyfont file:

    $ ft2tf > MyFont.tf

where "MyFont" can be replaced with a name of your choosing.

Remember to edit your config.h to point to the directory where you save
your MyFont.tf. If your font also has a bold face, repeat the process of
editing the ft2tf config.h file, this time specifying the location of
the boldface TTF file in the ft2tf config.h, rebuilding with makepkg,
and adding the final boldface tinyfont location to your fbpad config.h.

Also note that some fonts might require modification of the WIDTHDIFF
and HEIGHTDIFF to have the proper width and height, respectively.

> Color Support

By default, the AUR package installs the custom terminfo for fbpad, but
you will need to add

    export TERM=fbpad-256

to your shellrc to take advantage of the 256 color support. Clearly,
commands not spawned in your default shell (for instance, those for
EDITOR and MAIL) will not read your shellrc file, so you will need to
edit their definitions in your config.h file to have the commands for
EDITOR and MAIL run in a parent shell. For instance, the author of this
article, who uses zsh, changed the default command for MAIL from:

    #define MAIL		"mailx"

to

    #define MAIL		"zsh -i -c mailx"

Additionally, to have colors with the ls command, "fbpad-256" needs to
be added to the list of terms that ls knows can handle color. Per the
README, run the following command in your shell:

    $ dircolors --print-database | sed '/^TERM linux$/aTERM fbpad-256' >$HOME/.dircolors

and add eval `dircolors ~/.dircolors` to your shellrc file so that the
custom dircolors file, with the fbpad-256 term added, may be loaded.

Usage
-----

The following are examples of how some general desktop needs may be
implemented in fbpad.

> Copying Text

As everything is done mouselessly in fbpad, to copy text, users can make
a "screenshot" of all the text on the screen with the Alt+s command.
This will save all viewable text to the file /tmp/scr. Then, if your
shell supports editing the commandline with vim (for instance, the
edit-command-line ZLE function in zsh), you can open the /tmp/scr file
as a new buffer in vim and use its copy keybindings to paste the needed
text into your original buffer. Emacs users probably can adopt a similar
scheme to copy text.

> Watching YouTube

If one is using MPlayer with the video output driver set to fbdev2,
youtube-viewer can be used for searching YouTube and watching with
MPlayer from the commandline in fbpad. Alternatively, one can add the
following script as an external browser in the commandline web browser
w3m, and launch playback of videos from YouTube websites with one's
media player of choice. The script below employs fbff-git, a lightweight
media player also written by the author of fbpad, and yturl, a simple
program, that, rather UNIX-like, functions solely to convert YouTube
URLs into directly watchable URLs.

    #!/bin/sh
    video=$(yturl $1)
    fbff -f $video > /dev/null 2>&1

Save the file in your PATH as youtube.sh, and add it as an external
browser to w3m by opening w3m, hitting the o key to edit options, and
edit the "External Browser" field under "External Program Settings" by
entering in the field "youtube.sh". Hit "OK", and you are done. Now,
when wishing to watch a video, with YouTube open, hit the M key, and the
video will begin streaming instantly in fbff.

Recommended Programs
--------------------

Here are a few recommendations for programs that enhance the usability
of a framebuffer-based desktop:

-   dvtm - a dynamic virtual terminal manager (think dwm, but for the
    console)
-   fbcat - a framebuffer screenshot grabber
-   fbff-git - an ffmpeg-based media player
-   fbpdf-git - a MuPDF-based PDF viewer, optionally supports DjVu or
    rendering via poppler
-   fbv - an image viewer
-   screen - a terminal multiplexer
-   w3m - a commandline web browser

External Links
--------------

-   fbpdf, fbpad, and fbff - A Minimal Framebuffer Software Suite
-   litcave, the homepage of Ali Gholami Rudi's software projects

Retrieved from
"https://wiki.archlinux.org/index.php?title=Fbpad&oldid=236436"

Category:

-   Terminal emulators
