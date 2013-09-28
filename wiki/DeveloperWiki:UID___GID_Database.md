DeveloperWiki:UID / GID Database
================================

UID / GID Database
==================

This is intended to be a starting point for creating standard uid and
gid numbers.

I really think this should be moved directly into arch at some point and
just have a a keyword in PKGBUILD like

    require_user('user1' 'user2')
    require_group('group1')

and if they didn't exist they would be created according to this
database by makepkg when building or by pacman when installing.

Actually, for this to work, we will need to add the primary and
secondary groups to the database as well.

Users
-----

  User Name              UID
  ---------------------- ------
  root                   0
  bin                    1
  daemon                 2
  mail                   8
  news                   9
  uucp                   10
  ftp                    14
  proxy                  15
  stunnel                16
  jabber                 17
  osiris                 18
  slocate                21
  cron                   22
  snort                  29
  nagios (coming soon)   30
  nrpe                   31
  http                   33
  named                  40
  privoxy                42
  tor                    43
  mpd                    45
  nut                    55
  rbldns                 58
  rbldnszones            59
  dnslog                 60
  dnscache               61
  tinydns                62
  axfrdns                63
  clamav                 64
  bitlbee                65
  tomcat                 66
  minbif                 67
  uuidd                  68
  fax                    69
  cyrus                  70
  tomcat7                71
  courier                72
  postfix                73
  dovenull               74
  dovecot                76
  asterisk               77
  exim                   79
  vpopmail               80
  dbus                   81
  hal                    82
  nsvsd                  83
  avahi                  84
  nx                     85
  beaglidx               86
  ntp                    87
  postgres               88
  mysql                  89
  fetchmail              90
  nobody                 99
  nm-openconnect         104
  cherokee               106
  partimag               110
  x2gouser               111
  x2goprint              112
  gdm                    120
  lxdm                   121
  deluge                 125
  backuppc               126
  pulse                  130
  rtkit                  133
  kdm                    135
  znc                    136
  usbmux                 140
  transmission           169
  ldap                   439
  oprofile               492
  alias                  7790
  qmaild                 7791
  qmaill                 7792
  qmailp                 7793
  qmailq                 7794
  qmailr                 7795
  qmails                 7796

Groups
------

  Group Name                            GID
  ------------------------------------- ------
  root                                  0
  bin                                   1
  daemon                                2
  sys                                   3
  adm                                   4
  tty                                   5
  disk                                  6
  lp                                    7
  mem                                   8
  kmem                                  9
  wheel                                 10
  ftp                                   11
  mail                                  12
  news                                  13
  uucp                                  14
  proxy                                 15
  stunnel                               16
  jabber                                17
  osiris                                18
  log                                   19
  utmp                                  20
  locate (ex slocate/mlocate/rlocate)   21
  cron                                  22
  rfkill                                24
  smmsp                                 25
  snort                                 29
  nagios (coming soon)                  30
  nrpe                                  31
  http                                  33
  named                                 40
  privoxy                               42
  tor                                   43
  mpd                                   45
  games                                 50
  nut                                   55
  rbldns                                58
  rbldnszones                           59
  clamav                                64
  bitlbee                               65
  tomcat                                66
  minbif                                67
  uuidd                                 68
  cyrus                                 70
  tomcat7                               71
  courier                               72
  dovenull                              74
  postdrop                              75
  dovecot                               76
  asterisk                              77
  kvm                                   78
  exim                                  79
  vchkpw                                80
  dbus                                  81
  hal                                   82
  nsvsd                                 83
  avahi                                 84
  nx                                    85
  beaglidx                              86
  ntp                                   87
  postgres                              88
  mysql                                 89
  network                               90
  video                                 91
  audio                                 92
  optical                               93
  floppy                                94
  storage                               95
  scanner                               96
  camera                                97
  power                                 98
  nobody                                99
  users                                 100
  policykit                             102
  nm-openconnect                        104
  cherokee                              106
  vboxusers                             108
  vboxsf                                109
  partimag                              110
  x2gouser                              111
  x2goprint                             112
  gdm                                   120
  lxdm                                  121
  deluge                                125
  backuppc                              126
  vlock                                 129
  pulse                                 130
  pulse-access                          131
  pulse-rt                              132
  rtkit                                 133
  kdm                                   135
  znc                                   136
  usbmux                                140
  wireshark                             150
  cgred                                 160
  transmission                          169
  systemd-journal                       190
  ldap                                  439
  oprofile                              492
  qmail                                 2107
  nofiles                               2108

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:UID_/_GID_Database&oldid=250550"

Category:

-   DeveloperWiki
