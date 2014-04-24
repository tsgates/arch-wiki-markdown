TPM
===

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

A Trusted Platform Module is a "Security Chip" which is built in many
modern PCs.

Have a look on Wikipedia for more general information.

Contents
--------

-   1 TPM or not TPM
-   2 Enabling in the BIOS
-   3 Drivers
-   4 trousers/tcsd
-   5 Using the TPM
    -   5.1 tpm-tools
    -   5.2 tpmmanager
    -   5.3 openssl_tpm_engine
    -   5.4 tpm_keyring2
    -   5.5 opencryptoki

TPM or not TPM
--------------

First you must find out if you have an TPM in your computer, and what
kind of TPM.

For ThinkPads have a look in the Thinkwiki.

Enabling in the BIOS
--------------------

Just look for an Entry like "Enable TPM-Chip" and set it on Enabled.

Drivers
-------

Drivers are Kernel Modules and can be loaded with

    modprobe tpm

or tpm_atmel, tpm_bios, tpm_infineon, tpm_nsc or tpm_tis, depending on
your chipset.

trousers/tcsd
-------------

For using a TPM you must compile some packages from the AUR.

You will need the trousers package, which was created and released by
IBM.

It provides you with "tcsd", a user space daemon that manages Trusted
Computing resources and should be (according to the TSS spec) the only
portal to the TPM device driver.

tcsd has a manpage. You can configure tcsd trough /etc/tcsd.conf.

For starting tcsd and watching the output, run

    tcsd -f

or simply add tcsd to the DAEMONS line in /etc/rc.conf for automatic
startup with every boot.

Using the TPM
-------------

There are several AUR packages for using the TPM with trousers, most of
are also part of the trousers project.

> tpm-tools

tpm-tools

Is a set of tools like tpm_changeownerauth, tpm_clear, tpm_createek,
tpm_getpubek, tpm_resetdalock, tpm_restrictpubek, tpm_revokeek,
tpm_sealdate, tpm_selftest, tpm_setactive, tpm_setclearable,
tpm_setenable, tpm_setoperatorauth, tpm_setownable, tpm_setpresence,
tpm_takeownership, tpm_version.

Each of them has an own manpage.

> tpmmanager

tpmmanager

A Qt front-end to tpm-tools, not developed by the trousers team.

> openssl_tpm_engine

openssl_tpm_engine

OpenSSL engine which interfaces with the TSS API

> tpm_keyring2

tpm_keyring2

A key manager for TPM based eCryptfs keys

> opencryptoki

opencryptoki

openCryptoki is a PKCS#11 implementation for Linux. It includes drivers
and libraries to enable IBM cryptographic hardware as well as a software
token for testing.

Retrieved from
"https://wiki.archlinux.org/index.php?title=TPM&oldid=277272"

Categories:

-   Security
-   Hardware

-   This page was last modified on 1 October 2013, at 20:21.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
