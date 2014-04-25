Help:Editing
============

Related articles

-   ArchWiki:About
-   Help:Cheatsheet
-   Help:Style
-   Help:Reading
-   Help:Template
-   ArchWiki:Sandbox

ArchWiki is powered by MediaWiki, a free software wiki package written
in PHP, originally designed for use on Wikipedia. This is a short
tutorial about editing the ArchWiki. More in-depth help can be found at
Help:Contents on MediaWiki and Help:Contents on Wikipedia.

You must be logged-in to edit pages. Visit Special:UserLogin to log in
or create an account. To experiment with editing, please use the
sandbox. For an overview of wiki markup, see Help:Cheatsheet. For wiki
tasks, see ArchWiki:Contributing.

Before editing or creating pages, users are encouraged to familiarize
themselves with the general tone, layout, and style of existing
articles. An effort should be made to maintain a level of consistency
throughout the wiki. See Help:Reading for an overview of common
stylistic conventions. See Help:Style for more detail.

Contents
--------

-   1 Editing
    -   1.1 Reverting edits
-   2 Creating pages
-   3 Formatting
    -   3.1 Headings and subheadings
    -   3.2 Line breaks
    -   3.3 Bold and italics
    -   3.4 Strike-out
    -   3.5 Indenting
    -   3.6 Lists
        -   3.6.1 Bullet points
        -   3.6.2 Numbered lists
        -   3.6.3 Definition lists
    -   3.7 Code
    -   3.8 Tables
-   4 Links
    -   4.1 Internal links
        -   4.1.1 Links to sections of a document
    -   4.2 Interlanguage links
    -   4.3 Interwiki links
    -   4.4 External links
-   5 Redirects
-   6 Wiki variables, magic words, and templates
-   7 Discussion pages
    -   7.1 User talk pages

Editing
-------

To begin editing a page, click the edit tab at the top of the page.
Alternatively, users may edit a specific section of an article by
clicking the edit link to the right of the section heading. The Editing
page will be displayed, which consists of the following elements:

-   Edit toolbar (optional)
-   Edit box
-   Edit summary box
-   Save page, Show preview, Show changes, and Cancel links

The edit box will contain the wikitext (the editable source code from
which the server produces the web page) for the current revision of the
page or section. To perform an edit:

