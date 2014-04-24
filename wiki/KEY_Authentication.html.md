S/KEY Authentication
====================

Related articles

-   Secure Shell
-   One Time PassWord
-   Pam abl

This guide shows you how you can enable S/KEY one-time password
authentication on your Arch.

Warning:Do following actions on secure connection from a secure
computer. A chain is as strong as its weakest link.

Contents
--------

-   1 Install opie
-   2 Config pam module
-   3 Create an OTP key
-   4 Get yourself some passwords

Install opie
------------

Install the following packages from the AUR:

-   libpam-opie
-   opie-client
-   opie-server

(As of today 2010-05-17 packages does not seem to support x86_64 but
there is posted a fix on comments of opie-client)

Config pam module
-----------------

In /etc/pam.d tweak config files for wanted logins. I tweaked sshd and
sudo. Do the following to selected files:

    auth  required  pam_unix.so
    change to (note order)-->
    auth sufficient pam_unix.so
    auth sufficient pam_opie.so

If you want to use SSH, change ChallengeResponseAuthentication to yes in
/etc/ssh/sshd_config

Create an OTP key
-----------------

As your user (no root), run:

    # opiepasswd -c

After entering a passphrase you get your OTP key:

    ID busk OTP key is 499 fe6839
    MIRE MORE ODE DOME REAM

Get yourself some passwords
---------------------------

    # opiekey -n 20 499 fe6839

OR alternative way for Java-enabled mobile phone owners: Get VeJotp,
It's free and you can generate passwords on the run.

Now, when you ssh to your box, hit Enter to the password prompt and you
will be prompted for onetime password.

This guide is based on [1]

Retrieved from
"https://wiki.archlinux.org/index.php?title=S/KEY_Authentication&oldid=287337"

Category:

-   Security

-   This page was last modified on 9 December 2013, at 03:24.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
