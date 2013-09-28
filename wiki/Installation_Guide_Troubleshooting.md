Installation Guide Troubleshooting
==================================

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with             
                           Installation Guide.      
                           Notes: This page should  
                           be a part of             
                           Installation Guide       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Installing the base system
==========================

Errors when running pacstrap

> (PGP)Key "..." could not be imported

error: linux-api-headers: key "F990EB20FAEsomhing" is unknown 

Import PGP key EAE999BD, "Allan McRae <me@allanmcrae.com>", created on
2011-06-03? [Y/n]

error: key "Allan McRae <me@allanmcrae.com>" could not be imported

Can be due to incorrect date, to fix set the time manually or use
ntpd -qg to use the network to set the time.(a case)

> Key import fails otherwise

One solution is to change the core repo in /etc/pacman.conf from
SigLevel = PackageRequired to SigLevel = Optional TrustAll But that
would decrease security by a lot.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Installation_Guide_Troubleshooting&oldid=251577"