Bitmessage
==========

From the Bitmessage wiki:

"Bitmessage is a P2P communications protocol used to send encrypted
messages to another person or to many subscribers. It is decentralized
and trustless, meaning that you need-not inherently trust any entities
like root certificate authorities. It uses strong authentication which
means that the sender of a message cannot be spoofed, and it aims to
hide "non-content" data, like the sender and receiver of messages, from
passive eavesdroppers like those running warrantless wiretapping
programs."

Bitmessage may be used independently or with TOR. Using it with TOR has
additional security benefits.

Contents
--------

-   1 Installation
-   2 Set up
    -   2.1 Without TOR
    -   2.2 With TOR
-   3 Usage
    -   3.1 Testing
    -   3.2 Attachments
    -   3.3 Using bitmessage with Thunderbird
    -   3.4 Chans
-   4 Additional resources

Installation
------------

Install pybitmessage or pybitmessage-gitfrom the AUR. In order to use it
with TOR, install tor from the official repositories. If you wish to use
bitmessage with Thunderbird, install bmwrapper-git from the AUR. For
using the given python script to create magnet links, install the
package python2-bencode.

Set up
------

> Without TOR

After launching bitmessage (the name of the bitmessage binary is
pybitmessage) for the first time, disregard any popups and:

-   Navigate to the Your Identities tab
-   Hit the New button and create a few new addresses. Since bitmessage
    is built to be used with different (ideally disposable) addresses,
    feel free to create more than one address (for instance this user
    created four addresses)
-   You can use either a passphrase or a random number as the basis for
    the generation of your address. A random number is better for
    security and a passphrase is better for convenience (you can
    recreate your identity more easily with a passphrase than with a
    random number)
-   Remember the address version number and the stream number. These
    will be useful if you need to re-make your address for any reason

> With TOR

The same steps apply as above, except that you would need to do the
following (ideally before you set up your first identity):

-   Navigate to Settings > Network Settings and select SOCKS5 from the
    Type drop down under the Proxy server / Tor section
-   Next to Server hostname enter "localhost" and next to Port enter
    "9050" (If using the TOR browser bundle enter "9150")
-   Restart bitmessage

Usage
-----

> Testing

Using bitmessage is the same as using an email client. The addresses you
have are, however, in Bitmessage format. To test if bitmessage is
working properly for you or not, you can send a test message to
BM-orkCbppXWSqPpAxnz6jnfTZ2djb5pJKDb. This is an echo server and will
send your message back to you if you have configured everything
correctly.

> Attachments

Attachments are not possible for the moment in bitmessage. There are two
ways around it. One is to convert your files using base64 and
concatenating them to the end of your bitmessage itself.

    base64 < binary.file > text.file

The concatenated text can be copied to a text file by the recipient and
the following command can be used to reconvert the file back to its
original state:

    base64 -d < text.file > binary.file

This method, however, is neither in the interests of bitmessage (as it
increases the length of the message unnaturally) nor is it very elegant.
Hence it is advised to upload your file to a cloud-based storage
provider (ala dropbox or box) and send the link over using bitmessage.
Of course, if the file contains anything sensitive, it may be a good
idea to use PGP or some other program to encrypt your file. You can send
the passphrase used to encrypt the file over bitmessage.

An extreme method, especially if you wish to wish larger files, is to
create a magnet link or a torrent file and use that to share your data.
You need not list the torrent on a public torrent site for this to work.
To use this method, first create the torrent with all the files you wish
to share using your favorite torrent application. You can now share this
torrent file using the base64 method described above, or you can use the
following script to convert it into a magnet (source blogpost):

    ~/.scripts/createMagnetLink.py

    !/usr/bin/python2

    import sys
    import urllib
    import bencode
    import hashlib
    import base64

    if len(sys.argv) == 0:
    print("Usage: file")
    exit()

    torrent = open(sys.argv[1], 'r').read()
    metadata = bencode.bdecode(torrent)

    hashcontents = bencode.bencode(metadata['info'])
    digest = hashlib.sha1(hashcontents).digest()
    b32hash = base64.b32encode(digest)

    params = {'xt': 'urn:btih:%s' % b32hash,
    'dn': metadata['info']['name']}

    announcestr = ''
    for announce in metadata['announce-list']:
    announcestr += '&' + urllib.urlencode({'tr':announce[0]})

    paramstr = urllib.urlencode(params) + announcestr
    magneturi = 'magnet:?%s' % paramstr

    print(magneturi)

You need to have python2-bencode installed in order to make this script
work. The magnet link can be shared with the intended recipient without
using base64.

> Using bitmessage with Thunderbird

After setting up bitmessage normally, add the following to your
~/.config/PyBitmessage/keys.dat file:

    ~/.config/PyBitmessage/keys.dat

    apienabled = true
    apiport = 8442
    apiinterface = 127.0.0.1
    apiusername = <any user name> 
    apipassword = <any password>

You will need the bmwrapper package from the AUR. At the time of this
writing, it will automatically mean that you are on the git version of
bitmessage. Run bmwrapper from the terminal. The script operates by
running a POP server on localhost:12344, and an SMTP server on
localhost:12345.

When you set up Thunderbird to use your bitmessage address, you will
need to use the following settings:

-   Username: <whatever you set in your keys.dat file earlier>
-   Password: <whatever you set in your keys.dat file earlier>
-   Email: <your-bitmail-address@bm.addr>
-   Incoming mail server: POP, localhost:12344 with normal password. Do
    not use SSL
-   Outgoing mail server: SMTP, localhost:12345 with no password. Do not
    use SSL

> Chans

According to the bitmessage wiki:

A Mailing List without the requirement of a central "authority".
Sometimes called Chan (short for channel) because they usually focus on
a subject which also is the password for the deterministic address too.

A Chan (or a Distributed Mailing List) can be joined or created by
hitting "Join/Create Chan" in the file menu. A Passphrase must be
entered and the address is generated for creating a can. To join a Chan,
you must enter its address and a passphrase (of your choice).

Additional resources
--------------------

-   The Bitmessage Home Page
-   BMWrapper github page
-   The Bitmessage forum

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bitmessage&oldid=306112"

Category:

-   Networking

-   This page was last modified on 20 March 2014, at 17:42.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
