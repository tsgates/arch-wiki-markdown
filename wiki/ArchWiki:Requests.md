ArchWiki:Requests
=================

Is the wiki missing documentation for a popular software package or
coverage of an important topic? Or, is existing content in need of
correction, updating, or expansion? Write your requests below and share
your ideas...

See ArchWiki:Reports to report questionable contributions. Please sign
your edits and feel free to comment on others' requests.

Contents
--------

-   1 General requests
    -   1.1 Problem redirects
-   2 Creation requests
    -   2.1 HOWTO: SAMBA PDC + LDAP
    -   2.2 Tripwire
    -   2.3 Left-Handed Adjustments for Desktop Environments
    -   2.4 Input methods
    -   2.5 DRI
    -   2.6 ldns
-   3 Modification requests
    -   3.1 DeveloperWiki
    -   3.2 MediaWiki Visual Editor
    -   3.3 Move/Merge articles to external wikis
    -   3.4 New dependencies for pacman
    -   3.5 vmlinuz26
    -   3.6 Switch initscripts to systemd on all pages
    -   3.7 ConsoleKit and D-Bus
        -   3.7.1 polkit rebuild
        -   3.7.2 ck-launch-session dbus-launch and friends
    -   3.8 virtualbox-iso-additions & Co. package name changes
    -   3.9 Inconsistent block size value for dd command
    -   3.10 Move openjdk6 to jdk7-openjdk
    -   3.11 compiz and emerald got dropped to AUR
    -   3.12 libgl and libgl-dri are no more
    -   3.13 Automatic loading of kernel modules
    -   3.14 Help me rewrite the eCryptfs article
    -   3.15 Links to Gentoo wiki
    -   3.16 Cleanup: installation category
    -   3.17 Batch of deletion requests: Hardware Compatibility List for
        desktops
-   4 Bot requests

General requests
----------------

 Inaccurate content 
    Pages flagged with Template:Accuracy.
 Outdated content 
    Pages flagged with Template:Out of date.
 Irrelevant or unhelpful content 
    Pages flagged with Template:Deletion.
 Incomplete content 
    Pages flagged with Template:Expansion.
 Poorly-written content 
    Pages flagged with Template:Poor writing.
 Duplicate effort or overlapping scope 
    Pages flagged with Template:Merge.
 Misleading names 
    Pages flagged with Template:Moveto.
 Poor translations 
    Pages flagged with Template:Bad translation.
 Incomplete translations 
    Pages flagged with Template:Translateme. See also ArchWiki
    Translation Team.
 Incomplete content 
    Pages flagged with Template:Stub.
 Dead or broken links 
    Pages flagged with Template:Linkrot. Should be repaired or replaced.
 Templates with an undefined parameter 
    Pages automatically flagged with Template:META Error
 Unexplained presence of an article status template 
    Pages automatically flagged with Template:META Unexplained Status
    Template.
 Application listed without links to packages 
    Pages automatically flagged with Template:META Missing package.
 Pages with misspelled or deprecated templates 
    Need to fix template or change to new template.
 Full links 
    Should be turned into internal links.

> Problem redirects

Note:Redirects should not point to other sites and ones that do
sometimes erroneously show up on these pages.

-   Special:BrokenRedirects
-   Special:DoubleRedirects

Creation requests
-----------------

Here, list requests for topics that you think should be covered on
ArchWiki. If not obvious, explain why ArchWiki coverage is justified
(rather than existing Wikipedia articles or other documentation).
Furthermore, please consider researching and creating the initial
article yourself (see Help:Editing for content creation help).

> HOWTO: SAMBA PDC + LDAP

How to configure SAMBA PDC + LDAP in Arch Linux? (Moved from another
page. Hokstein 19:57, 16 September 2007 (EDT))

> Tripwire

Finding information on the install of this program already requires a
bit of searching around the net, and then a variety of modifications to
get it running correctly. It would be nice to have a good HowTo about
the install and setup of Tripwire on Arch. The package is availabe in
community.

It has since been removed from [community], it's in the AUR now. --
Karol 21:52, 29 August 2011 (EDT)

> Left-Handed Adjustments for Desktop Environments

I was thinking it would be helpful for lefties if there were a list of
configuration options for each desktop environment that facilitate
left-handed use of mice and touchpads. I'm not sure if this is related
enough to Arch to include in this wiki, but I haven't had a lot of luck
finding information for my own DE (KDE) let alone for others. I will
start writing down information, and if no one else thinks there should
be a separate page for this, I'll just add the information I find to
each individual DE's page. —ajrl 2013-08-11T15:09−06:00

