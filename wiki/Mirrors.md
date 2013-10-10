Mirrors
=======

> Summary

Updating and managing package mirrors

> Related

Mirroring

pacman

reflector

This page is a guide to selecting and configuring your mirrors, and a
listing of current available mirrors.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Enabling a specific mirror                                         |
|     -   1.1 Force pacman to refresh the package lists                    |
|                                                                          |
| -   2 Mirror status                                                      |
| -   3 Sorting mirrors                                                    |
|     -   3.1 List by speed                                                |
|     -   3.2 Combined listing by speed and status                         |
|     -   3.3 Script to automate use of Pacman Mirrorlist Generator        |
|     -   3.4 Using Reflector                                              |
|     -   3.5 Choosing a local mirror                                      |
|                                                                          |
| -   4 Official mirrors                                                   |
|     -   4.1 IPv6-ready mirrors                                           |
|                                                                          |
| -   5 Unofficial mirrors                                                 |
|     -   5.1 Global                                                       |
|     -   5.2 TOR Network                                                  |
|     -   5.3 Singapore                                                    |
|     -   5.4 Bulgaria                                                     |
|     -   5.5 Viet Nam                                                     |
|     -   5.6 China                                                        |
|     -   5.7 France                                                       |
|     -   5.8 Germany                                                      |
|     -   5.9 Indonesia                                                    |
|     -   5.10 Kazakhstan                                                  |
|     -   5.11 Lithuania                                                   |
|     -   5.12 Malaysia                                                    |
|     -   5.13 New Zealand                                                 |
|     -   5.14 Poland                                                      |
|     -   5.15 Russia                                                      |
|     -   5.16 South Africa                                                |
|     -   5.17 United States                                               |
|     -   5.18 Hyperboria                                                  |
|                                                                          |
| -   6 Troubleshooting                                                    |
|     -   6.1 Out-of-sync mirrors: corrupted packages/file not found       |
|         -   6.1.1 Using all mirrors                                      |
|                                                                          |
| -   7 See Also                                                           |
+--------------------------------------------------------------------------+

Enabling a specific mirror
--------------------------

To enable mirrors, open /etc/pacman.d/mirrorlist and locate your
geographic region. Uncomment mirrors you would like to use.

Note: ftp.archlinux.org is throttled at 50KB/s.

Example:

    # Any
    # Server = ftp://mirrors.kernel.org/archlinux/$repo/os/$arch
    Server = http://mirrors.kernel.org/archlinux/$repo/os/$arch

See #Mirror status and #List by speed for tools that help choosing
mirrors.

Tip:Uncomment 5 favorite mirrors and place them at the top of the
mirrorlist file. That way it's easy to find them and move them around if
the first mirror on the list has problems. It also makes merging
mirrorlist updates easier.

It is also possible to specify mirrors in /etc/pacman.conf. For the
[core] repository, the default setup is:

    [core]
    Include = /etc/pacman.d/mirrorlist

To use the HostEurope mirror as a default mirror, add it before the
Include line:

    [core]
    Server = ftp://ftp.hosteurope.de/mirror/ftp.archlinux.org/core/os/$arch
    Include = /etc/pacman.d/mirrorlist

pacman will now try to connect to this mirror first. Proceed to do the
same for [testing], [extra], and [community], if applicable.

Note:If mirrors have been stated directly in pacman.conf, remember to
use the same mirror for all repositories. Otherwise packages that are
incompatible to each other may be installed, like linux from [core] and
an older kernel module from [extra].

> Force pacman to refresh the package lists

After creating/editing /etc/pacman.d/mirrorlist, (manually or by using
rankmirrors) issue the following command:

    # pacman -Syy

Tip:Passing two --refresh or -y flags forces pacman to refresh all
package lists even if they are considered to be up to date. Issuing
pacman -Syy whenever changing to a new mirror is good practice and will
avoid possible issues.

Mirror status
-------------

Check the status of the Arch mirrors and how updated they are by
visiting http://www.archlinux.de/?page=MirrorStatus or
https://www.archlinux.org/mirrors/status/.

