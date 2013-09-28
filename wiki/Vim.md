Vim
===

"Vim is an advanced text editor that seeks to provide the power of the
de-facto UNIX editor ‘vi’, with a more complete feature set."

Vim focuses on keyboard usage, and offers useful features such as syntax
highlighting and scripting capabilities. Vim is not a simple text
editor, like nano or pico. It does require some time to learn, and a
great amount of time to master.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Usage                                                              |
|     -   2.1 Basic editing                                                |
|     -   2.2 Moving around                                                |
|     -   2.3 Repeating commands                                           |
|     -   2.4 Deleting                                                     |
|     -   2.5 Undo and redo                                                |
|     -   2.6 Visual mode                                                  |
|     -   2.7 Search and replace                                           |
|     -   2.8 Saving and quitting                                          |
|     -   2.9 Additional commands                                          |
|                                                                          |
| -   3 Configuration                                                      |
|     -   3.1 Wrap searches                                                |
|     -   3.2 Spell checking                                               |
|     -   3.3 Syntax highlighting                                          |
|     -   3.4 Using the mouse                                              |
|     -   3.5 Traverse line breaks with arrow keys                         |
|     -   3.6 Example ~/.vimrc                                             |
|                                                                          |
| -   4 Merging files (vimdiff)                                            |
| -   5 Vim tips                                                           |
|     -   5.1 Line numbers                                                 |
|     -   5.2 Substitute on lines                                          |
|     -   5.3 Make Vim restore cursor position in files                    |
|     -   5.4 Empty space at the bottom of gVim windows                    |
|     -   5.5 Replace vi command with vim                                  |
|                                                                          |
| -   6 Troubleshooting                                                    |
|     -   6.1 "^M"                                                         |
|                                                                          |
| -   7 See also                                                           |
|     -   7.1 Official                                                     |
|     -   7.2 Tutorials                                                    |
|         -   7.2.1 Videos                                                 |
|         -   7.2.2 Games                                                  |
|                                                                          |
|     -   7.3 Example configurations                                       |
|     -   7.4 Other                                                        |
+--------------------------------------------------------------------------+

Installation
------------

Install the command line version with the vim package, or you can
install the GUI version (which also provides vim) by installing the gvim
package.

Note:The vim package is meant to be as lightweight as possible; hence,
it does not support Python, Lua, and Ruby interpreters, nor does it
support X server options (this means that it will not support copy and
paste from the X clipboard). If you require these options, install the
gvim package instead (it includes the vim binary as well). The
herecura-stable unofficial repository also provides a couple different
Vim / gVim variants:

    $ pacman -Slq herecura-stable | grep vim

    vim-cli
    vim-gvim-gtk
    vim-gvim-motif
    vim-gvim-qt
    vim-gvim-x11
    vim-rt
    vim-tiny

Note:There are some visualization problems in KDE using gvim from
official repositories. In that case you can install vim-gvim-qt from
herecura-stable or vim-qt

Usage
-----

This is a basic overview on how to use Vim. Alternately, running
vimtutor or gvimtutor will launch vim's tutorial, which takes about
25-30 minutes.

Vim has four different modes:

-   Command mode: keystrokes are interpreted as commands.
-   Insert mode: keystrokes are entered into the file.
-   Visual mode: keystrokes select, cut, or copy text
-   Ex mode: input mode for additional commands (e.g. saving a file,
    replacing text...)

> Basic editing

If you start Vim with:

    $ vim somefile.txt

you will see a blank document (providing that somefile.txt does not
exist. If it does, you will see what is in there). You will not be able
to edit right away – you are in Command Mode. In this mode you are able
to issue commands to Vim with the keyboard.

Note:Vim is an example of classic Unix-style ware. It has a steep
learning curve, but once you get started, you will find that it is
extremely powerful. Also, all commands are case sensitive. Sometimes the
uppercase versions are “blunter” versions (s will replace a character, S
will replace a line), other times they are completely different commands
(j will move down, J will join two lines).