1.  Modify the wikitext as needed (see #Formatting below for details).
2.  Explain the edit in the Summary box (e.g. "fixed typo" or "added
    info on xyz" (see Help:Edit summary for details)).
    Note:All edits should be accompanied by a descriptive summary. The
    summary allows administrators and other maintainers to easily
    identify controversial edits and vandalism.
3.  Use the Show preview button to facilitate proofreading and verify
    formatting before saving.
4.  Mark the edit as minor by checking the This is a minor edit box if
    the edit is superficial and indisputable.
5.  Save changes by clicking Save page. If unsatisfied, click Cancel
    instead (or repeat the process until satisfied).

> Note:

-   If you are not going to use an external editor like vim, you may
    want to consider using wikEd, which adds syntax highlighting, regex
    search and replace and other nice features to the standard MediaWiki
    editor. The greasemonkey script works flawlessly with the ArchWiki.
-   Articles should not be signed because they are shared works; one
    editor should not be singled out above others.

> Reverting edits

If a page was edited incorrectly, the following procedures describe how
to revert an article to a previous version. To revert a single edit:

1.  Click the history tab at the top of the page to be modified (beside
    the edit tab). A list of revisions is displayed.
2.  Click the undo link to the right of the offending edit. An edit
    preview is displayed, showing the current revision on the left and
    the text to be saved on the right.
3.  If satisfied, click the Save page button at the bottom of the page.

The wiki page should now be back in its original state.

Occasionally, it is necessary to revert several edits at once. To revert
an article to a previous version:

1.  Click the history tab at the top of the page to be modified (beside
    the edit tab). A list of revisions is displayed.
2.  View the desired revision (i.e. the last good version) by clicking
    on the appropriate timestamp. That revision is displayed.
3.  If satisfied, click the edit tab at the top of the page. A warning
    is displayed: You are editing an out-of-date revision of this page.
    Simply click the Save page button to revert to this version.

Note:Avoid combining an undo and an edit! Revert the edit first, then
make additional changes; do not edit the revision preview.

Creating pages
--------------

Before creating a new page, please consider the following:

1.  Is your topic relevant to Arch Linux? Irrelevant or unhelpful
    articles will be deleted.
2.  Is your topic of interest to others? Consider not only what you wish
    to write about, but also what others may wish to read. Personal
    notes belong on your user page.
3.  Is your topic worthy of a new page? Search the wiki for similar
    articles. If they exist, consider improving or adding a section to
    an existing article instead.
4.  Will your contribution be significant? Avoid creating stubs unless
    planning to expand them shortly thereafter.

Creating a new page requires selection of a descriptive title and an
appropriate category.

Please read Help:Article naming guidelines and Help:Style#Title for
article naming advice. Do not include "Arch Linux" or variations in page
titles. This is the Arch Linux wiki; it is assumed that articles will be
related to Arch Linux (e.g., "Installing Openbox"; not "Installing
Openbox in Arch Linux").

Visit the Table of contents to help choose an appropriate category.
Articles may belong to multiple categories.

To add a new page to some category (say "My new page" to "Some
category") you need to:

1.  Create a page with your new title by browsing to
    https://wiki.archlinux.org/index.php/My_new_page (remember to
    replace "My_new_page" with the intended title!)
2.  Add [[Category:Some category]] to the top of your page

Note:Do not create uncategorized pages! All pages must belong to at
least one category. If you cannot find a suitable category, consider
creating a new one.

Formatting
----------

Text formatting is accomplished with wiki markup whenever possible;
learning HTML is not necessary. Various templates are also available for
common formatting tasks; see Help:Template for information about
templates. The Help:Cheatsheet summarizes the most common formatting
options.

> Headings and subheadings

Headings and subheadings are an easy way to improve the organization of
an article. If you can see distinct topics being discussed, you can
break up an article by inserting a heading for each section. See
Help:Style#Section headings and Help:Effective use of headers for style
information.

Headings must start from second level, and can be created like this:

    == Second-level heading ==

    === Third-level heading ===

    ==== Fourth-level heading ====

    ===== Fifth-level heading =====

    ====== Sixth-level heading ======

Note:First-level headings are not allowed, their formatting is reserved
for the article title.

If an article has at least four headings, a table of contents (TOC) will
be automatically generated. If this is not desired, place __NOTOC__ in
the article. Try creating some headings in the Sandbox and see the
effect on the TOC.

> Line breaks

An empty line is used to start a new paragraph while single line breaks
have no effect in regular paragraphs.

The HTML <br> tag can be used to manually insert line breaks, but should
be avoided. A manual break may be justified with other formatting
elements, such as lists.

+--------------------------------------+--------------------------------------+
| wikitext                             | rendering                            |
+======================================+======================================+
|     This sentence                    | This sentence is broken into three   |
|     is broken into                   | lines.                               |
|     three lines.                     |                                      |
+--------------------------------------+--------------------------------------+
|     This is paragraph number one.    | This is paragraph number one.        |
|                                      |                                      |
|     This is paragraph number two.    | This is paragraph number two.        |
+--------------------------------------+--------------------------------------+
|     * This point <br> spans multiple | -   This point                       |
|  lines                               |      spans multiple lines            |
|     * This point                     | -   This point                       |
|     ends the list                    |                                      |
|                                      | ends the list                        |
+--------------------------------------+--------------------------------------+

See Help:Style/White space for information on proper use of whitespace
characters.

> Bold and italics

Bold and italics are added by surrounding a word or phrase with two,
three or five apostrophes ('):

+--------------------------------------+--------------------------------------+
| wikitext                             | rendering                            |
+======================================+======================================+
| ''italics''                          | italics                              |
+--------------------------------------+--------------------------------------+
| '''bold'''                           | > bold                               |
+--------------------------------------+--------------------------------------+
| '''''bold and italics'''''           | bold and italics                     |
+--------------------------------------+--------------------------------------+

> Strike-out

Use strike-out text to show that the text no longer applies or has
relevance.

+--------------------------------------+--------------------------------------+
| wikitext                             | rendering                            |
+======================================+======================================+
|     <s>Strike-out text</s>           | Strike-out text                      |
+--------------------------------------+--------------------------------------+

> Indenting

Note:Indenting should only be used for discussion pages, see
Wikipedia:Indentation

To indent text, place a colon (:) at the beginning of a line. The more
colons you put, the further indented the text will be. A newline marks
the end of the indented paragraph.

+--------------------------------------+--------------------------------------+
| wikitext                             | rendering                            |
+======================================+======================================+
|     This is not indented at all.     | This is not indented at all.         |
|     :This is indented slightly.      |                                      |
|     ::This is indented more.         | This is indented slightly.           |
|                                      | This is indented more.               |
+--------------------------------------+--------------------------------------+

> Lists

Remember that wiki syntax does not support multi-line list items; every
newline character ends the list item definition. To start a new line
inside a list item, use the <br> tag. To enter a multi-line code block
inside a list item, use Template:bc and escape the content using
<nowiki> tags. See also Help:Style/White space and Help:Template.

Bullet points

Bullet points have no apparent order of items.

To insert a bullet, use an asterisk (*). Multiple *s will increase the
level of indentation.

+--------------------------------------+--------------------------------------+
| wikitext                             | rendering                            |
+======================================+======================================+
|     * First item                     | -   First item                       |
|     * Second item                    | -   Second item                      |
|     ** Sub-item                      |     -   Sub-item                     |
|     * Third item                     | -   Third item                       |
+--------------------------------------+--------------------------------------+

Numbered lists

Numbered lists introduce numbering and thus order the list items. You
should generally use unordered lists as long as the order in which items
appear is not the primary concern.

To create numbered lists, use the number sign or hash symbol (#).
Multiple #s will increase the level of indentation.

+--------------------------------------+--------------------------------------+
| wikitext                             | rendering                            |
+======================================+======================================+
|     # First item                     | 1.  First item                       |
|     # Second item                    | 2.  Second item                      |
|     ## Sub-item                      |     1.  Sub-item                     |
|     # Third item                     |                                      |
|                                      | 3.  Third item                       |
+--------------------------------------+--------------------------------------+
|     # First item                     | 1.  First item                       |
|     # Second item                    | 2.  Second item                      |
|     #* Sub-item                      |     -   Sub-item                     |
|     # Third item                     |                                      |
|                                      | 3.  Third item                       |
+--------------------------------------+--------------------------------------+

Definition lists

Definition lists are defined with a leading semicolon (;) and a colon
(:) following the term.

+--------------------------------------+--------------------------------------+
| wikitext                             | rendering                            |
+======================================+======================================+
|     Definition lists:                | Definition lists:                    |
|     ; Keyboard: Input device with bu |                                      |
| ttons or keys                        |  Keyboard                            |
|     ; Mouse: Pointing device for two |     Input device with buttons or     |
| -dimensional input                   |     keys                             |
|     or                               |  Mouse                               |
|     ; Keyboard                       |     Pointing device for              |
|     : Input device with buttons or k |     two-dimensional input            |
| eys                                  |                                      |
|     ; Mouse                          | or                                   |
|     : Pointing device for two-dimens |                                      |
| ional input                          |  Keyboard                            |
|                                      |     Input device with buttons or     |
|                                      |     keys                             |
|                                      |  Mouse                               |
|                                      |     Pointing device for              |
|                                      |     two-dimensional input            |
+--------------------------------------+--------------------------------------+
|     Use additional colons if a defin | Use additional colons if a           |
| ition has multiple definitions:      | definition has multiple definitions: |
|     ; Term                           |                                      |
|     : First definition               |  Term                                |
|     : Second definition              |     First definition                 |
|                                      |     Second definition                |
+--------------------------------------+--------------------------------------+

Definition lists must not be simply used for formatting, see W3's
examples.

> Code

To add code to the wiki, use one of the code formatting templates.
Alternatively, simply start each line with a single whitespace
character.

See Help:Style#Code formatting templates.

> Tables

Used effectively, tables can help organize and summarize swaths of data.
For advanced table syntax and formatting, see Help:Table.

+--------------------------------------+--------------------------------------+
| wikitext                             | rendering                            |
+======================================+======================================+
|     {| class="wikitable"             |   Distro   Color                     |
|     |+ Tabular data                  |   -------- --------                  |
|     ! Distro !! Color                |   Arch     Blue                      |
|     |-                               |   Gentoo   Purple                    |
|     | Arch || Blue                   |   Ubuntu   Orange                    |
|     |-                               |                                      |
|     | Gentoo || Purple               |   :  Tabular data                    |
|     |-                               |                                      |
|     | Ubuntu || Orange               |                                      |
|     |}                               |                                      |
+--------------------------------------+--------------------------------------+
|     {| class="wikitable"             |   Filesystem   Size   Used   Avail   |
|     ! Filesystem !! Size !! Used !!  |  Use%   Mounted on                   |
| Avail !! Use% !! Mounted on          |   ------------ ------ ------ ------- |
|     |-                               |  ------ ------------                 |
|     | rootfs || 922G || 463G || 413G |   rootfs       922G   463G   413G    |
|  || 53% || /                         |  53%    /                            |
|     |-                               |   /dev         1.9G   0      1.9G    |
|     | /dev || 1.9G || 0 || 1.9G || 0 |  0%     /dev                         |
| % || /dev                            |                                      |
|     |}                               |                                      |
+--------------------------------------+--------------------------------------+

Links
-----

Links are essential to help readers navigate the site. In general,
editors should ensure that every article contains outgoing links to
other articles (avoid dead-end pages) and is referenced by incoming
links from other articles (the what links here special page can be used
to display incoming links).

> Internal links

You can extensively cross-reference wiki pages using internal links. You
can add links to existing titles, and also to titles you think ought to
exist in future.

To make a link to another page on the same wiki, just put the title in
double square brackets.

For example, if you want to make a link to, say, the pacman article,
use:

    [[pacman]]

If you want to use words other than the article title as the text of the
link, you can add an alternative name after the pipe "|" divider (Shift
+ \ on English-layout and similar keyboards).

For example:

    The [[ArchWiki:About|ArchWiki]] is the primary documentation source for Arch Linux. 

...is rendered as:

The ArchWiki is the primary documentation source for Arch Linux.

When you want to use the plural of an article title (or add any other
suffix) for your link, you can add the extra letters directly outside
the double square brackets.

For example:

    makepkg is used in conjunction with [[PKGBUILD]]s.

...is rendered as:

makepkg is used in conjunction with PKGBUILDs.

Links to sections of a document

To create a link to a section of a document, simply add a # followed by
the section's heading.

For example:

    [[Help:Editing#Links to sections of a document]]

...is rendered as:

Help:Editing#Links to sections of a document

Tip:If linking to a section within the same page, the page name can be
omitted (e.g. [[#Links to sections of a document]]). Do not needlessly
reformat same-page section links to hide the anchor symbol (e.g.
[[#Links to sections of a document|Links to sections of a document]]).

> Interlanguage links

See Help:i18n#Interlanguage links

> Interwiki links

So-called interwiki links can be used to easily link to articles in
other external Wikis, like Wikipedia for example. The syntax for for
this link type is the wiki name followed by a colon and the article you
want to link to enclosed in double square brackets.

If you want to link to the Wikipedia:Arch Linux article you can use the
following:

    [[Wikipedia:Arch Linux]]

Or you can create a piped link with an alternate link label to the Arch
Linux Wikipedia article:

    [[Wikipedia:Arch Linux|Arch Linux Wikipedia article]]

Note:Using a piped link with an alternative link label should be
reserved for abbreviating longer URLs.

See: Wikipedia:InterWikimedia links

> External links

If you want to link to an external site, just type the full URL for the
page you want to link to.

    http://www.google.com/

It is often more useful to make the link display something other than
the URL, so use one square bracket at each end, with the alternative
title after the address separated by a space (not a pipe). So if you
want the link to appear as Google search engine, just type:

    [http://www.google.com/ Google search engine]

Note:If linking to another ArchWiki or Wikipedia page, use #Internal
links or #Interwiki links rather than external links! That is, if your
link starts with https://wiki.archlinux.org/ use an internal link; if
your link starts with http://en.wikipedia.org/ use an interwiki link!

Redirects
---------

To redirect automatically from one page to another, add #REDIRECT and an
internal link to the page to be redirected to at the beginning of a
page.

For example, you could redirect from "Cats" to "Cat":

    #REDIRECT [[Cat]]

Thus, anyone typing either version in the search box will automatically
go to "Cat".

Note that redirects are resolved internally by the server and will not
make it any slower to open an article.

When redirecting an existing page A to page B, for example after merging
the content of A into B, check if A has a talk page: if B does not have
a talk page, move A's talk page there; otherwise merge A's talk page to
B's. Then check if A's talk page is linked from some other page and fix
any of those links so that they point to B's talk page. Finally, mark
A's talk page for deletion.

Wiki variables, magic words, and templates
------------------------------------------

MediaWiki recognizes certain special strings within an article that
alter standard behavior. For example, adding the word __NOTOC__ anywhere
in an article will prevent generation of a table of contents. Similarly,
the word __TOC__ can be used to alter the default position of the table
of contents. See Help:Magic words for details.

Templates and variables are predefined portions of wikitext that can be
inserted into an article to aid in formatting content.

Variables are defined by the system and can be used to display
information about the current page, wiki, or date. For example, use
{{SITENAME}} to display the wiki's site name (which, on this wiki, is:
ArchWiki). To set an alternate title header for the current page,
another wiki variable can be used: {{DISPLAYTITLE:New Title}} (only
capitalization changes are permitted).

Templates, on the other hand, are user-defined. The content of any page
can be included in another page by adding {{Namespace:Page Name}} to an
article, but this is rarely used with pages outside the Template
namespace. (If the namespace is omitted, Template is assumed.) For
example, Template:Note, which can be included in an article with the
following wikitext:

    {{Note|This is a note.}}

...is rendered as:

Note:This is a note.

See Help:Template for more information.

Discussion pages
----------------

Discussion or "talk" pages are for communicating with other ArchWiki
users.

To discuss any page, go to that page and then click the "discussion" tab
at the top of the page. Add a new comment at the end of the page or
reply below an existing comment. Use indenting to format your
discussion. Standard practice is to indent your reply one more level
deep than the person to whom you are replying. Further, you should
insert your comment beneath the one to which you are replying, but below
others who are doing the same.

Sign comments by typing ~~~~ to insert your username and a timestamp.
Avoid editing another user's comments.

Experiment by editing the talk page of the Sandbox.

> User talk pages

Note the difference between a user page, and a user talk page. Everyone
may have a user talk page on which other people can leave public
messages. If one does not exist for a particular user, you may create it
so that you can leave a comment. If someone has left you a message on
yours, you will see a note saying "You have new messages" with a link to
your own user talk page: in this case you are supposed to reply on your
own talk page beneath the original message with appropriate indentation.
Please avoid replying to a discussion on a different talk page, for
example the one of the user who contacted you, since such a style of
communication creates disconnects with the flow of information regarding
the subject at hand.

Do not edit a user's own page without permission (i.e. [[User:Name]]);
these serve as personal user spaces. The "user talk page" is the correct
place for communicating (other than sending private email if the address
is published).

Retrieved from
"https://wiki.archlinux.org/index.php?title=Help:Editing&oldid=304709"

Category:

-   Help

-   This page was last modified on 16 March 2014, at 06:00.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
