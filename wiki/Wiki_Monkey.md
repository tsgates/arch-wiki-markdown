Wiki Monkey
===========

Wiki Monkey is a MediaWiki-compatible bot and editor assistant that can
be used directly within wiki pages in the browser as a user script.
Currently it is tested on Firefox, Chromium and Opera, but it is very
likely to work also on other browsers out of the box or with minor
adaptations. Wiki Monkey can also be easily extended through the
creation of plugins, exploiting its API.

The project is currently focused on ArchWiki, and as such most plugins
address ArchWiki-specific problems.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Firefox                                                      |
|     -   1.2 Chromium                                                     |
|         -   1.2.1 Tampermonkey (recommended)                             |
|         -   1.2.2 Native support                                         |
|                                                                          |
|     -   1.3 Opera                                                        |
|     -   1.4 Other browsers                                               |
|                                                                          |
| -   2 Configurations table                                               |
| -   3 Updates                                                            |
|     -   3.1 Firefox                                                      |
|         -   3.1.1 Scriptish                                              |
|         -   3.1.2 Greasemonkey                                           |
|                                                                          |
|     -   3.2 Chromium                                                     |
|         -   3.2.1 Tampermonkey                                           |
|         -   3.2.2 Native support                                         |
|                                                                          |
|     -   3.3 Opera                                                        |
|                                                                          |
| -   4 Tour of the features                                               |
| -   5 Contributions                                                      |
| -   6 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

> Firefox

Make sure you have installed either the Scriptish extension
(recommended) or the Greasemonkey extension.

Now just click on the link of one of Wiki Monkey configurations from the
"Scriptish/Greasemonkey/Tampermonkey" column in the #Configurations
table and your browser should ask you to install it.

> Chromium

Wiki Monkey can be installed in two ways: either using Tampermonkey or
exploiting Chromium's native support for user scripts.

Tampermonkey (recommended)

Make sure you have installed the Tampermonkey extension.

Now just click on the link of one of Wiki Monkey configurations from the
"Scriptish/Greasemonkey/Tampermonkey" column in the #Configurations
table and your browser should ask you to install it.

Note:Chromium will first ask you whether you want to install the script
with the native support or through Tampermonkey: of course you need to
choose the latter by clicking on OK.

Native support

Just click on the link of one of Wiki Monkey configurations from the
"Chromium native" column in the #Configurations table and your browser
should ask you to install it.

Note:Installing Wiki Monkey without Tampermonkey is not recommended
since Chromium's native support is still limited and some features may
not work correctly, as is the case of updates. Besides, plugins that
require cross-origin requests will not be available.

> Opera

Go to: Opera menu > Settings > Preferences > Advanced > Content >
JavaScript options: in the User JavaScript folder field, select the
directory where you will install user scripts.

Now download one of Wiki Monkey configurations from the "Opera" column
in the #Configurations table and save it in the folder you've chosen
earlier.

Finally, since the ArchWiki is accessed through the HTTPS protocol, you
need to visit opera:config and enable the User Javascript on HTTPS
setting under User Prefs. You will be prompted to allow the execution of
Wiki Monkey the first time you access the ArchWiki in each browsing
session.

> Other browsers

It should be possible to install Wiki Monkey in other browsers in ways
similar to one of the browsers above. If your browser only supports raw
JavaScript files, installing one of Wiki Monkey configurations from the
"standalone" column in the #Configurations table may work.

Configurations table
--------------------

This is the table with the predefined configurations: read the section
above for instructions on which link you must choose.

  Name          Description                                                  Scriptish/Greasemonkey/Tampermonkey   Chromium native   Opera      standalone
  ------------- ------------------------------------------------------------ ------------------------------------- ----------------- ---------- ------------
  Editor        Provides only manual-editing aid functions in editor pages   install                               install           download   download
  Patrol-Lite   Provides a quick-report function in diff pages               install                               install           download   download
  Patrol        Editor + Patrol-Lite                                         install                               install           download   download
  Bot           Patrol + automatic operations on list pages                  install                               install           download   download

Alternatively, you can create your own configuration.

Warning:Although it is possible to keep multiple configurations of Wiki
Monkey installed together, make sure to enable only one at a time.

Note:Plugins that require cross-origin requests are not available for
the Chromium-native, Opera and standalone versions.

Updates
-------

> Firefox

Scriptish

Open Firefox's Add-ons Manager (Tools -> Add-ons), select User Scripts,
right-click on Wiki Monkey and choose Find Updates.

