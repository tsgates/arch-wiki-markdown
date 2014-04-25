Help:Effective use of headers
=============================

Related articles

-   Help:Article naming guidelines
-   Help:Writing article introductions
-   Help:Editing
-   Help:Style

This article was written to assist wiki writers and editors in creating
effective articles and expand the ArchWiki readers' experience.

You are not required to know how to edit a wiki page in order to follow
this article. This page is a more general style guide, rather than a
technical editing HOWTO.

Contents
--------

-   1 About article headers
    -   1.1 Terms used in this article
    -   1.2 Use of headers and headings
        -   1.2.1 Slowing down the reader
        -   1.2.2 Grouping paragraphs into subtopics
        -   1.2.3 Marking important parts
    -   1.3 Headers and the table of contents
-   2 About heading levels
    -   2.1 Headings of the same level should have equal significance
    -   2.2 Top level headings should always be of highest level
-   3 Types of heading structures
    -   3.1 Single-level structure
    -   3.2 False multi-level structure
        -   3.2.1 Side-note
        -   3.2.2 Mark auxiliary information
    -   3.3 Multi-level structure
        -   3.3.1 Group arguments together
        -   3.3.2 Alternative arguments
        -   3.3.3 Contradictory argument
-   4 The header text
-   5 Formatting

About article headers
---------------------

Headers mark the start of a new section. Sections may be organized in a
tree form with some sections nested within other sections. To reflect
the section structure, headers may be formatted differently. Sections
and corresponding headers are divided into levels depending on their
place relative to other sections.

> Terms used in this article

A section that is contained within another section is said to be of a
lower level than its container (or parent). Therefore the parent is of a
higher level.

Each header with the text spanning to the next header of the same level
is called a heading.

Headings have numbers that describe their level in the tree. Higher
level headings have lower numbers, and vice versa. For example, the
article's title on ArchWiki is heading level 1.

> Use of headers and headings

Headers and headings serve a couple of important purposes:

-   they slow readers down for better absorption of information
-   they group parts of the article into logical units
-   they mark important pieces of text

Slowing down the reader

When presenting your topic to readers, you must know that it takes some
time to read even through shortest articles. A header may serve as a
buffer to slow down the reader before reading the following section.
This slow-down allows the reader to think about the content and prepare
him/herself for the following text.

Grouping paragraphs into subtopics

Most of the time, your article will not treat just one topic, and you
will need to visit some more or less related topics in order to explain
and expand your main topic. Such visits may be confusing when a reader
is trying to scan through the article. Therefore, you need to signal for
such deviations.

Marking important parts

Sometimes, readers just want to look through the table of contents (TOC)
in order to identify parts of the article that are of special interest.
They may also do so by looking at the headers themselves. In both cases,
clearly defined headers serve the purpose of quick identification of
important sections of your article. Moreover, TOC is created by
automatically listing the headings in your article.

> Headers and the table of contents

A table of contents for an article is created automatically when more
than two headers are defined. In order to hide the TOC, you may include
a line with the following code anywhere in your article:

    __NOTOC__

About heading levels
--------------------

There are some important things to note when talking about heading
levels.

> Headings of the same level should have equal significance

This may sound self-explanatory, but it is not quite straightforward as
it seems. Consider this example:

-   Introduction
-   Step 1: Installing X
-   Step 2: Editing keyboard settings
-   Step 3: Editing mouse settings
-   Step 4: Editing display settings
-   Step 5: Adding fglrx options
-   Step 6: Starting X
-   Conclusions

If you carefully analyze this list, you will notice that steps 2 to 4
are actually of less significance than steps 1 and 6, and that step 5 is
of least significance. This is not to say that all those steps have more
or less text than the others. It is the conceptual significance that is
important.

To amend this, we will modify the headings like so:

-   Introduction
-   Step 1: Installing X
-   Step 2: Configuring X
    -   Step 2a: Editing keyboard settings
    -   Step 2b: Editing mouse settings
    -   Step 2c: Editing display settings
        -   Step 2c-1: Adding fglrx options
-   Step 3: Starting X
-   Conclusions

As you can see, we have merged steps 2 to 4 into a single heading titled
Configuring X, and divided the heading into 3 subheadings. Also, we have
attached the step 5 to step 2c, and turned it into a subheading.

> Top level headings should always be of highest level

This may also sound like common sense, but there is one little problem.
The headers have formatting style associated with them. Many people use
those associated formatting rules to manipulate how their article looks.
This in turns yield a broken heading structure.

Let us take a look at this example:

-   Introduction
-   Step 1
-   Step 2
-   Step 3
    -   Conclusion

