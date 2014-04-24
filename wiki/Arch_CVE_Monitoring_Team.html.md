Arch CVE Monitoring Team
========================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: For now, this     
                           page is a draft to       
                           construct something      
                           according to             
                           https://mailman.archlinu 
                           x.org/pipermail/arch-dev 
                           -public/2014-March/02595 
                           2.html                   
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Related articles

-   Security Task Force
-   CVE-2014

  
 This article introduces the Arch CVE Monitoring Team (ACMT) and
describes best practices for contributing.

  

Contents
--------

-   1 Introduction
-   2 Joining the ACMT
-   3 Participation Guidelines
-   4 Procedure
    -   4.1 Bug Report Template
-   5 Resources
    -   5.1 RSS
    -   5.2 Mailing Lists
    -   5.3 Other Distributions
    -   5.4 Other
    -   5.5 More
-   6 Package Categories and Team Members

Introduction
------------

Arch Linux is a community-driven distribution. It relies upon the
efforts of volunteers to maintain and improve the distribution itself
and to support fellow community members.

The importance of software security cannot be overstated. Today's
society relies upon computer technology for everything from amusement to
indispensable national and local infrastructure. Many rely upon Arch
Linux to provide these.

On March 9, 2014, Allan McRae called upon our community to assist in
securing Arch Linux by monitoring any and all relevant resources for
announced Common Vulnerabilities and Exposures (CVE's). In contrast to
security issues which can be fixed by updating, CVE's require patches to
be backported. As such, Arch developers must be notified that this is
the case. This is where the ACMT comes in.

The ACMT should embody the efforts of the "security-conscious" part of
the Arch users population. Server owners, maintainers of workstations in
production environments as well as concerned personal users would gain
the benefit of relatively prompt security updates. The ACMT should help
alleviate two important problems: finding bugs, communicating with
developers.

The Team is a volunteer maintained service. Volunteers are welcome to
help identify and notify packages with security vulnerabilities.

Joining the ACMT
----------------

Joining is as simple as helping. Firstly, join the Arch Security mailing
list and/or IRC chan #archlinux-security. Secondly, consider the area
where you'd like to help. It would be ideal to have team members' labor
divided across the software ecosystem as equally as possible. This helps
the Team to quickly and efficiently find and report CVE's. Software
categories are listed below. However, it is not required that those who
wish to volunteer restrict their monitoring in any way. "Global" and
multiple-category volunteers are needed and encouraged.

It is recommended that interested parties please consider monitoring
those categories for which there are fewer volunteers. However, it is
fully recognized that volunteers contribute best in areas in which
they're most interested. Please consider both of these factors when
selecting where your primary efforts will be placed. However, please
note that it is not required that you restrict your monitoring to any
one particular category. The goal of the ACMT is to simply keep Arch
Linux secure. Any and all efforts are more than welcome and unreservedly
appreciated.

If you would like to join the Team, please edit this page to include
your name in the Package Categories and Team Members section below.
Please place your name beneath the package category for which you will
be monitoring. If you do not care to monitor specific categories and you
would like to contribute any and all, please place your name in the
"Global" category. These options are not mutually exclusive.

Participation Guidelines
------------------------

ACMT monitors all packages within the following repositories:

-   core
-   extra
-   community

Follow mailing lists (both development and user), security advisories
(if any) and bug trackers on a regular basis. A few resources are listed
below. You will quickly learn the different kind of vulnerabilities if
you are unfamiliar. For those who will monitor languages, it is ideal to
be able to operate at both the interpreter level (often written in C)
and the language level.

Everyone should file bug reports. If you are unsure how to file a bug
report, please refer to the Bug Reporting Guidelines.

People with the technical ability are encouraged to not only file bug
reports about CVE's, but write/comment patches, test, communicate with
upstream developers, among other things.

Procedure
---------

A critical security exploit has been found in a software package within
the Arch Linux official repositories. An ACMT member picks up this
information from some mailing list he/she is following. If upstream
released a new version that corrects the issue, the ACMT member should
flag the package out-of-date and post pertinent information to the
arch-security mailing list, which will likely get the attention of the
developers. If, on the other hand, upstream releases only a patch, the
ACMT member should file a bug report.

Bug Report Template

    Title : [<pkg-name>] security patch for <CVE-id>
    Description:
    Quick description of the issue (or copy/paste from oss-sec, upstream bug reports, etc.)
    upstream bug report [0]

    Resolution:
    patch [1] 

    Resources:
    [0] links to upstream bug report
    [1] link to patch

The criticality of the bug report should be set to either Critical or
High, depending on the severity of the issue. Some updates will be much
more critical than others. However, updates are always recommended in
the case of any vulnerability.

Once this process is complete, please add the CVE to the CVE-2014
Documented Resolved CVE table.

Resources
---------

> RSS

National Vulnerability Database (NVD) 
    All CVE vulnerabilites: http://nvd.nist.gov/download/nvd-rss.xml
    All fully analyzed CVE vulnerabilities:
    http://nvd.nist.gov/download/nvd-rss-analyzed.xml

> Mailing Lists

oss-sec
    main list dealing with security of free software, a lot of CVE
    attributions happen here, required if you wish to follow security
    news.  
    info:
    http://oss-security.openwall.org/wiki/mailing-lists/oss-security
    subscribe: oss-security-subscribe(at)lists.openwall.com
    archive: http://www.openwall.com/lists/oss-security/

bugtraq
    a full disclosure moderated mailing list (noisy)
    info: http://www.securityfocus.com/archive/1/description
    subscribe: bugtraq-subscribe(at)securityfocus.com

full-disclosure
    another full-disclosure mailing-list (noisy)
    info: http://lists.grok.org.uk/full-disclosure-charter.html
    subscribe: full-disclosure-request(at)lists.grok.org.uk

Also consider following the mailing lists for specific packages, such as
LibreOffice, X.org, Puppetlabs, ISC, etc.

> Other Distributions

Resources of other distributions (to look for CVE, patch, comments
etc.):

RedHat and Fedora
    
    rss advisories:
    https://admin.fedoraproject.org/updates/rss/rss2.0?type=security
    CVE tracker: https://access.redhat.com/security/cve/<CVE-id>
    bug tracker: https://bugzilla.redhat.com/show_bug.cgi?id=<CVE-id>

Ubuntu
    
    advisories: http://www.ubuntu.com/usn/atom.xml
    CVE tracker:
    http://people.canonical.com/~ubuntu-security/cve/?cve=<CVE-id>
    database:
    https://code.launchpad.net/~ubuntu-security/ubuntu-cve-tracker/master

Debian
    
    CVE tracker: http://security-tracker.debian.org/tracker/<CVE-id>
    patch-tracker: http://patch-tracker.debian.org/
    database: http://anonscm.debian.org/viewvc/secure-testing/data/

OpenSUSE
    
    CVE tracker: http://support.novell.com/security/cve/<CVE-id>.html

> Other

Mitre and NVD links for CVE's
    
    http://cve.mitre.org/cgi-bin/cvename.cgi?name=<CVE-id>
    http://web.nvd.nist.gov/view/vuln/detail?vulnId=<CVE-id>

NVD and Mitre do not necessarily fill their CVE entry immediately after
attribution, so it's not always relevant for Arch. The CVE-id and the
"Date Entry Created" fields do not have particular meaning. CVE are
attributed by CVE Numbering Authorities (CNA), and each CNA obtain CVE
blocks from Mitre when needed/asked, so the CVE ID is not linked to the
attribution date. The "Date Entry Created" field often only indicates
when the CVE block was given to the CNA, nothing more.

Linux Weekly News
    LWN provides a daily notice of security updates for various
    distributions
    http://lwn.net/headlines/newrss

> More

For more resources, please see the OpenWall's Open Source Software
Security Wiki.

  

Package Categories and Team Members
-----------------------------------

Below is a list of general package categories. Should you like, you are
welcome to add a new category. Please remember the KISS philosophy when
editing the list.

-   Global

Billy Wayne McCann

HegemoOn

[Your Name Here]

-   Kernel

Mark Lee

-   Filesystems

[Your Name Here]

-   GNU userland

RbN

-   Xorg

RbN

-   Systemd

RbN

-   Perl and associated software

[Your Name Here]

-   Python and associated software

Scott Lawrence

[Your Name Here]

-   Java and associated software

[Your Name Here]

-   Ruby and associated software

[Your Name Here]

-   Gtk/Gnome and associated software

[Your Name Here]

-   QT/KDE and associated software

Billy Wayne McCann (KDE)

[Your Name Here]

-   Various Windows Managers (please include which WM along with your
    name)

[Your Name Here]

Retrieved from
"https://wiki.archlinux.org/index.php?title=Arch_CVE_Monitoring_Team&oldid=305500"

Categories:

-   Arch development
-   Security

-   This page was last modified on 18 March 2014, at 17:33.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
