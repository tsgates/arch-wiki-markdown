Writing Article Introductions
=============================

> Summary

This article covers the topic of writing effective and useful article
introductions. An article introduction is usually the first heading in
an article. This article will discuss information, writing style, and
formatting that make up a good article introduction.

> Series

Writing Short Article Names

Writing Article Overviews

Writing Article Introductions

Effective Use of Headers

> Related

Help:Editing

Help:Style

This article was written to assist wiki writers and editors in creating
effective articles and expand the ArchWiki readers' experience.

You are not required to know how to edit a wiki page in order to follow
this article. This page is a more general style guide, rather than a
technical editing HOWTO.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Article introduction                                               |
| -   2 The text                                                           |
|     -   2.1 Title                                                        |
|     -   2.2 Previous experiences and knowledge                           |
|     -   2.3 System states and configuration                              |
|     -   2.4 Hardware requirements                                        |
|     -   2.5 What readers are not going to find in the article            |
|                                                                          |
| -   3 Formatting                                                         |
+--------------------------------------------------------------------------+

Article introduction
--------------------

Since the article introduction is (usually) the first thing readers
encounter after they have read the article overview, and decided they
would like to know more about the topic, article introductions have a
purpose of introducing readers to the topic.

Each article is started with a set of assumptions. These assumptions are
seldom true for most readers, and an article introduction has the
purpose of filtering readers that fulfill the assumptions made by
writers. You do not really have to introduce readers to the rest of the
article, but it may help clear some things up, that would otherwise
remain unclear even after reading the whole article... many times over.

For instance, you may have written an article about configuring the
system in a certain way. However, you have assumed that readers have a
clean and freshly installed Arch Linux on their primary hard drive. How
would your method be affected if the kernel was, for example,
customized? Or, how would step 3 work if package X was missing?

You need to think about prerequisites for your method and present those
prerequisites before you start your article. This has two key benefits:

1.  It allows readers to decide if they want to read the article, before
    they have gone too far.
2.  It enables you to write an article without too many unnecessary
    digressions.

Number two has a huge impact on reader performance, and actually makes
your article more streamlined.

There are a number of things you might consider including in your
article introduction, but here are some of the more important ones in no
particular order:

-   previous experiences and knowledge required
-   system states and configuration
-   ownership of hardware components
-   what readers are not going to find in the article

The text
--------

We have already mentioned some things you might mention in an article
introduction. We will now take a look at some of the problems in
formulating an effective and useful article introduction.

> Title

Since introductions are too important to just skip, you need a good
title for it. You may opt for generic titles like Introductory notes, or
a more aggressive version like Read this first, or friendlier variants
like Before you read this article. You may also want something more
specific, like Intended audience or Who should read this article. Maybe
a more integrated variant like Preparing the system would go better with
your topic.

In any case, the title should catch readers' attention and tell them
that they need to read this part of the article first.

> Previous experiences and knowledge

When talking about previous experience, you need to keep in mind that
there are two meanings of the words. One is a more general meaning. We
may call someone a newbie or a guru based on the overall
knowledge/experience/reputation of that individual. The other is a
concrete experience of participating in an event or activity (and the
knowledge derived from that). For practical reasons, it is better to
demand previous experience(s) in the latter sense. Most articles on
ArchWiki talk about topics that are specific, and in some context. In a
given context, a newbie may display proficiency, whereas a guru may show
lack of interest. If you require specific previous experiences, readers
have a better chance of judging their ability to follow the rest of the
article.

You may also want to provide readers with links to resources that would
help them gain knowledge required to understand the article.

> System states and configuration

Sometimes, a missing package or a differently configured system
component may render an article useless on some systems. Therefore, you
need to track down and define all relevant system configuration (like,
relevant rc.config parameters, required packages, etc) whenever
possible.

> Hardware requirements

Hardware requirements are usually fairly obvious. If you are talking
about installing drivers for dial-up modem XYZ, nobody will ever think
you are talking about a modem ZYX. However, in some cases it is good to
mention the specific hardware requirements. For instance, if you are
writing an article about installing drivers for XYZ-123, you may warn
users that the same might not apply to XYZ-456.

It is also a nice touch to add the photo of the hardware your article is
about to discuss.

> What readers are not going to find in the article

Sometimes, the article's title may be slightly misleading. Therefore you
may need to warn readers about the actual topic of the article, and
possibly offer a link to other articles that readers might have been
looking for.

For example, some readers might have thought this article was about how
to format pages using wiki text. Therefore, those readers have been
warned that this is not the page they were looking for, and the link to
the right page was provided.

Formatting
----------

The formatting of the article introduction follows the usual ArchWiki
customs. However, there are still details that deserve closer attention.

When listing requirements, you have two approaches. One is to verbosely
explain the requirements and other introductory notes in plain (your
language here). The other method is to offer a well-organized list of
requirements.

The code for introduction header is:

    == Title ==

Other than this, there is no specific guideline.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Writing_Article_Introductions&oldid=205569"

Category:

-   Help
