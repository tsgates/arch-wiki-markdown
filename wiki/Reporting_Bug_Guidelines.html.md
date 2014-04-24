Reporting Bug Guidelines
========================

Related articles

-   General Troubleshooting
-   Step By Step Debugging Guide
-   Debug - Getting Traces

Opening (and closing) bug reports on the Arch Linux Bugtracker is one of
many possible ways to help the community. However, poorly-formed bug
reports can be counter-productive. When bugs are incorrectly reported,
developers waste time investigating and closing invalid reports. This
document will guide anyone wanting to help the community by efficiently
reporting and hunting bugs.

See also: How to Report Bugs Effectively by Simon Tatham

Contents
--------

-   1 Before reporting
    -   1.1 Search for duplicates
    -   1.2 Upstream or Arch?
    -   1.3 Bug or feature?
        -   1.3.1 Reasons for not being a bug
        -   1.3.2 Reasons for not being a feature
    -   1.4 Gather useful information
        -   1.4.1 See also
-   2 Opening a bug
    -   2.1 Creating an account
    -   2.2 Projects and categories
    -   2.3 Summary
    -   2.4 Severity
    -   2.5 Including relevant information
-   3 Following up on bugs
    -   3.1 Voting and Watching
    -   3.2 Answering additional information requests
    -   3.3 Updating the bug report when a new version of the related
        software is out
    -   3.4 Closing when solved
    -   3.5 More about bug status
-   4 See also

Before reporting
----------------

Preparing a detailed and well-formed bug report is not difficult, but
requires an effort on behalf of the reporter. The work done before
reporting a bug is arguably the most useful part of the job.
Unfortunately, few people take the time to do this work properly.

The following steps will guide you in preparing your bug report or
feature request.

> Search for duplicates

If you encounter a problem or desire a new feature, there is a high
probability that someone else already had this problem or idea. If so,
an appropriate bug report may already exist. In this case, please do not
create a duplicate report; see #Following up on bugs instead.

Search thoroughly for existing information, including:

-   Arch Linux Forums: The forums are often the first stop for users
    looking for help or sharing ideas. While a solution may not yet
    exist, additional background information and discussion can steer
    you in the right direction.

-   Arch Linux Bugtracker: Your problem may have already been reported
    to Arch Linux developers. Duplicate bug reports are unhelpful and
    promptly closed. Search both recently closed bugs as well as open
    reports. Remember to mark 'search details' and/or 'search comments'
    under Advanced, the bug title may not contain the text you're
    searching for.

-   Google or your favorite search engine: Search using the program's
    name, version, and a relevant part of the error message, if any.

-   Upstream forum, mailing list and bug tracker: If Arch Linux is not
    responsible for a bug, it should be reported upstream rather than
    the Arch Linux Bugtracker. Search both recently closed bugs as well
    as open reports. Bugs may have already been fixed in the program's
    development version.

-   Other distribution forums: The free software community is vast;
    Archers are not the only users with ideas! Consider searching the
    Gentoo Forums, FedoraForum.org, and Ubuntu Forums, for example.

> Upstream or Arch?

Arch Linux is a GNU/Linux distribution. Arch developers and Trusted
Users are responsible for compiling, packaging, and distributing
software from a wide range of sources. Upstream refers to these sources
– the original authors or maintainers of software that is distributed in
Arch Linux. For example, the popular Firefox web browser is developed by
the Mozilla Project.

If Arch is not responsible for a bug, the problem will not be solved by
reporting the bug to Arch developers. Responsibility for a bug is said
to lie upstream when it is not caused through the distribution's porting
and integration efforts.

By reporting bugs upstream, you will not only help Archers and Arch
developers, but you will also help other people in the free software
community as the solution will trickle down to all distributions.

Once you have reported a bug upstream or have found other relevant
information from upstream, it might be helpful to post this in the Arch
bug tracker, so both Arch developers and users are made aware of it.

So what is Arch Linux responsible for?

-   Arch Linux Projects: pacman, AUR, initscripts, Arch Websites. If you
    have a doubt about if the project belongs to Arch or not, display
    the package information (pacman -Qi foobar_package or using the
    website) and look at the URL.

-   Packaging: Packaging basically consists of fetching the source code
    from upstream, compiling it with relevant options, making sure that
    it will be correctly installed on an Arch system, and checking that
    the main functionality works. Packaging at Arch does not consist of
    adding new functionality or patches for existing bugs; this is the
    job of the upstream developer.

If a bug/feature is not under Arch's responsibility, report it upstream.
See also Reasons for not being a bug.

> Bug or feature?

bug
    something that should work but does not work, contrary to the
    developer's intentions.
feature
    something which software does or would do if somebody coded it.

Reasons for not being a bug

-   Something you would like a piece of software to do, which is not
    implemented by the upstream developers. In short : a new feature.
-   A bug already reported upstream.
-   A bug already fixed upstream but not in Arch because the package is
    not up-to-date.
