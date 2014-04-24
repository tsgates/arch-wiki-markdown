Security Task Force
===================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Related articles

-   Arch CVE Monitoring Team

This is a draft of the proposal to create a Arch Linux Security Team
(ALST) centered around Arch Linux. Once the idea has passed, this page
will be edited to carefully explain the duties of ALST members.

Contents
--------

-   1 Philosophy
-   2 Purpose
    -   2.1 Mirror update speed
    -   2.2 Maintainer's reaction
-   3 Procedure
-   4 Implementation
    -   4.1 What constitutes an important security update?
    -   4.2 Infrastructure
    -   4.3 ALST members' duties

Philosophy
----------

ALST should help the developers, not add more work to them.
Participation in ALST should be voluntary and, with the exception of one
or more TUs, left to the non-developers. STF should conform to the Arch
Philosophy - following the STF recommendations should be optional for
all users of Arch Linux.

Purpose
-------

ALST should embody the efforts of the "security-conscious" part of the
Arch users population. Server owners, maintainers of workstations in
production environments as well as concerned personal users would gain
the benefit of relatively prompt security updates. ALST should help
alleviate two important problems.

ALST Will Strive to Monitor all Packages within the following
repositories:

-   current
-   extra
-   testing
-   community

Maintainers in the unsupported category may be called upon to update
packages due to security concerns, however this will be strongly
dependent on the various maintainers within the AUR system.

ALST Members will not be responsible for creating interim packages to
prevent duplicate PKGBUILDS or packages. Updated Package builds can be
suggested to developers and TU's, but it is up to the discretion of the
package maintainer to update a particular package.

> Mirror update speed

ALST important security notices will include a direct link to the
updated package on one of the central servers. This allows the users to
manually download the updated package and pacman -U it.

> Maintainer's reaction

Arch Linux developers are volunteers with their own personal lives. They
might not have time to promptly address updates of their packages. They
might have not heard about a recent security update. ALST members would
suggest the maintainers to update their packages once an important
security flaw has been found.

Likewise the ALST is a volunteer maintained service. Volunteers are
welcome to help out the ALST identify and notify packages with security
vulnerabilities.

Procedure
---------

A big security exploit has been found for package-1.5.8. The developer
of this package has released 1.5.9 that fixes this exploit. An ALST
member picks up this information from some mailing list he/she is
following. Since the member believes this constitutes an important
security update (see below), he/she contacts the maintainer of package
Arch Linux package.

The vulnerable package should be flagged 'out-of-date', and the
maintainer notified. Packages maintained by Arch Linux team members will
be notified via the bug-tracking system at https://bugs.archlinux.org

Once the maintainer addresses the issue and updates the package to
package-1.5.9, the ALST member posts on the "Arch-Security" mailing
lists would follow this format:

    ------------------------------------------------------------
    Arch Linux Security Warning		ALSW <Year>-<Warning#>
    ------------------------------------------------------------

    Name:      <Package Name>
    Date:      <Date Update Released>
    Severity:  <Code Warnings
    Warning #: <Year>-<Warning>

    ------------------------------------------------------------

    Product Background
    ===================
    <Package Information>

    Problem Background
    ===================
    Description of Exploit

    A remote malicious server could execute arbitrary code
    on a client by using 'setenv' with the LD_PRELOAD
    environment variable. Malicious code could be executed 
    on the client machine with full rights.

    Problem Packages
    ===================
    ------------------------------------------------------------------
    Package       |   Repo    |   Group    |   Unsafe   |    Safe    |
    ------------------------------------------------------------------
    Package Name     Current    Network      < 2.0.6-1    >= 2.0.6-1

    Package Fix
    ===================
    Link to updated Package Direct on Main Arch Linux Servers
    Link to PKGBUILD for Users to build own packages


    Reference(s)
    ===================
    http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-1629

    Contact	
    ===================
    If you have problems, concerns, questions or appreciation, you
    can contact the security team at <ALST Email address>

All notices should be signed using PGP (or OSS equivalents such as
GnuPG) to verify message integrity to users watching the ALST Updates.

All packages will have a severity of one of the following:

Severe
    A critical hole has been discovered. It is strongly recommended to
    update ASAP
High
    A noticeable hole has been discovered. Recommend Upgrade
Medium
    A hole has been discovered. Update when possible.
Low
    A small hole containing a possible exploit has been found. Update as
    needed.

Some updates will be much more critical than others, however updates are
always recommended in the case of any vulnerability. In the case of a
production or test server, updates can be followed at the digression of
the user/administrator.

Please note: This is a voluntary service providing advice to the
community. Following these procedures is not mandatory.

Implementation
--------------

> What constitutes an important security update?

This is left to ALST members. An update to, say, apache would definitely
be considered important. On the other hand, member might find a security
flaw in gaim not to be of too much importance. How big the security
exploit is also affects the reasoning. If it is a relatively popular
network program and allows arbitrary code execution then it will
probably be deemed important.

While ALST Team Members will strive to stay on top of all security
updates, it should be noted that programs with a lower impact may not be
immediately updated or noticed by either ASLT members or TU's

> Infrastructure

ALST members would need an "Arch-security" mailing list, hopefully
linked from archlinux.org webpage. For inter-ALST discussions, a forum
thread or a mailing list should be enough.

> ALST members' duties

The members would need to read their favourite security-related mailing
list and act accordingly. TUs might need to build some interim packages,
however, hopefully that should only be a small number change in
PKGBUILD.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Security_Task_Force&oldid=304505"

Categories:

-   Arch development
-   Security

-   This page was last modified on 14 March 2014, at 19:55.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
