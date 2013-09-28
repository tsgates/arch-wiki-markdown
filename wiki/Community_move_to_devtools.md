Community move to devtools
==========================

Proposal: Make [community] use the same repository system as [core] or
[extra].

Result: The proposal was passed on 23 Jan 2009. The [community]
repository has recently moved to a new server and has been moved to the
SVN/devtools setup. Shell accounts have been created for Trusted Users.
See the following threads for details on the transition:  
 https://www.archlinux.org/pipermail/aur-general/2009-June/005359.html  
 https://www.archlinux.org/pipermail/aur-general/2009-July/005844.html

* * * * *

Reference:
https://archlinux.org/pipermail/aur-general/2008-December/003325.html   
The above thread contains the initial discussion on this proposal.

For quite a while, [community] in Arch has led an almost independent
existence, being tightly coupled with the AUR. Many improvements have
been made in the workflow of package distribution in 'devtools' which
are used for uploading and managing packages in the [core] and [extra]
repositories.

This proposal suggests that the [community] repository move to using the
same repository system as [core] or [extra]. The benefits and detriments
of the proposal, along with the technical steps to complete the
transition (if the proposal were to be passed) are discussed below.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Detriments                                                         |
| -   2 Benefits                                                           |
| -   3 Technical steps for the transition                                 |
|     -   3.1 Behind the scenes                                            |
+--------------------------------------------------------------------------+

Detriments
==========

-   It might affect the autonomy of Trusted Users, and this is a big
    change from the way we've been used to.
-   The effort to make the transition happen is not trivial.
-   You'd lose votes for community packages.
-   You'd lose package comments and notifications.
-   Combining community packages with official packages will contribute
    a performance hit for all repos when dealing with build files.

Note: We may still be able to keep community packages in the AUR
interface. It will just take a bit of patching of community scripts to
keep them.

Benefits
========

-   There'll be fewer tools to support, since Trusted Users would then
    use the same tools as Arch developers, but with reduced permissions
    (only permission to write to the [community] repository)

-   It'd be much easier to create and maintain a [community-testing]
    repository (or even the [testing] repository, if it's possible to
    cleanly separate the relevant permissions). A testing repository for
    [community] would be a great help in doing rebuilds.

-   It'll be easier to migrate from being a Trusted User to a developer,
    since all the repositories would be using the same infrastructure. A
    simple permissions change, and they could be uploading packages to
    [core] or [extra].

-   [community] would naturally become more decoupled from the AUR.
    Packages in [community] would become visible on the main Arch
    website, giving greater visibility to [community]. Also the search
    function on the website would then be able to search across all the
    repositories.

-   The AUR code becomes greatly simplified, making code refactoring or
    rewrites easier.

Technical steps for the transition
==================================

Reference:
https://archlinux.org/pipermail/aur-general/2009-January/003460.html

-   devtools/db-scripts have to be patched for [community]. ABS also has
    to be patched.
-   Decide what's to be done on the web frontend side (AUR, main Arch
    site) and then do it!
-   CVS to SVN migration. This would not be much of a problem since
    there would be scripts from the main repository migration lying
    around.

Behind the scenes
-----------------

-   Admins would now need to maintain user accounts for new TUs or when
    TUs leave.
-   Quotas will probably need to be implemented for disk/cpu/ram usage,
    as we open gerolde up to way more user accounts in one fell swoop

phrakture 12:50, 9 January 2009 (EST)

  
 The most important objective of this proposal is to make [community]
use the same infrastructure (devtools, etc.) as the Arch official
repositories [core] and [extra]. Technical details about how the
transition is to be made (whether [community] and AUR should be totally
decoupled, for example) need to be discussed.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Community_move_to_devtools&oldid=237822"

Category:

-   Arch development