If you want to enable automatic updates, choose Show More Information
instead, then set Automatic Updates to On.

Scriptish's perferences are available in Firefox's Add-ons Manager
(Tools -> Add-ons), selecting the Extensions tab.

Greasemonkey

Greasemonkey should enable automatic updates by default, you can check
opening Firefox's Add-ons Manager (Tools -> Add-ons), selecting User
Scripts, right-clicking on Wiki Monkey and verifying Automatic check for
updates is ticked.

Greasemonkey's perferences are available in Firefox's Add-ons Manager
(Tools -> Add-ons), selecting the Extensions tab.

> Chromium

Tampermonkey

Tampermonkey should enable automatic updates by default, you can check
opening Tools -> Extensions, selecting Tampermonkey's options, selecting
the Settings tab and verifying the settings for Check Interval in the
Script Update section.

Native support

Chromium's native support for user scripts is rather limited and should
not be able to update Wiki Monkey. If you want automatic or
semi-automatic updates, it is recommended to use Tampermonkey as
described in the Installation section.

> Opera

Due to how user scripts are installed in Opera, there is currently no
way to have automatic or semi-automatic updates, you will have to check
periodically and reinstall the script when a new version is released.

Tour of the features
--------------------

After installing the desired version of Wiki Monkey, start visiting the
editor of this very page, you will find Wiki Monkey's interface right
below the Save page button row. As you can see there are some buttons,
each of which will execute a plugin action (see Bundled plugins for
detailed information):

-   Fix header reorders the elements in the header, warns about possible
    problems (e.g. lack of category) and tries to fix some.
-   Fix headings tries to fix the levels of section headings so that
    they start from level 2 and do not increase by more than 1 level
    with relation to the parent section.
-   Use code templates replaces <pre>, <code> and <tt> with Template:bc
    and Template:ic, taking care of adding numbered parameters or
    <nowiki> tags when necessary.
-   Expand contractions expands some common English contractions, e.g.
    "don't" becomes "do not".
-   Multiple line breaks compresses multiple empty lines into one.
-   RegExp substitution lets you perform a regular expression
    substitution.
-   Sync interlanguage links * synchronizes the interlanguage links of
    the edited page with those of its translations.
-   Fix old AUR links ** converts direct AUR-1.x package links to
    instances of Template:AUR.

By pressing one of them, the text in the editor will be modified, but
note that the page will not be saved, so you will still be able to see
the diff or the preview and perform other modifications manually. The
Execute row and Execute all buttons are used to execute more plugins one
after the other, thus saving some clicks.

At the bottom of Wiki Monkey's interface you will always find the log
area, on dark background, where Wiki Monkey and its plugins will output
their messages.

Now, if you have installed the "Patrol Lite", "Patrol" or "Bot"
configuration, visit Special:RecentChanges and select a diff from the
list: right below the diff panes you will find Wiki Monkey's interface.
Here the only bundled plugin is Quick report, which adds a row with a
link to the visited diff in the specialized table of ArchWiki:Reports.

At this point, if you have installed the "Bot" configuration, visit
Special:SpecialPages: at the top of the page you will find those plugins
that have a generic purpose and are not based on a specific page: the
only currently available plugin is a function to update Table of
Contents pages.

Finally, if you have installed the "Bot" configuration, visit the
Category of this article: right at the top you will find Wiki Monkey's
bot interface, whose usage is explained in the upstream documentation;
other pages where you can find the bot are What Links Here pages and
many of the list pages linked from Special:SpecialPages. The available
plugins for the bot are a regular expression substitution function and a
tool for synchronizing the interlanguage links of the pages with those
of their translations*. The External links search page also provides a
plugin for converting direct AUR-1.x package links to instances of
Template:AUR**.

* The Chromium-native, Opera and standalone configurations can only
synchronize local languages.

** Available only for the Scriptish/Greasemonkey/Tampermonkey
configurations.

Contributions
-------------

Of course any help in the resolution of bugs or the development of new
plugins is appreciated: if you are interested, send an email to the
original author (or use his talk page) and urge him to finally complete
the documentation about the development of plugins, which is actually
quite straightforward.

See also
--------

-   Troubleshooting
-   Bug reports, feature requests, questions

Retrieved from
"https://wiki.archlinux.org/index.php?title=Wiki_Monkey&oldid=237461"

Category:

-   Internet Applications