I think a separate page is better. -- Fengchao (talk) 11:58, 12 August
2013 (UTC)

> Input methods

Currently there is no page on ArchWiki properly describing various input
methods generally. There is only
Internationalization#Input_methods_in_Xorg, but it has several problems:

-   missing descriptions
-   X compose key does not fit in
-   GTK has a default "simple" input method featuring the Ctrl+Shift+u
    shortcut for entering a unicode character (this was added recently
    into a wrong article: [1]) - again, no description
-   no description of XIM - outdated, but sometimes used as fallback?

So this is quite enough material to start a new great article ;)

-- Lahwaacz (talk) 18:23, 18 December 2013 (UTC)

> DRI

An article, or even stub that links to resources, explaining what DRI
is, why it's important, differences between DRI 1, 2, 3, how DRI1 is no
longer supported as of xorg-server 1.13, simple xorg.conf code
explaining the DRI section, enabling the composite and render extensions
there, these and more. Just my thoughts.

> ldns

ldns is a core package with no wiki documentation. It is also relatively
new in the world of DNS tools and is not well covered on the Internet.
Documentation of basic features and what it is not (eg a replacement for
bind) would provide a valueable resource. MichaelRpdx (talk) 20:07, 17
February 2014 (UTC)

The description of the ldns package is "Fast DNS library supporting
recent RFCs". The official homepage mentions that several example
programs are included with the library, the official docs is probably
best for programmers. -- Lahwaacz (talk) 21:37, 17 February 2014 (UTC)

Modification requests
---------------------

Here, list requests for correction or other modification of existing
articles. Only systemic modifications that affect multiple articles
should be included here. If a specific page needs modification, use that
page'sdiscussionortalkpage instead and one of the #General requests
templates.

As a rolling release, Arch is constantly receiving updates and
improvements. Because of this the Arch wiki must be updated quickly to
reflect these changes.

> DeveloperWiki

Many pages are out of date and I can't even flag them out of date.
Should users be warned that pages in this "category" may be really old
and abandoned? -- Karol 09:19, 8 October 2011 (EDT)

Perhaps we can create a special template to be included at the top of
every article in that category? -- Kynikos 13:41, 8 October 2011 (EDT)

> MediaWiki Visual Editor

References to the Visual editor sandbox should me made on the Wiki and
BBS, especially where new users will easily come across it. ~ Filam
16:12, 16 December 2011 (EST)

> Move/Merge articles to external wikis

Although Finnish and Serbian have their own wikis, we're still hosting
some articles in those languages:

-   Finnish articles
-   Serbian articles: Српски, Srpski

Some users of those wikis should probably be contacted in order to
complete the move/merge, replacing those articles with interlanguage
links at least on the respective English pages.

-- Kynikos (talk) 16:34, 10 May 2012 (UTC) (Last edit: 03:04, 22
September 2013 (UTC))

> New dependencies for pacman

Some parts of the wiki may need updating, e.g.
Pacman#Q:_Pacman_is_completely_broken.21_How_do_I_reinstall_it.3F (the
last one in the FAQ). -- Karol 08:39, 20 January 2012 (EST)

There are actually quite a few dependencies that aren't mentioned, since
a broken dependency of pacman would also break pacman (can see them all
with pactree -l pacman | sort -u | cut -f 1 -d ' '). The packages that
would need to be downloaded and extracted would vary depending on which
partial upgrade was done. thestinger 15:19, 21 February 2012 (EST)

> vmlinuz26

Instead of flagging all articles still using the old kernel image naming
out of date, can we do some mass-renaming? -- Karol 20:55, 20 October
2011 (EDT)

Last week, I found at one article that was using vmlinuz26 in an example
for users of non-recent kernel versions. I'm not sure if we would want
to keep such an example around, but we may want to decide that before
doing a mass rename. And for what it's worth, I don't think it is
necessary to keep such antiquated examples around. -- Jstjohn (talk)
20:53, 4 June 2012 (UTC)

Of course I don't know what article you're referring to, but doing a
mass-renaming with a bot sounds a bit dangerous, because as you've
pointed out there may be exceptions where the old kernel names are still
ok. I'm moving this discussion out of Bot requests. -- Kynikos (talk)
14:57, 5 June 2012 (UTC)

