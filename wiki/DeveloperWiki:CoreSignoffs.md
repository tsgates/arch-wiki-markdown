DeveloperWiki:CoreSignoffs
==========================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Core Signoffs                                                      |
|     -   1.1 Process                                                      |
|     -   1.2 Caveats                                                      |
|     -   1.3 List of potential signees for low-usage core packages        |
+--------------------------------------------------------------------------+

Core Signoffs
=============

This policy is intended to ensure the [core] repository, and thus the
core of Arch Linux, is as functional as possible at all times.

> Process

The process is simple:

-   All [core] packages MUST go to [testing] first.
-   When a [core] package is placed in [testing] an email SHOULD be sent
    to the arch-dev-public mailing list with the subject "[signoff]
    foobar-1.0-1", where foobar-1.0-1 is the package name and version.
-   All developers are encouraged to test this package.
-   If a package works fine, a reply SHOULD be sent, telling the
    maintainer it worked, and on which architecture.
-   When a package receives 2 signoffs for each architecture, it can be
    moved from [testing] to [core].
-   A maintainer is free to leave a package in [testing] for further
    testing or signoffs, but should make this intention known in the
    signoff email.

> Caveats

The maintainer himself *DOES* count as a signoff. We are working under
the assumption that the maintainer did test the package before pushing
it to [testing]. Thus, a package may only need one signoff if the
original maintainer tested it on both architectures before uploading.

> List of potential signees for low-usage core packages

This list is to improve the effectiveness of the signoffs by determining
what packages can't get the required signoffs by the dev group. Please
put your name (or nick) and the arch (i686, x86_64, both) along the
low-usage packages you can test. I'm listing here all the core packages.
The ones that I believe everyone use and can test (please fix if they
are incorrect or missing) are marked by a 'EVERYONE' so you don't need
to write your name beside them.

  ------------------------- --------------------------------------------------------------
  acl                       EVERYONE
  atl2                      (in kernel now, this package will be dropped)
  attr                      EVERYONE
  autoconf                  EVERYONE
  automake                  EVERYONE
  b43-fwcutter              
  bash                      EVERYONE
  bin86                     EVERYONE
  binutils                  EVERYONE
  bison                     EVERYONE
  bridge-utils              
  bzip2                     EVERYONE
  ca-certificates           
  capi4k-utils              
  coreutils                 EVERYONE
  cpio                      
  cracklib                  EVERYONE
  cryptsetup                
  dash                      Dan(both)
  db                        EVERYONE
  dbus-core                 
  dcron                     EVERYONE
  device-mapper             Eric(both)
  dhcpcd                    Eric(x86_64), Ronald(both), Geoffroy(both)
  dialog                    Aaron(both)
  diffutils                 EVERYONE
  dmapi                     
  dmraid                    
  dnsutils                  
  dosfstools                Geoffroy(i686)
  e2fsprogs                 Allan (both), Ronald(both), Geoffroy(i686 ext4, x86_64 ext3)
  ed                        EVERYONE
  eventlog                  makedep for syslog-ng
  expat                     
  fakeroot                  EVERYONE
  file                      EVERYONE
  filesystem                EVERYONE
  findutils                 EVERYONE
  flex                      EVERYONE
  gawk                      EVERYONE
  gcc                       EVERYONE
  gcc-libs                  EVERYONE
  gdbm                      
  gen-init-cpio             EVERYONE
  gettext                   Allan (both)
  glib2                     EVERYONE
  glibc                     EVERYONE
  gmp                       EVERYONE
  gpm                       Eric(both)
  grep                      EVERYONE
  groff                     EVERYONE
  grub                      Eric(x86_64), Aaron(both)
  gzip                      EVERYONE
  hdparm                    Geoffroy(i686)
  heimdal                   EVERYONE
  hwdetect                  
  ifenslave                 
  initscripts               EVERYONE
  iproute                   
  iptables                  Ronald(both)
  iputils                   
  ipw2100-fw                
  ipw2200-fw                Pierre (i686)
  isdn4k-utils              
  iwlwifi-3945-ucode        Allan (both) / Thayer (i686)
  iwlwifi-4965-ucode        Geoffroy(i686)
  iwlwifi-5000-ucode        
  jfsutils                  Ronald(both)
  kbd                       EVERYONE
  kernel-headers            EVERYONE
  kernel26                  EVERYONE
  klibc                     EVERYONE
  klibc-extras              EVERYONE
  klibc-kbd                 EVERYONE
  klibc-module-init-tools   EVERYONE
  klibc-udev                EVERYONE
  less                      EVERYONE
  libarchive                EVERYONE
  libdownload               EVERYONE
  libelf                    
  libevent                  
  libgcrypt                 
  libgpg-error              
  libldap                   
  libpcap                   
  libsasl                   
  libtool                   EVERYONE
  libusb                    
  licenses                  EVERYONE
  lilo                      Eric(i686)
  links                     Eric(both)
  linux-atm                 
  logrotate                 EVERYONE
  lvm2                      Eric(both)
  lzo2                      
  m4                        EVERYONE
  madwifi                   
  madwifi-utils             
  mailx                     
  make                      EVERYONE
  man                       EVERYONE
  man-pages                 EVERYONE
  mdadm                     Eric(x86_64)
  mkinitcpio                EVERYONE
  mlocate                   EVERYONE
  module-init-tools         EVERYONE
  mpfr                      EVERYONE
  nano                      Eric(both), Ronald(both)
  ncurses                   EVERYONE
  ndiswrapper               
  ndiswrapper-utils         
  net-tools                 EVERYONE
  netcfg                    EVERYONE
  netkit-telnet             
  nfs-utils                 Dan(both)
  nfsidmap                  
  openssh                   EVERYONE
  openssl                   EVERYONE
  openswan                  
  openvpn                   Geoffroy(i686 client,x86_64 client+server)
  pacman                    EVERYONE
  pam                       EVERYONE
  patch                     EVERYONE
  pciutils                  Aaron(both)
  pcmciautils               
  pcre                      EVERYONE
  perl                      EVERYONE
  pkgconfig                 EVERYONE
  popt                      EVERYONE
  portmap                   Dan(both, see nfs-utils above)
  ppp                       
  pptpclient                
  procinfo                  
  procps                    
  psmisc                    EVERYONE
  readline                  EVERYONE
  reiserfsprogs             dgriffiths (i686)
  rp-pppoe                  Ronald(both)
  rt2500                    
  rt2x00-rt61-fw            
  rt2x00-rt71w-fw           
  run-parts                 
  sdparm                    
  sed                       EVERYONE
  shadow                    EVERYONE
  sudo                      EVERYONE
  sysfsutils                
  syslog-ng                 EVERYONE
  sysvinit                  EVERYONE
  tar                       EVERYONE
  tcp_wrappers              
  texinfo                   EVERYONE
  tiacx                     
  tiacx-firmware            
  tzdata                    EVERYONE
  udev                      EVERYONE
  usbutils                  EVERYONE
  util-linux-ng             
  vi                        Eric(both) / Aaron(both) (EVERYONE?)
  vpnc                      Pierre (i686), Geoffroy(i686)
  wget                      EVERYONE
  which                     EVERYONE
  wireless_tools            Thayer (i686)
  wlan-ng26                 
  wlan-ng26-utils           
  wpa_supplicant            Pierre (i686) / Thayer (i686)
  xfsprogs                  
  xinetd                    
  zd1211-firmware           
  zlib                      EVERYONE
  ------------------------- --------------------------------------------------------------

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:CoreSignoffs&oldid=173403"

Category:

-   DeveloperWiki