You insert text (stick it before the cursor) with the i command. I
(uppercase i) inserts text at the beginning of the line. You append text
(place text after the cursor, what most people expect) with a. Typing A
will place the cursor at the end of the line.

Return to command mode at any time by pressing Esc.

> Moving around

In Vim, you can move the cursor with the arrow keys, but this isn't the
Vim way. You’d have to move your right hand all the way from the
standard typing position all the way to the arrow keys, and then back.
Not fun.

In Vim you can move down by pressing j. You can remember this because
the “j” hangs down. You move the cursor back up by pressing k. Left is h
(it's left of the “j”), and right is l (lowercase L).

^ will put the cursor at the beginning of the line, and $ will place it
at the end.

Note:^ and $ are commonly used in regular expressions to match the
beginning and ending of the line. Regular expressions are very powerful
and are commonly used in *nix environment, so maybe it is a little bit
tricky now, but later you will notice “the idea” behind the use of most
of these key mappings.

To advance a word, press the w key. W will include more characters in
what it thinks is a word (e.g. underscores and dashes as a part of a
word). To go back a word, b is used. Once again, B will include more
characters in what Vim considers a word. To advance to the end of a
word, use e, E includes more characters.

To advance to the beginning of a sentence, ( will get the job done. )
will do the opposite, moving to the end of a sentence. For an even
bigger jump, { will move the the beginning a whole paragraph. } will
advance to the end of a whole paragraph.

To advance to the header (top) of the screen, H will get the job done. M
will advance to the middle of the screen, and L will advance to the last
(bottom). gg will go to the beginning of the file, G will go to the end
of the file. Ctrl+D will let you scroll page by page.

> Repeating commands

If a command is prefixed by a number, then that command will be executed
that number of times over (there are exceptions, but they still make
sense, like the s command). For example, pressing 3i then “Help! ” then
Esc will print “Help! Help! Help!“. Pressing 2} will advance you two
paragraphs. This comes in handy with the next few commands…

> Deleting

The x command will delete the character under the cursor. X will delete
the character before the cursor. This is where those number functions
get fun. 6x will delete 6 characters. Pressing . (dot) will repeat the
previous command. So, lets say you have the word "foobar" in a few
places, but after thinking about it, you’d like to see just “foo”. Move
the cursor under the "b", hit 3x, move to the next "foobar" and hit .
(dot).

The d will tell Vim that you want to delete something. After pressing d,
you need to tell Vim what to delete. Here you can use the movement
commands. dW will delete up to the next word. d^ will delete up unto the
beginning of the line. Prefacing the delete command with a number works
well too: 3dW will delete the next three words. D (uppercase) is a
shortcut to delete until the end of the line (basically d$). Pressing dd
will delete the whole line.

To delete then replace the current word, place the cursor on the word
and execute the command cw. This will delete the word and change to
insert mode. To replace only a single letter use r.

> Undo and redo

Vim has a built-in clipboard (also known as a buffer). Actions can be
undone with u and redone with Ctrl+r.

> Visual mode

Pressing v will put you in visual mode . Here you can move around to
select text, when you’re done, you press y to yank the text into the
buffer (copy), or you may use c to cut. p pastes after the cursor, P
pastes before. V, Visual Line mode, is the same for entire lines. Ctrl+v
is for blocks of text.

Note:Whenever you delete something, that something is placed inside a
buffer and is available for pasting.

> Search and replace

To search for a word or character in the file, simply use / and then the
characters your are searching for and press enter. To view the next
match in the search press n, press N for the previous match.

To search and replace use the substitute :s/ command. The syntax is:
[range]s///[arguments]. For example:

    Command        Outcome
    :s/xxx/yyy/    Replace xxx with yyy at the first occurence
    :s/xxx/yyy/g   Replace xxx with yyy first occurrence, global (whole sentence)
    :s/xxx/yyy/gc  Replace xxx with yyy global with confirm
    :%s/xxx/yyy/g  Replace xxx with yyy global in the whole file