The author of that article thought bold 24pt type assigned to level 1
headings was too large and too bold for such an unimportant section like
Conclusion. So the author thought that it would be a better idea to use
the italic 12pt type assigned to level 3 headings. This results in a
heading structure that has the last section two levels below the other
sections. The correct structure would be:

-   Introduction
-   Step 1
-   Step 2
-   Step 3
-   Conclusion

The conclusion is now in line with the rest of the article.

Note:It may seem somewhat awkward that sections like Introduction or
Conclusion are given same importance as the main article, but those
sections are in fact important. It is always better to add a note (one
like this) at the end of the article, or completely exclude poorly
formulated or lacking sections than to demote them into lower level
headings and break the article's logical structure for the sake of
aesthetic issues.

Types of heading structures
---------------------------

Based on the number of levels used, and the their purpose, heading
structure may be divided into following categories:

1.  Single-level structure
2.  False multi-level structure
3.  Multi-level structure

> Single-level structure

When writing an article, the most straightforward way is to divide it
into steps. Those steps may not necessarily be real steps, something
that readers need to take. They may be steps that a writer takes in
developing his article. In any case, those steps follow one another and
are arranged in a single-level structure.

A typical setup of this kind may look like this:

-   Introduction
-   Step 1: doing this or the other
-   Step 2: cleaning up
-   Step 3: troubleshooting
-   Further reading

This is what a simple 3-step HOWTO with introduction and references may
look.

> False multi-level structure

Sometimes, there is a need to deviate from the simple and flowing
single-level structure.

Side-note

Usually, you need to deviate shortly from the main flow to elaborate on
something.

-   Introduction
-   Step 1: doing this or the other
    -   Notes on configuring XYZ
-   Step 2: cleaning up
-   Step 3: troubleshooting
-   Further reading

Consider this an alternative to adding notes and comments via the Note
template.

Mark auxiliary information

Maybe you want to add a marker to some important part that acts as a
additional argument to main discussion, or enhances the main discussion
in some other way.

-   Introduction
-   Step 1: doing this or the other
    -   Here is the sample code
-   Step 2: cleaning up
    -   Here is the sample code
-   Step 3: troubleshooting
    -   Here is the sample code
-   Further reading

> Multi-level structure

Multi-level structure is typical of longer, more in-depth articles.
However, it may also be effectively used in shorter HOWTOs.

Here are some cases when a multi-level structure may come in handy.

Note:Keep in mind that we are describing parent-child relationships of
heading levels, and that it is not important if the parent is level 1,
or 2, or 3. The same applies to all multi-level structures that have 2
or more levels.

Group arguments together

Subheadings can be to main headings what headings are to the entire
article.

An example:

-   Introduction
-   Step 1: doing this or the other
-   Step 2: cleaning up
    -   First do this
    -   Then do that
    -   You're done!
-   Step 3: troubleshooting
-   Further reading

Alternative arguments

Sometimes, you need to give your readers a few different angles on a
subject.

For example:

-   Introduction
-   Step 1: doing this or the other
    -   This is one way to do it
    -   This is another way to do it
-   Step 2: cleaning up
-   Step 3: troubleshooting
-   Further reading

Contradictory argument

If you need to talk about opposing arguments, you may give each party a
subheading of its own.

For instance:

-   Introduction
-   Step 1: doing this or the other
    -   You want this
    -   There are reasons for not wanting this, though
-   Step 2: cleaning up
-   Step 3: troubleshooting
-   Further reading

The header text
---------------

We will summarize some of the key points here, and if you want a more
detailed account, you may read Help:Article naming guidelines. The rules
listed here apply to both header texts and article names.

-   Header texts should be as specific as possible, and they should
    reflect the heading's scope
-   Header texts should be general enough to allow for future
    enhancement of headings
-   Header texts should be as short as possible (also see Help:Article
    naming guidelines)

Formatting
----------

As we already noted, it is crucial not to abuse header formatting styles
to beautify your articles. If you do not like what you see, contact the
admins or sysops and ask for their opinion, or offer to fix the
situation in a manner that would not compromise the heading structures.

To mark some text as a heading, two or more equal signs (==) must be
used.

Note:The lowest-supported heading level would actually be 1 (=), but its
formatting is reserved for article titles: article sections must always
start from level 2.

Here is the the code for marking headers:

    ==Header level 2==
    ===Header level 3===
    ====Header level 4====
    =====Header level 5=====
    ======Header level 6======

If you want to see how these are formatted, you may use the Sandbox.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Help:Effective_use_of_headers&oldid=302593"

Category:

-   Help

-   This page was last modified on 1 March 2014, at 04:11.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
