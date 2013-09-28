LilyPond
========

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Getting Started                                                    |
|     -   1.1 Torn between two operating systems.                          |
|     -   1.2 Installation                                                 |
|                                                                          |
| -   2 Tweaking                                                           |
|     -   2.1 Which editor to use?                                         |
|     -   2.2 Speed up writing notes                                       |
|     -   2.3 More usefull info                                            |
+--------------------------------------------------------------------------+

Getting Started
---------------

Searching for a good software and not trash looking for writing sheet
music in linux? LilyPond! Are you tired of pointing and clicking?
LilyPond! Are you tired of having dual-boot systems so you could just
write music? LilyPond! Are you tired of cracks and illegal software?
LilyPond!

> Torn between two operating systems.

My only barrier on deleting Windows from my hard disk was that i am an
artist. I was searching for a good comercial software for writing sheet
music. I was waiting for years on Sibelius Software to give a port for
linux but like they didn't care. But due to their lack of interest i
have found this amazing software that i could only dream off.

> Installation

For a quick start:

    ~# pacman -S lilypond

To see how this software realy works create a text file called ‘test.ly’
and enter:

    ~# cat > test.ly
    {
     c' e' g' e'
    }

and then hit Ctrl+D to save. To process ‘test.ly’, proceed as follows:

    ~# lilypond test.ly

It will create test.pdf and test.ps files. Open it with your favorite
viewer.

Tweaking
--------

> Which editor to use?

-   VIM

Vim with the possibilities of compiling the code within the program
along with syntax coloring tools and indenting. First install vim
editor.

    ~# pacman -S vim

Go to this Lilypond website [1] and follow the instructions on how to
enable the vim mode. The next thing you need to do is enable the
syntaxses. To do so edit ~/.vimrc with your favorite editor and after
editing your file should look like this:

    ~# nano ~/.vimrc
    set runtimepath+=/usr/share/lilypond/2.12.3/vim/ 
    syntax on		" Turn on colors
    filetype plugin on	" Enables the ftplugin options
    set autoindent		" Automaticaly indent while writing.

Now when you edit a *.ly file you can compile your code with <F5>
button, open PDF viewer with <F6> and play midi with <F4> (timidity).
Config file is in "/usr/share/lilypond/2.12.3/vim/ftplugin/lilypond.vim"
and you can read your options there and edit it.

Click-and-point using evince. [2]

-   Frescobaldi

You can find it in AUR.

-   jEdit with lilyPondTools plugin.

    ~# pacman -S jedit

Open jEdit and go to Plugins -> Plugin Manager. Select Install tab and
click on LilyPondTools. Hit the Install button.

> Speed up writing notes

One other thing that i discoverd is LilyComp [3]. Its purpose is to
speed up writing notes. You need python and tk to use it. I had to edit
two lines (67 and 68) in lilycomp.py to enable deutsch.ly dictionary for
sharp and flat symbols. It uses absolute notation (\relative is not
used.)

> More usefull info

-   For JEdit: Under plugins install LookAndFeel. You can find good
    stuff under Visual.

For better usability my settings are: under Global Options -> Docking
put the Console and Error List to right and LilyPond PDF preview to
bottom under Docking position. Then under View push Alternate docked
window placement and Alternate tool bar placement buttons.

-   For tutorial on how to use this software visit LilyPond [4] website.

Retrieved from
"https://wiki.archlinux.org/index.php?title=LilyPond&oldid=250026"

Category:

-   Applications
