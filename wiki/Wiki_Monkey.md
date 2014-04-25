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

Contents
--------

-   1 Installation
-   2 Tour of the features
    -   2.1 Editor pages
    -   2.2 Diff pages
    -   2.3 Page lists (Bot)
    -   2.4 Special functions
    -   2.5 Recent Changes
-   3 See also

Installation
------------

Follow the upstream documentation.

Note:since the ArchWiki is served through HTTPS, Opera users will have
to follow the instructions in the related note.

Tip:the names of ArchWiki-specific configurations appear in the
configurations table with an "ArchWiki-" prefix.

Tour of the features
--------------------

Discover the features of Wiki Monkey by following this tour. See Bundled
plugins for more detailed information.

Tip:at the bottom of Wiki Monkey's interface you will always find a log
area, on dark background, where Wiki Monkey and its plugins will output
their messages.

> Editor pages

If you have installed the ArchWiki-Editor, ArchWiki-Patrol or
ArchWiki-Bot configuration, in every editor page (e.g.
ArchWiki:Sandbox's) you will find Wiki Monkey's interface right below
the Save page button row. As you can see there are some buttons, each of
which will execute a plugin action:

-   Fix header reorders the elements in the header, warns about possible
    problems (e.g. lack of category) and tries to fix some.
-   Fix headings tries to fix the levels of section headings so that
    they start from level 2 and do not increase by more than 1 level
    with relation to the parent section.
-   Fix external links tries to turn external links into proper
    internal/interwiki links (e.g. Wikipedia), or templates (e.g.
    Template:Pkg).
-   Fix section links checks links to sections ([[#Section]]) and tries
    to fix them if broken.
-   Use code templates replaces <pre>, <code> and <tt> with Template:bc
    and Template:ic, taking care of adding numbered parameters or
    <nowiki> tags when necessary.
-   Expand contractions expands some common English contractions, e.g.
    "don't" becomes "do not".
-   Squash multiple line breaks compresses multiple empty lines into
    one.
-   Convert summary to related starts the conversion discussed in Help
    talk:Style/Article summary templates#Deprecation of summaries and
    overviews; the user will have to finish it manually.
-   RegExp substitution lets you perform a regular expression
    substitution.
-   Fix external section links checks links to sections of other
    articles ([[Article#Section]]) and tries to fix them if broken; it
    also supports Template:Related and Template:Related2.
-   Sync interlanguage links synchronizes the interlanguage links of the
    edited page with those of its translations (the Chromium-native,
    Opera and standalone configurations can only synchronize local
    languages).
-   Fix old AUR links converts direct AUR-1.x package links to instances
    of Template:AUR (or Template:Pkg if the package has been moved to
    the official repositories) (available only for the
    Scriptish/Greasemonkey/Tampermonkey configurations).
-   Update package templates checks the existence of the packages and
    groups linked through Template:Pkg, Template:AUR and Template:Grp
    and tries to update any broken template (available only for the
    Scriptish/Greasemonkey/Tampermonkey configurations).

By pressing one of them, the text in the editor will be modified, but
note that the page will not be saved, so you will still be able to see
the diff or the preview and perform other modifications manually. The
Execute row and Execute all buttons are used to execute more plugins one
after the other, thus saving some clicks.

> Diff pages

If you have installed the ArchWiki-Patrol-Lite, ArchWiki-Patrol or
ArchWiki-Bot configuration, in every diff page (e.g. one from
ArchWiki:Sandbox's history) you will find Wiki Monkey's interface right
below the two diff panes. Here the only bundled plugin is Quick report,
which adds a row with a link to the visited diff in the specialized
table of ArchWiki:Reports. See also ArchWiki:Maintenance Team.

> Page lists (Bot)

If you have installed the ArchWiki-Bot configuration you will find Wiki
Monkey's Bot interface in many pages that show lists of pages (e.g.
Category pages, What Links Here pages and many Special pages; see
Category:Sandbox for a specific example). The usage of the Bot interface
is explained in the upstream documentation. The actions that can be
executed by the bot are:

-   Substituting text through regular expressions.
-   Checking and trying to fix any broken links (including
    Template:Related and Template:Related2) to specific sections of the
    target article.
-   Synchronizing the interlanguage links of pages with those of their
    translations (the Chromium-native, Opera and standalone
    configurations can only synchronize local languages).
-   Checking the existence of the packages and groups linked through
    Template:Pkg, Template:AUR and Template:Grp and trying to update any
    broken templates (available only for the
    Scriptish/Greasemonkey/Tampermonkey configurations).
-   Converting direct AUR-1.x package links to instances of Template:AUR
    (or Template:Pkg if the package has been moved to the official
    repositories) (the Bot is shown only if there is at least one item
    in the list; available only for the
    Scriptish/Greasemonkey/Tampermonkey configurations).

Note:The Bot interface is hidden by default, you will have to show it by
clicking on the dedicated link.

> Special functions

If you have installed the ArchWiki-Bot configuration you will also find
Wiki Monkey's interface at the top of Special:SpecialPages: here you
will find those plugins that have a generic purpose and are not based on
a specific page. The available plugins are a function to update Table of
contents pages, and a function to fix double redirects.

> Recent Changes

If you have installed the ArchWiki-Patrol-Lite, ArchWiki-Patrol or
ArchWiki-Bot configuration, at the top of Special:RecentChanges you will
find Wiki Monkey's Recent Changes filter. Currently the bundled filter
only groups the changes by the language of the affected article.

Note:the default filter is designed to work on top of MediaWiki's Recent
Changes filter, which can be enabled in
Special:Preferences#mw-prefsection-rc. This also means that you must be
logged on in order to use it.

See also
--------

-   Changelog
-   Troubleshooting
-   Bug reports, feature requests, questions

Retrieved from
"https://wiki.archlinux.org/index.php?title=Wiki_Monkey&oldid=302674"

Category:

-   Internet applications

-   This page was last modified on 1 March 2014, at 04:31.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
