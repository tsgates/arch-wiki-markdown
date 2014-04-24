Help:Template
=============

Related articles

-   Help:Editing
-   Help:Reading
-   Help:Style

A template is a piece of predefined wikitext that can be inserted into
an article. Templates are primarily used to aid in formatting content.

Contents
--------

-   1 Usage
    -   1.1 Style
    -   1.2 Escape template-breaking characters
        -   1.2.1 Named parameters
        -   1.2.2 nowiki tags
        -   1.2.3 HTML entities
-   2 Creation
-   3 List of templates
    -   3.1 Testing
    -   3.2 Article status templates
    -   3.3 Related articles templates
    -   3.4 Code formatting templates
    -   3.5 Note templates
    -   3.6 Miscellaneous templates
    -   3.7 Package templates
-   4 See also

Usage
-----

Templates are used by adding the following markup to an article:

    {{Template name}}

Most templates take additional arguments, such as Template:Note:

    {{Note|This text should be noted.}}

which produces:

Note:This text should be noted.

Some templates use named parameters, such as Template:hc:

    {{hc|head=/etc/rc.local|output=exit 0}}

which produces:

    /etc/rc.local

    exit 0

The general format is:

    {{Template name|param1|param2|...|paramN}}

See each template's page for specific usage instructions.

> Style

-   Templates should be used with the capitalization shown in the
    examples in their pages, for example {{Pkg|... and {{ic|... are
    correct, while {{pkg|... and {{Ic|... are not.
-   There should be no spaces around the template name:
    {{Template name|... is correct, while for example
    {{ Template name |... is not.

> Escape template-breaking characters

There are some characters that, if used inside a template, will break
its output: most frequently this happens with "=" (the equal sign) and
"|" (the pipe sign). Solutions to this problem are described below.

Named parameters

If the problem is only with "=" signs, the recommended solution is to
explicitly introduce template parameters with their names or positional
numbers. This is very useful with query strings in URLs or variable
definitions, but will not work for other offending characters, like "|".
For example:

    {{Tip|1=https://www.archlinux.org/?foo=bar}}

Tip:https://www.archlinux.org/?foo=bar

Or, with multiple parameters:

    {{hc|1=$ echo "="|2==}}

    {{hc|head=$ echo "="|output==}}

    $ echo "="

    =

nowiki tags

If you are having problems with characters other than "=", e.g. "|", the
recommended solution is to enclose the whole parameter in <nowiki> tags.
This method displays all kinds of characters, but completely prevents
the wiki engine from processing text markup, such as links and other
templates. For example:

    {{Tip|<nowiki>= | }} https://www.archlinux.org/ {{ic|foo}}</nowiki>}}

Tip:= | }} https://www.archlinux.org/ {{ic|foo}}

Enclosing only specific parts (or even single characters) in <nowiki>
tags still works of course, but for readability it is recommended to use
such method only if links or other templates have to be normally
displayed. For example:

    {{Tip|<nowiki>= | }}</nowiki> https://www.archlinux.org/ {{ic|foo}}}}

Tip:= | }} https://www.archlinux.org/ foo

HTML entities

Replacing the offending characters with their respective HTML entities
always works, but since it reduces the readability of the source text,
it is recommended only when the solutions above are not practicable. For
example:

    {{Tip|&#61; &#124; &#125;&#125;}}

Tip:= | }}

Creation
--------

> Note:

-   Only create relevant templates. If you are attempting to create a
    very specialized template that will likely only ever be used on a
    few articles, please do not bother, avoid cluttering up the
    templates namespace.
-   Only create concise templates. Remember The Arch Way: Keep It
    Simple, Stupid!

The following template should be used when creating new templates to
facilitate usage and editing:

    <noinclude>{{Template}}

    '''A brief description of the template'''

    ====Usage====

    {{ic|<nowiki>{{Template name|param1|param2|...|paramN}}</nowiki>}}

    ====Example====

    {{Template name|param1|param2|...|paramN}}</noinclude><includeonly>Template code goes here...</includeonly>

To begin the creation process, simply visit Template:Template name
(substituting Template name with the desired name of the template),
edit, and add the relevant wikitext.

List of templates
-----------------

The templates that users can use directly in articles on the ArchWiki
are listed below. Click on the links to see their detailed usage. For a
list that also includes localizations and meta templates see
Special:AllPages/Template:, Special:PrefixIndex/Template: or
Special:MostLinkedTemplates.

Warning:Please do not experiment with existing templates. If you want to
edit a non-protected template, copy the text to Template:Sandbox, edit
and test it there, and copy it back when it works. It is strongly
recommended (and necessary for protected templates) to suggest any
modifications on discussion pages first.

> Testing

-   Template:Sandbox
-   Template:Lorem Ipsum

> Article status templates

-   Template:Accuracy
-   Template:Bad translation
-   Template:Deletion
-   Template:Expansion
-   Template:Merge
-   Template:Moveto
-   Template:Out of date
-   Template:Poor writing
-   Template:Stub
-   Template:Translateme

> Related articles templates

-   Template:Related articles start
-   Template:Related
-   Template:Related articles end

> Code formatting templates

-   Template:ic
-   Template:bc
-   Template:hc

> Note templates

-   Template:Note
-   Template:Tip
-   Template:Warning

> Miscellaneous templates

-   Template:App
-   Template:Bug
-   Template:Linkrot

> Package templates

-   Template:Pkg
-   Template:Grp
-   Template:AUR

See also
--------

-   Template:Template
-   http://meta.wikimedia.org/wiki/Help:Template

Retrieved from
"https://wiki.archlinux.org/index.php?title=Help:Template&oldid=302590"

Category:

-   Help

-   This page was last modified on 1 March 2014, at 04:10.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
