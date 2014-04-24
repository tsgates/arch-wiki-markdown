Help:Style/White space
======================

Related articles

-   Help:Editing#Line breaks

This article defines the standards for the use of whitespace characters
in the source code of articles. The style used in the examples is to be
considered an integral part of the rules.

Contents
--------

-   1 Generic rules
-   2 Main, Category, ArchWiki, Help namespaces
    -   2.1 Example
-   3 Talk, *_talk namespaces
    -   3.1 Example

Generic rules
-------------

-   Avoid using multiple blank lines to space out paragraphs or
    sections.
-   Separate section titles from the = characters with a single space
    character.
-   Separate section headers from section bodies with an empty line.
-   There should be no spaces around template names, template
    parameters, link titles, and alternative link text.
-   There should be no spaces between indentation colons and indented
    text.
-   Separate list characters (* and #) from their items with a space.
-   Individual list items cannot be separated by blank lines, otherwise
    the wiki parser will start a new list for each item.

Main, Category, ArchWiki, Help namespaces
-----------------------------------------

-   Separate categories with single line breaks.
-   Separate interlanguage links with single line breaks.

> Example

    [[Category:Example A]]
    [[Category:Example B]]
    [[es:Article]]
    [[zh-CN:Article]]
    {{Expansion|Example status template}}

    {{Related articles start}}
    {{Related|Related article A}}
    {{Related|Related article B}}
    {{Related articles end}}

    Example introduction.

    == Section 1 ==

    Example section body.

    === Section 1.1 ===

    Example section body with [[Related article|link]].

    == Section 2 ==

    === Section 2.1 ===

    Example section body with {{Template|Parameter 1|2=Parameter 2}}.

    * List item
    ** List item
    * List item

    === Section 2.2 ===

     Singe-line code example

    {{bc|
    Multiline code example
    1
    2
    3
    }}

    {{bc|1=
    Multiline code example
    1
    2
    3
    }}

    {{bc|<nowiki>
    Multiline code example
    1
    2
    3
    </nowiki>}}

Talk, *_talk namespaces
-----------------------

-   Separate different replies with an empty line.

> Example

    == Discussion 1 ==

    First post, paragraph 1.

    First post, paragraph 2.

    -- ~~~~

    :Reply 1, single paragraph. -- ~~~~

    ::Reply 2, paragraph 1.
    ::Reply 2, paragraph 2.
    ::-- ~~~~

    == Discussion 2 ==

    First post, single paragraph. -- ~~~~

    :Reply 1, paragraph 1.
    :Reply 1, paragraph 2.
    :-- ~~~~

    ::Reply 2, single paragraph. -- ~~~~

Retrieved from
"https://wiki.archlinux.org/index.php?title=Help:Style/White_space&oldid=303954"

Category:

-   Help

-   This page was last modified on 10 March 2014, at 23:47.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
