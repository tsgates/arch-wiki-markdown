SHA password hashes
===================

Note:With shadow 4.1.4.3-3 sha512 is the default for new passwords (see
bug 13591 and corresponding commit).

If your current password was created with shadow version prior to
4.1.4.3-3 (2011-11-26) you are using MD5. To start using a SHA-512 hash
you just need to change your password with passwd.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Benefits of SHA-2 over MD5                                         |
| -   2 Increasing Security                                                |
| -   3 Re-Hash the Passwords                                              |
| -   4 Known Problems                                                     |
|     -   4.1 fgetty                                                       |
+--------------------------------------------------------------------------+

Benefits of SHA-2 over MD5
--------------------------

In Linux distributions login passwords are commonly hashed and stored in
the /etc/shadow file using the MD5 algorithm. The security of the MD5
hash function has been severely compromised by collision
vulnerabilities. This does not mean MD5 is insecure for password hashing
but in the interest of decreasing vulnerabilities a more secure and
robust algorithm that has no known weaknesses (e.g. SHA-512) is
recommended.

The following tutorial uses the SHA-512 hash function, which has been
recommended by the United States' National Security Agency (NSA) for Red
Hat Enterprise Linux 5. Alternatively, SHA-2 consists of four additional
hash functions with digests that are 224, 256, 384, and 512 bits.

Increasing Security
-------------------

Note:You must have root privileges to edit this file.

The rounds=N option helps to improve key strengthening. The number of
rounds has a larger impact on security than the selection of a hash
function. For example, rounds=65536 means that an attacker has to
compute 65536 hashes for each password he tests against the hash in your
/etc/shadow. Therefore the attacker will be delayed by a factor of
65536. This also means that your computer must compute 65536 hashes
every time you log in, but even on slow computers that takes less than 1
second. If you do not use the rounds option, then glibc will default to
5000 rounds for SHA-512. Additionally, the default value for the rounds
option can be found in sha512-crypt.c.

Open /etc/pam.d/passwd with a text editor and add the rounds option at
the end of of the uncommented line. After applying this change the line
should look like this:

    password	required	pam_unix.so sha512 shadow nullok rounds=65536

Note:For a more detailed explanation of the /etc/pam.d/passwd password
options check the PAM man page.

Re-Hash the Passwords
---------------------

Even though you have changed the encryption settings, your passwords are
not automatically re-hashed. To fix this, you must reset all user
passwords so that they can be re-hashed.

As root issue the following the command,

    # passwd <username>

where <username> is the name of the user whose password you are
changing. Then re-enter their current password, and it will be re-hashed
using the SHA-2 function.

To verify that your passwords have been re-hashed, check the /etc/shadow
file as root. Passwords hashed with SHA-256 should begin with a $5 and
passwords hashed with SHA-512 will begin with $6.

Known Problems
--------------

> fgetty

Arch Linux is using SHA-512 password hashing by default (since
2011-11-26). The very minimal terminal manager fgetty does not support
SHA-512 password hashing by default. Enabling SHA-512 with the default
fgetty will cause you to be locked out. A patched version of fgetty is
in the AUR named fgetty-pam which adds SHA-512 support.

Retrieved from
"https://wiki.archlinux.org/index.php?title=SHA_password_hashes&oldid=238790"

Category:

-   Security