The rename is done very long time ago. I am stating to do the following
except few places as mentined above.

-   vmlinuz26 to vmlinuz-linux
-   kernel26.img to initramfs-linux.img
-   kernel26-fallback.img to initramfs-linux-fallback.img Done

-- Fengchao (talk) 05:40, 26 September 2012 (UTC)

> Switch initscripts to systemd on all pages

TODO:

-   D-Bus: Remove or redirect to Systemd. All link to it should be check
    and cleaned up.

Now that initscripts no longer are supported, we should change stuff
that have information with initscripts to systemd --Toringe (talk)
22:49, 23 March 2013 (UTC)

Agree, all initscripts should be converted to systemd. Many old stuff
could be removed safely now. -- Fengchao (talk) 01:25, 24 March 2013
(UTC)

D-Bus has nothing to do with initscripts deprecation, closing. --
Lahwaacz (talk) 21:04, 29 November 2013 (UTC)

Unclosing.

What should we do with articles that mention rc.conf etc? If I'm not
going to fix them, is it OK to mark them as out of date like
Very_Secure_FTP_Daemon#Using_xinetd and then consider the wiki switch to
systemd as complete? -- Karol (talk) 12:05, 14 December 2013 (UTC)

Yes please, go the Out-of-date template way, it will be more effective
than this discussion. -- Kynikos (talk) 03:49, 15 December 2013 (UTC)

> ConsoleKit and D-Bus

polkit rebuild

ConsoleKit support has now been fully dropped from all packages in the
repositories. There is no need for ck-launch-session and friends after
this moves.

Please use link to General Troubleshooting#Session permissions to
replace anything mentioning ck-launch-session, dbus-launch, problems
with consolekit/logind, etc.

-- thestinger (talk) 04:40, 26 September 2012 (UTC)

ck-launch-session dbus-launch and friends

We can remove every single mention of ck-launch-session on the wiki -
consolekit support has been dropped upstream and Arch is going to drop
it from all the other packages too. This was also never actually needed,
since a session is already started with pam, and you simply needed to
keep the session on the same tty. Using dbus-launch is usually not
needed at all, and should be removed almost everywhere too. --
thestinger (talk) 18:56, 20 October 2012 (UTC)

I decided just to get this right once and for all in xinitrc with the
xinitrc.d snippet to start dbus, and preserving the session by keeping X
on the same tty (which works with both logind and ck). It also avoids
all the things that can go wrong with ck-launch-session (dbus being
started first, for one). thestinger (talk) 22:24, 24 October 2012 (UTC)

TODO:

-   remove ck-launch-session
-   remove dbus-launch
-   clean up pages mention consolekit.

--Fengchao (talk) 01:23, 18 April 2013 (UTC)

Status update: all pages inappropriately using ck-launch-session are
marked as out of date, the only English page falling into this category
is Joy2key. The number of localized pages in that list is quite high
though, this issue should get some more attention. Pages also currently
mention "consolekit" (the third link) only regarding its deprecation. --
Lahwaacz (talk) 11:46, 30 November 2013 (UTC)

> virtualbox-iso-additions & Co. package name changes

I guess virtualbox-iso-additions is now called virtualbox-guest-iso.
There are other changes (virtualbox-modules -> virtualbox-host-modules,
virtualbox-source -> virtualbox-host-source) but the old names are not
used in English articles. There may be some other changes (new names,
changes to how things work), I only edited that one thing because I know
nothing about virtualbox. If no more edits are needed, feel free to
close this request. -- Karol (talk) 08:58, 23 September 2012 (UTC)

> Inconsistent block size value for dd command

There are many examples of the dd command on the ArchWiki and they use
various values for the block size option. There seems to be a lot of
confusion about what value to use. This is exemplified by the Using DD
for disk cloning question on Server Fault. I have also collected a few
examples from the ArchWiki (see: User:Filam/Block size#Disparate
examples). In order to make these examples more consistent I would like
to either write Block size or Dd. Then any examples could be replaced by
references like the Package management style rules. What do you think of
that plan?  
 -- Filam (talk) 19:45, 24 September 2012 (UTC)

Can you give a more explicit example? For instance, how would you change
this extract from User-mode_Linux#Build_rootfs_image:

1.) First you have to create a single, big file into which you will
install Arch Linux. This command creates a single 1 GB file, only
containing zeros - should be enough for a basic Arch Linux installation.

    dd if=/dev/zero of=rootfs bs=1MB count=1000

