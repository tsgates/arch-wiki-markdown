Google Authenticator
====================

The Google Authenticator project provides a two-step authentication
procedure using one-time passcodes (OTP). The OTP generator application
is available for iOS, Android and Blackberry. Similar to
S/KEY_Authentication the authentication mechanism integrates into the
Linux PAM system. This guide shows the installation and configuration of
this mechanism.

Contents
--------

-   1 Installation
-   2 Setting up the PAM
-   3 Generating a secret key file
-   4 Setting up your OTP-generator
-   5 Testing

Installation
------------

The required software is available in the
google-authenticator-libpam-git package in the AUR.

Setting up the PAM
------------------

Warning:If you do all configuration via SSH do not close the session
before you tested that everything is working, else you may lock yourself
out. Furthermore consider generating the key file before activating the
PAM.

Usually one demands two-pass authentication only for remote login. The
corresponding PAM configuration file is /etc/pam.d/sshd. In case you
want to use Google Authenticator globally you would need to change
/etc/pam.d/system-auth, however, in this case proceed with extreme
caution to not lock yourself out. In this guide we proceed with editing
/etc/pam.d/sshd which is most safely (but not necessarily) be done in a
local session.

To enter both, your unix password and your OTP add
pam_google_authenticator.so the following way.

     auth            required        pam_google_authenticator.so
     auth            required        pam_unix.so
     auth            required        pam_env.so

This will ask for the OTP before prompting for your Unix password.
Changing the order of the two modules will reverse this order.

Warning:Only users that have generated a secret key file (see below)
will be allowed to log in using SSH.

To allow login with either the OTP or your Unix password use

     auth            sufficient      pam_google_authenticator.so
     auth            sufficient      pam_unix.so
     auth            required        pam_env.so

Finally enable challenge-response authentication in
/etc/ssh/sshd_config:

     ChallengeResponseAuthentication yes

and reload sshd's configuration

     # systemctl reload sshd

Generating a secret key file
----------------------------

Every user who wants to use two-pass authentication needs to generate a
secret key file in his home folder. This can very easily be done using
google-authenticator as included in google-authenticator-libpam-git.

       $ google-authenticator
       Do you want authentication tokens to be time-based (y/n) y
       https://www.google.com/chart?chs=200x200&chld=M%7C0&cht=qr&chl=otpauth://totp/username@hostname%3Fsecret%3DZVZG5UZU4D7MY4DH
       Your new secret key is: ZVZG5UZU4D7MY4DH
       Your verification code is 269371
       Your emergency scratch codes are:
         70058954
         97277505
         99684896
         56514332
         82717798
       
       Do you want me to update your "/home/username/.google_authenticator" file (y/n) y
       
       Do you want to disallow multiple uses of the same authentication
       token? This restricts you to one login about every 30s, but it increases
       your chances to notice or even prevent man-in-the-middle attacks (y/n) y
       
       By default, tokens are good for 30 seconds and in order to compensate for
       possible time-skew between the client and the server, we allow an extra
       token before and after the current time. If you experience problems with poor
       time synchronization, you can increase the window from its default
       size of 1:30min to about 4min. Do you want to do so (y/n) n
       
       If the computer that you are logging into isn't hardened against brute-force
       login attempts, you can enable rate-limiting for the authentication module.
       By default, this limits attackers to no more than 3 login attempts every 30s.
       Do you want to enable rate-limiting (y/n) y

It's recommended to store the emergency scratch codes safely (print them
out and keep them in a save location) as they are your only way to log
in (via SSH) when you lost your mobile phone (i.e. your OTP-generator).
They are also stored in ~/.google_authenticator, so you can look them up
any time as long as you are logged in.

Setting up your OTP-generator
-----------------------------

Install the corresponding generator application on your mobile phone
from the corresponding store by browsing to
http://m.google.com/authenticator from your mobile device. In the
applications menu click the corresponding button to create a new account
and either scan the QR code from the URL you were told when generating
the secret key file, or enter the secret key (in the example above
'ZVZG5UZU4D7MY4DH') manually.

Now you should see a new passcode token being generated every 30 seconds
on your phone.

Testing
-------

SSH to your host from another machine or from another terminal window
and check if it works.

     $ssh username@hostname
     login as: username
     Verification code:
     Password:
     $

Retrieved from
"https://wiki.archlinux.org/index.php?title=Google_Authenticator&oldid=306067"

Categories:

-   Secure Shell
-   Security

-   This page was last modified on 20 March 2014, at 17:39.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
