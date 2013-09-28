MiniDLNA
========

MiniDLNA is server software with the aim of being fully compliant with
DLNA/UPnP clients. The MiniDNLA daemon serves media files (music,
pictures, and video) to clients on a network. Example clients include
applications such as totem and xbmc, and devices such as portable media
players, Smartphones, Televisions, and gaming systems (such as PS3 and
Xbox 360).

MiniDLNA (ReadyDLNA) is a simple, lightweight alternative to MediaTomb,
but has fewer features. It does not have a web interface for
administration and must be configured by editing a text file.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Global                                                       |
|         -   2.1.1 Service                                                |
|                                                                          |
|     -   2.2 Local                                                        |
|         -   2.2.1 Automatic Media_DB Update                              |
|                                                                          |
| -   3 Other aspects                                                      |
|     -   3.1 Firewall                                                     |
|     -   3.2 File System and Localization                                 |
|     -   3.3 Media Handling                                               |
+--------------------------------------------------------------------------+

Installation
------------

Install minidlna from the official repositories.

Configuration
-------------

The MiniDLNA daemon can be run as either a global
(config:/etc/minidlna.conf) or per-user instance (config:user-defined),
these are the necessary common settings:

    #network_interface=eth0                         # Self-discovers if commented (at times necessary to set)
    media_dir=A,/home/user/Music                    # Mounted Media_Collection drive directories
    media_dir=P,/home/user/Pictures                 # Use A, P, and V to restrict media 'type' in directory
    media_dir=V,/home/user/Videos
    friendly_name=Media Server                      # Optional
    db_dir=/var/cache/minidlna                      # MiniDLNA Media_DB dir needs to be un-commented
    log_dir=/var/log                                # Log dir needs to be un-commented
    inotify=yes                                     # 'no' for less resources, restart required for new media
    presentation_url=http://www.mylan/index.php     # or use your device static IP http://192.168.0.14:8200/

> Global

MiniDLNA scans your Media_Collection at startup and creates or updates
database Media_DB browsable via media players. Set database cache and
logging dirs in config, so the db and album art cache won't be
re-created on every restart. By default MiniDLNA runs as nobody user
without shell access as set in /etc/conf.d/minidlna, unless you set your
own. That user needs rw permissions to cache and log directories you
specified in conf. Create the required directories and chown them to
nobody:nobody.

    # mkdir /var/{cache,log}/minidlna
    # chown nobody:nobody /var/{cache,log}/minidlna

If you change MiniDLNA user, you can login as that user and create a
symbolic link in the default Media_DB directory to a mounted in the
system external Media_Collection drive, just make sure to set the user's
rw permissions and other mount options for the drive in fstab if present
at boot, or udev automount rules if attached after boot:

    # ln -s /media/MyDrive/Media_DB /var/cache/minidlna

Service

The minidlna service can be managed by the minidlna daemon.

> Local

Create the necessary files and directories locally and edit the
configuration:

    # install -Dm644 /etc/minidlna.conf ~/.config/minidlna/minidlna.conf
    # $EDITOR minidlna.conf

Configuring should be as above, specifically:

    media_dir=/home/$USER/dir
    db_dir=/home/$USER/.config/minidlna/cache
    log_dir=/home/$USER/.config/minidlna

A local daemon script to stop, start... MiniDLNA is available in the AUR
(minidlnad) along with an autostart .desktop file. To run:

    # minidlnad
     minidlnad [start|stop|restart|rescan] - actions for the MiniDLNA daemon

Alternatively you can autostart by adding in your .bash_profile :

    minidlna -f /home/$USER/.config/minidlna/minidlna.conf -P /home/$USER/.config/minidlna/minidlna.pid

  

Automatic Media_DB Update

Kernel adds one inotify watch per each folder/subfolder in
Media_Collection Directories set in /etc/minidlna.conf to monitor
changes thus allowing MiniDLNA to update Media_DB in real time. When
MiniDLNA is run as a regular user, it does not have the ability to
change the kernel's inotify limits. If default number of inotify watches
is non-sufficient to have MiniDLNA monitor all your media folders,
increase inotify watches through sysctl (100000 should be enough for
most uses):

    # sudo sysctl fs.inotify.max_user_watches=100000

To have it permanently changed, add to /etc/sysctl.conf

    # Increase inotify max watchs per user for local minidlna
    fs.inotify.max_user_watches = 100000

inotify performance may depend on device type. Some don't rescan media
drives on a consistent basis or at all. If files are added/deleted to
monitored media directories, they may not be noticed until the device
DLNA client is restarted.

Check inotify updates via MiniDLNA presentation_url by comparing files
count. If it doesn't change, make sure the user running MiniDLNA has rw
access to the DB folder. If the issue persists, copy or download new
files first to a non-watched by inotify Downloads folder on the same
drive, and then move them to appropriate media folders, since lengthy
media files copying or downloading may confuse inotify.

You can also clean or rebuild MiniDLNA DB manually after stopping
MiniDLNA daemon, or analyze its debug output (Ctrl+C to exit):

Stop the MiniDLNA daemon:

    # systemctl stop minidlna

To rebuild Media_DB forcibly:

    $ sudo -u nobody minidlna -R

Stop the daemon after rebuilding Media_DB e.g. killall minidlna.

To run in debug mode:

    $ sudo -u nobody minidlna -d