-- Kynikos (talk) 12:36, 25 September 2012 (UTC)

> Move openjdk6 to jdk7-openjdk

Developer annourcement: OpenJDK6 packages will be removed by the end of
this month.

All users should move to OpenJDK7 based packages
jre7-openjdk/jre7-openjdk-headless/jdk7-openjdk (or the Oracle based
JRE/JDK from AUR) very soon.

The next OpenJDK7 update will replace openjdk6 on the system.

There are many openjdk6 exist in Arch wiki. All of them should be
removed or changed to openjdk7.

> compiz and emerald got dropped to AUR

https://mailman.archlinux.org/pipermail/arch-dev-public/2013-May/024956.html

sysvinit also got removed.

I've done some updating (just the English articles), so this is more of
a heads-up for anyone taking care of non-English articles or people who
would like to double check if I missed something / messed something up.
I don't know if e.g. this or this is the right way to approach a
situation where 'foo' package is neither in the AUR nor in the repos,
but there may be 'foo-git' or 'foo-no-gnome' in the AUR. It seems to
clash with ArchWiki:Requests#Use_AUR_templates. I've noticed that if
there's a 'foo-git' package in the AUR, when 'foo' gets dropped from the
repos, no dev / TU uploads 'foo' package to the AUR - makes sense, but
makes updating the wiki harder ;P

I didn't fix Emerald because I don't know which package in the AUR - if
any - represents the 'standard Emerald themes'. The link to emerald
needs to be updated the sentence rephrased, as it's not in the repos
anymore.

Apart from that one edit, I didn't touch compiz, as it needs more
extensive editing and I know nothing about it compiz. Sure, I can just
remove the parts that are outdated (e.g. referring to the removed
package groups) but maybe someone can do a nicer rewrite.

List of recently removed packages / package groups:

    ccsm
    compiz-bcop
    compiz-core
    compiz-decorator-gtk
    compiz-decorator-kde
    compiz-fusion-plugins-extra
    compiz-fusion-plugins-main
    compiz-manager
    compizconfig-backend-gconf
    compizconfig-python
    emerald
    emerald-themes
    fusion-icon
    libcompizconfig
    mingetty
    proftpd
    slmodem
    sysvinit
    bmp
    epiphany-extensions
    mkbootcd
    python-m2crypto

-- Karol (talk) 22:53, 21 May 2013 (UTC)

> libgl and libgl-dri are no more

Quite a few articles mention these packages. I think that instead of
libgl they should point to mesa-libgl or nvidia-libgl. libgl-dri is not
provided by any package. -- Karol (talk) 12:47, 26 May 2013 (UTC)

libgl is a virtual package that is provided by multiple other packages:

- mesa-libgl, nvidia-libgl, nvidia-304xx-utils from extra

- catalyst-utils, catalyst-utils-pxp from the catalyst repos

- mesa-libgl-git and probably many more from AUR

You can even do pacman -S libgl, and it will ask which one you want to
install (of course it will only list the ones from repos that you have
added to /etc/pacman.conf). Thus using "libgl" as a package/dependency
name is in fact correct, and should be preferred in places where we
don't care about which specific graphics driver is used.

--Sas (talk) 18:28, 9 January 2014 (UTC)

> Automatic loading of kernel modules

There are notes like "Since kernel 3.4 all necessary modules are loaded
automatically" and "Newer versions of udev load the module
automatically", which are usually followed by rather long section "If
that does not work, do modprobe foo" and "To make it permanent after
reboot, add the following to /etc/modules-load.d/module.conf".

Examples: Kernel_modules#Configuration, CPU_Frequency_Scaling,
CPU_Frequency_Scaling#CPU_frequency_driver, Network
configuration#Check_the_driver_status, Wireless_Setup#Device_driver.

There are several problems with this, so quick list of tasks:

-   Verify kernel and udev version, because this also depends on the
    resolution of
    ArchWiki_talk:Reports#Minimum_supported_kernel_version.
-   Perhaps the notes should be unified (though autoloading on hotplug
    and when some command is executed are different). Also note that
    some notes mentioning udev might be inaccurate and need to be
    changed to mention kernel (and vice versa).
-   Replace verbose modprobe fallback commands with link to Kernel
    modules#Loading - see Help:Style#Kernel module operations.
