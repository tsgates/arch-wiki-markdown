ArchWiki:Reports
================

This table is used to report questionable edits as described in
ArchWiki:Maintenance Team. Please use the talk page for discussing
reports.

  Diff                                Timestamp             Type      Notes
  ----------------------------------- --------------------- --------- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Archiso                             2012-04-05 19:12:13   content   why remove the "mkinitcpio.conf" section and leave "aitab" and "Boot Loader" even if all of them say the default files are ok?
  User-mode_Linux                     2012-05-02 08:52:20   content   the DAEMONS array without `!hotplug` doesn't make sense anymore, the whole article should be adaptaed to the style rules; NOTE that `pacman -Sy` seems correct in this case
  ATI                                 2012-07-08 11:44:51   content   I tend to be suspicious of this kind of edits/justifications, maybe it requires investigation (also note it's just the author's second edit)
  Beginners%27_Guide%2FInstallation   2013-04-06 15:11:45   content   All this could probably be merged to Partitioning, UEFI, GPT... Also considering the recent efforts to move information out of the Beginners' guide to specific articles
  Samsung_Chromebook_%28ARM%29        2013-05-18 20:12:31   content   I don't know if this article should be left categorized under Category:Getting and installing Arch or should be put under Category:Samsung (or both); see also https://bbs.archlinux.org/viewtopic.php?pid=1274776 and consider acting coherently on Raspberry Pi; create a page for Arch Linux ARM? (already mentioned in Arch_Based_Distributions_(Active)#Arch_Linux_ARM);
  Installing_Arch_Linux_on_ZFS        2013-06-05 23:12:33   content   duplicated ZFS#Swap partition here with some modifications, maybe there's a better way to avoid duplications
  Synergy                             2013-06-18 08:55:30   content   if confirmed, it looks more like a bug to be reported (upstream?)
  Windows_and_Arch_Dual_Boot          2013-08-26 13:24:31   content   after a very quick check, the rest of the section still seems to rely on the FAT32 partition
  Netctl                              2013-10-31 10:17:54   content   Does replacing ifplugd work universally as decribed in this edit? If yes, it might replace other instances of netctl-ifplugd too.
  OpenChange_Server                   2013-11-26 07:00:03   content   some weird package installation instructions
  Silent_boot                         2013-11-26 01:22:13   content   instructions to edit files in /usr/lib/systemd/, drop-in files should be used
  Raspberry_Pi                        2013-12-29 18:08:52   content   Questionable tips (in all three sections)
  Citadel groupware                   2014-02-09 22:11:35   content   Is using easy install script OK or should we recommend using citadel?
  VirtualBox                          2014-03-02 22:47:46   content   The script should probably not be installed in /sbin (resp. /usr/bin), but will mount recognize different path, e.g. /usr/local/sbin?
  ASUS_N56                            2014-03-06 15:21:16   content   We've got a disambiguation page, which are not supported; I think it could be just deleted, both linked pages are very new.
  Locale                              2014-03-14 22:28:00   content   Why would anyone configure locale/language in ~/.pam_environment?
  KDE                                 2014-03-20 16:46:35   style     Wrong formatting, probably needs different woriding. Also not explained why, user notified: User_talk:Jalley#KDE.2C_ZFS_and_MariaDB.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ArchWiki:Reports&oldid=306151"

Category:

-   ArchWiki

-   This page was last modified on 20 March 2014, at 18:47.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
