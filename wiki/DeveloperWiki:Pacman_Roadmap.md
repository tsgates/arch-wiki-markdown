DeveloperWiki:Pacman Roadmap
============================

This page does not provide a traditional roadmap. Pacman releases are
generally made after a major feature has been added and these get added
in the order that patches are contributed.

Instead, this page provides a brief overview of major features being
discussed for future inclusion in pacman. This does not represent a
complete list of all areas of pacman development (or even areas
currently being developed...). All discussion about pacman development
should take place on the pacman-dev mailing list.

Contents
--------

-   1 Potential Release Schedule
    -   1.1 Pacman 4.2
-   2 New Feature Ideas
    -   2.1 Package Signing - Polishing
    -   2.2 Hooks
    -   2.3 Optdepend Handling
    -   2.4 Parallel operations
    -   2.5 Iterator interface for databases
-   3 Future Release Plans

Potential Release Schedule
--------------------------

This is not a for sure list by any means. This is simply to keep the
main development team focused on a given release and what needs to be
polished before we can push a major version out the door.

  

> Pacman 4.2

Applied:

-   makepkg-template
-   directory as symlink support removal

Planned:

-   (Nothing)

New Feature Ideas
-----------------

> Package Signing - Polishing

Idea: Tidy up our current implementation of package signing.

Flyspray: FS#28014 FS#34741

> Hooks

Idea: Pacman should have hooks to perform common tasks. See here for a
more detailed description.

Flyspray: FS#2985

Mailing List:

-   https://mailman.archlinux.org/pipermail/pacman-dev/2010-July/011441.html
    (first of set of four)
-   https://mailman.archlinux.org/pipermail/pacman-dev/2011-January/012313.html
-   https://mailman.archlinux.org/pipermail/pacman-dev/2011-January/012335.html

Development branch: Not started

> Optdepend Handling

Idea: Currently optdepends in pacman serve no purpose other than
informational. It would be useful if these could be handled in a similar
fashion to regular dependencies for many operations. See here for a more
detailed description of what is currently being implemented.

Flyspray: FS#12708 (and others)

Mailing List:
https://mailman.archlinux.org/pipermail/pacman-dev/2011-August/013961.html

Development branch: https://github.com/moben/pacman/tree/optdep

> Parallel operations

Idea: Some things libalpm does are embarrassingly parallel, make it
happen. Also, simply allow the library to be used in multithreaded
environments even if we do not do parallel stuff on our own- namely DB
loading stuff needs to be protected.

Flyspray: (None)

Mailing List:
https://mailman.archlinux.org/pipermail/pacman-dev/2011-February/012466.html,
https://mailman.archlinux.org/pipermail/pacman-dev/2011-February/012508.html

> Iterator interface for databases

Idea: Provide an iterator interface for databases, especially those with
'files' entries, to keep memory usage in check.

Mailing List:
https://mailman.archlinux.org/pipermail/pacman-dev/2011-July/013816.html

Future Release Plans
--------------------

See flyspray roadmap

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:Pacman_Roadmap&oldid=264733"

Category:

-   Pacman development

-   This page was last modified on 30 June 2013, at 00:55.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
