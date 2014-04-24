BluRay
======

Related articles

-   Optical Disc Drive

  ------------------------ ------------------------ ------------------------
  [Tango-go-next.png]      This article or section  [Tango-go-next.png]
                           is a candidate for       
                           moving to Blu-ray.       
                           Notes: The official      
                           spelling is "Blu-ray",   
                           not "BluRay".[1][2]      
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This article is designed to help Linux users to play the BluRay discs
they have legally purchased on their computers. Since no official BluRay
player software is available on their system, Linux users have to use
open-source libraries capable of handling the DRM schemes that protect
these disc contents. This is legal in most countries where
interoperability allows this.

Contents
--------

-   1 How it works
    -   1.1 BluRay DRM
        -   1.1.1 AACS
            -   1.1.1.1 AACS decryption process
        -   1.1.2 BD+
    -   1.2 Summary
-   2 Playback
    -   2.1 Preparation
        -   2.1.1 Method 1 (PK and Host K/C)
        -   2.1.2 Method 2 (VUK)
    -   2.2 Media Players
        -   2.2.1 mplayer
            -   2.2.1.1 Stuttering Video
            -   2.2.1.2 Incorrect Audio Language
            -   2.2.1.3 Out of Sync Audio
        -   2.2.2 vlc
        -   2.2.3 xine
    -   2.3 Troubleshooting
        -   2.3.1 Absent KEYDB.cfg file
        -   2.3.2 Revoked Host key/certificate
        -   2.3.3 Using aacskeys
            -   2.3.3.1 If aacskeys is not able to generate the key
-   3 Other Useful Software

How it works
------------

> BluRay DRM

Contrary to the DVD CSS, which was definitely compromised once the
unique encryption key had been discovered, BluRay uses stronger DRM
mechanisms, which makes it a lot more difficult to manage. Firstly, the
AACS standard uses a lot more complicated cryptographic process to
protect the disc content, but also allows the industry to revoke
compromised keys and distribute new keys through new BR discs. Secondly,
BluRay may also use another layer of protection: BD+. Although most of
commercial discs use AACS, a few of them additionally use BD+. In 2007,
the AACS system was compromised and decryption keys were published on
the Internet. Many decryption programs were made available, but the
interest to Linux users was the capability of playing their discs -
legally purchased - on their computers. Although the industry was able
to revoke the first leaked decryption keys, new keys are regularly
published in a cat and mouse play.

AACS

The AACS specification and decryption process are publicly available at
[3]. Many articles and research papers describe it in detail at [4], [5]
or [6]. libaacs is a research project from the VideoLAN developer team
to implement the Advanced Access Content System specification, and
distributed as an open-source library [7]. This project does not offer
any key or certificate that could be used to decode encrypted
copyrighted material. However, combined with a key database file, it is
possible to use it to play BluRay discs that use the AACS standard. This
file is called KEYDB.cfg and is accessed by libaacs in ~/.config/aacs.
The format of this file is available at [8].

AACS decryption process

The AACS decryption process for a protected disc by a licensed player
goes through four stages:

1.  The software/embedded player's Device Keys, together with the disc's
    Media Key Block (MKB) data are used to retrieve a "Processing Key",
    and with that (plus another datum from the MKB) to compute the Media
    Key.
2.  That Media Key, together with the disc's Volume ID (VID) obtained by
    the player presenting a valid Host Certificate to the drive is used
    to compute the Volume Unique Key (VUK).
3.  This VUK is used to unscramble the disc's scrambled Title Keys.
4.  Finally those Title Keys unscramble the disc's protected media
    content.

Note that it is the disc that contains the MKB. MKB have been renewed
since the first commercial BluRay release in 2006. The latest MKB is
version 30, but many MKB actually share the same key. The software
player provides the Host key and certificate, whereas the drive contains
a list of the Host key/certificates that have been revoked.

Using libaacs, the decryption process can skip some of these stages to
reach the last step, which allows the media player to play the disc.
This is either by providing in the KEYDB.cfg file either (or both):

-   a valid (corresponding to the MKB version of the disc) Processing
    key and a valid (i.e. non revoked by the drive) Host key/certificate
-   a valid VUK for the specific disc.

