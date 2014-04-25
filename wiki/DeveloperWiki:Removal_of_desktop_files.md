DeveloperWiki:Removal of desktop files
======================================

Contents
--------

-   1 [community]
    -   1.1 Background information
    -   1.2 Relevant quote
    -   1.3 Relevant commands
    -   1.4 Progress
        -   1.4.1 Not Done (last updated 2012-08-07)
        -   1.4.2 Pending (have been reported)
        -   1.4.3 Finished (upstream rejected the .desktop file)
-   2 Tools
    -   2.1 gendesk
-   3 See also

[community]
-----------

> Background information

"Since archlinux advertises itself as having vanilla packages, I thought
it might be a good idea to contact upstream about either including these
desktop files in their sources, or if they refuse, then get rid of them.
Packages should only be moved to the Done list if the .desktop files are
removed from svn repos and the package itself. In case upstream does
reject taking in the .desktop file, put it in the Done (rejected) list
but do not delete the .desktop files from the package until the very end
when we can formally warn users about the impending .desktop deletion
and give them a week to backup anything they want."

-   See also: FS#23387

> Relevant quote

"Patching only occurs in extremely rare cases, to prevent severe
breakage in the instance of version mismatches that may occur within a
rolling release model." - Arch Linux Source Integrity

> Relevant commands

For finding the number of .desktop files in /var/abs/community:

-   find /var/abs/community -name '*.desktop' | sort -u | wc -l

For finding the .desktop files in trunk in the community repo:

-   find . -maxdepth 3 -wholename "*trunk/*.desktop*"

With wiki formatting:

-   for f in `find . -maxdepth 3 -wholename "*trunk/*.desktop*" | sort -u | sed 's:/trunk/:/:'`; do echo $f | sed 's:./:* :'; done

> Progress

Not Done (last updated 2012-08-07)

-   alleyoop/alleyoop.desktop
-   assaultcube/assaultcube.desktop
-   astromenace/astromenace.desktop
-   aumix/aumix.desktop
-   awesome/awesome.desktop
-   blobby2/blobby2.desktop
-   boinc/boinc.desktop
-   bomberclone/bomberclone.desktop
-   caph/caph.desktop
-   checkgmail/checkgmail.desktop
-   critter/critter.desktop
-   cycle/cycle.desktop
-   dguitar/dguitar.desktop
-   driconf/driconf.desktop
-   dvdisaster/dvdisaster.desktop
-   dwarffortress/dwarffortress.desktop
-   dwm/dwm.desktop
-   epdfview/epdfview.desktop.patch
-   esmska/esmska.desktop
-   extremetuxracer/extremetuxracer.desktop
-   fceux/fceux.desktop
-   flobopuyo/flobopuyo.desktop
-   freecol/fc.desktop
-   freedroid/freedroid.desktop
-   freedroidrpg/freedroidrpg.desktop
-   freemind/freemind.desktop
-   freevo/freevo.desktop
-   frogatto/frogatto.desktop
-   gcolor2/gcolor2.desktop
-   gebabbel/gebabbel.desktop
-   ghemical/ghemical.desktop
-   gl-117/gl-117.desktop
-   gnormalize/gnormalize.desktop
-   gutenpy/gutenpy.desktop
-   gxmessage/gxmessage.desktop
-   hedgewars/hedgewars.desktop
-   hex-a-hop/hex-a-hop.desktop
-   intellij-idea-community-edition/idea.desktop
-   josm/josm.desktop
-   jsampler/jsampler-classic.desktop
-   jsampler/jsampler.desktop
-   kcheckers/kcheckers.desktop
-   lastfm-client/lastfm.desktop
-   mari0/mari0.desktop
-   mp3splt-gtk/mp3splt-gtk.desktop
-   mumble/mumble11x.desktop
-   nfoview/x-nfo.desktop
-   ninja-ide/ninja-ide.desktop
-   nvclock/nvclock.desktop-use-gksu.patch
-   openarena/openarena-server.desktop
-   openarena/openarena.desktop
-   paraview/paraview.desktop
-   pdfedit/pdfedit.desktop
-   pympc/pympc.desktop
-   q4wine/q4wine.desktop
-   qcad/QCad.desktop
-   qgit/qgit.desktop
-   qsopcast/qsopcast.desktop
-   qtcreator/qtcreator.desktop
-   rapidsvn/rapidsvn.desktop
-   rxvt-unicode/urxvt-tabbed.desktop
-   rxvt-unicode/urxvt.desktop
-   rxvt-unicode/urxvtc.desktop
-   sage-mathematics/SAGE-notebook.desktop
-   sk1/sk1.desktop
-   smc/smc.desktop
-   speed-dreams/speed-dreams.desktop
-   springlobby/springlobby.desktop
-   stormbaancoureur/stormbaancoureur.desktop
-   sxiv/sxiv.desktop
-   tdfsb/tdfsb.desktop
-   tea/tea.desktop
-   teeworlds/teeworlds.desktop
-   torcs/torcs.desktop
-   tuxcards/tuxcards.desktop
-   tuxguitar/tuxguitar.desktop
-   umlet/umlet.desktop
-   urbanterror/urbanterror.desktop
-   vym/vym.desktop
-   widelands/widelands.desktop
-   xboard/xboard.desktop
-   xemacs/xemacs.desktop
-   xonotic/xonotic-glx.desktop
-   xonotic/xonotic-sdl.desktop

