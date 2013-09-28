Yubikey
=======

The Yubikey is a small USB token that generates One-Time Passwords
(OTP). It is manufactured by Yubico.

One of its strengths is that it emulates a USB keyboard to send the OTP
as text, and thus requires no drivers.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
|     -   1.1 How does it work                                             |
|     -   1.2 Security risks                                               |
|         -   1.2.1 AES key compromission                                  |
|         -   1.2.2 Validation requests/responses tampering                |
|                                                                          |
|     -   1.3 YubiCloud and validation servers                             |
|                                                                          |
| -   2 Two-factor authentication with SSH                                 |
|     -   2.1 Prerequisites                                                |
|     -   2.2 PAM configuration                                            |
|         -   2.2.1 If using HTTPS to authenticate the validation server   |
|         -   2.2.2 If using HMAC to authenticate the validation server    |
|                                                                          |
|     -   2.3 SSHD configuration                                           |
|     -   2.4 That is it!                                                  |
|     -   2.5 Explanation                                                  |
+--------------------------------------------------------------------------+

Introduction
------------

> How does it work

Yubikey's authentication protocol is based on symmetric cryptography.
More specifically, each Yubikey contains a 128-bit AES key, unique to
that key. It is used to encrypt a token made of different fields such as
the ID of the key, a counter, a random number, etc. The OTP is made from
concatenating the ID of the key with this encrypted token.

This OTP is sent to the target system, to which we want to authenticate.
This target system asks a validation server if the OTP is good. The
validation server has a mapping of Yubikey IDs -> AES key. Using the key
ID in the OTP, it can thus retrieve the AES key and decrypt the other
part of the OTP. If it looks OK (plain-text ID and encrypted ID are the
same, the counter is bigger than the last seen one to prevent replay
attacks...), then authentication is successful.

The validation server sends that authentication status back to the
target system, which grants access or not based on that response.

> Security risks

AES key compromission

As you can imagine, the AES key should be kept very secret. It can not
be retrieved from the Yubikey itself (or it should not, at least not
with software). It is present in the validation server though, so the
security of this server is very important.

Validation requests/responses tampering

Since the target system relies on the ruling of the validation server, a
trivial attack would be to impersonate the validation server. The target
system thus needs to authenticate the validation server. 2 methods are
available :

-   HMAC: This is also symmetric crypto, the target server and
    validation server share a key that is used to sign requests and
    responses.
-   TLS: Requests and responses travel via HTTP, so TLS (HTTPS) can be
    used to authenticate and encrypt the connection.

> YubiCloud and validation servers

When you buy a Yubikey, it is preloaded with an AES key that is known
only to Yubico. They will not even communicate it to you. Yubico
provides a validation server with free unlimited access (YubiCloud). It
also offers open-source implementations of the server.

So you can either:

-   choose to use your Yubikey with its preloaded AES key and validate
    against Yubico's validation server ;
-   or load a new AES key in your Yubikey and run your own validation
    server.

Note:To authenticate the Yubico validation server, you can:

-   with HMAC: use https://upgrade.yubico.com/getapikey/ to get an HMAC
    key and ID
-   with HTTPS: the validation server's certificate is signed by
    GoDaddy, that is cool because it is thus trusted by default in Arch
    installs (at least if you have package ca-certificates)

Two-factor authentication with SSH
----------------------------------

Note:See also:
http://code.google.com/p/yubico-pam/wiki/YubikeyAndSSHViaPAM

This details how to use a Yubikey to have two-factor authentication with
SSH, that is, to use both a password and a Yubikey-generated OTP.

> Prerequisites

The necessary packages are on the AUR. The one you need for TFA with SSH
is the yubico-pam-git. It depends on:

-   libyubikey
-   yubico-c-client-git
-   yubikey-personalization-git

Install them.

Note:If you are configuring a distant server to use Yubikey, you should
open at least one additional, rescue SSH session, so that you are not
locked out of your server if the configuration does not work and you
exit your main session inadvertently

> PAM configuration

You have to edit /etc/pam.d/sshd, and modify the line that reads :

    auth		required	pam_unix.so

into

    auth		required	pam_unix.so	use_first_pass

Then do one of the following. I personally would highly recommend the
HTTPS method, but the choice is yours. --Gohu 17:49, 24 April 2011 (EDT)

If using HTTPS to authenticate the validation server

Insert the following line before the previously modified pam_unix.so
line.

    auth            required        pam_yubico.so           id=1 url=https://api.yubico.com/wsapi/2.0/verify?id=%d&otp=%s

The id=1 is of no real use but it is required.

Note:If you run your own validation server, modify the url parameter to
point to your server

If using HMAC to authenticate the validation server

Insert the following line before the previously modified pam_unix.so
line.

    auth            required        pam_yubico.so           id=1234 key=YnVubmllcyBhcmUgY29vbAo=

where id and key are your own HMAC ID and key, requested from Yubico as
explained above.

Note:HMAC credentials should be unique to a single target server. That
way, if an attacker finds them, he will not be able to craft responses
to authenticate to other target servers you own

Note:We did not specify the url parameter: it defaults to Yubico's HTTP
(non-TLS) server

You should also disallow unprivileged users to read the file to prevent
them from seeing the HMAC credentials:

    # chmod o-r /etc/pam.d/sshd

Note:If you run your own validation server, add the url parameter to
point to your server

> SSHD configuration

You should check that /etc/ssh/sshd_config contains these lines and that
they are not commented, but I believe this is the default.

    ChallengeResponseAuthentication no
    UsePAM yes

> That is it!

You should not need to restart anything if you just touched the PAM
config file.

To log in, at the Password: prompt of SSH, you have to type your
password without pressing enter and touch the Yubikey's button. The
Yubikey should send a return at the end of the OTP so you do not need to
touch the enter key at all.

Note:If you remove use_first_pass from the pam_unix.so line, you can
just use your YubiKey first, then it will prompt for your password after
the YubiKey line.

> Explanation

This works because the prompt is pam_yubico.so's one, since this module
is before pam_unix.so, which does basic password authentication. So, you
are giving a string that is the concatenation of your password and the
OTP to pam_yubico.so. Since the OTPs have a fixed length (let us call
this size N), it just has to get the last N characters to retrieve the
OTP, and it assumes that the other characters at the start are the
password. It tries to validate the OTP, and in case of success, sends
the password to the next PAM module, pam_unix.so, which was instructed
not to prompt for the password, but to receive it from the previous
module, with use_first_pass.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Yubikey&oldid=207071"

Category:

-   Security