If libaacs finds a valid processing key for the disc MKB version as well
as a valid Host key and certificates, it can start the decryption
process from step 2. However, the Host key/certificates are regularly
revoked through the propagation of new BluRay discs. Once revoked, a
drive is not able to read both new and older discs. This is usually
irreversible and can only be fixed by providing a more recent Host
key/certificate (for Windows users, this corresponds to updating their
software player). The advantage of this method is that until the Host
key/certificate is revoked, and as long as the disc uses an MKB version
for which the Processing key is known, libaacs is able to compute the
VUK of any disc. As of today, the Processing keys for MKB versions 1 to
28 have been computed and made available on the Internet.

Thankfully, in case no valid Processing key is available and/or the Host
certificate has been revoked, libaacs has an alternative way to decrypt
a disc: by providing a valid VUK in the KEYDB.cfg file. This allows
libaacs to skip directly to step 3. Contrary to the Processing keys,
VUKs are disc specific. Therefore this is less efficient as the user
will have to get the VUK from a third party. But the great advantage is
that VUKs cannot be revoked. Note that if libaacs is able to perform
step 2 (with a valid Host key/certificate), then it stores the VUK
calculated in step 3 in ~/.cache/aacs/vuk. At subsequent viewings of the
same disc, libaacs can reuse the stored VUK. Thus it may be a good idea
to backup these VUKs.

BD+

In December 2013, VideoLAN released the long awaited libbdplus which
provides experimental support for BD+ decryption.

> Summary

1. The user starts playing a BluRay with a video player having libbluray
and libaacs support.

2. If the BR disc is not scrambled with AACS, go to 4a.

3. If the BR disc is scrambled with AACS, libaacs will:

3.1. Check if a valid VUK for the disc is already available in
~/.cache/aacs/vuk/. If yes, go to step 4a, if not continue to next step.

3.2. Read ~/.config/aacs/KEYDB.cfg:

3.2.1. If a valid VUK is available, go to 4a, if not continue to next
step.

3.2.2. If a valid Processing key (i.e. corresponding to the disc MKB
version) and a valid (non-revoked by drive) Host key/certificate is
available, libaacs will compute the VUK. The VUK is stored in
~/.cache/aacs/vuk for future use. Go to step 4a.

3.3 If no valid key is available, go to step 4b.

4a. The software player is able to play the disc content.

4b. The software player fails to read the disc content.

Playback
--------

> Preparation

Firstly install libbluray and libaacs from the official repositories.
Then try method 1, and if this does not work, try method 2. The two
methods are not exclusive, you can use both methods in the same
KEYDB.cfg file.

Method 1 (PK and Host K/C)

Download http://vlc-bluray.whoknowsmy.name/files/KEYDB.cfg (contains no
VUKs, but contains Processing keys and a Host key/certificate up to MKB
v28 that is revoked in MKB v30 discs) in ~/.config/aacs/. This method
will only work if your drive has not revoked the host key/certificate
that is in this KEYDB.cfg file.

    cd ~/.config/aacs/ && wget http://vlc-bluray.whoknowsmy.name/files/KEYDB.cfg

Next, mount the bluray to a directory. eg:

    # mount /dev/sr0 /media/blurays

When you play the disc (using mplayer or vlc), libaacs will store the
VUK in ~/.cache/aacs/vuk. The filename is the disc ID and its content is
the VUK itself. VLC will reuse this VUK even if it does not find a valid
KEYDB.cfg file, so it could be a good idea to backup this directory for
the future.

Method 2 (VUK)

If bluray playback with the hcert mentioned above does not work,
download a list of VUKs from
http://forum.doom9.org/attachment.php?attachmentid=11170&d=1276615904 or
(newer) http://forum.doom9.org/showthread.php?p=1525922#post1525922. You
will need to create 2 files in the directory ~/.config/aacs.
Unfortunately, both are distributed with the name 'KEYDB'. Fortunately,
the VUK file is usually named KEYDB.txt on doom9's forums. The
'KEYDB.cfg' file can be downloaded to this directory as-is. The
'KEYDB.txt' file should be renamed 'vuk' - with no file extension.
Attempting to insert the VUK entries into the KEYDB.cfg file will
invalidate the file. Note that the VUK entry format has changed since
the early libaacs versions. All keys must start with 0x. This command
will automatically reformat the keys:

    sed -i 's/\([[:xdigit:]]\)\{5,\}/0x&/g' ~/.config/aacs/vuk

Next, mount the bluray to a directory. eg:

    # mount /dev/sr0 /media/blurays

> Media Players

These are media players capable of using libbluray and libaacs to play
AACS-scrambled BluRay discs.

mplayer