Pending (have been reported)

-   blobby2/blobby2.desktop
    (http://sourceforge.net/apps/mantisbt/blobby/view.php?id=28)
-   bomberclone/bomberclone.desktop
    (http://sourceforge.net/tracker/?func=detail&aid=3404991&group_id=79449&atid=556632)
-   caph/caph.desktop
    (http://sourceforge.net/tracker/?func=detail&aid=3404994&group_id=295355&atid=1247095)
-   checkgmail/checkgmail.desktop
    (http://sourceforge.net/tracker/?func=detail&aid=3377367&group_id=137480&atid=738666)
-   gcolor2/gcolor2.desktop -
    https://sourceforge.net/tracker/?func=detail&aid=3404696&group_id=119919&atid=685762
-   higan-gtk/purify.desktop (using gendesk for now, will contact
    upstream to have it included)
-   higan-qt/purify.desktop (using gendesk for now, will contact
    upstream to have it included)
-   paraview/paraview.desktop -
    http://paraview.org/Bug/view.php?id=12508
-   pingus/pingus.desktop -
    http://code.google.com/p/pingus/issues/detail?id=136
-   rbutil/rbutil.desktop (http://gerrit.rockbox.org/r/#/c/573/)
-   speed-dreams/speed-dreams.desktop
    (https://sourceforge.net/apps/trac/speed-dreams/ticket/112)
-   sxiv/sxiv.desktop (https://github.com/muennich/sxiv/pull/50)
-   tea/tea.desktop - sent to author, he promised to include in next
    release
-   torcs/torcs.desktop
    (http://sourceforge.net/tracker/?func=detail&aid=3405193&group_id=3777&atid=103777)
-   tremulous/tremulous.desktop -
    https://bugzilla.icculus.org/show_bug.cgi?id=6027
-   umlet/umlet.desktop - sent to upstream -
    http://code.google.com/p/umlet/issues/detail?id=23
-   uqm/uqm.desktop - https://bugs.uqm.stack.nl/show_bug.cgi?id=788
-   urbanterror/urbanterror.desktop

Finished (upstream rejected the .desktop file)

-   gens/gens.desktop (switched to gendesk, no release in 5 years,
    pretty much dead)
-   nexuiz/nexuiz-glx.desktop (nexuiz is effectively dead)
-   nexuiz/nexuiz-sdl.desktop (nexuiz is effectively dead)
-   qgit/qgit.desktop (no project activity in 3 yrs)
-   xskat/xskat.desktop
-   intellij-idea-community-edition/intellijidea.desktop - IDEA has an
    option to generate desktop file from GUI, so there's no stand-alone
    file provided: http://youtrack.jetbrains.com/issue/IDEA-83646

Tools
-----

> gendesk

gendesk started as an Arch Linux-specific tool for generating .desktop
files by fetching the needed information directly from PKGBUILD files.
Now it is a general tool that takes command-line arguments. See Desktop
Entries#gendesk for more information.

See also
--------

-   The Arch Desktop Project
-   Desktop Entries

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:Removal_of_desktop_files&oldid=287051"

Categories:

-   Arch development
-   DeveloperWiki

-   This page was last modified on 8 December 2013, at 03:30.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