You can generate an up to date mirrorlist here, automate the process
with a script, or install Reflector, a utility that generates a
mirrorlist using Mirrorcheck's list; you can also manually check how
up-to-date a mirror is by:

1.  picking a server and browsing to "extra/os/";
2.  accessing https://www.archlinux.org/ in another browser tab or
    window; and
3.  comparing the last-modified date of the i686 directory on the mirror
    to the [extra] date on the homepage, in the Package Repositories box
    to the right.

Sorting mirrors
---------------

When downloading packages pacman uses the mirrors in the order they are
in /etc/pacman.d/mirrorlist. If not using reflector, which has the
ability to sort mirrors by both how updated they are and their speed,
follow this demonstration of manual mirror sorting.

Note:This does not apply to powerpill-light, which connects to many
servers simultaneously to increase the overall download speed. The speed
of individual connections becomes less relevant, and powerpill-light can
be configured to require minimum speeds per connection.

> List by speed

Take full advantage of using the fastest local mirror, which can be
determined via the included Bash script, /usr/bin/rankmirrors.

Back up the existing /etc/pacman.d/mirrorlist:

    # cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

Edit /etc/pacman.d/mirrorlist.backup and uncomment mirrors for testing
with rankmirrors.

Optionally run the following sed line to uncomment every mirror:

    # sed '/^#\S/ s|#||' -i /etc/pacman.d/mirrorlist.backup

Finally, rank the mirrors. Operand -n 6 means only output the 6 fastest
mirrors:

    # rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist

Run rankmirrors -h for a list of all the available options.

> Combined listing by speed and status

It is not a good idea to just use the fastest mirrors, since the fastest
mirrors might be out of date. The preferred way would be to use #List by
speed, then sorting those 6 fastest mirrors by their #Mirror status.

Simply visit either one or both #Mirror status links and sort them by
the ones that are more up to date. Move the more up to date mirrors to
the top of /etc/pacman.d/mirrorlist and if the mirrors are way out of
date simply do not use those; repeat the process leaving out the
outdated mirrors. So this ends up with a total of 6 mirrors that are
sorted by speed and status, leaving out outdated mirrors.

When having mirror issues the above should be repeated. Or repeat once
in a while even if not having mirror problems, to keep
/etc/pacman.d/mirrorlist up to date.

> Script to automate use of Pacman Mirrorlist Generator

You can use the following shell script to update your mirrors based on
the rankings produced by the Pacman Mirrorlist Generator. If you do not
live in the United States, you can change the country variable.

    updatemirrors.sh

    #!/bin/sh

    [ "$UID" != 0 ] && su=sudo

    country='US'
    url="https://www.archlinux.org/mirrorlist/?country=$country&protocol=ftp&protocol=http&ip_version=4&use_mirror_status=on"

    tmpfile=$(mktemp --suffix=-mirrorlist)

    # Get latest mirror list and save to tmpfile
    wget -qO- "$url" | sed 's/^#Server/Server/g' > "$tmpfile"

    # Backup and replace current mirrorlist file (if new file is non-zero)
    if [ -s "$tmpfile" ]
    then
      { echo " Backing up the original mirrorlist..."
        $su mv -i /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.orig; } &&
      { echo " Rotating the new list into place..."
        $su mv -i "$tmpfile" /etc/pacman.d/mirrorlist; }
    else
      echo " Unable to update, could not download list."
    fi

    # allow global read access (required for non-root yaourt execution)
    chmod +r /etc/pacman.d/mirrorlist

  

Note:You will need to copy the text above, place it into a file, and run
chmod +x on the file. If you are not currently logged in as root, the
script will invoke sudo for you when it needs to rotate the new
mirrorlist into place.

> Using Reflector

Alternatively, you can use Reflector to automatically retrieve the
latest mirrorlist from the MirrorStatus page, filter the most up-to-date
mirrors, sort them by speed and overwrite the file
/etc/pacman.d/mirrorlist.

> Choosing a local mirror

The simple way is to edit mirrorlist file by placing a local mirror at
the top of the list. pacman will then use this mirror for preference.