You can use the global :g/ command to search for patterns and then
execute a command for each match. The syntax is: [range]:g//[cmd].

    Command  Outcome
    :g/^#/d  Delete all lines that begins with #
    :g/^$/d  Delete all lines that are empty

> Saving and quitting

To save and/or quit, you will need to use Ex mode. Ex mode commands are
preceded by a :. To write a file use :w or if the file doesn’t have a
name :w filename. Quitting is done with :q. If you choose not to save
your changes, use :q!. To save and quit :x.

> Additional commands

1.  Pressing s will erase the current letter under the cursor, and place
    you in insert mode. S will erase the whole line, and place you in
    insert mode.
2.  o will create a newline below the line and put you insert mode, O
    will create a newline above the line and put you in insert mode.
3.  yy will yank an entire line
4.  cc will delete the current line and place you in insert mode.
5.  * will highlight the current word and n will search it

Configuration
-------------

Vim's user-specific configuration file is located in the home directory:
~/.vimrc, and files are located inside ~/.vim/ The global configuration
file is located at /etc/vimrc. Global files are located inside
/usr/share/vim/.

The Vim global configuration in Arch Linux is very basic and differs
from many other distributions' default Vim configuration file. To get
some commonly expected behaviors (such as syntax highlighting, returning
to the last known cursor position), consider using Vim's example
configuration file:

    # mv /etc/vimrc /etc/vimrc.bak
    # cp /usr/share/vim/vim73/vimrc_example.vim /etc/vimrc

> Wrap searches

With this option the search next behaviour allows to jump to the
beginning of the file, when the end of file is reached. Similarly,
search previous jumps to the end of the file when the start is reached.

    set wrapscan

> Spell checking

    set spell

With this setting, Vim will highlight incorrectly spelled words. Place
the cursor on a misspelled word and enter z= to view spelling
suggestions.

Only English language dictionaries are installed by default, more can be
found in the official repositories. To get the list of available
languages type:

    # pacman -Ss vim-spell

Language dictionaries can also be found at the Vim FTP archive. Put the
downloaded dictionar(y/ies) into the ~/.vim/spell folder and set the
dictionary by typing: :setlocal spell spelllang=LL

Tip:

-   To enable spell checking for LaTeX (or TeX) documents only, add
    autocmd FileType tex setlocal spell spelllang=en_us into your
    ~/.vimrc or /etc/vimrc, and then restart Vim. For spell checking of
    languages other than English, simply replace en_us with the value
    appropriate for your language.
-   To enable spelling in two languages (for instance English and
    German), add set spelllang=en,de into your ~/.vimrc or /etc/vimrc,
    and then restart Vim.
-   You can enable spell checking for arbitrary file types (e.g. *.txt)
    by using the FileType plugin and a custom rule for file type
    detection. To enable spell checking for any file ending in *.txt,
    create the file /usr/share/vim/vimfiles/ftdetect/plaintext.vim, and
    insert the line
    autocmd BufRead,BufNewFile *.txt    setfiletype plaintext into that
    file. Next, insert the line
    autocmd FileType plaintext setlocal spell spelllang=en_us into your
    ~/.vimrc or /etc/vimrc, and then restart Vim.

> Syntax highlighting

To enable syntax highlighting (Vim supports a huge list of programming
languages):

    :filetype plugin on
    :syntax on

> Using the mouse

Vim has the ability to make use of the mouse, but requires xterm's mouse
reporting feature.

1.  See the example .vimrc below to enable the mouse.
2.  Use xterm. In your console: export TERM=xterm-256color or
    export TERM=xterm

Notes:

-   This even works in PuTTY over SSH.
-   In PuTTY, the normal highlight/copy behaviour is changed because Vim
    enters visual mode when the mouse is used. To select text with the
    mouse normally, hold down the Shift key while selecting text.

> Traverse line breaks with arrow keys

By default, pressing ← at the beginning of a line, or pressing → at the
end of a line, will not let the cursor traverse to the previous, or
following, line.