-   A package which is not-up-to-date. Use the Flag Package Out-of-Date
    feature on Arch's packages website.
-   A package which does not use Fedora, Ubuntu or some other community
    patch. Patches should be submitted upstream.
-   A package where non essential function X or function Y is not
    activated. This is a feature request.
-   A package which does not include a .desktop file or icons or other
    freedesktop stuff. This is not a bug if such files are not included
    in the source tarball, and this must be requested as a feature
    request upstream. If such files are provided by upstream but not
    used in the package then this is a bug.

Reasons for not being a feature

-   When it is a bug ...
-   When it is not under Arch responsibility to implement the feature,
    i.e. an upstream feature.
-   A package is not up-to-date. Use the Flag Package Out-of-Date
    feature on Arch's packages website.
-   A package which does not use Fedora, Ubuntu or some other community
    patch. Patches should be submitted upstream.

> Gather useful information

Here is a list of useful information that should be mentioned in your
bug report :

-   Version of the package being used. Always specify package version
    Saying "the latest" , "todays" , or "the package in extra" have
    absolutely no meaning. Especially if the bug is not about to get
    fixed right away.

-   Version of the main libraries used by the package (available in the
    depends variable in the PKGBUILD), when they are involved in the
    problem. If you do not know exactly what information to provide then
    wait for a bug hunter to ask you for it ...

-   Version of the kernel used if you are having hardware related
    problems.

-   Indicate whether or not the functionality worked at one time or not.
    If so indicate since when it stopped working.

-   Indicate your hardware brand when you are having hardware related
    problems

-   Add relevant log information when any is available. This can be
    obtained in the following places depending on the problem :
    -   /var/log/messages for kernel and hardware related issues.
    -   /var/log/Xorg.0.log or /var/log/Xorg.2.log or any Xorg like log
        files if video related problems (nvidia, ati, xorg ...)
    -   Run your program in a console and use verbose and/or debug mode
        if available (see your program documentation), and copy the
        output in a file. When running an application in a terminal make
        sure relevant information will be displayed in english so that
        many people can understand it. This can be done by using export
        LC_ALL="c". Example with a software named foobar from which you
        would like to have relevant information at runtime and provided
        that foobar has a --verbose option :

    someone@somecomputer # export LC_ALL="C"
    someone@somecomputer # foobar --verbose

This will affect only the current terminal and will stop taking effect
when the terminal is closed.

If you have to paste a lot of text, like the output of dmesg, or a Xorg
log, is it preferred to save it as a file on your computer and attach it
to your bug report. Attaching a file rather than using a pastebin to
present relevant information is preferable in general due to the fact
that pastebined content may suffer by expired links or any other
potential problems. Attaching a file guarantees the provided information
will always be available.

-   Indicate how to reproduce the bug. This is very important, it will
    help people test the bug and potential patches on their own
    computer.

-   The stack trace. It is a list of calls made by the program during
    its execution, and helps in finding part of the program where the
    bug is located, especially if bug involves the program crashing. You
    can obtain a stack trace using gdb (The GNU Debugger) by running the
    program with "gdb name_of_program" and then typing "run" at the gdb
    prompt. When the program crashes, type "bt" at the gdb prompt to
    obtain the stack trace and then "quit" to exit gdb.

See also

-   Step By Step Debugging Guide
-   Debug - Getting Traces

Opening a bug
-------------

When you are sure it is a bug or a feature and you gathered all useful
information, then you are ready to open a bug report or feature request.

> Creating an account

You have to create an account on Arch's bug tracker system. This is as
easy as creating an account on a wiki or a forum and there is nothing
particular to mention here. Do not be afraid of giving the email address
you currently use : it will be hidden and you will receive mails only
for bugs you follow.

> Projects and categories

Once you have determined your feature or bug is related to Arch and not
an upstream issue, you will need to file your problem in the correct
place (watch the project name in the drop down list to the left of
'Switch' button in top left corner of bug report creation page.):

-   Arch Linux - for packages in testing, core, or extra. It is also a
    place for documentation, websites (except AUR), and security issues.

-   Arch User Repository (AUR) - for the AUR website code and server
    issues. This does not include third party apps used to access the
    AUR or packages in unsupported.

-   Community Packages - for packages in community. It is not a place
    for packages in unsupported.

-   Pacman - for pacman and the official scripts and tools associated
    with it. This includes things like makepkg and abs. It does not
    include community developed packages such as yaourt.

-   Release Engineering - intended for all release related issues (isos,
    installer, etc)

There is no place for reporting problems with packages in unsupported.
The AUR provides a way to add comments to a package in unsupported. You
should use this to report bugs to the package maintainer.

> Summary

Please write a concise and descriptive Summary.

Here is a list of recommendations:

-   Do not name your report "pkgname is broken after the last update" -
    it is non-descriptive and "after last update" has no meaning in
    Arch.