To play blurays in mplayer the basic playback command is:

    mplayer br:///</bluray/mount/dir>

or:

    mplayer br://<title number> -bluray-device </bluray/mount/dir>

Stuttering Video

It is likely that you will need to enable hardware acceleration and
multi core CPU support for the bluray to play smoothly.

For nvidia cards, enable hardware acceleration by installing libvdpau
and using the option '-vo vdpau' with mplayer. eg:

    mplayer -vo vdpau br:///</bluray/mount/dir>

For multi core CPU support use the options '-lavdopts threads=N', where
'N' is the number of cores. eg:

    mplayer -lavdopts threads=2 br:///</bluray/mount/dir>

Incorrect Audio Language

You can scroll through the playback languages using the '#' key.

Out of Sync Audio

From your first mplayer output, you must find the codec used for the
bluray. It will be at the end of the line "Selected video codec".

For H.264 discs use the option '-vc ffh264vdpau'. eg:

    mplayer -vc ffh264vdpau br:///</bluray/mount/dir>

For VC-1 discs use '-vc ffvc1vdpau'. eg:

    mplayer -vc ffvc1vdpau br:///</bluray/mount/dir>

For MPEG discs use '-vc ffmpeg12vdpau'. eg:

    mplayer -vc ffmpeg12vdpau br:///</bluray/mount/dir>

vlc

Since version 2.0.0, vlc has had experimental bluray playback support.
Bluray menus are not yet working (however, this is improving ; you may
try using libbluray-git instead of libbluray).

Start playback with:

    vlc bluray://</bluray/mount/dir>

xine

Start playback with:

    xine bluray://</bluray/mount/dir>

> Troubleshooting

Absent KEYDB.cfg file

If a valid VUK is found in ~/.cache/aacs/vuk, then libaacs does not need
to use KEYDB.cfg to decrypt the content. However, a KEYDB.cfg file in
~/.config/aacs/ is still required (even if that file is empty).

Revoked Host key/certificate

Unfortunately, what may happen when trying to play a newer BluRay disc
is the revocation of host key/certificates (which are keys of licensed
software players) by your drive. When this happens, aacskeys will return
this message:

     The given Host Certficate / Private Key has been revoked by your drive.

This is part of the AACS protection scheme: editors are able to revoke
old software player host keys that have leaked on the Internet and
distribute the lists on newer commercial disc releases. This is
irreversible and does cannot be fixed even after reflashing the drive.
The only two ways to correct this would be:

-   to update the host key/certificate part in KEYDB.cfg to ones that
    have not been revoked (yet)
-   to add in KEYDB.cfg the VUK of each specific disc instead, as
    explained above. VUKs cannot be revoked by the industry.

When a disc (using mplayer or vlc) is succesfully decrypted, libaacs
will store the VUK in ~/.cache/aacs/vuk. If the host key/certificate in
KEYDB.cfg is subsequently revoked, VLC will still be able to use the
stored VUK, so it could be a good idea to backup the ~/.cache/aacs
directory for the future.

Using aacskeys

Install aacskeys. You need to run aacskeys from a directory that
contains valid host key/certificate and processing keys:

    cd /usr/share/aacskeys

and run:

    aacskeys </bluray/mount/dir>

eg:

    cd /usr/share/aacskeys && aacskeys /media/blurays

If you wish, you may add the BR to the key database: edit
~/.config/aacs/KEYDB.cfg and add the information output by aacskeys
using this syntax:

    0x<unit key file hash> = Film Title    | V | 0x<volume unique key>

If aacskeys is not able to generate the key

Try to generate the VolumeID with DumpVID using wine. The VolumeID can
now be used to generate the bluray key with aacskeys with the VolumeID
option

    Usage: aacskeys [options] <mountpath> [volume id / binding nonce]

Other Useful Software
---------------------

For DVD, the libdvdcss package supplies the needed decryption libs.
Below are some options for BluRay/HD-DVD decryption. Users can employ to
backup a commercial BluRay movie under Fair Use guidelines:

-   aacskeys - Opensource
-   dumphd - Opensource
-   makemkv - Closed source/limited free beta

-   anydvdhd - Commercial software requiring users to run it on an
    Microsoft OS in a VM.

Retrieved from
"https://wiki.archlinux.org/index.php?title=BluRay&oldid=303393"

Categories:

-   Audio/Video
-   Optical

-   This page was last modified on 6 March 2014, at 17:13.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
