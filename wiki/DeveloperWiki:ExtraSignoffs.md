DeveloperWiki:ExtraSignoffs
===========================

Extra Signoffs
==============

> Process

The process is simple:

-   If you need to test a package from the [extra] repository, you can
    add it to [testing]
-   When a [extra] package is placed in [testing] an email SHOULD be
    sent to the arch-dev-public mailing list with the subject "[signoff]
    [extra] foobar-1.0-1", where foobar-1.0-1 is the package name and
    version.
-   In the email the maintainer has to say the reasons why that package
    went to [testing]
-   All developers are encouraged to test this package.
-   If a package works fine, a reply SHOULD be sent, telling the
    maintainer it worked, and on which architecture.
-   When a package receives 2 signoffs for each architecture, it can be
    moved from [testing] to [extra].
-   A maintainer is free to leave a package in [testing] for further
    testing or signoffs, but should make this intention known in the
    signoff email.

> Caveats

The maintainer himself *DOES* count as a signoff. We are working under
the assumption that the maintainer did test the package before pushing
it to [testing]. Thus, a package may only need one signoff if the
original maintainer tested it on both architectures before uploading.

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:ExtraSignoffs&oldid=89127"

Category:

-   DeveloperWiki
