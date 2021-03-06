Zim
===

  Summary help replacing me
  -----------------------------------------------------------------------------------------
  Zim is a notepad like desktop application that is inspired by the way people use wikis.

From the project home page:

Zim is a graphical text editor used to maintain a collection of wiki
pages. Each page can contain links to other pages, simple formatting and
images. Pages are stored in a folder structure, like in an outliner, and
can have attachments. Creating a new page is as easy as linking to a
nonexistent page. All data is stored in plain text files with wiki
formatting. Various plugins provide additional functionality, like a
task list manager, an equation editor, a tray icon, and support for
version control.

Zim can be used to:

-   Keep an archive of notes
-   Take notes during meetings or lectures
-   Organize task lists
-   Draft blog entries and emails
-   Do brainstorming

Contents
--------

-   1 Installation
-   2 Usage
-   3 Configuration
-   4 Tips
    -   4.1 Plugins
        -   4.1.1 Spell checker
-   5 Troubleshooting
    -   5.1 Problems at launch
    -   5.2 Error: Unable to find or create trash directory
-   6 See also

Installation
------------

You can install zim from the official repositories. There is also an AUR
package called zim-bzr which provides the latest developer snapshot.

Usage
-----

The usage of Zim is very self-explanatory. This screencast provides a
good overview about the basic functionality.

Configuration
-------------

The main configuration file is located in Zim's config directory:
~/.config/zim/preferences.conf. Another important file is located in the
same directory: ~/.config/zim/notebooks.list. This file contains a list
of all wikis and there file path.

Besides the configuration there exist the wiki directories which are set
up when a new wikis are created. Those folders store all wiki pages in
plain txt format.

Tips
----

Specific user tricks to accomplish tasks.

> Plugins

Zim provides a lot of useful plugins where many of them are not enabled
by default. They can be found at Edit > Preferences > Plugins. That is,
there is a plugin which provides a tray icon.

Spell checker

The requirements for the Spell Checker plugin are as follows: gtkspell,
python2-gtkspell and aspell-en.

Change aspell-en to your desired language support. Now you can configure
the Spell Checker and define the default language, in my case en_GB.

Troubleshooting
---------------

> Problems at launch

A common error is at start up resulting in a error message like the
following this thread:

    UnboundLocalError: local variable 'i' referenced before assignment

It is often related to a problem with the file path of the wikis stored
in ~/.config/zim/notebooks.list. Try to delete or move this file and
restart Zim.

> Error: Unable to find or create trash directory

This error message indicates that Zim is not able to find the trash
directory as in this thread. This occurs when the wiki is stored on a
partition that does not have any trash directory under
/partition/.local/share/Trash. Due to that one is not able to delete
pages as Zim tries to move them to the trash. Solutions are either the
creation of a trash directory or the installation of the developer
snapshot instead of the stable version which permanently deletes a page
if no trash directory can be found. Thus, the user does not receive this
error message anymore.

See also
--------

-   Zim homepage
-   Zim official manual
-   A short screencast

Retrieved from
"https://wiki.archlinux.org/index.php?title=Zim&oldid=265253"

Category:

-   Text editors

-   This page was last modified on 6 July 2013, at 09:03.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
