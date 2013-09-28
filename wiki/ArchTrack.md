ArchTrack
=========

ArchTrack is an unofficial project that aims to enable both security
professionals and newcomers to learn and use security and hacking tools
within Arch Linux.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Inspiration                                                        |
| -   2 Ideals                                                             |
|     -   2.1 Required Reading                                             |
|     -   2.2 Quotes                                                       |
|     -   2.3 Rules                                                        |
|                                                                          |
| -   3 Milestones                                                         |
| -   4 Participation                                                      |
| -   5 Forms                                                              |
| -   6 Contact Information                                                |
|     -   6.1 Other                                                        |
|     -   6.2 Historical                                                   |
|                                                                          |
| -   7 Links                                                              |
+--------------------------------------------------------------------------+

Inspiration
-----------

How can one not be inspired by the great work of BackTrack Linux and
many other security-oriented distributions and tools? Thanks to open
community, we intend to learn from what others have already accomplished
and given back to the community at large. We will apply their lessons in
the adoption of their examples and tools to Arch Linux.

Ideals
------

-   Follow Arch Linux ethos: Arch Linux, The Arch Way, The Arch Way
    v2.0...
-   Include both the latest stable and development versions of tools, in
    line with Arch Linux's status as a "rolling-release cutting-edge
    distribution" (ref)
-   Be a community effort
-   We DO NOT support the use of ArchTrack (or any tool) in an illegal
    or unethical way
-   We DO suggest that you exercise your responsibility to abide by all
    applicable laws, regulations, rules and guidelines
-   Don't just be a penetration testing distribution. Include tools from
    other major roles in cybersecurity such as network security
    monitoring, forensics, etc.

> Required Reading

-   How To Ask Questions The Smart Way by Eric S. Raymond

> Quotes

-   A determined soul will do more with a rusty monkey wrench than a
    loafer will accomplish with all the tools in a machine shop. --
    Robert Hughes

> Rules

-   Once it's out, it's out.
-   Trust no one.
-   Trust but verify.
-   Don't trust, and verify. (ref)
-   Nothing is 100% secure.
-   Everything has weaknesses.
-   Physical access = game over
-   Rational paranoia is healthy, irrational paranoia is unhealthy,
    stupid and worthless.
-   There is no magic silver bullet solution.
-   Security is a process.
-   It's not about the number of tools, vulnerabilities, open ports,
    checkboxes; it is about the value, impact, result, outcomes...
-   Don't ask questions you do not want to hear the answer to.
-   The only stupid questions are the ones that start with "This might
    be a stupid question...".
-   Search and you will find either the answer or the right people to
    ask.

Milestones
----------

-   Utilize existing (or make new) AUR packages for every tool available
    in BackTrack plus any other tools that should be included
-   Create ArchTrack packages and submit to AUR
    -   archtrack
    -   Add various other ArchTrack packages that properly
        sub-categorize packages by various criteria. For example, one
        wants to install all command line and web tools, but no gui
        tools.
        -   Another idea is to sub-categorize by role: pentesting vs
            vulnerability assessment vs network security monitoring.
            Although there may be overlap between roles, there may be
            some value in enabling a "specialist" versions optimized for
            a particular use. If you disagree with this, you can just
            ignore these and not worry about it.

-   Provide a pacman repository for all packages included in ArchTrack
-   Provide a functionality like ABS for all packages included in
    ArchTrack
-   Produce live media (iso/livecd/liveusb via archiso, larch, or
    something else?)
-   Create & manage marketing materials, logo, themes, wiki pages...
    -   I'm not really a graphic designer, but if I have my way... any
        ArchTrack logo should definitely not be a simple combination of
        the official Arch Linux logo and the official BackTrack logo.
        Since ArchTrack is Arch Linux, an ArchTrack logo should include
        or build upon the Arch Linux logo.
        -   Version 0.1: On second thought, there's no reason to have a
            logo that directly builds on the Arch Linux logo, even
            though we share a certain philosophy. The ArchTrack project
            is different and distinct. This is an original abstract
            design. It's simple and clean, and shouldn't conflict with
            any other logos.
            -   Can't upload and embed it on this page, but you can see
                it as the icon on our Twitter account (@archtrack) or
                directly here.
            -   As ASCII Art

          |      |
        __|_|  |_|__
          | |\/| |
          |      |