The default behavior can be changed by adding set whichwrap=b,s,<,>,[,]
to your ~/.vimrc file.

> Example ~/.vimrc

An example Vim configuration.

Merging files (vimdiff)
-----------------------

Vim includes a diff editor (a program that can merge differences between
two files). vimdiff will open colored windows each showing the content
of the file with colored highlights of the differences, line by line.
You are left with two modes: the insert one, which let you edit the
file, and the screen mode, which let you move around windows and lines.
Begin by running vimdiff file1 file2. Some example commands are found
below:

]c  
    next difference
[c  
    previous difference
Ctrl+w+w  
    switch windows
i  
    enter Insert mode
Esc  
    exit Insert mode
p  
    paste a line
do  
    diff obtain. when cursor is on a highlighted difference and changes
    from other window will move into the current one
dp  
    diff put. same as diff obtain but will put the changes from current
    windows into the other one
zo  
    open folded text
zc  
    close folded text
:diffupdate 
    re-scan the files for differences
yy  
    copy a line
:wq  
    save and exit the current window
:wqa  
    save and exit both windows
:q!  
    exit without saving

Once your file has been correctly edited taking account changes in
file.pacnew:

    # mv file file.bck
    # mv file.pacnew file

Check if your new file is correct, then remove your backup:

    # rm file.bck

Vim tips
--------

Specific user tricks to accomplish tasks.

> Line numbers

1.  Show line numbers by :set number.
2.  Jump to line number :<line number>.

> Substitute on lines

To only substitute between certain lines:

    :n,ns/one/two/g

For example, to replace instances of 'one' with 'two' between lines 3
and 4, one would execute:

    :3,4s/one/two/g

> Make Vim restore cursor position in files

If you want the cursor to appear in its previous position after you open
a file, add the following to your ~/.vimrc:

    if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    endif

See also this tip in Vim Wiki.

> Empty space at the bottom of gVim windows

When using a window manager configured to ignore window size hints, gVim
will fill the non-functional area with the GTK theme background color.

A solution is to make a more pleasing background color: just put the
following lines in ~/.gtkrc-2.0:

    style "vimfix" {
      bg[NORMAL] = "#242424" # this matches my gVim theme 'Normal' bg color.
    }
    widget "vim-main-window.*GtkForm" style "vimfix"

> Replace vi command with vim

Run the following commands:

    # ln -s $(which vim) /usr/local/bin/vi
    # ln -s $(which vim) /usr/local/bin/view

Also see http://superuser.com/questions/27091/vim-to-replace-vi

Troubleshooting
---------------

> "^M"

There is a "^M" at the end of each line. This usually happens when you
are editing a text file which was created in MS-DOS or Windows.

Solution: Replace all "^M" using the command:

    :%s/^M//g

Pay attention, "^" is the control letter, press Ctrl+Q to get the right
"^".

Alternatively, install the package dos2unix from the official
repositories, and run dos2unix <file name here>.

See also
--------

> Official

-   Homepage
-   Documentation
-   Tips Wiki

> Tutorials

-   vi Tutorial and Reference Guide
-   Graphical vi-Vim Cheat Sheet and Tutorial
-   Vim Introduction and Tutorial
-   Open Vim - Collection of Vim learning tools
-   Learn Vim Progressively
-   know vim

Videos

-   Vimcasts - Screencasts in .ogg format.
-   Tutorial Videos - Covering the basics up to advanced topics.

Games

-   Vim Adventures
-   VimGolf

> Example configurations

-   nion's
-   A detailed configuration from Amir Salihefendic
-   Bart Trojanowski
-   Steve Francia's Vim Distribution

> Other

-   HOWTO Vim - Gentoo wiki article which this article was based on
    (author unknown).
-   Vivify - A ColorScheme Editor for Vim

Retrieved from
"https://wiki.archlinux.org/index.php?title=Vim&oldid=255248"

Categories:

-   Development
-   Text editors
