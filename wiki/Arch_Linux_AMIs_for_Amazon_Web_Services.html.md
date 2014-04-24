Arch Linux AMIs for Amazon Web Services
=======================================

Contents
--------

-   1 Running public Arch AMIs
    -   1.1 Archlinux AMI
    -   1.2 Other AMIs
-   2 Building Arch AMIs
-   3 Updated Images

Running public Arch AMIs
------------------------

> Archlinux AMI

New 64 bit AMIs available in all regions! They are updated as of
2012-10-19. I'm working on writing up a how to and will post when it's
done. Beowuff (talk) 18:20, 17 July 2012 (UTC)

-   ami-6ee95107 = US East (N. Virginia)
-   ami-bcf77e8c = US West (Oregon)
-   ami-337d5b76 = US West (N. California)
-   ami-17595a63 = EU (Ireland)
-   ami-6af9b938 = Asia Pacific (Singapore)
-   ami-8cad138d = Asia Pacific (Tokyo)
-   ami-6259807f = South America (Sao Paulo)

> Other AMIs

Verified working public arch liunx AMIs are below

    AMI          Store Build   Release     Kernel Last verified
    ami-07be766e  EBS  64 bit  2011-04-15  3.0+   2012-01-14    
    ami-19be7670  EBS  64 bit  2011-11-18  3.0+   2012-01-14    
    ami-26e8144f  EBS  32 bit  2011-04-15  2.6    2012-01-14    
    ami-38e81451  EBS  32 bit  2011-04-15  2.6    2012-01-14    

These AMIs ship with Arch linux kernels that are booted by PV-GRUB.

(2012-01-14) The 64 bit AMIs consistently failed to boot on Micro
instances in us-east-1a and us-east-1d. In us-east-1b and us-east-1c the
AMIs occasionally fail to boot. Stop and start the instance to reassign
it a random machine in these cases.

This may be an issue with Amazon running different versions of Xen on
different machines / older availability zones.

Building Arch AMIs
------------------

linux-ec2 in AUR compiles the Arch linux kernel for AWS with Xen modules
enabled and the XSAVE patch applied.

Updated Images
--------------

Up-to-date (as of 03/05/2013) Amazon EC2 AMI images for Arch Linux can
be found here:

http://www.uplinklabs.net/projects/arch-linux-on-ec2/

Retrieved from
"https://wiki.archlinux.org/index.php?title=Arch_Linux_AMIs_for_Amazon_Web_Services&oldid=257204"

Category:

-   Getting and installing Arch

-   This page was last modified on 16 May 2013, at 09:10.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
