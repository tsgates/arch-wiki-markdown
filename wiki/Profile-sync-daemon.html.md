Profile-sync-daemon
===================

Summary help replacing me

Profile-sync-daemon (psd) is a diminutive pseudo-daemon designed to
manage your browser's profile in tmpfs and to periodically sync it back
to your physical disc (HDD/SSD). This is accomplished via a symlinking
step and an innovative use of rsync to maintain back-up and
synchronization between the two. One of the major design goals of psd is
a completely transparent user experience.

> Related

Anything-sync-daemon

Firefox

Chromium

Opera

SSD

Contents
--------

-   1 Benefits of psd
-   2 Supported browsers
-   3 Setup and installation
    -   3.1 Edit /etc/psd.conf
-   4 Using psd
    -   4.1 Preview mode (parse)
    -   4.2 Running psd to manage profiles
    -   4.3 Sync at more frequent intervals (optional)
-   5 Caveats for Firefox and Heftig's Aurora ONLY
-   6 FAQ
    -   6.1 Q1. My system crashed and didn't sync back. What do I do?
    -   6.2 Q2. Where can I find this snapshot?
    -   6.3 Q3. How can I restore the snapshot?
-   7 Support
-   8 PSD on other distros
    -   8.1 Debian
    -   8.2 Mint and Ubuntu
-   9 See also

Benefits of psd
---------------

Running this daemon is beneficial for two reasons:

1.  Reduced wear to physical drives
2.  Speed

Since the profile(s), browser cache*, etc. are relocated into tmpfs (RAM
disk), the corresponding onslaught of I/O associated with using the
browser is also redirected from the physical drive to RAM, thus reducing
wear to the physical drive and also greatly improving browser speed and
responsiveness. For example, the access time of RAM is on the order of
nanoseconds while the access time of physical discs is on the order of
milliseconds. This is a difference of six orders of magnitude or
1,000,000 times faster.

Note:Some browsers such as Chrome/Chromium, Firefox (since v21), Midori,
and Rekonq actually keeps their cache directories separately from their
profile directory. It is not within the scope of profile-sync-daemon to
modify this behavior; users are encouraged to refer to the Chromium
tweaks#Cache_in_tmpfs section for Chromium and to the Firefox_Ramdisk
article for several workarounds. An easy fix is to move the various
browsers' cache directory from their default location (e.g.
/home/$USER/.cache/<browser>/<profile>/) to the corresponding profile
directory, e.g. /home/$USER/.mozilla/firefox/<profile>/cache, and then
symlink the new cache folder back to its original location. This way,
profile-sync-daemon will automatically take into account the cache
folder too.

Supported browsers
------------------

Currently, the following browsers are auto-detected and managed:

-   Chromium
-   conkeror
-   Firefox (all flavors including stable, beta, and aurora)
-   firefox-trunk: An Ubuntu-only browser
-   google-chrome
-   google-chrome-beta
-   heftig's version of Aurora: An Arch Linux only browser
-   Midori
-   Opera
-   opera-next
-   Qupzilla

Setup and installation
----------------------

profile-sync-daemon is available for download from the AUR. Build it and
install like any other package.

> Edit /etc/psd.conf

Edit the included /etc/psd.conf defining which user(s) will have their
profiles managed by psd.

Example:

    # List users separated by spaces whose browser(s) profile(s) will get symlinked 
    # and sync'ed to tmpfs.
    # Do NOT list a user twice!
    USERS="facade happy"

Note:At least one user must be defined.

Optionally uncomment the BROWSERS array and populate it with whichever
browser(s) are to be sync'ed to tmpfs. If the BROWSERS array stays
commented (default) then all supported browser profiles will be sync'ed
if they exist.

Example: Let's say that Chromium, Opera and Midori are installed but
only Chromium and Opera are to be sync'ed to tmpfs since the user keeps
Midori as a backup browser and it is seldom used:

    # List browsers separated by spaces to include in the sync. Useful if you do not
    # wish to have all possible browser profiles sync'ed.
    #
    # Possible values:
    #   chromium
    #   conkeror.mozdev.org
    #   firefox
    #   firefox-trunk
    #   google-chrome
    #   heftig-aurora 
    #   midori
    #   opera
    #   opera-next
    #   qupzilla
    #
    # If the following is commented out (default), then all available/supported 
    # browsers will be sync'ed, separated by comma
    BROWSERS="chromium opera"

Using psd
---------

> Preview mode (parse)

The 'parse' option can be called to show users exactly what psd will do
based on the /etc/psd.conf entered. Call it like so:

    $ profile-sync-daemon parse
     Profile-sync-daemon v5.24

    psd will manage the following per /etc/psd.conf settings:

    browser/psname:  chromium/chromium
    owner/group:     facade/users
    sync target:     /home/facade/.config/chromium
    tmpfs dir:       /tmp/facade-chromium
    profile size:    81M

    browser/psname:  firefox/firefox
    owner/group:     facade/users
    sync target:     /mnt/data/docs/facade/mozilla/firefox/1Zp9V43q.banking
    tmpfs dir:       /tmp/facade-firefox-1Zp9V43q.banking
    profile size:    5.9M

    browser/psname:  firefox/firefox
    owner/group:     facade/users
    sync target:     /mnt/data/docs/facade/mozilla/firefox/obg67zqQ.proxy
    tmpfs dir:       /tmp/facade-firefox-obg67zqQ.proxy
    profile size:    17M

As shown in the output and as stated above, if no specific browser or
subset of browsers are defined in the BROWSERS array, psd will sync ALL
supported profiles that it finds for the given user(s).

> Running psd to manage profiles

Do not call /usr/bin/profile-sync-daemon to sync or to unsync directly.
Instead use the provided service files.