-   -   Wiki page
        -   Continue modularization
        -   Use templates to allow for easy transclusion of a tool to
            appear in multiple functional areas
        -   Improve the organization and categorization of the tools
            tables
            -   Add color-coded status column

    -   Properly acquire administrative control of freenode irc channel
        #archtrack
    -   Register @ArchTrack twitter account and set up automatic
        announcements of various events (releases, wiki page edits,
        commits to the github repo...)

-   Translations?
-   Supporting custom tools or scripts?
    -   Single command to update everything
    -   Menus
    -   Online documentation

Participation
-------------

If you like this idea and want to help, please dive in. The first
milestone is probably the most difficult and will take the longest to
accomplish. Accordingly, it is the area of greatest need. There is no
official record of "project membership" or "project leaders", just what
people contribute. If you feel so moved please investigate how to use
the AUR and develop packages for it, then pick a tool off the list and
get to work.

Please do not feel restricted to selecting a tool off our list. Many
things exist that we just do not know about, although I hope that if it
were popular/good my attentive scouring should have found it. We need
your eyeballs to help find the tools that ArchTrack should contain (or
at least be aware of) ;-) In which case, it'd help if you make a
PKGBUILD for it and submit it to the AUR.

Finally, if you want to make sure that we know that your AUR package
exists, please send a quick email to
ryooichi[PLUS]archtrack[AT]gmail[DOT]com with the name of the tool,
which categories it should be in, and the AUR id of your package.

If you have some other contribution (such as logo work, etc) and aren't
interested in becoming an AUR package maintainer, I'd recommend that you
learn how to do it and/or find someone to help you. I'll restate that
this is a community effort and this community needs people who are
willing to choose a cause and run with it, not people that require lots
of hand-holding and babysitting. Failing that, you could email it to
ryooichi[PLUS]archtrack[AT]gmail[DOT]com and I'll incorporate it when
possible.

Forms
-----

These are beta. Try them out and send us any feedback. We'll see how
they work.

-   Tool Suggestion: Let us know about a tool (View results)
-   Toolkit Suggestion: Let us know about a collection of tools (View
    results)

Contact Information
-------------------

Here is a summary of the best places to learn more, communicate, and get
involved:

-   Wiki Page: Central point
-   @ArchTrack on Twitter: Announcements
    -   If you're on Twitter, you can follow us to show support, ask
        questions and get automatic updates from this wiki page, the
        talk page, github and sourceforge!
    -   Alternatively you can use our Twitter RSS feed to acheive the
        same aggregation without joining Twitter.

-   IRC: #archtrack on Freenode (unofficially?): Support
-   Talk Page: Background discussion
-   ArchTrack project at SourceForge: Project page
-   Ryooichi's ArchTrack project at GitHub: Development
-   AUR: Please make comments about the packages on their respective AUR
    page: archtrack
    -   The "0.x" versions should tip you off to the fact that these are
        to be considered VERY EXPERIMENTAL!

-   Forums
    -   Networking, Server, and Protection » Archtrack (id=58401,
        pid=786669)

-   Email
    -   ryooichi[PLUS]archtrack[AT]gmail[DOT]com

> Other

-   The Ethical Hacker Network - ArchTrack

> Historical

-   http://wiki.nofxx.com/arch:at
-   http://wiki.archlinux-br.org/AT

Links
-----

-   BackTrack official website
-   Offensive Security blog

Retrieved from
"https://wiki.archlinux.org/index.php?title=ArchTrack&oldid=209369"

Category:

-   Security
