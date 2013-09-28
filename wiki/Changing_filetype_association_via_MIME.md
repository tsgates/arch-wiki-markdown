Changing filetype association via MIME
======================================

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Default     
                           Applications.            
                           Notes: add content of    
                           this page to the newer   
                           article (Discuss)        
  ------------------------ ------------------------ ------------------------

Many of you will be wanting to run Windows applications within your
Linux installation, and you can do this via the wonderful Wine. This
guide will show you how to alter your MIME database in a safe way so
that you can associate Windows executables with Wine. Warning: Do NOT
attempt to modify the mime database directly!

First, create the file ~/.local/share/mime/packages/mime.xml as such:

    $ mkdir -p ~/.local/share/mime/packages
    $ touch ~/.local/share/mime/packages/mime.xml

Next, open up mime.xml and paste the following inside:

    <?xml version="1.0" encoding="UTF-8"?>
    <mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
      <mime-type type="application/x-ms-dos-executable">
             <comment xml:lang="en">Windows Executable</comment>
             <glob pattern="*.exe"/>
      </mime-type>
    </mime-info>

Finally, enter this at the command prompt:

    $ update-mime-database ~/.local/share/mime

That's it!

The method outlined above will integrate the xml file you made with the
mime database, so that you can make your own associations for .exe files
(probably Wine).

Setting mime handler for arbitrary files
----------------------------------------

In this example, we are going to define rox as the file handler of a
file called "test.mp4".

The mime type somehow is in the file so it is not the app that says "use
mime type x on this file" but it's rather "use whatever mime type is
associated with this file". To see a mime type of a file called test.mp4
use this command:

    $ xdg-mime query filetype test.mp4

In my example I got this:

    audio/mp4; charset=binary

Now we set the mime-type, in my example I want to use rox to handle this
file, and then configure rox to use vlc:

    $ xdg-mime default rox.desktop audio/mp4

Since I already set the default action for that file in rox with a
right-click and then using "vlc" as the command, this now works
beautifully.

If you are wondering, setting the default app for a mime type will edit
the file

     ~/.local/share/applications/defaults.list

and add the following for this magic to work:

    <Default Applications>
    audio/mp4=rox.desktop

Resources
---------

-   http://www.freedesktop.org/wiki/Specifications/shared-mime-info-spec

Retrieved from
"https://wiki.archlinux.org/index.php?title=Changing_filetype_association_via_MIME&oldid=205700"

Category:

-   Wine
