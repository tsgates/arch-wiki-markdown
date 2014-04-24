DeveloperWiki:Patching
======================

Contents
--------

-   1 Patching
    -   1.1 Vanilla Packages
    -   1.2 When is patching acceptable?
    -   1.3 When is patching discouraged?

Patching
========

This policy is intended to *suggest*, not to enforce.

> Vanilla Packages

Arch tries, as much as possible, to ship packages as the original author
of the software intended. This means that every time we add a patch, we
take one more step away from their intent. Additionally, patches can be
hard to maintain when we're talking hundreds of packages.

> When is patching acceptable?

It's inevitable that some software will need modifications to work.

-   Patches to the *build system* are pretty much always allowed. This
    is usually needed when Arch's tools are too new for shipped scripts,
    and things do not work right (libtool is a known offender here).

-   Patches due to a *too new* compiler are usually allowed. GCC
    releases tend to be more and more strict, disallowing things that
    were once allowed. Fixing compiler errors so that the source builds
    under Arch are common and allowable.

-   When a *major feature* doesn't work in the app, bug fix patches are
    allowed. To explain 'major feature', think of an app that burns DVDs
    - if it doesn't burn DVDs due to a bug, well, that's a major
    feature. If the 'Help' menu doesn't work, well, that's a minor
    feature.

> When is patching discouraged?

-   Fixing minor features is not our job and patches should not be
    applied to fix things not directly related to the app's
    functionality. Patches to fix typos or images are discouraged.

-   Additional features should *NOT* be added by Arch. Patches that add
    completely new features should be sent to upstream. As said before -
    we ship packages as the ORIGINAL AUTHORS intended them. Not as WE
    intend them.

-   Features denied by upstream. If a patch was sent and the original
    developers denied it, we should *NEVER* apply that patch, no matter
    how opinionated we are. You are welcome to fork the app and supply a
    package for your own app.

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:Patching&oldid=161307"

Category:

-   DeveloperWiki

-   This page was last modified on 21 September 2011, at 18:53.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
