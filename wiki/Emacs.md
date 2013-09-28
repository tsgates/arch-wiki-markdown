Emacs
=====

  Summary
  --------------------------------------------------------
  Tutorial on acquiring and using the Emacs text editor.

Emacs is the extensible, customizable, self-documenting real-time
display editor. At the core of Emacs lies an Emacs Lisp interpreter, the
language in which the majority of Emacs' built-in functionality and
extensions are implemented. GTK is the default X toolkit used as of GNU
Emacs 22, though it functions equally well within a CLI environment. The
text-editing capabilities of Emacs are often compared to that of vim.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Running Emacs                                                      |
|     -   2.1 Normal way                                                   |
|     -   2.2 No Colors                                                    |
|     -   2.3 As a daemon                                                  |
|     -   2.4 As a systemd unit                                            |
|                                                                          |
| -   3 Quick Start                                                        |
|     -   3.1 Basic terminology and convention                             |
|     -   3.2 Movement                                                     |
|     -   3.3 Files and buffers                                            |
|     -   3.4 Editing                                                      |
|     -   3.5 Killing, yanking and regions                                 |
|     -   3.6 Search and replace                                           |
|     -   3.7 Prefix arguments                                             |
|     -   3.8 Windows and frames                                           |
|     -   3.9 Modes                                                        |
|                                                                          |
| -   4 Tips and tricks                                                    |
|     -   4.1 TRAMP                                                        |
|     -   4.2 Keyboard macros and registers                                |
|     -   4.3 Regular expressions                                          |
|     -   4.4 Rectangular selections                                       |
|     -   4.5 Bookmarks                                                    |
|     -   4.6 Elisp interpreter                                            |
|     -   4.7 Smart window switch                                          |
|     -   4.8 Shell calls                                                  |
|     -   4.9 Shell buffers                                                |
|     -   4.10 Show matching parentheses                                   |
|     -   4.11 Spell checking                                              |
|     -   4.12 Tables                                                      |
|     -   4.13 Agenda, spreadsheet and document authoring                  |
|     -   4.14 Refactoring and smart completion                            |
|         -   4.14.1 Features                                              |
|         -   4.14.2 Configuration                                         |
|         -   4.14.3 Further reading                                       |
|                                                                          |
|     -   4.15 Using Emacs as git mergetool                                |
|                                                                          |
| -   5 Customization                                                      |
|     -   5.1 Multiple configurations                                      |
|     -   5.2 Loading extensions                                           |
|     -   5.3 Local and custom variables                                   |
|     -   5.4 Custom colors and theme                                      |
|     -   5.5 SyncTeX support                                              |
|                                                                          |
| -   6 Documentation                                                      |
|     -   6.1 Contextual help                                              |
|     -   6.2 The Manuals                                                  |
|                                                                          |
| -   7 Extensions                                                         |
|     -   7.1 Emacs MediaWiki                                              |
|                                                                          |
| -   8 Troubleshooting                                                    |
|     -   8.1 Colored output issues                                        |
|     -   8.2 Menus appear empty                                           |
|     -   8.3 Problems displaying characters in X Windows                  |
|     -   8.4 Slow startup                                                 |
|     -   8.5 Cannot open load file: ...                                   |
|     -   8.6 Dead-accent keys problem: '<dead-acute> is undefined'        |
|     -   8.7 C-M-% and some other bindings do not work in emacs nox       |
|     -   8.8 Emacs client gets stuck when switching back to it            |
|                                                                          |
| -   9 Alternatives                                                       |
|     -   9.1 mg                                                           |
|     -   9.2 zile                                                         |
|     -   9.3 uemacs                                                       |
|                                                                          |
| -   10 See also                                                          |
+--------------------------------------------------------------------------+

Installation
------------

Emacs comes in several variants (sometimes referred to as emacsen). The
most common of these is GNU Emacs.

Install emacs, available in the Official Repositories. If you usually
work in a terminal, you may prefer the emacs-nox variant without GTK
(nor sound and other fancy stuff).

Another common variant is xemacs.

Running Emacs
-------------

Before launching emacs, you should know how to close it (especially if
you run it in a terminal) : use the Ctrl+xCtrl+c key sequence.

> Normal way

To start Emacs run:

    $ emacs

or, to use it from the console:

    $ emacs -nw

If you installed the nox version, 'emacs' and 'emacs -nw' will be the
same.

A file name can also be provided to open that file immediately:

    $ emacs filename.txt

> No Colors

By default, Emacs starts with a color theme showing hyperlinks in dark
blue. To start Emacs without any color theme or scheme:

    $ emacs -nw --color=no

This will cause all text to appear in white color only.

> As a daemon

Emacs can take some time to start since it has to load the .emacs file
each time. Besides, you may want to access the same files from differant
instances. Since version 23, Emacs is capable to run as a daemon to
which users can connect. To run Emacs as a daemon:

    $ emacs --daemon

You are likely to start the daemon at startup time and to connect a
window to the daemon. Besides, it is possible to connect both graphical
and console clients to the daemon at the same time and make the GUI to
start quickly.

If you want to connect to the daemon simply use the folowing command
(note that it will start a graphical client if called in a graphical
environment or a console client if called in a console like a tty):

    $ emacsclient

If you still want a console client no matter you are in a graphical
environment then use:

    $ emacsclient -t

Furthermore, you can add the -a "" parameter. Now, the first time you
call the command, it will start emacs as a daemon, so that it remains
running in background to improve startup time for future calls (and to
remember buffers as well).

You could use the following shell configuration:

    alias emacs='emacsclient -t -a ""'
    EDITOR='emacsclient -t -a ""'

but it has some caveats: many program will fail to load the external
editor because of the spaces in the command.

A more convenient and reliable solution is to write your own script:

    /bin/em

    #!/bin/sh
    emacsclient -a "" -t "$@"

then make it executable:

    # chmod 755 /bin/em

Now 'em' will work just as expected.

With xfce, if you want to tell it to use emacsclient -c instead of
emacs %f when opening a new file, you can change your modify your
emacs.desktop like so:

    /usr/share/applications/emacs.desktop

    ## This line has been commented out:
    #Exec=emacs %f

    ## For this line
    Exec=emacsclient -c

    ## or, if using the preceeding script, uncomment this line instead
    #Exec=em

This way, a client will be called each time you open up a file and so be
very fast!