-   There's small problem with similar instructions to use some kernel
    module option - I don't consider it to be basic operation according
    to Help:Style#Kernel module operations, but this to be too verbose.
    I think some clear note (can't think of any right now) and link to
    Kernel modules#Setting module options should be provided.

-- Lahwaacz (talk) 19:09, 5 August 2013 (UTC)

As the minimum supported kernel version is apparently 3.10 at the
moment, we should get rid of those modprobe commands and just link to
Kernel_modules#Configuration. -- Lahwaacz (talk) 21:02, 29 November 2013
(UTC)

> Help me rewrite the eCryptfs article

Not sure if this is the correct place to post this, but I'd like to let
the admins/maintainers and other interested Arch wiki editors know of my
plans for the eCryptfs article, which I have laid out at
Talk:ECryptfs#Major_restructuring/rewrite. If there are any objections,
or suggestions for how to do it better, it would be nice to hear them
early on.  
 Also, since it's a relatively big task, it will take a long time to
complete if I remain on my own. So feel free to join me! :)

> Links to Gentoo wiki

http://en.gentoo-wiki.com/ is offline for some quite time now, the new
address is http://wiki.gentoo.org/. There are several links that need to
be updated: [2]. I don't really know what (and when) happened there, I
just suppose that there has been some major restructuring of the Gentoo
documentation - there is not direct 1:1 mapping of the old links to the
new address, so it will have to be done manually. -- Lahwaacz (talk)
14:06, 22 February 2014 (UTC)

Actually, there is Gentoo Wiki Archives, but is it safe to link there
considering that it is read-only? -- Lahwaacz (talk) 22:27, 6 March 2014
(UTC)

http://wiki.gentoo.org/ is of course preferable, however if there's
really no alternative and the article in the Archives is still relevant,
the fact that it's no longer editable shouldn't prevent from linking
there. -- Kynikos (talk) 01:43, 8 March 2014 (UTC)

> Cleanup: installation category

Category:Getting and installing Arch needs a serious cleanup, there are
many outdated and/or inappropriate pages. I don't know if my perception
of these pages isn't too radical, feel free to comment and possibly hold
me down a bit.

> Inappropriate:

-   Erch - what is this? Some poor long forgotten spin-off?
-   Install_on_windows_by_CoLinux - some Arch/Debian mutant spin-off, 6
    years old
-   Installation_Guide_Troubleshooting - either merge or delete,
    official document should not have an unofficial troubleshooting
    section/page
-   Installing_Arch_Linux_on_a_Sun_Cobalt_RAQ_550 - move somewhere into
    Category:Hardware?
-   Installing_Arch_Using_Old_Installation_Media - do we really need
    this?
-   CuBox - not officially supported, provides only the most basic
    information (+ caveats copied from Raspberry Pi...)

Seriously outdated:

-   AIF_Configuration_File - outdated, but see
    Talk:AIF_Configuration_File#Preserve_AIF_pages_for_Development (it
    says "pages" in title, were there more?)
-   Installing_Arch_Linux_with_EVMS - last stable version of EVMS is
    from 2006

> Duplicated:

-   Creating_Arch_Linux_disk_image could be merged into
    Hard_Disk_Installation (and the result probably seriously
    simplified)
-   Install_from_SSH and Remote_Arch_Linux_Install describe basically
    the same thing
-   Installing_Arch_Linux_in_Virtual_Server - merge into
    Virtual_Private_Server?
-   merge Remastering_the_Install_ISO and Building_a_Live_CD?

-- Lahwaacz (talk) 22:08, 6 March 2014 (UTC)

> Batch of deletion requests: Hardware Compatibility List for desktops

I've flagged a bunch of these empty pages for deletion, so I would
appreciate it if an ArchWiki Admin would delete these pages:

-   HCL/Desktops/Sony
-   HCL/Desktops/Acer
-   HCL/Desktops/Apple
-   HCL/Desktops/Asus
-   HCL/Desktops/Compaq
-   HCL/Desktops/eMachines
-   HCL/Desktops/Fujitsu
-   HCL/Desktops/Siemens-Fujitsu
-   HCL/Desktops/Gateway
-   HCL/Desktops/IBM
-   HCL/Desktops/Medion
-   HCL/Desktops/Micron

-- Jstjohn (talk) 06:57, 16 March 2014 (UTC)

Bot requests
------------

Here, list requests for repetitive, systemic modifications to a series
of existing articles to be performed by a wiki bot.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ArchWiki:Requests&oldid=306137"

Category:

-   ArchWiki

-   This page was last modified on 20 March 2014, at 17:49.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