Ctrl+C to exit it.

Other aspects
-------------

Other aspects and MiniDLNA limitations may need to be considered
beforehand to ensure satisfaction from its performance.

> Firewall

If using a firewall the the ssdp (1900/udp) and trivnet1 (8200/tcp)
ports will need to be opened. For example, this can be done with arno's
iptables firewall by editing firewall.conf and opening the ports by
doing:

    OPEN_TCP="8200"
    OPEN_UDP="1900"

> File System and Localization

When keeping MiniDLNA Media_DB on an external drive accessible in both
Linux and Windows, choose proper file system for it. NTFS preserves in
Windows its Linux defaults: rw access for root user and UTF8 font
encoding for file names, so media titles in your language are readable
when browsing Media_DB in terminal and media players, since most support
UTF8. If you prefer Vfat (FAT32) for better USB drive compatibility with
older players when hooked directly, or your Media_Collection drive is
Vfat and has folder & file names in your local language, MiniDLNA can
transcode them to UTF8 charset while scanning folders to Media_DB. Add
to Media_Collection and Media_DB drives' mount options your FS language
codepage for transcoding to short DOS file names, and iocharset for
converting long file names to your terminal's locale, i.g.
codepage=cp866,iocharset=utf8 (or ISO-8859-5). Set rw permissions for
all users, since Vfat doesn't preserve Linux access permissions:

    UUID=6140-75F7 /media/MyDrive/Media_DB vfat user,rw,async,noatime,umask=111,dmask=000,codepage=cp866,iocharset=utf8 0 0

While your iocharset would be present in the system with a matching
locale, if your terminal or player supports only short file names, check
if the set codepage is also present and enabled (like ru_RU.CP866), i.e.
was included in system config when ArchLinux release was compiled, or
consider recompiling the release to add it:

    ls /usr/share/fonts/encodings

MiniDLNA lists Movies and Photos by file name in its DB, and Music
entries by ID3 tags instead of file names. If Music collection wasn't
tagged in UTF8 but in a local charset, MiniDLNA might not identify and
transcode it correctly to UTF8 for display in media players, or the
original tags codepage(s) may be absent in your system, so the tags
won't be readable even when media file names are. In this case consider
re-tagging your collection to UTF-16BE or UTF-8 encoding with an ID3 Tag
Converter.

Picking the "right" file system for your Media_Collection is a
trade-off: XFS and EXT4 show fast read/write for HDs and lower CPU load
critical for small Plug Computers with attached storage. NTFS is most
compatible with Windows when plugging a drive directly for faster copy,
while network file systems like Samba, NFS or iSCSI allow import to
Windows any Linux FS with slower data copy. As file fragmentation
affects playback, store your Movies on a non-system drive formatted in
XFS (prevents fragments), NTFS (fragment resistant and easy to defrag),
or EXT4 (uses large file extents), and avoid EXT3 or less resistant
FAT32. For smaller Flash drives with seldom fragmented Music and Photo
files, VFAT (FAT32) and EXT4 show faster writes with less CPU load, but
EXT4 may affect memory wear due to journaling, and less compatible with
media players. Proper drive partitioning, block alignment and mount
options (i.e. async,noatime...- choice depends on file system and memory
type) can greatly accelerate flash and HD drive speed among other
advantages.

> Media Handling

MiniDLNA is aimed for small devices, so doesn't generate movie
thumbnails to lower CPU load and DB built time. It uses either thumbs in
the same folder with movie if any, or extracts them where present from
media containers like MP4 or MKV with embedded Album Art tags, but not
AVI. One can add thumbs (JPG 160x160 pxl or less) to media folders with
a Thumbnail Maker, and miniDLNA will link them to media files after
rescan. Larger thumbs will be resized and stored in Media_DB that slows
scan. At one movie per folder, follow thumb naming rules in
minidlna.conf. For multiple show episodes per folder, each thumb name
should match its episode name without ext. (<file>.cover.jpg or
<file>.jpg). To handle MS Album Art thumb names with GUID, add * to the
end "AlbumArt_{*".jpg . MiniDLNA will list on screen only chosen media
type (i.e. Movies), but won't other files in the same folder.

When viewing photos, progressive and/or lossless compression JPG may not
be supported by your player via DLNA. Also resize photos to "suggested
photo size" by the player's docs for problem free image slideshow. DLNA
spec restricts image type to JPG or PNG, and max size to 4096 x 4096
pixels - and that's if the DLNA server implementation supports the LARGE
format. The next size limit down (MEDIUM) is 1024 x 768, so resizing may
help to show photos correctly.

To decrease system load, MiniDLNA doesn't transcode on the fly
unsupported media files into supported by your player formats. When
building Media_DB, it might not correctly identify whether certain
formats are supported by your player, which may play via UPnP a broader
formats choice. DLNA standard is quite limiting UPnP subset in media
containers and codec profiles allowed. If you don't see on TV screen or
can't play some media files listed in Media_DB, check if your HD started
spinning or try connecting to your media player via USB for their
playback. MiniDLNA might not support choosing audio tracks, subtitles,
disk chapters, list sorting, and other advanced playback features for
your player model.

Retrieved from
"https://wiki.archlinux.org/index.php?title=MiniDLNA&oldid=252761"

Category:

-   Audio/Video