Alternativley the pacman.conf file can be edited by placing a local
mirror before the line sourcing the mirrorlist file, i.e. where it says
"add your preferred servers here". It is safer if you use the same
server for each repository.

Official mirrors
----------------

The official Arch Linux mirror list is available from the
pacman-mirrorlist package. To get an even more up-to-date list of
mirrors, use the Pacman Mirror List Generator page on the main site.

In the unlikely scenario that you are without any configured mirrors and
pacman-mirrorlist is not installed, run the following command:

    # wget -O /etc/pacman.d/mirrorlist https://www.archlinux.org/mirrorlist/all/

Be sure to uncomment a preferred mirror as described above, then:

    # pacman -Syy
    # pacman -S --force pacman-mirrorlist

If you want your mirror to be added to the official list, file a feature
request. In the meantime, add it to the #Unofficial mirrors list at the
end of this page.

If you get an error stating that the $arch variable is used but not
defined, add the following to your /etc/pacman.conf:

    Architecture = x86_64

Note:You can also use the values auto and i686 for the Architecture
variable.

> IPv6-ready mirrors

The pacman mirror list generator can also be used to find a list of
current IPv6 mirrors.

Unofficial mirrors
------------------

These mirrors are not listed in /etc/pacman.d/mirrorlist.

> Global

-   http://sourceforge.net/projects/archlinux/files/ - ISO files only;
    Does not have any releases since 2006. Use it only if for getting
    older ISOs.

> TOR Network

-   http://cz2jqg7pj2hqanw7.onion/archlinux
-   ftp://mirror:mirror@cz2jqg7pj2hqanw7.onion/archlinux

> Singapore

-   http://mirror.nus.edu.sg/archlinux/

> Bulgaria

-   http://mirror.telepoint.bg/archlinux/
-   ftp://mirror.telepoint.bg/archlinux/

> Viet Nam

FPT TELECOM

-   http://mirror-fpt-telecom.fpt.net/archlinux/

> China

CHINA TELECOM

-   http://mirror.lupaworld.com/archlinux/

CHINA UNICOM

-   http://mirrors.sohu.com/archlinux/

> Cernet

-   http://ftp.sjtu.edu.cn/archlinux/ - Shanghai Jiaotong University
-   ftp://ftp.sjtu.edu.cn/archlinux/
-   http://mirrors.ustc.edu.cn/archlinux/ - University of Science and
    Technology of China
-   ftp://mirrors.ustc.edu.cn/archlinux/
-   http://mirrors.tuna.tsinghua.edu.cn/archlinux/ - Tsinghua University
-   http://mirrors.4.tuna.tsinghua.edu.cn/archlinux/ (ipv4 only)
-   http://mirrors.6.tuna.tsinghua.edu.cn/archlinux/ (ipv6 only)
-   http://mirror.lzu.edu.cn/archlinux/ - Lanzhou University

> France

-   http://delta.archlinux.fr/ - With Delta package support. Needs
    xdelta3 package from extra to run.
-   http://mirror.soa1.org/archlinux
-   ftp://mirror:mirror@mirror.soa1.org/archlinux

> Germany

-   http://ftp.uni-erlangen.de/mirrors/archlinux/
-   ftp://ftp.uni-erlangen.de/mirrors/archlinux/
-   http://ftp.u-tx.net/archlinux/
-   ftp://ftp.u-tx.net/archlinux/
-   http://mirror.michael-eckert.net/archlinux/
-   http://linux.rz.rub.de/archlinux/

> Indonesia

-   http://mirror.kavalinux.com/archlinux/ - only from Indonesia
-   http://kambing.ui.ac.id/archlinux/
-   http://repo.ukdw.ac.id/archlinux/

> Kazakhstan

-   http://archlinux.kz/
-   http://mirror.neolabs.kz/archlinux/
-   http://mirror-kt.neolabs.kz/archlinux/

> Lithuania

-   http://edacval.homelinux.org/mirrors/archlinux/ - Only from LT,
    without ISO

> Malaysia

