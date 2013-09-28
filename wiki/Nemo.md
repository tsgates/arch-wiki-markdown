Nemo
====

Nemo is the file manager of the Cinnamon desktop.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Make Nemo your default file browser                          |
|                                                                          |
| -   2 Configuration                                                      |
|     -   2.1 Show / hide desktop icons                                    |
|                                                                          |
| -   3 Extensions                                                         |
| -   4 Nemo Actions                                                       |
|     -   4.1 Clam Scan                                                    |
|     -   4.2 Moving files                                                 |
+--------------------------------------------------------------------------+

Installation
------------

Install nemo from the Official Repositories.

> Make Nemo your default file browser

Change from Nautilus to Nemo :

    /usr/share/applications/nautilus.desktop

    [...]
    #Exec=nautilus %U
    Exec=nemo %U
    [...]

Configuration
-------------

> Show / hide desktop icons

    # false to hide ; true to show
    dconf write /org/nemo/desktop/show-desktop-icons false

Extensions
----------

-   Nemo fileroller — Integrate File Roller into Nemo.

https://github.com/linuxmint/nemo-extensions/tree/master/nemo-fileroller
|| nemo-fileroller

-   RabbitVCS Nemo — Integrate RabbitVCS into Nemo.

http://www.rabbitvcs.org || rabbitvcs-nemo

-   Python2 Nemo — Python bindings for the Nemo Extension API.

https://github.com/linuxmint/nemo-extensions/tree/master/nemo-python ||
python2-nemo

Nemo Actions
------------

It allows the user to add new entries to the Nemo context menu.  
 The file /usr/share/nemo/actions/sample.nemo_action contains an example
of a Nemo action.  
 Places where to put custom action files :

-   $HOME/.local/share/nemo/actions/
-   /usr/share/nemo/actions/

Pay attention to the name convention. Your file has to preserve the file
ending .nemo_action.

> Clam Scan

    $HOME/.local/share/nemo/actions/clamscan.nemo_action

    [Nemo Action]
    Name=Clam Scan
    Comment=Clam Scan

    Exec=gnome-terminal -x sh -c "clamscan -r %F | less"

    Icon-Name=bug-buddy

    Selection=Any

    Extensions=dir;exe;dll;zip;gz;7z;rar;

> Moving files

    $HOME/.local/share/nemo/actions/archive.nemo_action

    [Nemo Action]
    Active=true


    # The name to show in the menu, locale supported with standard desktop spec.
    # Use %N as an (optional) token to display the simple filename in the label.
    # If multiple are selected, then the arbitrary first selected name will be used.
    # Token is inactive for selection type of Multiple, None and Any (it will be treated literally)
    # **** REQUIRED ****

    Name=Archive %N


    # Tool tip, locale supported (Appears in the status bar)
    # %N can be used as with the Name field, same rules apply

    Comment=Archiving %N will add .archive to the object.


    # What to run.  Enclose in < > to run an executable that resides in the actions folder.
    # Use %U as a token where to insert a URL list, use %F as a token to insert a file list
    # **** REQUIRED ****
    #Exec=gedit %F

    Exec=<archive.py %F>

    # What type selection: [S]ingle, [M]ultiple, Any, or None (background click)
    # Defaults to Single if this field is missing

    Selection=S


    # What extensions to display on - this is an array, end with a semicolon
    # Use "dir" for directory selection and "none" for no extension
    # Use "any" by itself, semi-colon-terminated, for any file type
    # Extensions are NOT case sensitive.  jpg will match JPG, jPg, jpg, etc..
    # **** REQUIRED ****

    Extensions=any;

    $HOME/.local/share/nemo/actions/archive.py

    #! /usr/bin/python2 -OOt


    import sys
    import os
    import shutil

    filename = sys.argv[0]
    print "Running " + filename
    print "With the following arguments:"
    for arg in sys.argv:
        if filename == arg:
            continue
        else:
            print arg
            #os.rename('%s','%s.archive') % (arg,arg)
            shutil.move(arg, arg+".archive")

Retrieved from
"https://wiki.archlinux.org/index.php?title=Nemo&oldid=254466"

Category:

-   File managers