Both a systemd service file and a timer are provided and should be used
to interact with psd. Both should be invoked together! The role of the
timer is update the tmpfs copy/copies back to the disk which it does
once per hour. Failure to start the resync timer will result in the
profile being sync'ed only on start up and shutdown.

Start psd and psd-resync service and enable them to start/stop at
boot/shutdown (highly recommended).

Obviously, you must first close your browser before starting the
service.

> Sync at more frequent intervals (optional)

The package provided timer syncs once per hour. Users may optionally
redefine this behavior simply by extending the systemd unit. The example
below changes the timer to sync once every ten minutes:

    /etc/systemd/system/psd-resync.timer.d/frequency.conf

    [Unit]
    Description=Timer for Profile-sync-daemon - 10min

    [Timer]
    # Empty value resets the list of timers
    OnUnitActiveSec=
    OnUnitActiveSec=10min

See man systemd.timer for additional options.

Caveats for Firefox and Heftig's Aurora ONLY
--------------------------------------------

The way psd keeps track of browser profiles and sync targets requires
users to have a unique name as the last directory for all profiles in
their respective $HOME/.mozilla/browser/profiles.ini files. psd will
check when it is called to run for this and refuse if this rule is not
satisfied. The following is an example of a BAD profile that will fail
the the test. Note that although each full path is unique, they both end
in the same name! Again, the user must modify the profiles.ini and the
corresponding directory on the filesystem to correct this in order to
use psd.

    ~/.mozilla/firefox/profiles.ini

    [General]
    StartWithLastProfile=1

    [Profile0 for user facade]
    Name=normal
    IsRelative=0
    Path=/mnt/data/docs/facade/mozilla/firefox/myprofile.abc
    Default=1

    [Profile1 for user happy]
    Name=proxy
    IsRelative=0
    Path=/mnt/data/docs/happy/mozilla/firefox/myprofile.abc

FAQ
---

Note:The first three questions apply to versions of psd equal to or
greater than v5.40 only.

> Q1. My system crashed and didn't sync back. What do I do?

Odds are the "last good" backup of your browser profiles is just fine
still sitting happily on your filesystem. Upon restarting psd (on a
reboot for example), a check is preformed to see if the symlink to the
tmpfs copy of your profile is invalid. If it is invalid, psd will
snapshot the "last good" backup before it rotates it back into place.
This is more for a sanity check that psd did no harm and that any data
loss was a function of something else.

> Q2. Where can I find this snapshot?

It depends on the browser. You will find the snapshot in the same
directory as the browser profile and it will contain a date-time-stamp
that corresponds to the time at which the recovery took place. For
example, chromium will be
~/.config/chromium-backup-crashrecovery-20130912_153310 -- of course,
the date_time suffix will be different for you.

> Q3. How can I restore the snapshot?

-   Stop psd.
-   Confirm that there is no symlink to the tmpfs browser profile
    directory. If there is, psd did not stop correctly for other
    reasons.
-   Move the "bad" copy of the profile to a backup (don't blindly delete
    anything).
-   Copy the snapshot directory to the name that browser expects.

Example using Chromium:

    mv ~/.config/chromium ~/.config/chromium-bad
    cp -a ~/.config/chromium-backup-crashrecovery-20130912_153310 ~/.config/chromium

At this point you can launch chromium which will use the backup snapshot
you just copied into place. If all is well, close the browser and
restart psd and psd-resync (if using systemd). You may safely delete
~/.config/chromium-backup-crashrecovery-20130912_153310 at this point.

Support
-------

Post in the discussion thread with comments or concerns.

PSD on other distros
--------------------

psd is a bash script and should therefore run on any Linux distro. Below
is a list of distros known to package psd, and a link to download their
respective packages.

Note:Different distros use different init systems. The packages linked
below are configured to use the default init system for the given
distro.

  Distro     Default Init System   Link to Package
  ---------- --------------------- ---------------------------------------
  Arch       Systemd               AUR.
  Chakra     Systemd               CCR.
  Debian     Upstart               Graysky's PPA. See instruction below.
  Exherbo    Systemd               In official repos.
  Fedora     Systemd               In official repos.
  Gentoo     OpenRC                In official repos.
  Mint       Upstart               Graysky's PPA. See instruction below.
  OpenSUSE   Upstart               Packaged by Overman79.
  Ubuntu     Upstart               Graysky's PPA, See instruction below.
  Void       Systemd               In official repos.

> Debian

To add the PPA (personal package archive) to your Debian (tested on
Squeeze) system, and to install psd:

    # echo "deb http://ppa.launchpad.net/graysky/utils/ubuntu quantal main" > /etc/apt/sources.list.d/graysky.list
    # echo "deb-src http://ppa.launchpad.net/graysky/utils/ubuntu quantal main" >> /etc/apt/sources.list.d/graysky.list
    # apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FF7F9516
    # apt-get update
    # apt-get install profile-sync-daemon

> Mint and Ubuntu

To add the PPA (personal package archive) to your Ubuntu (packages
available for Lucid and newer) system, and to install psd:

    $ sudo add-apt-repository ppa:graysky/utils
    $ sudo apt-get update
    $ sudo apt-get install profile-sync-daemon

See also
--------

-   http://www.webupd8.org/2013/02/keep-your-browser-profiles-in-tmpfs-ram.html
-   http://bernaerts.dyndns.org/linux/250-ubuntu-tweaks-ssd

Retrieved from
"https://wiki.archlinux.org/index.php?title=Profile-sync-daemon&oldid=305083"

Categories:

-   Web Browser
-   Scripts

-   This page was last modified on 16 March 2014, at 12:47.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