-   http://mirror.oscc.org.my/archlinux/
-   http://mirrors.inetutils.net/archlinux/ - ISO and Core

> New Zealand

-   http://mirror.ihug.co.nz/archlinux/
-   http://mirror.ece.auckland.ac.nz/archlinux/ NZ only

> Poland

-   ftp://ftp.icm.edu.pl/pub/Linux/dist/archlinux/ - ICM UW
-   http://ftp.icm.edu.pl/pub/Linux/dist/archlinux/ - ICM UW
-   rsync://ftp.icm.edu.pl/pub/Linux/dist/archlinux/ - ICM UW

> Russia

-   http://hatred.homelinux.net/archlinux/ - Vladivostok, without iso,
    with 3SPY project repos and mingw32 repo
-   http://mirrors.krasinfo.ru/archlinux/ - Krasnoyarsk,
    Classica-Service Ltd

> South Africa

-   http://ftp.sun.ac.za/ftp/pub/mirrors/archlinux/ - Stellenbosch
    University
-   ftp://ftp.sun.ac.za/pub/mirrors/archlinux/
-   http://ftp.leg.uct.ac.za/pub/linux/arch/ - University of Cape Town
-   ftp://ftp.leg.uct.ac.za/pub/linux/arch/
-   http://mirror.ufs.ac.za/archlinux/ - University of the Free State
-   ftp://mirror.ufs.ac.za/os/linux/distros/archlinux/
-   http://ftp.wa.co.za/pub/archlinux/ - Web Africa Networks
-   ftp://ftp.wa.co.za/pub/archlinux/
-   http://archlinux.mirror.ac.za - TENET - Tertiary Education and
    Research Network of South Africa
-   ftp://archlinux.mirror.ac.za

> United States

-   http://archlinux.linuxfreedom.com - Contains numerous ISO images but
    does not contain the ISO dated 2011.08.19
-   http://mirror.pointysoftware.net/archlinux/

> Hyperboria

-   http://[fc7b:5f90:01f8:2b33:7c3e:f94b:00f3:0bed]/archlinux/

Troubleshooting
---------------

> Out-of-sync mirrors: corrupted packages/file not found

Issues regarding out-of-sync mirrors pointed out in this news post may
have already been sorted out for most users, but in the event that
problems of this nature present themselves again, simply try to see if
the packages are present in the [testing] repository.

After having synced with pacman -Sy, use this command:

    # pacman -Ud $(pacman -Sup | tail -n +2 | sed -e 's,/\(core\|extra\)/,/testing/,' \
                                                  -e 's,/\(community\)/,/\1-testing/,')

Doing so could help in any occasion where packages in the mirror have
not been synced to [core] or [extra], and are still residing in
[testing]. It is perfectly safe to install from [testing] in this case
since the packages are being matched by version and release numbers.

In any event, it is best to switch mirrors and sync with pacman -Syy
than resorting to an alternate repository. However, all or some of the
mirrors may at times be out-of-sync to some degree.

Using all mirrors

To emulate pacman -Su's behavior of going through the entire mirror
list, use this script:

    ~/bin/pacup

    #!/bin/bash

    # Pacman will not exit on the first error. Comment the line below to
    # try from [testing] directly.
    pacman -Su "$@" && exit

    while read -r pkg; do
      if pacman -Ud "$pkg"; then
        continue
      else
        while read -r mirror; do
          pacman -Ud $(sed "s,.*\(/\(community-\)*testing/os/\(i686\|x86_64\)/\),$mirror\1," <<<"$pkg") &&
          break
        done < <(sed -ne 's,^ *Server *= *\|/$repo/os/\(i686\|x86_64\).*,,gp' \
               </etc/pacman.d/mirrorlist | tail -n +2 )
      fi
    done < <(pacman -Sup | tail -n +2 | sed -e 's,/\(core\|extra\)/,/testing/,' \
                                            -e 's,/\(community\)/,/\1-testing/,')

See Also
--------

-   MirUp – pacman mirrorlist downloader/checker

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mirrors&oldid=254002"

Categories:

-   About Arch
-   Package management