> As a systemd unit

Note that this method has some caveats though. It seems there is a
limited shell environment which will restrict shell calls, most notably
for compilation mode. You'd be better off using the emacs daemon.

Create a systemd unit for emacs:

    /etc/systemd/system/emacs@.service

    [Unit]
    Description=Emacs: the extensible, self-documenting text editor

    [Service]
    Type=forking
    ExecStart=/usr/bin/emacs --daemon
    ExecStop=/usr/bin/emacsclient --eval "(progn (setq kill-emacs-hook 'nil) (kill-emacs))"
    Restart=always
    User=%i

    [Install]
    WantedBy=multi-user.target

You need to enable the unit so that it gets started on every boot:

    systemctl enable emacs@<username>

To actually use the unit, either reboot or start the unit manually:

    systemctl start emacs@<username>

Quick Start
-----------

Although Emacs is complex, it will not take long to begin to understand
the benefits which the level of customization and extensibility bring.
Furthermore, the comprehensive variety of extensions already available
allows it to be transformed into a powerful environment for almost any
form of text-editing.

Emacs has an excellent built-in tutorial which can be accessed by
clicking the first link on the splash screen; by selecting Help->Emacs
Tutorial from the menu or by pressing 'F1' followed by 't'. This page is
designed to be an additional resource for getting started with Emacs.

Emacs also includes a set of reference cards, useful for beginners and
experts alike, see /usr/share/emacs/<version>/etc/refcards/ (substitute
<version> for your version of emacs).

> Basic terminology and convention

Emacs uses some terminology and conventions which may seem unusual at
first and will be introduced where appropriate. However, there is some
terminology which should be introduced before-hand, as it is fundamental
to working with Emacs.

The one piece of terminology which must be introduced early is the
concept of buffers. A buffer is a representation of data within Emacs.
For example, when a file is opened in Emacs, that file is read from disk
and its contents stored in a buffer, which allows it to be edited and
saved back to disk later. Buffers are not limited to text, and can also
contain images and widgets. Work is in progress to allow buffers to even
display applications! Another way to think of it: data available on disk
is referred to as a 'file', whereas data available in Emacs is referred
to as a 'buffer'.

The convention for key sequences in Emacs may be unfamiliar. Namely:

C-x refers to Control-x

M-x refers to Meta-x

Note:'Meta' corresponds to the Alt key in most cases. Alternatively, the
Esc key can be used.

For example, to exit Emacs use the following key sequence: C-x C-c. This
can be read as "Hold Control and press 'x'. Release. Hold Control and
press 'c'." Although Emacs provides a menu bar, it is recommended
practise to focus on learning the key sequences. This guide will refer
to keybindings with the convention used in Emacs from now on.

> Movement

Cursor movement is very similar to other graphical editors. The mouse
and arrow keys can be used to change the position of the cursor
(referred to as point in Emacs). The standard movement commands
performed by the arrow keys also have more accessible bindings in Emacs.
To move forward one character, use C-f and to move one character
backward, C-b. C-n and C-p can be used to move to the next and previous
lines, respectively. Again, it is generally recommended to use these
key-sequences in preference to the mouse and/or arrow keys.

As might be expected, Emacs provides more advanced movement commands,
including moving by word and sentence. M-f moves forward one word and
M-b will move point one word backward. Similarly, M-e moves point one
sentence forward and M-a one sentence backward.

Until now, all of the movement commands introduced have been relative to
point. M-< can be used to move point to the beginning of the buffer,
with its counterpart, M->, moving to the end of the buffer. To move
point to a specific line number, use M-g g. M-g g will prompt for the
desired line number. Also, to move to the start or end of the current
line, use C-a or C-e, respectively.

Note:Keybindings for these commands, or indeed any command, may differ
slightly depending on which modes are currently active. However, it is
unusual for the replacement command not to provide equivalent
functionality. See Modes for more information.

> Files and buffers

Emacs provides a series of commands to act upon files, the most common
of which will be detailed here. C-x C-f is used to open a file (this
command is called 'find-file' in Emacs). Should the file specified not
exist, Emacs will open an empty buffer. Saving a buffer will create the
file with the buffer's contents. C-x C-s can be used to save a buffer.
To save a buffer with a different filename, use C-x C-w (this is a
mnemonic for the command 'write-file'), which will prompt for the new
filename before writing it to disk. It is also possible to ensure all
buffers are saved with C-x s, which, should a buffer be modified since
its last save, a prompt will be displayed asking which action to take.

Note:C-x C-f does not read the file from disk again if a buffer
corresponding to the file is still opened. To re-read the file from
disk, kill the buffer (C-x k) prior to C-x C-f or use M-x revert-buffer.

Many interactive commands such as "find-file" or "write-file" prompt for
input in the bottom-most line of the Emacs window. This line is referred
to as the minibuffer. The minibuffer supports many basic editing
commands as well as tab-completion similar to that which is available in
many *nix shells. <TAB> can be pressed twice in succession to display a
list of completions, and if desired, the mouse can be also be used to
select a completion from that list. Completion in the minibuffer is
available for many forms of input including commands and filenames.

The minibuffer also provides a history feature. The previous items
entered for a command can be recalled using the Up Arrow or C-p.

To exit the minibuffer at any time, press C-g.

After opening several files, a way to switch between them is needed.
Opening a file corresponding to a buffer already available in Emacs,
will cause Emacs to switch to that buffer. But this is not the most
effective way. Emacs provides C-x b, which prompts for the new buffer to
be displayed (tab-completion is available here). By entering the name of
a buffer which does not exist, a new buffer with that name will be
created.

Note:To switch to the previous buffer use C-x b <RET>, as the previous
buffer is the default.

A list of all open buffers can be displayed using C-x C-b. Should a
buffer no longer be required, it can be removed with C-x k.

> Editing

Many editing commands exist within Emacs. Perhaps the most important
command which has not yet been introduced is 'undo', which can be
performed via C-_ or C-/. Movement commands generally also have a
corresponding delete command. For example, M-<backspace> can be used to
delete a word backwards, and M-d to delete a word forwards. To delete to
the end of the line, or the end of the sentence, use C-k or M-k,
respectively.

It is a rule-of-thumb that no line be allowed to exceed 80 characters.
This aids readability, especially in cases where the line wraps at the
edge of a window. Automatically inserting (or removing) line
separator(s) is known as filling in Emacs. A paragraph can be filled
using M-q.

