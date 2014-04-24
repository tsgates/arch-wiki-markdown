SciTE
=====

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

SciTE is a Scintilla based text editor. Originally built to demonstrate
the Scintilla text editor library, it has grown to be a general-purpose
editor with facilities for building and running programs. It is best
used for jobs with simple configurations.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Example configuration
    -   2.2 Tips

Installation
------------

Install scite, available in the Official repositories.

Configuration
-------------

SciTE has a lot of configuration settings, which are read from
~/.SciTEUser.properties (user-specific) and
/usr/share/scite/SciTEGlobal.properties (global). Both of these files
can be accessed from the Options menu. The Frequently Asked Questions
page also has some tips that may be useful.

> Example configuration

    # Show "<filename> in <path>" instead of just "<filename>"
    title.full.path=2

    # Show toolbar and statusbar
    #toolbar.visible=0
    #statusbar.visible=0

    # Maximum number of tabs
    #buffers=40

    # Hide tab bar if there is only one tab
    #tabbar.hide.one=0

    # Split code and output (F8) panes vertically
    split.vertical=0

    # Ask to reload a file that has been modified externally
    load.on.activate=1
    are.you.sure.on.reload=1

    # Save the session
    save.position=1
    save.recent=1
    #save.session=0
    #save.find=0

    # Set all code styles to use monospaced font of the same size
    font.monospace=font:!DejaVu Sans Mono,size:10
    font.base=$(font.monospace)
    font.small=$(font.monospace)
    font.comment=$(font.monospace)
    font.text=$(font.monospace)
    font.text.comment=$(font.monospace)
    font.embedded.base=$(font.monospace)
    font.embedded.comment=$(font.monospace)
    font.vbs=$(font.monospace)

    # Show line numbers, pad if fewer than 4 digits
    line.margin.visible=1
    line.margin.width=4+
    margin.width=0

    # Indentation style (Shift+Ctrl+I)
    #indent.size=8
    #use.tabs=1
    #tabsize=8

    # Indicate tab and space characters (Shift+Ctrl+A)
    #view.whitespace=0
    #whitespace.fore=#000000

    # Column guide, indicates long lines
    edge.mode=1
    edge.column=80

    # Make Python quotes foldable (useful for docstrings)
    fold.quotes.python=1

> Tips

go on to html.properties file; to get the advantages you need the
php.api and the phpfunctions.properties from HERE. You also find api
files for ASP.

    #replace netscape with mozilla-firefox again
    if PLAT_GTK
    	command.go.$(file.patterns.web)=mozilla-firefox "file:///$(FilePath)"

    # load the .api file which I downloaded from the web; it contains, per line,
    # a short explanation of each command
    # $file.patterns.php is defined for *.php and friends by file extensions
    api.$(file.patterns.php)=$(SciteDefaultHome)/php.api
    # the calltips for the hypertext lexer shall not be case sensitive
    calltip.hypertext.ignorecase=1
    # define how the calltipps should be parsed, the following is the same as
    # the standard anyway, but might be overwritten by some people in SciTEGlobal
    calltip.hypertext.parameters.start=(
    calltip.hypertext.parameters.end=)
    calltip.hypertext.parameters.separators=,
    # some calltips have an additionally explanation after the final ")"
    #   -this makes display them in a second line
    calltip.hypertext.end.definition=)

    # autocopleter stuff
    # defines which type of characters let the autocompletion pop up
    autocomplete.hypertext.start.characters=_$(chars.alpha)
    # also the autocompletion should not be case sensitive since, grrr php and html
    autocomplete.html.ignorecase=1

There can be defined 10 commands file.pattern, these are some for html
and one for php files. Actually Scite is capable of parsing the output
of commands for line and column like it does for the php -l command
further down or the already defined perl checker. Unfortunately it
doesn't work for tidy, it always open a blank new tab on clicking
instead of placing the cursor at the correct position :/

Show error messages of tidy, doesn't change the file

    # extend the "Extras" menu with some commands
    # Tidy Checking
    command.name.1.$(file.patterns.web)=HTML Tidy Validate
    command.1.$(file.patterns.web)=tidy -quiet -errors $(FilePath)
    error.select.line=1

Use Tidy to format(indent and wrap at line 80) and clean your code. This
command is defined this way: - save file to disk - have tidy parsing it
and rewrite the output directly back to the file - re-read in the file
and show in editor -> consequence: !!! THERE IS NO UNDO ON THIS
COMMAND !!! Since we set 'activate are.you.sure.on.reload=1' a warning
will popup, if we really wanna reload it. So you can decide based on the
output in message pane.

    # Tidy Cleanup and indent
    command.name.2.$(file.patterns.web)=HTML Tidy Cleanup
    command.2.$(file.patterns.web)=tidy -i -wrap 80 -m $(FilePath)
    command.save.before.1.$(file.patterns.web)=1
    command.is.filter.2.$(file.patterns.web)=1

This activates the php linter which finds parsing errors like missing
line ends or braces. A click on the error message highlights the error
in editor and places the cursor there.

    # activate a lint checker for php files
    command.name.1.$(file.patterns.php)=Check PHP syntax
    command.1.$(file.patterns.php)=php -l $(FilePath)

To open files in a new tab of the current instance, rather than a new
instance (window)

    # Checking
    check.if.already.open=1

Retrieved from
"https://wiki.archlinux.org/index.php?title=SciTE&oldid=301378"

Categories:

-   Development
-   Text editors

-   This page was last modified on 24 February 2014, at 11:42.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
