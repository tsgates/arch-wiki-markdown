TGT iSCSI Target
================

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: Dutch article is 
                           the original, English is 
                           not my native language.  
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Summary help replacing me

Installation and configuration of TGT as iSCSI target

> Related

iSCSI Target

iSCSI Boot

The TGT SCSI framework can be used for several storage protocols. This
document describes the usage of TGT as iSCSI target.

Contents
--------

-   1 Why TGT
-   2 Installation
-   3 Configuration
-   4 Example configuration
-   5 Start
-   6 See also

Why TGT
-------

There are several different iSCSI targets for Linux available, with more
or less the same performance. TGT has the following advantages:

-   active development
-   the only iSCSI target that can be used for vSphere environments

Installation
------------

The tgt software must be deployed from AUR. If you want to use the
direct store, then sg3_utils must be deployed from the [extra]
repository. Using direct-store, the properties of the physical device
will be available for the initiator and target.

Please notice, if you're using a Firewall, tcp port 3260 should be open.

Configuration
-------------

The configuration can be done:

-   using the tgtadm utility, afterwards you can use tgt-admin --dump to
    save the configuration.   
     You can find this method in the Scsi-target-utils Quickstart Guide,
    as linked from the TGT website. Unfortunately the bad thing about
    this method is that not all parameters will be stored in the
    configuration file.
-   editing the /etc/tgt/targets.conf file.

Example configuration
---------------------

    <target iqn.2004-01.nl.xtg:iscsi-server1>
     direct-store /dev/sdb
     write-cache on
     initiator-address ALL
     incominguser user password
     scsi_id 00010001
     vendor_id XTG
     lun 12
    </target>

    MaxRecvDataSegmentLength 131072
    MaxXmitDataSegmentLength 131072
    MaxBurstLength 262144
    FirstBurstLength 262144
    TargetRecvDataSegmentLength=262144
    InitiatorRecvDataSegmentLength=262144
    MaxOutstandingUnexpectedPDUs=0
    MaxOutstandingR2T=1
    MaxCommands=128

In the first part of this example, /dev/sdb will be offered as lun 12
and chap authentication is configured. In the second part are some iSCSI
advanced parameters

Start
-----

If the configuration is well done, TGT can be started:

    sudo rc.d start tgt

If you want to start TGT during the boot process of Arch Linux, add tgt
in the DAEMONS area of the rc.conf file.

    DAEMONS = ( ... network tgt ... )

You can check if everything works like expected:

    tgt-admin -s

See also
--------

-   Quickstart Guide for STGT for Fedora
-   Configuration File Guide

Retrieved from
"https://wiki.archlinux.org/index.php?title=TGT_iSCSI_Target&oldid=207338"

Category:

-   Storage

-   This page was last modified on 13 June 2012, at 16:14.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