Characters and words can be transposed using C-t and M-t, respectively.
For example: Hello World! → World! Hello

The case of words is also readily adjustable. M-l downcases a word from
point (HELLO → hello); M-u upcases a word from point (hello → HELLO) and
M-c capitalizes the first character of a word from point while
downcasing the remainder (hElLo → Hello).

> Killing, yanking and regions

A region is a section of text between two positions. One of those
positions is referred to as mark, and the other is point. C-<SPC> is
used to set the position of mark, after which point can be moved to
create a region. Within GNU Emacs 23.1 onwards, this region is visible
by default. There are a number of commands which act upon regions, among
the most commonly used are killing commands.

In Emacs, cut and paste are referred to as kill and yank, respectively.
Many commands which delete more than one character (including many of
those in the above section, such as C-k and M-d) actually cut the text
and append it to what is known as the kill-ring. The kill-ring is simply
a list of killed text. The kill-ring stores up to the last 60 kills by
default. Successive kills are concatenated and stored at the head of the
list.

C-w and M-w can be used to kill and copy a region, respectively.

To insert killed text into a buffer (known as 'yanking'), use C-y. C-y
can be used multiple times in succession to yank text repeatedly. As
mentioned, previous kills are stored in a list, however C-y only
retrieves the first of them. The earlier kills can be accessed via M-y.
This will remove the text inserted by 'yank' initially, replacing it
with the text killed earlier. M-y must be used immediately following C-y
and can be used in many times succession to cycle through the kill-ring.

> Search and replace

Searching for a string is common practise in text-editing. This can be
performed using C-s (to search forward) or C-r (to search backward).
These commands prompt for the string for which to search. Searching is
performed incrementally, and so it will match the next (or previous)
occurrence as you type. To move to the next or previous match, press C-s
or C-r again, respectively. Once a match has been found, <RET> can be
used to end the search. Alternatively, should you wish to return to the
location you initiated the search, use C-g.

Once a search is completed (i.e., was not aborted with C-g or similar),
the string which was searched for will be the default for any following
search. To make use of this, press C-s C-s or C-r C-r to search forward
or backward again, respectively.

Regular Expression searches behave identically to the searching
described above except for the command to initiate the search. Use C-M-s
or C-M-r to initiate a regexp search forward or backward, respectively.
Once a Regular Expression search has commenced, C-s and C-r can be used
to search forward or backward, just as with string searches.

In addition to searching, it is also possible to perform string and
regular expression replacement (via M-% and C-M-%, respectively).
Prompts are provided for both the initial and replacement text, and then
another prompt for the action to perform on the highlighted match.
Although many options are available (the full list is available by
pressing ?), the most commonly used are y, to perform replacement, n, to
skip this match, and ! to replace this, and all following matches.

> Prefix arguments

C-u corresponds to the 'universal-argument' command. Providing a
'universal-argument' is a way to provide more information to a command
(this information is referred to as a 'prefix argument'). For instance

    C-u 80 %

will insert a line of percent signs. Or

    C-u 4 M-d

Will delete 4 words. In this case, we provided the amount of words
desired to the command invoked by M-d.

You can make it a little quicker by using the equivalent M-<number> as
universal argument.

    M-80 %

===Indentation Indentation is usually performed with either <TAB>, to
indent a single line, or with C-M-\, to indent a region. If the region
is active (i.e. highlighted), then <TAB> will also indent region.

Exactly how text is indented usually depends on the major-mode which is
active. Major-modes often define indentation styles specialising in
indenting a certain type of text. (See Modes for more information.)

In some cases, a suitable major-mode may not exist for a file type, in
which case, manual indentation may be necessary. Create a region (see
Killing, yanking and regions) then perform indentation with C-u <n> C-x
<TAB> (where '<n>' is the number of columns which the text within the
region should be indented). For example:

Increase the region's indentation by four columns:

    C-u 4 C-x <TAB>

Decrease the region's indentation by two columns.

    C-u -2 C-x <TAB>

> Windows and frames

Emacs is designed for convenient editing of many files at a time. This
is achieved by dividing the Emacs interface into three levels. Namely,
buffers, which have already been introduced, as well as windows and
frames.

A window is a viewport used for displaying a buffer. A window can
display only one buffer at a time, however one buffer can be displayed
in many windows. Beneath each window exists a mode-line, which displays
information for that buffer.

A frame is an Emacs "window" (in standard terminology. i.e., 'window' in
the sense of the modern desktop paradigm) which contains a title bar,
menu bar and one or more 'windows' (in Emacs terminology. i.e., the
above definition of 'window').

From now on the definition of these terms as they exist in Emacs will be
used.

To split the window vertically or horizontally, use C-x 2 or C-x 3,
respectively. This has the effect of creating another window in the
current frame. To cycle between multiple windows, use C-x o.

The opposite of splitting a window, is deleting it. To delete the
current window, use C-x 0 and C-x 1 to delete all windows except the
current.

As with windows, it is also possible to create and delete frames. C-x 5
2 creates a frame. With C-x 5 0 to delete the current frame and C-x 5 1
to delete all except the current frame.

Note:These commands do not affect buffers. For example, deleting a
window does not kill the buffer it displays.

> Modes

An Emacs mode is an extension written in Emacs Lisp that controls the
behaviour of the buffer it is attached to. Usually it provides
indentation, syntax highlighting and keybindings for editing that form
of text. Sophisticated modes can turn Emacs into a full-fledged IDE
(Integrated Development Environment). Emacs will generally use a file's
extension to determine which mode should be loaded.

Useful modes for editing shell scripts are sh-mode, line-number-mode and
column-number-mode. They can be used in parallel and are invoked by:

M-x sh-mode <RET>

M-x column-number-mode <RET>

line-number-mode is enabled by default, though, it can be toggled on/off
by issuing the command again:

M-x line-number-mode <RET>