-   Start the Summary with package name enclosed in square brackets,
    e.g. "[pkgname] 3.0.5-1 breaks copy-paste feature". By naming
    reports this way you make it much easier for developers to sort
    reports by package names.
-   Do not write too much text in the Summary. Excessive text will not
    be visible in reports list.

> Severity

Choosing a critical severity will not help to solve the bug faster. It
will only make truly critical problems less visible and probably make
the developer assigned to your bug a bit less open to fixing it.

Here is a general usage of severities :

-   Critical- System crash, severe boot failure that is likely to affect
    more than just you, or an exploitable security issue in either a
    core or outward-facing service package.
-   High- The main functionality of the application does not work, less
    critical security issues, etc.
-   Medium- A non-essential functionality does not work, UNIX standards
    not respected, etc.
-   Low- An optional functionality (plugin or compilation activated)
    does not work.
-   Very Low- Translation or documentation mistake. Something that
    really does not matter much but should be noticed for a future
    release.

> Including relevant information

This is maybe one of the most difficult parts of bug reporting. You have
to choose from the chapter Gather useful information which information
you will add to your bug report. This will depend on which your problem
is. If you do not know what the relevant pieces of information are, do
not be shy : it is better to give more information than needed than not
enough.

A good tutorial on reporting bugs can be found at [1]

However, developers or bug hunters will ask you for more information if
needed. Fortunately after a few bug reports you will know what
information should be given.

Short information can be inlined in your bug report, whereas long
information (logs, screenshots ...) should be attached.

Following up on bugs
--------------------

Do not think the work is done once you have reported a bug!

Developers or other users will probably ask you for more details and
give you some potential fixes to try. Without continued feedback, bugs
cannot be closed and the end result is both angry users and developers.

> Voting and Watching

You can vote for your favorite bugs. The number of votes indicates to
the developers how many people are impacted by the bug. However, this is
not a very effective way of getting the bug solved. Much more important
would be posting any additional information you know about the bug if
you were not the original reporter.

Watching a bug is important- you will receive an email when new comments
are added or the bug status has changed. If you opened a bug verify that
the "Notify me whenever this task changes" checkbox is activated in
order to receive such emails.

> Answering additional information requests

People will take the time to look at your bug report and will try to
help you. You need to continue to help them resolve your bug. Not
answering to their questions will keep your bug unresolved and likely
hamper enthusiasm to fix it.

Please take the time to give people more information if requested and
try the solutions proposed.

Developers or bug hunters will close your bug if you do not answer
questions after a few weeks or a month.

> Updating the bug report when a new version of the related software is out

Sometimes a bug is related to a given package version and is fixed in a
new version. If this is the case then indicate it in the bug report
comments and request a closure.

> Closing when solved

Sometimes people report a bug but do not notify when they have solved it
on their own, leaving people searching for a solution that has already
been found. Please request a closure if you found a solution and give
the solution in the bug report comments.

> More about bug status

During its life a bug goes through several states :

-   Unconfirmed : This is the default state. You have just reported it
    and nobody managed to reproduce the problem or confirmed that it is
    actually a bug.

-   New : The bug is confirmed but it has not been assigned to the
    developer responsible for the related software. It is usually the
    case when more investigation is needed to determine which software
    is responsible for the bug.

-   Assigned : The bug has been assigned to a developer responsible for
    the software involved in the bug. It does not mean that the
    developer will be the one who will fix the bug. It does not even
    mean that the developer will work on a solution. It just means that
    the developer will take care of the life cycle of the bug, including
    reviewing patches if any, releasing a fix and closing the bug when
    required. There is no point in contacting a developer directly to
    have a bug fixed more quickly, he/she will certainly not like it ...

-   Researching : Somebody is looking for a solution. This status is
    rarely used at Arch and it is better this way. The researching
    status could make people believe they do not need to get interested
    in the bug report. But usually we need more than one person to fix a
    bug : having several experienced people on a bug helps a lot.

-   Waiting on Response and Requires testing : The one who reported a
    bug is asked to provide more information or to try a proposed
    solution, but he/she did not give a feedback yet. Those status are
    rarely used at Arch and should be used more often. However it is
    important that you watch the bug (see the voting and watching
    section) as developers or bug hunters usually ask questions in the
    comments.

-   A task closure has been requested : this is not exactly a status,
    but you may find some bug reports with such a notification. This
    indicates that somebody requested a closure for the bug. A reason is
    added to the request most of the time. It is upon the assignee
    developer to decide whether he/she will accept the closure or not.

-   Closed : Either this is not a valid bug (see Reasons for not being a
    bug) or a solution has been found and released.

Some people (developers, TUs ...) are responsible for dispatching the
bugs and change their status.

See also
--------

-   Bug Day
-   Midyear Cleanup
-   Christmas Cleanup

Retrieved from
"https://wiki.archlinux.org/index.php?title=Reporting_Bug_Guidelines&oldid=298694"

Category:

-   Arch development

-   This page was last modified on 18 February 2014, at 13:33.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
