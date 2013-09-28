Writing Article Overviews
=========================

Summary

This article discusses article overview writing techniques. Article
overviews are short textual summaries that appear inside a box on the
right. This article covers some style questions, writing tips, and
formatting techniques.

Series

Writing Short Article Names

Writing Article Overviews

Writing Article Introductions

Effective Use of Headers

Related

Help:Editing

This article was written to assist wiki writers and editors in creating
effective articles and expand the ArchWiki readers' experience.

You are not required to know how to edit a wiki page in order to follow
this article. This page is a more general style guide, rather than a
technical editing HOWTO.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Article overview                                                   |
| -   2 The text                                                           |
|     -   2.1 Example                                                      |
|                                                                          |
| -   3 Formatting                                                         |
+--------------------------------------------------------------------------+

Article overview
----------------

When a reader first encounters the page, the first thing he or she
notices is the article overview. Therefore, an overview has the task of
quickly identifying the topic for the readers. It also presents readers
with basic information about an article, such as required software,
required hardware, related articles, etc.

The text
--------

An effective article is one that fulfills its intended purpose. In order
to fulfill its purpose, an article must introduce a method. You make
your article effective by clearly defining the methods and the purpose.

Thus, an article overview needs to answer these two questions:

1.  What will I be able to achieve after I read this article?
2.  How will I achieve the goal?

The text should not be long. Two well thought out sentences, three at
most.

> Example

For example, this article has a three-sentence overview.

-   Answer to first question: This article discusses article overview
    writing techniques.
-   For some people, that may still not be enough information, so:
    Article overviews are short textual summaries that appear inside a
    box on the right.
-   Answer to second question: This article covers some style questions,
    writing tips, and formatting techniques.

As you can see, you do not need lengthy explanations of what are you
going to talk about. However, you also need something people can read,
before they really dig in.

This article's title may have easily been mistaken for a long list of
summaries of all ArchWiki articles. Fortunately, thanks to the overview,
you do get a clear idea of what this article is about, even before
reaching the first header.

Formatting
----------

Article overviews are formatted using a set of templates. The templates
are:

-   Article summary start
-   Article summary end
-   Article summary text
-   Article summary heading
-   Article summary link
-   Article summary wiki

The Article summary start and Article summary end are mandatory. Of
course, in order for the overview box to be of any use, you also need at
least one Article summary text template.

Here is an example of a simple article overview box with just a summary
text:

    {{Article summary start}}
    {{Article summary text|This is a short summary}}
    {{Article summary end}}

Try it out in the Sandbox. Just copy the code above and paste it there.
Preview or save the page to see the results.

At the very least, an article overview box should contain the article
summary.

For a more complete article overview box, you will usually want to list
the required software or hardware. When listing software, it is
recommended that you provide a link to the software's home page. That
can be done by using Article summary link template.

    {{Article summary heading|Required software}}
    {{Article summary link|Name of software (version)|http://www.link2software.com/}}
    ....

Hardware can be listed either by linking to the manufacturer's technical
data sheet, or manufacturer's web site, or simply by naming a piece of
hardware. You need a minimum of model and make for the list to be of any
use. The following example uses the last method:

    {{Article summary heading|Required hardware}}
    {{Article summary text|Name of hardware (Manufacturer)
    ....

Finally, it is a nice touch to find and link to related articles on
ArchWiki. This is done by using Article summary wiki template:

    {{Article summary heading|Related}}
    <nowiki>{{Article summary wiki|Related article title}}
    ....

Let us see the complete overview box now:

    {{Article summary start}}
    {{Article summary text|This is a short summary}}
    {{Article summary heading|Required software}}
    {{Article summary link|Name of software (version)|http://www.link2software.com/}}
    {{Article summary heading|Required hardware}}
    {{Article summary text|Name of hardware (Manufacturer)}}
    {{Article summary heading|Related}}
    {{Article summary wiki|Related article title}}
    {{Article summary end}}

Of course, you may add more headings to the overview box. This is a
recommendation for a standard list of overview headings:

-   Article summary (required; brief summary of the article)
-   Series (list all articles in a series of related articles)
-   Legal (possible legal issues)
-   Required software (links to required software)
-   Required hardware (links to, or list of required hardware)
-   Related (links to other related wiki articles)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Writing_Article_Overviews&oldid=205568"

Category:

-   Help