sh-mode is a major-mode. Major-modes adjust Emacs, and often also
provide a specialised set of commands, for editing a particular type of
text. Only one major-mode can be active in each buffer. In addition to
syntax highlighting, and indentation support, sh-mode defines several
commands to help write shell scripts. The following shows a few of those
commands:

    C-c (	 Insert a function definition

    C-c C-f	 Insert a 'for' loop

    C-c TAB	 Insert an 'if' statement

    C-c C-w	 Insert a 'while' loop

    C-c C-l	 Insert an indexed loop from 1 to n

'line-number-mode' and 'column-number-mode', are minor-modes.
Minor-modes can be used to extend a major-mode and any number of
minor-modes can be enabled at once.

Tips and tricks
---------------

While the previous sections has given an overview of the basic editing
commands available, it has not given an indication of the possibilities
of Emacs. This section will cover some more advanced techniques and
functionality.

We cannot cover everything as it would be too long. So this section will
only serve as a demo for some dazzling features of Emacs.

See Documentation to get access to more in-depth detail about all
features.

> TRAMP

TRAMP (Transparent Remote Access, Multiple Protocols) is an extension
which, as its name suggests, provides transparent access to remote files
across a number of protocols. When prompted for a filename, entering a
specific form will invoke TRAMP. Some examples:

To prompt for the root password before opening /etc/hosts with root
permissions:

    C-x C-f /su::/etc/hosts

To connect to 'myhost' as 'myuser' via SSH and open the file
~/example.txt:

    C-x C-f /ssh:myuser@myhost:~/example.txt

The path for TRAMP is typically of the form
'/[protocol]:[[user@]host]:<file>'. TRAMP supports much more than the
examples above might indicate. For more information refer to the TRAMP
info manual, which is distributed with Emacs.

> Keyboard macros and registers

This section will provide a practical demonstration of the use of a
couple of more powerful editing features. Namely, keyboard macros and
registers.

The aim will be to produce a listing of a series of characters and their
corresponding position in this list. While it is possible to format each
of them by hand, this would be slow and error-prone. Alternatively, some
of Emacs' more powerful editing functionality could be leveraged. Before
describing a solution, some details behind the techniques which will be
used follow.

The first feature which will be introduced is registers. Registers are
used to store and retrieve a variety of data types ranging from numbers
to window configurations. Each register is given a name of a single
character: this character is used to access the register.

The other which will be demonstrated is keyboard macros. A keyboard
macro stores a sequence of commands so they can be easily repeated
later. These changes will now be performed step-by-step.

Starting with a buffer containing our set of characters:

    ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz

Prepare a register by invoking the `number-to-register' command (C-x r
n) then storing the number '0' in register 'k':

    C-x r n k

With point at the beginning of the buffer, start a keyboard macro (C-x
() and begin to format the characters:

    C-x ( C-f M-4 .

Insert (C-x r i) and increment (C-x r +) the register 'k'. The prefix
argument (C-u) is used to leave point positioned after the inserted
text:

    C-u C-x r i k C-x r + k

Complete the formatting by inserting a newline. Emacs can then repeat
that process, beginning from the point where we started defining the
keyboard macro, for the rest of the characters. C-x e completes then
invokes the keyboard macro. The prefix argument, M-0, causes the macro
to repeat until it comes across an error. In this case it aborts once it
reaches the end of the buffer.

    <RET> M-0 C-x e

The result:

     A....0
     B....1
     C....2
     [...]
     x....49
     y....50
     z....51

If you want to save your macro for leter use, you must give it a name
and save it to your configuration file:

    name-last-kbd-macro 
    insert-kbd-macro

All defined macros are stored in the macro ring. To cycle between
macros, use

    C-x C-k C-n  next macro
    C-x C-k C-p  previous macro

You can also use registers to save virtually anything.

    C-x r SPC Copy current point (position) to register
    C-x r w   Copy current window configuration to register.
    C-x r j   Restore register.

So if you often work with windows side by side, for different project,
you can save the configuration for the different projects and easily
switch from one view to the other.

You can list used registers with the list-registers command.

> Regular expressions

From the Emacs Manual: "A regular expression, or regexp for short, is a
pattern that denotes a (possibly infinite) set of strings." This section
will not go into any detail regarding regular expressions themselves (as
there is simply too much to cover). It will however provide a quick
demonstration of their power. See Regular Expressions section in the
Emacs Manual for further reading.

Given the same scenario presented above: A list of characters which are
to be formatted to represent their respective position in the list. (see
Keyboard macros and registers). Again, starting with a buffer
containing.

    ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz

At the beginning of the buffer, use C-M-% (if the key-sequence is
difficult to perform, it may be more comfortable to use M-x
query-replace-regexp). At the prompt:

    \(.\)

which simply matches one character. Then, when prompted for the
replacement:

    \1....\#^J

Note:'^J' represents where a newline should be placed, it should not be
entered into the prompt. The newline must instead be inserted literally
using C-q C-j.

The replacement expression reads: "Insert the matched text between the
first set of parentheses (in this case, a single character), followed by
4 periods then insert an automatically incremented number followed by a
newline.

Finally, press ! to apply this across the entire buffer. All of the
formatting that was performed in the previous section was performed with
a single regexp replacement.

> Rectangular selections

A very powerful feature you may expect from advanced text editors is the
possibility to select and edit text in a rectangular area.

This also works in Emacs. Select your text as usual with C-SPC. Now you
can use several rectangular command.

    C-x r t  Replace rectangle with text.
    C-x r k  Kill (and save in kill-ring) rectangle.
    C-x r y  Yank rectangle.
    C-x r o  Blank out rectangle.

Note that the command will not affect text outside the rectangle, even
though it is highlighted.

> Bookmarks

Emacs can remember a list of visited files.

    C-x r m Add current buffer to bookmarks.
    C-x r b Open a buffer from bookmarks.
    C-x r l List bookmarks.

> Elisp interpreter

Emacs can evaluate any elisp expression at anytime with the
eval-last-sexp function (bound to C-x C-e by default). Emacs always
spawn a *scratch* buffer when you start it. It will not be saved to
disk, so feel free to add any pice of text / code you want. It is
especially useful for elisp evaluation. Note that this buffer starts
using the lisp-interaction-mode by default.

Alternatively Emacs provides a top-level elisp interpreter with the ielm
command.

> Smart window switch

The traditional window switch with C-x o can be cumbersome to use in the
long run. The windmove commands provide a more convenient way to do
this. All you have to do is to hold down Shift while pointing at a
window with the arrow keys.

To activate the windmove keys, use the following in your configuration
file:

    ~/.emacs

    (when (fboundp 'windmove-default-keybindings)
      (windmove-default-keybindings))

> Shell calls

Use M-! to call an external command. Use a prefix argument (C-u M-!) to
output the result to current buffer at point.

You can use M-| on a region to use it as input for a command. For
instance

    C-u M-| sort -u RET

will sort region, remove duplicates and replace the region with the
result.

> Shell buffers

You can spawn a shell buffer and execute commands just like you would do
in any terminal. A classic shell buffer can be spawned with the shell
command.

Emacs features a very powerful shell entirely written in Emacs Lisp, the
eshell. The major advantage over shells like csh or zsh is that the
native shell language is elisp itself. So you can use all advanced
feature of elisp for your shell functions.

> Show matching parentheses

You can use the show-paren mode. By default, there’s a small delay
before showing a matching parenthesis. Set the show-paren-delay to 0 to
deactivate.

    ~/.emacs

    (show-paren-mode 1)
    (setq show-paren-delay 0)

> Spell checking

You can choose the dictionnary with

    M-x ispell-change-dictionary

To check a single work use M-$. You can start checking the whole buffer
with

    M-x ispell-buffer

You can enable on-the-fly spell checking by enabling the flyspell-mode.
For source code files you can restrict the mode to comments by using the
flyspell-prog-mode instead.

> Tables

Emacs comes with some powerful functions to handle and generate tables
for various languages. Let's show an example.

    Fruits  Quantity
    Apples  5
    Melons  2

Now select the previous content in a region, and run

    table-capture

Use two spaces for the column delimiter, and a line brak (C-q C-j) for
the row delimiter. This will lead to the following result.

    +------+--------+
    |Fruits|Quantity|
    +------+--------+
    |Apples|5       |
    +------+--------+
    |Melons|2       |
    +------+--------+

You can revert back the operation with

    table-release

There is a lot of handy table-* functions, like table-insert-row,
table-span-cell, table-widen-cell, etc.

Finally, the ultimate purpose of the table functions is to convert it to
the desired markup language. Use the table-generate-source for that. For
LaTeX, the previous table would result in

    % This LaTeX table template is generated by emacs 24.2.1
    \begin{tabular}{|l|l|}
    \hline
    Fruits & Quantity \\
    \hline
    Apples & 5 \\
    \hline
    Melons & 2 \\
    \hline
    \end{tabular}

Using the table mode you can also do some spreadsheet work like sum on
rows and columns, but you will quickly find it limited. Besides it is
quite slow. Have a look at the org-mode for much more powerful
possibilities.

> Agenda, spreadsheet and document authoring

Emacs can offer powerful office features thanks to the famous and
powerful Org mode. This mode is part of the standard Emacs distribution.

Org mode is originally a powerful TODO and Agenda agent, but has quickly
evolved to a much wider set of features. There is simply too much to
tell about Org that we cannot aford even to skim over all the features.
So we will only whet your appetite with a few exemples.

Open a new file TODO.org file, Org mode should be loaded. If not, switch
to it with M-x org-mode.

    TODO.org

    * First entry
    ** Subentry
       Some comments
    *** Subsubentry
    * Second entry
      - List item 1
      - List item 2

Now a few useful bindings.

-   TAB to cycle-fold current entry.
-   S-TAB to cycle-fold all entries.
-   M-RET to start a new item on the same level as the current one.
-   M-<left> and M-<right> to change level.
-   M-<up> and M-<down> to move item together with all its subsections.
-   S-<left> and S-<right> to change status. On list items it will
    change the item style.
-   S-<up> and S-<down> to change priority.
-   C-c ^ to sort all subentries of the current entry.
-   C-c . to add a timestamp to the current entry. Use Shift and arrows
    to skip days or weeks. Use the mouse on the calendar or press Enter
    on a specific day to choose it.

The spreadsheet features are very comprehensive. Let's give an excerpt
from the manual:

        Finally, just to whet your appetite for what can be done with the
     fantastic `calc.el' package, here is a table that computes the Taylor
     series of degree `n' at location `x' for a couple of functions.

         |---+-------------+---+-----+--------------------------------------|
         |   | Func        | n | x   | Result                               |
         |---+-------------+---+-----+--------------------------------------|
         | # | exp(x)      | 1 | x   | 1 + x                                |
         | # | exp(x)      | 2 | x   | 1 + x + x^2 / 2                      |
         | # | exp(x)      | 3 | x   | 1 + x + x^2 / 2 + x^3 / 6            |
         | # | x^2+sqrt(x) | 2 | x=0 | x*(0.5 / 0) + x^2 (2 - 0.25 / 0) / 2 |
         | # | x^2+sqrt(x) | 2 | x=1 | 2 + 2.5 x - 2.5 + 0.875 (x - 1)^2    |
         | * | tan(x)      | 3 | x   | 0.0175 x + 1.77e-6 x^3               |
         |---+-------------+---+-----+--------------------------------------|
         #+TBLFM: $5=taylor($2,$4,$3);n3

Org mode recognizes a table when the pipe | is the first non-whitespace
character on line. In the previous text, no line was drawn. This is done
automatically when TAB is pressed after an entry or the |- sequence. The
result column was not written by hand neither, it is computed from the
calc formula on the last line. Use C-u C-c C-c to recompute all values
in a table.

There is also some handy row and column manipulation bindings like those
for the TODO file. Alt plus arrows will move columns and arrows.

For more in-depth details, refer to the official manual: C-h i m Org
mode RET.

> Refactoring and smart completion

If you are looking for popular programming features found in most IDE
(such as Eclipse), the Semantic tool will do the job. It is part of
Emacs standard distribution. Currently C, C++, Scheme, Javascript, Java,
HTML, and Make are well supported. You can find a table on the current
support state on the CEDET page.

Open a file in your favorite programming landuage supported by Semantic
and turn on the Semantic minor mode with

    M-x semantic-mode

Semantic will work for a few seconds parsing the libraries included from
your file (in C that would mostly be the standard library for instance).

Features

Once done, you can start using the great Semantic features:

Smart completion

Press C-c , SPC to complete a symbol at point. If it is an argument, it
will check for type correctness.

Jump to symbol

Press C-c , j to prompt for a symbol and jump to its definition. You can
use auto-completion with TAB. Use a capital J to search for symbol
accross files.

List symbol calls

Press C-c , g to prompt for a symbol and list the places where it is
being referred to. You can use n and p to navigate through the resulting
entries. Press RET to toggle details, and RET again on a reference to
jump to it. Use a capital G in the first command to work across files.

Refactoring

First list use of the symbol you want to refactor with the
aforementioned command. Now press ( to start defining a macro on the
symbol. This is actually much more powerful than refactoring since you
can apply any function to the symbol and even act on its surrounding
symbols. Press C-x ) to finish the macro and E to call it.

Describe symbol

Call the following function to display details on a symbol.

    semantic-ia-show-summary

This can be very useful for complexe data structures and function
prototypes. There is no binding by default.

Configuration

Here follows a sample configuration for use of Semantic with all
supported programming languages: an example binding and a display
configuration.

    ;; Semantic with ghost display (allows M-n and M-p to browse completion).
    (semantic-mode 1)
    (define-key my-keys-minor-mode-map (kbd "C-c , d") 'semantic-ia-show-summary)
    (setq semantic-complete-inline-analyzer-displayor-class 'semantic-displayor-ghost)

You can also add some specialization for a specific language. Here for
C:

    (add-hook
     'c-mode-hook
     (lambda ()
       (local-set-key (kbd "M-TAB") 'semantic-complete-analyze-inline)
       (local-set-key "." 'semantic-complete-self-insert)
       (local-set-key ">" 'semantic-complete-self-insert)))

Further reading

You can access the info manual directly from Emacs: C-h i m Semantic
RET.

> Using Emacs as git mergetool

By default, Git provides support for using Emacs' Emerge mode as a merge
tool. However you may prefer the Ediff mode. Unfortunately this mode is
not supported by git for technical reasons. There is still a way to use
it by evaluating some elisp code upon emacs call.

    .gitconfig

    [mergetool.ediff]
        cmd = emacs --eval \" (progn (defun ediff-write-merge-buffer () (let ((file ediff-merge-store-file)) (set-buffer ediff-buffer-C) (write-region (point-min) (point-max) file) (message \\\"Merge buffer saved in: %s\\\" file) (set-buffer-modified-p nil) (sit-for 1))) (setq ediff-quit-hook 'kill-emacs ediff-quit-merge-hook 'ediff-write-merge-buffer) (ediff-merge-files-with-ancestor \\\"$LOCAL\\\" \\\"$REMOTE\\\" \\\"$BASE\\\" nil \\\"$MERGED\\\"))\" 

    [merge]
    	tool = ediff

Note that the command has to be on a single line. In the above example,
we launch a new instance of Emacs. You might want to use emacsclient for
quicker startup; it is not recommended though since the Ediff call is
not really clean: it could mess with your current Emacs session.

If you want an instant startup you can use the -q parameter. If you want
to launch Emacs quickly while preserving at least a part of your
configuration, you can call Emacs with

     emacs -q -l ~/.emacs-light

where the light configuration file loads only what you need for Ediff.

See kerneltrap.org and stackoverflow for more details on this trick and
the Ediff issue.

Customization
-------------

Emacs can configured by editing ~/.emacs or using M-x customize. This
section will focus on editing ~/.emacs by hand, and provide some example
customizations to demonstrate commonly-configured aspects of Emacs. The
customize command provides a simple interface to make adjustments,
though it may become restricting as you grow more familiar with Emacs.

All of the examples here can be performed while Emacs is running. To
evaluate the expression within Emacs, use:

C-M-x with point anywhere within the expression.

or

C-x C-e with point following the last ')'

For some users, typing 'yes' and 'no' in prompts can quickly become
tiring. To instead use the 'y' and 'n' keys at these prompts:

    (defalias 'yes-or-no-p 'y-or-n-p)

To stop the cursor blinking, use:

    (blink-cursor-mode -1)

Similarly, to enable column-number-mode, as discussed in the previous
section:

    (column-number-mode 1)

The similarities between the previous two commands are not a
coincidence: blink-cursor-mode and column-number-mode are both
minor-modes. As a rule, minor-modes can be enabled given positive
argument or disabled with a negative argument. Should the argument be
omitted, the minor-mode will be toggled on/off.

Here are some more examples of minor-modes. The following will disable
the scroll bars, menu-bar and tool-bar, respectively.

    (scroll-bar-mode -1)
    (menu-bar-mode -1)
    (tool-bar-mode -1)

The variable, 'auto-mode-alist', can be modified to change the
major-mode used by default for certain file names. The following example
will make the default major-mode for '.tut' and '.req' files
'text-mode'.

    (setq auto-mode-alist
      (append
        '(("\\.tut$" . text-mode)
          ("\\.req$" . text-mode))
        auto-mode-alist))

Settings can also be applied on a per-mode basis. A common method for
this is to add a function to a hook. For example, to force indentation
to use spaces instead of tabs, but only in text-mode:

    (add-hook 'text-mode-hook (lambda () (setq indent-tabs-mode nil)))

Similarly, to only use spaces for indentation everywhere:

    (setq-default indent-tabs-mode nil)

Keybindings can be adjusted in two ways. The first of which is
'define-key'. 'define-key' creates a keybinding for a command but only
in one mode. The example below will make F8 delete any whitespace from
the end of each line of a 'text-mode' buffer:

    (define-key text-mode-map (kbd "<f8>") 'delete-trailing-whitespace)

The other method is 'global-set-key'. This is used to bind a key to a
command everywhere. To bind 'query-replace-regexp' (C-M-%) to '<f7>'.

    (global-set-key (kbd "<f7>") 'query-replace-regexp)

Binding a command to an alternate key does not replace any existing
bindings. Which is to say, 'query-replace-regexp' would be bound to both
F7 and C-M-% after the above example.

Almost anything within Emacs can be configured. Browsing through the
Emacs Wiki should give a solid place to start.

> Multiple configurations

You can use several configurations and tell Emacs to load one or the
other.

For example, let's define two configuration files.

    .emacs

    (load "~/.emacs.d/main" nil t)
    (load "~/.emacs.d/functions" nil t)
    (load "~/.emacs.d/modes" nil t)
    (load "~/.emacs.d/plugins" nil t)
    (load "~/.emacs.d/theme" nil t)

This is the full configuration we load for the deamon. But the plugins
file is huge and slow to load. If we want to spaqn a new Emacs instance
that does not need the plutings features, it can be cumbersome to load
it everytime in the long time.

    .emacs-light

    (load "~/.emacs.d/main" nil t)
    (load "~/.emacs.d/functions" nil t)
    (load "~/.emacs.d/modes" nil t)
    (load "~/.emacs.d/theme" nil t)

And now we launch Emacs with

    emacs -q -l ~/.emacs-light

You can create an alias to ease the call.

> Loading extensions

You can load extensions using the require function. For instance

    (require 'mediawiki)

If you try using the same configuration file on a machine where
mediawiki is not installed, Emacs will primpt for an error. Besides, all
extension-specific code would be parsed for nothing.

The trick is to test the return value of require:

    (if (require 'mediawiki nil t)
        (progn
          (setq mediawiki-site-alist '(
                 ("ArchLinux" "https://wiki.archlinux.org/" "UserName" "" "Main Page")
                 )
               )
          (setq mediawiki-mode-hook
                (lambda ()
                  (visual-line-mode 1)
                  (turn-off-auto-fill)
                  ))
     )) 

> Local and custom variables

You can define variables in your configuration file that can be later
one modified locally for a file.

    (defcustom my-compiler "gcc" "Some documentation")

Now in any file you can define local variables in two ways:

-   On the very first line, write

    // -*- my-compiler:g++; mode:c++ -*-

-   If you cannot (or do not want to) write this on the first line, you
    can put it at the end:

    // Local Variables:
    // my-compiler: g++
    // mode: c++
    // End:

Note that the beginning characters need to be comments for the current
language, that's why here we used two backslashes for C++. For Elisp you
would use

    ;; -*- mode:emacs-lisp -*-

There is two functions that may help you in defining the variables:
add-file-local-variable and add-file-local-variable-prop-line.

Finally, custom variable are considered insecure by default. If you try
to open a file that contains local variable redefining insecure custom
variables, Emacs will ask you for confirmation.

If you know what you are doing, you can declare the variable as secure,
thus removing the Emacs prompt for confirmation. You need to specify a
predicate that any new value has to verify so that it can be considered
safe.

    (defcustom my-compiler "gcc" "Some documentation" :safe 'stringp)

In the previous example, if you attempt to set anything else than a
string, Emacs will consider it insecure.

> Custom colors and theme

Colors can be easily customized using the face facility.

    (set-face-background  'region                 "color-17")
    (set-face-foreground  'region                 "white")
    (set-face-bold-p      'font-lock-builtin-face t ) 

You can have let Emacs tell you the name of the face where the point is.
Use the customize-face function for that. The facility will show you how
to set colors, bold, underline, etc.

Emacs in console can handle 256 colors, but you will have to use an
appropriate terminal for that. For instance URxvt has support for 256
colors. You can use the list-colors-display for a comprehensive list of
supported colors. This is highly terminal-dependent.

> SyncTeX support

Emacs is definitely one of the most powerful LaTeX editor. This is
mostly due to the fact you can adapt or create a LaTeX mode to fit your
needs best.

Still, there might be some challenges, like SyncTeX support. First you
need to make sure your TeX distribution has it. If you installed TeX
Live manually, you may need to install the synctex package.

    # umask 022 && tlmgr install synctex

SyncTeX support is viewer-dependent. Here we will use Zathura as an
example, so the code needs to be adapted if you want to use another PDF
viewer.

    (defcustom tex-my-viewer "zathura --fork -s -x \"emacsclient --eval '(progn (switch-to-buffer  (file-name-nondirectory \"'\"'\"%{input}\"'\"'\")) (goto-line %{line}))'\"" 
      "PDF Viewer for TeX documents. You may want to fork the viewer
    so that it detects when the same document is launched twice, and
    persists when Emacs gets closed.

    Simple command:

      zathura --fork

    We can use

      emacsclient --eval '(progn (switch-to-buffer  (file-name-nondirectory \"%{input}\")) (goto-line %{line}))'

    to reverse-search a pdf using SyncTeX. Note that the quotes and double-quotes matter and must be escaped appropriately."
    :safe 'stringp)

Here we define our custom variable. If you are using AucTeX or Emacs
default LaTeX-mode, you will have to set the viewer accordingly.

Now open a LaTeX source file with Emacs, compile the document, and
launch the viewer. Zathura will spawn. If you press Ctrl+Left click
Emacs should place the point at the corresponding position.

Documentation
-------------

You may find yourself overwhelmed by the amount of Emacs features. You
may find it difficult to know how to use Emacs Lisp to customize your
favorite mods, or even to create your own modes / packages. Thankfully
Emacs takes a strong point to auto-documenting everything: its
internals, current configuration, bindings, etc. Almost everything is
documented.

> Contextual help

Emacs is self-documenting by design. As such, a great deal of
information is available to determine the name of a specific command or
its keybinding, for example. The following is a listing of some of the
most helpful of these:

    C-h a        Find a command matching a description.

    C-h b        List all active keybindings.

    C-h f        Describe the given function.

    C-h k        Find which command a key is bound to.

    C-h m        Display information regarding the currently active modes.

    C-h t        Start the Emacs tutorial.

    C-h v        Describe the given function.

    C-h w        Find which key(s) a command is bound to.

> The Manuals

If you really want to master Emacs, the most recommanded source of
documentation remains the official manuals:

-   Emacs: the complete Emacs user manual.
-   Emacs FAQ.
-   Emacs Lisp Intro: if you never used any programming language before.
-   Elisp: if you are already familiar with a programming language.

You can access it as PDFs from GNU.org or directly from Emacs itself
thanks to the embedded 'info' reader: C-h i. Press m to choose a book.

Some users prefer to read books using 'info' because of its convenient
shortcuts, its paragraphs adapting to window width and the font adapted
to current screen resolution. Some find it less irritating to the eyes.
Finally you can easily copy content from the book to any Emacs buffer,
and you can even execute Lisp code snippets directly from the examples.

You may want to read the Info book to know more about it: C-h i m info
<RET>. Press ? while in info mode for a quick list of shortcuts.

Extensions
----------

While Emacs includes hundreds of modes, libraries and other extensions,
there are many more available to further Emacs' capabilities. The
majority of these come with instructions detailing any changes needed to
be made to ~/.emacs. These instructions are generally found in the
comment block at the beginning of an elisp source file, or in a README
(or similar) should the extension consist of multiple source files.

A number of popular extensions are available as packages in the
'community' repository, and more still are available via the AUR. The
name of such packages have a 'emacs-' prefix (for example,
emacs-lua-mode). In many cases, the changes which need to be made to
~/.emacs are shown during the installation of the package.

Should instructions describing how to activate a specific extension not
be available in the aforementioned location(s), check for a
corresponding page in the Emacs Wiki, which will almost certainly
provide an example configuration. The Emacs Wiki is also an excellent
resource for discovering even more extensions.

You can also use the Emacs Lisp Package Archive (ELPA) to automatically
install packages. See the website for instructions. ELPA is included
with Emacs 24 (the newest version of Emacs); it is an accepted part of
the Emacs ecosystem.

> Emacs MediaWiki

Since we are at it, you may be a contributor to Arch Linux Wiki, or any
Mediawiki-based website. Then emacs will become your best friend thanks
to the Emacs Mediawiki extension. Check the dedicated page for more
details.

Troubleshooting
---------------

> Colored output issues

By default, the Emacs shell will show raw escape sequences used to print
colors. In other words, it will display strange symbols in place of the
desired colored output.

Including the following into ~/.emacs amends the problem:

    (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

> Menus appear empty

A bug exists in GNU Emacs 23.1 (using the GTK toolkit) which may cause
some menus to appear empty. This appears to be fixed in Emacs' CVS
trunk. The corresponding Debian bug report contains a workaround.

> Problems displaying characters in X Windows

If when you start emacs in X windows all the characters in the main
window are white boxes with black borders (the ones you see if you try
to view characters for which you do not have the correct font
installed), you need to install xorg-fonts-75dpi and/or
xorg-fonts-100dpi and restart X windows.

> Slow startup

Slow startup times are often caused by one of two things.

To determine which it might be, run Emacs with:

    $ emacs -q

If Emacs still starts slowly, refer to Incorrect network configuration.
If not, it is almost certainly a problem in your .emacs.

-   Mistakes, particularly in /etc/hosts, will often result in a 5+
    second delay when starting Emacs. Refer to 'set the hostname' in the
    network configuration guide for information.

-   A simple way to search for the cause is to comment-out (i.e., prefix
    lines with ';') suspect sections of your ~/.emacs (or
    ~/.emacs.d/init.el) then start Emacs again to see if there's any
    change. Keep in mind use of "require" and "load" can slow the
    startup down, especially when used with larger extensions. They
    should, as a rule, only be used when their target is either: needed
    once Emacs starts or provides little more than "autoloads" for an
    extension. Otherwise, use the 'autoload function directly. For
    example, instead of:

    (require 'anything)

you might use:

    (autoload 'anything "anything" "Select anything" t)

> Cannot open load file: ...

The most common cause of this error is the 'load-path' variable not
including the path to the directory within which the extension is
located. To solve this, add the appropriate path to the list to be
searched prior to attempting to load the extension:

     (add-to-list 'load-path "/path/to/directory/")

When attempting to use packages for extensions and Emacs has been
configured with a prefix other than '/usr', the load-path will need to
be updated. Place the following in ~/.emacs prior to the instructions
provided by the package:

     (add-to-list 'load-path "/usr/share/emacs/site-lisp")

If compiling Emacs by hand, keep in mind that the default prefix is
'/usr/local'.

> Dead-accent keys problem: '<dead-acute> is undefined'

Searching about this bug on Google, we find this link:
http://lists.gnu.org/archive/html/help-gnu-emacs/2009-05/msg00167.html

Explaining the problem: in recent versions of b72

    Emacs, the normal way to use accent keys doesn't work as expected. Trying to accent a word like 'fiancé' will produce the message above.

A way to solve it is just put the line above on your startup file,
~/.emacs:

      (require 'iso-transl)

And no, it isn't a bug, but a feature of new Emacs versions. Reading the
subsequent messages about it on the mail list, we found it
(http://lists.gnu.org/archive/html/help-gnu-emacs/2009-05/msg00179.html):

It seems that nothing is loaded automatically because there is a choice
betwee iso-transl and iso-acc. Both seem to provide an input method with
C-x 8 or Alt-<accent> prefix, but what you and I are doing is just
pressing a dead key (^, ´, `, ~, ¨) for the accent and then another key
to "compose" the accented character. And there is no Alt key used in
this! And according to documentation it seems be appropriate for 8-bit
encodings, so it should be pretty useless in UTF-8. I reported this bug
when it was introduced, but the bug seems to be

a3b

    classified as a feature ... Maybe it's just because the file is auto-loaded though pretty useless. 

> C-M-% and some other bindings do not work in emacs nox

This is because terminals are more limited than Xorg. Some terminals may
handle more bindings than other, though. Two solutions:

-   either use the GTK version
-   or change the binding to a supported one.

Example:

    .emacs

    (global-set-key (kbd "C-M-y") 'query-replace-regexp)

> Emacs client gets stuck when switching back to it

If you are using Emacs daemon, then you should know that input is
blocking. If one Emacs instance is in the minibuffer (after an M-x for
instance), then all other instance will wait for it to finish. Press C-g
to cancel any input to make sure this Emacs session is not blocking.

Alternatives
------------

There are numerous implementations of Emacs. GNU/Emacs is probably the
most popular.   
 Lighter Emacs compatibile alternatives can be found in Arch
repositories or in AUR.

> mg

mg (originally called MicroGnuEmacs) is lightweight implementation of
Emacs written in C.

It's possible to install mg right away from community

    # pacman -S mg

or download source from official page.

> zile

According to the offical web page "GNU Zile is a lightweight Emacs
clone. Zile is short for Zile Is Lossy Emacs. Zile has been written to
be as similar as possible to Emacs; every Emacs user should feel at
home.".

zile can be found in extra

    # pacman -S zile

the latest taballs can be found in official GNU mirrors.

> uemacs

uemacs is "Micro-emacs version customized by Linus Torvalds". It can be
found in AUR as uemacs.

See also
--------

-   GNU Emacs home page
-   GNU Emacs Manual
-   Emacs Wiki
-   WikEmacs - a more readable, but less complete Emacs Wiki
-   Useful introduction to Emacs and its shortcuts
-   The Church of Emacs
-   Emacs Cheat Sheet
-   Official reference card

Retrieved from
"https://wiki.archlinux.org/index.php?title=Emacs&oldid=252850"

Categories:

-   Development
-   Text editors
