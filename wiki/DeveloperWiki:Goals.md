DeveloperWiki:Goals
===================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Current Suggestions                                                |
|     -   2.1 James Rayner                                                 |
|     -   2.2 Roman Kyrylych                                               |
|     -   2.3 Paul Mattal                                                  |
|     -   2.4 Aaron Griffin                                                |
|     -   2.5 eliott                                                       |
|     -   2.6 Phil                                                         |
+--------------------------------------------------------------------------+

Introduction
============

This page is for a common set of general goals, NOT specific tasks. They
are better set on the DeveloperWiki:Objectives page, and developed
*after* goals. This article is part of the DeveloperWiki.

Objectives change over time, the Goals are a set of mostly static
targets we all agree on. Objectives are tasks destined to assist fulfill
and ensure we reach those targets, Goals.

Current Suggestions
===================

James Rayner
------------

-   Provide the latest software as is practical, while aiming to achieve
    a reasonable level of stability
-   Not be dependent on any graphical interface for any system function
-   Remain a lightweight, general purpose distribution that is simple in
    its implementation
-   Continue to be a strongly community oriented distribution

Roman Kyrylych
--------------

-   Provide a good set of reliable and modern Linux technologies for
    desktop, server and portable PCs
-   Be equally suitable for home, educational, small business and
    corporate use
-   Provide a solid base for creating custom Arch (ISOs and repos)
    variants for users specific purposes
-   Remain a "install once, run forever" distribution
-   Provide good i18n and l10n support

Paul Mattal
-----------

These may be a bit long, but I've copied them in from an email written
some time ago and at the time many thought they were a good summary of
Arch cornerstones. I think they're still useful today.

-   Simple design. Reasoning: “Debugging is twice as hard as writing the
    code in the first place. Therefore, if you write the code as
    cleverly as possible, you are, by definition, not smart enough to
    debug it.” – Brian W. Kernighan
-   i686 only. One architecture. Reasoning: It keeps things simple for
    the developers, and keeps us from spreading ourselves too thin.
    Clearly, Arch will eventually have to at least choose another
    architecture.. i686 won't be around forever. I'm not opposed to
    bringing on more developers and finding ways for us to support
    multiple architectures, if done correctly, but I believe strongly
    that each architecture should have a separate maintenance team in
    order for this critical aspect of Arch's success to be preserved.
-   Vanilla. As few patches as is reasonable to make things play
    together in the ways necessary, and then primarily as stopgap
    solutions until things get fixed upstream. This creates
    predictability and allows smart people with general GNU/Linux
    knowledge to pick up Arch instantly. It also keeps us from
    maintaining more and more custom patches over time.
-   Easy packaging with pacman. The SINGLE thing that will probably keep
    me from ever leaving Arch is how simple it is to create packages
    with Pacman. The thought of ever having to write another RPM spec
    file or something else as obtuse or complicated or ill-conceived as
    that makes me want to toss my lunch. When I find new software on the
    Web to help me do my work, I can have it packaged and integrated
    into my bag of tricks usually in less than an hour. As a result of
    this simplicity, we have a Community who understands what's going on
    and can be productively helpful and supportive of each other.
-   Binary distribution. Unlike Gentoo, we can download and install
    Firefox on a reasonably fast machine with a reasonably fast link in
    less than a minute. Also, we test and certify binaries, so quirks of
    people's machines don't bugger up their compile processes. The
    result is that after a pacman -Syu, on any machine, most things just
    work.

"i686 only" is a outdated now as we have official x86_64 too. However,
it's obvious that Arch shouldn't support as many archs as Debian, and
projects like LowArch (i586) and probably Arch Linux PPC will be better
managed separately. -- Roman Kyrylych

  

Aaron Griffin
-------------

This might not be exactly where or what we are, but cactus once called
Arch a "meta distribution". That is, it gives you tools and a very nice
base with which you can do whatever you want. I think this also
coincides with 2 of the "goals" I would like to see - that is, (a) like
Andy said, we provide a very nice base system and not much more, and (b)
"Slackware with pacman" - we get likened to Slackware enough, and I
think the simplicity that Slackware strives for is ideal for us as well.

eliott
------

I say focus more on the core packages, the underlying fundamentals. Push
the addons higher into the stack. I liken Arch to one of the BSD's,
oddly enough. The BSD team focuses on handling the core. They deal with
things that come about when the system goes from poweroff to running a
base network OS. Then ports managers handle the packages that lay on top
of this core system. Just a thought.

Phil
----

Not got much to add but some point I'd like to ack:

-   I'm with eliott regarding a bigger differentiation between core and
    everything else.
-   I also don't think commitments to further architectures will benefit
    the distro, as Roman said
-   I'd also like to see continued support for i18n, even though i don't
    need it.

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:Goals&oldid=100719"

Category:

-   DeveloperWiki
