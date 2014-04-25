rTorrent
========

rTorrent is a quick and efficient BitTorrent client that uses the
libtorrent library. It is written in C++ and uses the ncurses
programming library, which means it uses a text user interface. When
combined with GNU Screen and Secure Shell, it becomes a convenient
remote BitTorrent client.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Performance
    -   2.2 Create and manage files
    -   2.3 Port configuration
    -   2.4 Additional settings
-   3 Key bindings
    -   3.1 Redundant mapping
-   4 Additional tips
    -   4.1 systemd service file with tmux
    -   4.2 Pre-allocation
    -   4.3 Manage completed files
        -   4.3.1 Notification with Google Mail
    -   4.4 Displaying active torrents
    -   4.5 Manually adding trackers to torrents
-   5 Troubleshooting
    -   5.1 CA certificates
    -   5.2 Locked directories
    -   5.3 Event failed: bad return code
-   6 Web interface
    -   6.1 XMLRPC interface
    -   6.2 Saving magnet links as torrent files in watch folder
-   7 rtorrent-pyro
    -   7.1 PyroScope
-   8 See also

Installation
------------

Install the rtorrent package that is available in the official
repositories.

Alternatively, install rtorrent-git or rtorrent-extended from the AUR.

Configuration
-------------

Note:See the rTorrent wiki article on this subject for more information:
Common Tasks in rTorrent for Dummies.

Before running rTorrent, find the example configuration file
/usr/share/doc/rtorrent/rtorrent.rc and copy it to ~/.rtorrent.rc:

    $ cp /usr/share/doc/rtorrent/rtorrent.rc ~/.rtorrent.rc

> Performance

Note:See the rTorrent wiki article on this subject for more information:
Performance Tuning

The values for the following options are dependent on the system's
hardware and Internet connection speed. To find the optimal values read:
Optimize Your BitTorrent Download Speed

    min_peers = 40
    max_peers = 52

    min_peers_seed = 10
    max_peers_seed = 52

    max_uploads = 8

    download_rate = 200
    upload_rate = 28

The check_hash option executes a hash check when a torrent download is
complete or rTorrent is started. When starting, it checks for errors in
your completed files.

    check_hash = yes

> Create and manage files

The directory option will determine where your torrent data will be
saved. Be sure to enter the absolute path, as rTorrent may not follow
relative paths:

    directory = /home/[user]/torrents/

The session option allows rTorrent to save the progess of your torrents.
It is recommended to create a directory called .session (e.g.
mkdir ~/.session).

    session = /home/user/.session/

The schedule option has rTorrent watch a particular directory for new
torrent files. Saving a torrent file to this directory will
automatically start the download. Remember to create the directory that
will be watched (e.g. mkdir ~/watch). Also, be careful when using this
option as rTorrent will move the torrent file to your session folder and
rename it to its hash value.

    schedule = watch_directory,5,5,load_start=/home/user/watch/*.torrent
    schedule = untied_directory,5,5,stop_untied=
    schedule = tied_directory,5,5,start_tied=

The following schedule option is intended to stop rTorrent from
downloading data when disk space is low.

    schedule = low_diskspace,5,60,close_low_diskspace=100M

> Port configuration

The port_range option sets which port(s) to use for listening. It is
recommended to use a port that is higher than 49152 (see: List of port
numbers). Although, rTorrent allows a range of ports, a single port is
recommended.

    port_range = 49164-49164

Additionally, make sure port forwarding is enabled for the proper
port(s) (see: Port Forward guides).

> Additional settings

The encryption option enables or disables encryption. It is very
important to enable this option, not only for yourself, but also for
your peers in the torrent swarm. Some users need to obscure their
bandwidth usage from their ISP. And it does not hurt to enable it even
if you do not need the added security.

    encryption = allow_incoming,try_outgoing,enable_retry

It is also possible to force all connections to use encryption. However,
be aware that this stricter rule will reduce your client's availability:

    encryption = require,require_RC4,allow_incoming,try_outgoing,enable_retry

See the Wikipedia article on this subject for more information:
BitTorrent Protocol Encryption

This final dht option enables DHT support. DHT is common among public
trackers and will allow the client to acquire more peers.

    dht = auto
    dht_port = 6881
    peer_exchange = yes

Note:See the rTorrent wiki article on this subject for more information:
Using DHT

Key bindings
------------

rTorrent relies exclusively on keyboard shortcuts for user input. A
quick reference is available in the table below. A complete guide is
available on the rTorrent wiki (see: rTorrent User Guide).

Note:Striking Ctrl-q twice in quick succession will make rTorrent
shutdown without waiting to send a stop announce to the connected
trackers.

  Cmd                Action
  ------------------ ----------------------------------------------------------------------
  Ctrl-q             Quit application
  Ctrl-s             Start download. Runs hash first unless already done.
  Ctrl-d             Stop an active download or remove a stopped download
  Ctrl-k             Stop and close the files of an active download.
  Ctrl-r             Initiate hash check of torrent. Without starting to download/upload.
  Left               Returns to the previous screen
  Right              Goes to the next screen
  Backspace/Return   Adds the specified *.torrent
  a|s|d              Increase global upload throttle about 1|5|50 KB/s
  A|S|D              Increase global download throttle about 1|5|50 KB/s
  z|x|c              Decrease global upload throttle about 1|5|50 KB/s
  Z|X|C              Decrease global download throttle about 1|5|50 KB/s

> Redundant mapping

Ctrl-s is often used for terminal control to stop screen output while
Ctrl-q is used to start it. These mappings may interfere with rTorrent.
Check to see if these terminal options are bound to a mapping:

    $ stty -a

    ...
    swtch = <undef>; start = ^Q; stop = ^S; susp = ^Z; rprnt = ^R; werase = ^W; lnext = ^V;
    ...

To remove the mappings, change the terminal characteristics to undefine
the aforementioned special characters (i.e. stop and start):

    # stty stop undef
    # stty start undef

To remove these mappings automatically at startup you may add the two
preceding commands to your ~/.bashrc file.

Additional tips
---------------

> systemd service file with tmux

    /etc/systemd/system/rt@.service

    [Unit]
    Description=rTorrent
    Requires=network.target local-fs.target

    [Service]
    Type=oneshot
    RemainAfterExit=yes
    KillMode=none
    User=%I
    ExecStart=/usr/bin/tmux new-session -s rt -n rtorrent -d rtorrent
    ExecStop=/usr/bin/tmux send-keys -t rt:rtorrent C-q
    WorkingDirectory=/home/%I/

    [Install]
    WantedBy=multi-user.target

Start at boot time:

    # systemctl enable rt@$USER

Start manually:

    # systemctl start rt@$USER

Stop:

    # systemctl stop rt@$USER

Attach to rtorrent's session:

    tmux attach -t rt

Detach:

    Ctrl-b d

> Pre-allocation

The rTorrent package in the community repository lacks pre-allocation.
Compiling rTorrent with pre-allocation allows files to be allocated
before downloading the torrent. The major benefit is that it limits and
avoids fragmentation of the filesystem. However, this introduces a delay
during the pre-allocation if the filesystem does not support the
fallocate syscall natively.

Therefore this switch is recommended for xfs, ext4 and btrfs
filesystems, which have native fallocate syscall support. They will see
no delay during preallocation and no fragmented filesystem.
Pre-allocation on others filesystems will cause a delay but will not
fragment the files.

To make pre-allocation available, recompile libtorrent from the ABS tree
with the following new switch:

     $ ./configure --prefix=/usr --disable-debug --with-posix-fallocate

To enable it, add the following to your ~/rtorrent.rc:

    ~/rtorrent.rc

      # Preallocate files; reduces defragmentation on filesystems.
      system.file_allocate.set = yes

> Manage completed files

> Note:

-   Currently, this part requires either the git version of
    rtorrent/libtorrent or having applied the patch to 0.8.6 that adds
    'equal'.
-   If you're having trouble with this tip, it's probably easier to
    follow this.

It is possible to have rtorrent sort completed torrent data to specific
folders based on which 'watch' folder you drop the *.torrent into while
continuing to seed. Many examples show how to do this with torrents
downloaded by rtorrent. The problem is when you try to drop in 100% done
torrent data and then have rtorrent check the data and resume, it will
not be sorted.

As a solution, use the following example in your ~/.rtorrent.rc. Make
sure to change the paths.

    # location where new torrent data is placed, and where you should place your
    # 'complete' data before you place your *.torrent file into the watch folder
    directory = /home/user/torrents/incomplete

    # schedule a timer event named 'watch_directory_1':
    # 1) triggers 10 seconds after rtorrent starts
    # 2) triggers at 10 second intervals thereafter
    # 3) Upon trigger, attempt to load (and start) new *.torrent files found in /home/user/torrents/watch/
    # 4) set a variable named 'custom1' with the value "/home/user/torrents/complete"
    # NOTE: if you do not want it to automatically start the torrent, change 'load_start' to 'load'
    schedule = watch_directory_1,10,10,"load_start=/home/user/torrents/watch/*.torrent,d.set_custom1=/home/user/torrents/complete"

    # insert a method with the alias 'checkdirs1'
    # 1) returns true if the current path of the torrent data is not equal to the value of custom1
    # 2) otherwise, returns false
    system.method.insert=checkdirs1,simple,"not=\"$equal={d.get_custom1=,d.get_base_path=}\""

    # insert a method with the alias 'movecheck1'
    # 1) returns true if all 3 commands return true ('result of checkdirs1' && 'torrent is 100% done', 'custom1 variable is set')
    # 2) otherwise, returns false
    system.method.insert=movecheck1,simple,"and={checkdirs1=,d.get_complete=,d.get_custom1=}"

    # insert a method with the alias 'movedir1'
    # (a series of commands, separated by ';') 
    # 1) "set path of torrent to equal the value of custom1";
    # 2) "mv -u <current data path> <custom1 path>";
    # 3) "clear custom1", "stop the torrent","resume the torrent"
    # 4) stop the torrent
    # 5) start the torrent (to get the torrent to update the 'base path')
    system.method.insert=movedir1,simple,"d.set_directory=$d.get_custom1=;execute=mv,-u,$d.get_base_path=,$d.get_custom1=;d.set_custom1=;d.stop=;d.start="

    # set a key with the name 'move_hashed1' that is triggered by the hash_done event.
    # 1) When hashing of a torrent completes, this custom key will be triggered.
    # 2) when triggered, execute the 'movecheck1' method and check the return value.
    # 3) if the 'movecheck' method returns 'true', execute the 'movedir1' method we inserted above.
    # NOTE-0: *Only* data that has had their hash checked manually with ^R [^R = Control r].
    # Or on a rtorrent restart[which initiates a hash check]. Will the data move; ~/torrents/incomplete => ~/torrents/complete for example.
    # NOTE-1: 'branch' is an 'if' conditional statement: if(movecheck1){movedir1}
    system.method.set_key=event.download.hash_done,move_hashed1,"branch={$movecheck1=,movedir1=}"

You can add additional watch folders and rules should you like to sort
your torrents into special folders.

For example, if you would like the torrents to download in:

    /home/user/torrents/incomplete

and then sort the torrent data based on which folder you dropped the
*.torrent into:

    /home/user/torrents/watch => /home/user/torrents/complete
    /home/user/torrents/watch/iso => /home/user/torrents/complete/iso
    /home/user/torrents/watch/music => /home/user/torrents/complete/music

You can have the following in your .rtorrent.rc:

    directory = /home/user/torrents/incomplete
    schedule = watch_directory_1,10,10,"load_start=/home/user/torrents/watch/*.torrent,d.set_custom1=/home/user/torrents/complete"

    schedule = watch_directory_2,10,10,"load_start=/home/user/torrents/watch/iso/*.torrent,d.set_custom1=/home/user/torrents/complete/iso"

    schedule = watch_directory_3,10,10,"load_start=/home/user/torrents/watch/music/*.torrent,d.set_custom1=/home/user/torrents/complete/music"

    system.method.insert=checkdirs1,simple,"not=\"$equal={d.get_custom1=,d.get_base_path=}\""
    system.method.insert=movecheck1,simple,"and={checkdirs1=,d.get_complete=,d.get_custom1=}"
    system.method.insert=movedir1,simple,"d.set_directory=$d.get_custom1=;execute=mv,-u,$d.get_base_path=,$d.get_custom1=;d.set_custom1=;d.stop=;d.start="
    system.method.set_key=event.download.hash_done,move_hashed1,"branch={$movecheck1=,movedir1=}"

Also see pyroscope especially the rtcontrol examples. There is an AUR
package.

Notification with Google Mail

Cell phone providers allow you to "email" your phone:

    Verizon: 10digitphonenumber@vtext.com
    AT&T: 10digitphonenumber@txt.att.net
    Former AT&T customers: 10digitphonenumber@mmode.com
    Sprint: 10digitphonenumber@messaging.sprintpcs.com
    T-Mobile: 10digitphonenumber@tmomail.net
    Nextel: 10digitphonenumber@messaging.nextel.com
    Cingular: 10digitphonenumber@cingularme.com
    Virgin Mobile: 10digitphonenumber@vmobl.com
    Alltel: 10digitphonenumber@alltelmessage.com OR
    10digitphonenumber@message.alltel.com
    CellularOne: 10digitphonenumber@mobile.celloneusa.com
    Omnipoint: 10digitphonenumber@omnipointpcs.com
    Qwest: 10digitphonenumber@qwestmp.com
    Telus: 10digitphonenumber@msg.telus.com
    Rogers Wireless: 10digitphonenumber@pcs.rogers.com
    Fido: 10digitphonenumber@fido.ca
    Bell Mobility: 10digitphonenumber@txt.bell.ca
    Koodo Mobile: 10digitphonenumber@msg.koodomobile.com
    MTS: 10digitphonenumber@text.mtsmobility.com
    President's Choice: 10digitphonenumber@txt.bell.ca
    Sasktel: 10digitphonenumber@sms.sasktel.com
    Solo: 10digitphonenumber@txt.bell.ca

-   Install mailx which is provided by the s-nail package that is found
    in the official repositories.

-   Clear the /etc/mail.rc file and enter:

    set sendmail="/usr/bin/mailx"
    set smtp=smtp.gmail.com:587
    set smtp-use-starttls
    set ssl-verify=ignore
    set ssl-auth=login
    set smtp-auth-user=USERNAME@gmail.com
    set smtp-auth-password=PASSWORD

Now to send the text, we must pipe a message to the mailx program.

-   Make a Bash script:

    /path/to/mail.sh

    echo "$@: Done" | mailx 5551234567@vtext.com

Where the $@ is a variable holding all the arguments passed to our
script.

-   And finally, add the important ~/.rtorrent.rc line:

    system.method.set_key = event.download.finished,notify_me,"execute=/path/to/mail.sh,$d.get_name="

Breaking it down:

notify_me is the command id, which may be used by other commands, it can
be just about anything you like, so long as it is unique.

execute= is the rtorrent command, in this case to execute a shell
command.

/path/to/mail.sh is the name of our script (or whatever command you want
to execute) followed by a comma separated list of all the
switches/arguments to be passed.

$d.get_name= 'd' is an alias to whatever download triggered the command,
get_name is a function which returns the name of our download, and the
'$' tells rTorrent to replace the command with its output before it
calls execute.

The end result? When that torrent, 'All Live Nudibranches', that we
started before leaving for work finishes, we will be texted:

    All Live Nudibranches: Done

> Displaying active torrents

The rtorrent doesn't list the active tab properly by default, add this
line to your .rtorrent.rc to show only active torrents

    schedule = filter_active,30,30,"view_filter = active,\"or={d.get_up_rate=,d.get_down_rate=}\""

Then press 9 in your rTorrent client to see the changes in action.

> Manually adding trackers to torrents

1.  Select torrent to edit from rTorrent console view.
2.  Hit Ctrl+x.
3.  If you had four trackers type following lines one at a time (always
    press Ctrl+x first) to add four more for example:

    d.tracker.insert="5","udp://tracker.publicbt.com:80"
    d.tracker.insert="6","udp://tracker.openbittorrent.com:80"
    d.tracker.insert="7","udp://tracker.istole.it:80"
    d.tracker.insert="8","udp://tracker.ccc.de:80"

Troubleshooting
---------------

> CA certificates

To use rTorrent with a tracker that uses HTTPS, do the following as
root:

    # cd /etc/ssl/certs
    # wget --no-check-certificate https://www.geotrust.com/resources/root_certificates/certificates/Equifax_Secure_Global_eBusiness_CA-1.cer
    # mv Equifax_Secure_Global_eBusiness_CA-1.cer Equifax_Secure_Global_eBusiness_CA-1.pem
    # c_rehash

And from now on run rTorrent with:

    $ rtorrent -o http_capath=/etc/ssl/certs

If you use GNU Screen, update the .screenrc configuration file to
reflect this change:

    $ screen -t rtorrent rtorrent -o http_capath=/etc/ssl/certs

In rTorrent 0.8.9, set network.http.ssl_verify_peer.set=0 to fix the
problem.

For more information see: rTorrent Error & CA Certificate and rTorrent
Certificates Problem

> Locked directories

rTorrent can sometimes lock up after a crash or incorrect shutdown, and
will complain about a lock file.

Per the error message, the file called "rtorrent.lock" can be found
within the hidden folder .rtorrentsession for your download directory
and manually removed.

> Event failed: bad return code

This is caused by there being spaces in your system.method.* lines.
Remove the spaces and it will work.

Web interface
-------------

There are numerous web interfaces and front ends for rTorrent including:

-   WTorrent is a web interface to rtorrent programmed in php using
    Smarty templates and XMLRPC for PHP library.
-   nTorrent is a graphical user interface client to rtorrent (a cli
    torrent client) written in Java.
-   rTWi is a simple rTorrent web interface written in PHP.
-   Rtgui is a web based front end for rTorrent written in PHP and uses
    XML-RPC to communicate with the rTorrent client.
-   rutorrent and Forum - A web-based front-end with an interface very
    similar to uTorrent which supports many plugins and advanced
    features (see also: ruTorrent and Guide on forum).

Note:rTorrent is currently built using XML-RPC for C/C++, which is
required for some web interfaces (e.g. ruTorrent).

> XMLRPC interface

If you want to use rtorrent with some web interfaces (e.g. rutorrent)
you need to add the following line to the configuration file:

    scgi_port = localhost:5000

For more information see: Using XMLRPC with rtorrent

> Saving magnet links as torrent files in watch folder

Note: Rtorrent natively supports downloading torrents through magnet
links. At the main view (reached by starting Rtorrent and pressing 1),
press enter. At "load.normal>" paste the magnet link and press enter
again. This will start the download.

If you wish to have magnet links automatically added to your watch
folder, here is a script that will do the trick:

    #!/bin/bash
    watch_folder=~/.rtorrent/watch
    cd $watch_folder
    [[ "$1" =~ xt=urn:btih:([^&/]+) ]] || exit;
    echo "d10:magnet-uri${#1}:${1}e" > "meta-${BASH_REMATCH[1]}.torrent"

(adapted from
http://blog.gonzih.org/blog/2012/02/17/how-to-use-magnet-links-with-rtorrent/).

Save it, for instance as rtorrent-magnet, give it execution permission,
and place it somewhere under your $PATH. Then in Firefox:

1.  Type about:config into the Location Bar (address bar) and press
    Enter.
2.  Right-click: New > Boolean > Name:
    network.protocol-handler.expose.magnet > Value > false.
3.  Next time you click a magnet link you will be asked which
    application to open it with. Select the script we just created and
    you'll be done.

If you want xdg-open to handle this, which you need if you're using
chrome instead of firefox, (though gnome and other DE might have their
own programs overriding xdg-open) you need to patch xdg-open according
to this site [1]

but since you do not want to open the magnet with deluge, change deluge
for the name of your script as such adding the following at the right
place in the xdg-open code:

        elif (echo "$1" | grep -q '^magnet:'); then
            rtorrent-magnet "$1" 
            if [ $? -eq 0 ]; then
                exit_success
            fi

This should be at line 652 at the time of writing, xdg-open 1.1.0 rc1

rtorrent-pyro
-------------

rtorrent-pyro from the AUR comes with an extended rtorrent console
interface. It doesn't contain the pyroscope tools yet though. If you
also need the pyroscope tools see #PyroScope .

Make sure you add following command to ~/.rtorrent.rc, which makes the
asterisk key * to a shortcut for toggling between extended and collapsed
view within rtorrent's interface:

    schedule = bind_collapse,0,0,"ui.bind_key=download_list,*,view.collapsed.toggle="

Also set "pyro.extended" to 1 to activate rTorrent-PS features.

    system.method.insert = pyro.extended, value|const, 1

> PyroScope

We create a directory for the installation of pyroscope, then download
and update the source code from subversion:

    mkdir -p ~/.lib
    svn checkout http://pyroscope.googlecode.com/svn/trunk/ ~/.lib/pyroscope
    ~/.lib/pyroscope/update-to-head.sh

Adding pyroscope bin's PATH to .bashrc:

    export PATH=$PATH:path_to_the_bin      # Example path for pyroscope bin's: /home/user/.lib/pyroscope/bin/

Creating the ~/.pyroscope/config.ini:

    pyroadmin --create-config

Add this to your ~/.rtorrent.rc. Don't forget to add the path of your
pyroscope bin's dir (see below).

    system.method.insert = pyro.bin_dir, string|const, write_here_path_to_your_pyroscope_bin_dir     # Example path: /home/user/.lib/pyroscope/bin/
    system.method.insert = pyro.rc_dialect, string|const|simple, "execute_capture=bash,-c,\"test $1 = 0.8.6 && echo -n 0.8.6 || echo -n 0.8.9\",dialect,$system.client_version="
    system.method.insert = pyro.rtorrent_rc, string|const|private, "$cat=~/.pyroscope/rtorrent-,\"$pyro.rc_dialect=\",.rc.default"
    import = $pyro.rtorrent_rc=

Optionally: TORQUE: Daemon watchdog schedule. Must be activated by
touching the "~/.pyroscope/run/pyrotorque" file! You can also just use
rtorrent watch dir or give pyro_watchdog a try, which comes with
'treewatch' ability, meaning it also watches for torrents recursively
within the given watch path. Further documentation for pyro_watchdog is
here: [2] To enable pyro_watchdog, add this in ~/.rtorrent.rc and
further configurations are in ~/.pyroscope/torque.ini.

    schedule = pyro_watchdog,30,300,"pyro.watchdog=~/.pyroscope,-v"

Following steps are important. Before using pyroscope tools you have to
set the missing "loaded" times to that of the .torrent file. Run this in
your terminal:

    rtcontrol '!*"*' loaded=0 -q -sname -o 'echo "$(name)s"\ntest -f "$(metafile)s" && rtxmlrpc -q d.set_custom $(hash)s tm_loaded \$(\
        ls -l --time-style "+%%s" "$(metafile)s" \
        | cut -f6 -d" ")\nrtxmlrpc -q d.save_session $(hash)s' | bash

And now set the missing "completed" times to that of the data file or
directory:

    rtcontrol '!*"*' completed=0 done=100 path=\! is_ghost=no -q -sname -o 'echo "$(name)s"\ntest -e "$(realpath)s" && rtxmlrpc -q d.set_custom $(hash)s tm_completed \$(\
        ls -ld --time-style "+%%s" "$(realpath)s" \
        | cut -f6 -d" ")\nrtxmlrpc -q d.save_session $(hash)s' | bash

Example usage: Will print out all torrents older than 2 hours:

    rtcontrol -V completed=+2h -scompleted -ocompleted

Deletes all torrents older than 48 hours:

    rtcontrol -V completed=+48h -scompleted -ocompleted --cull --yes

See also
--------

-   Manpage for rtorrent
-   Screen Tips
-   Comparison of BitTorrent clients on Wikipedia
-   rTorrent Community Wiki - Public place for information on rTorrent
    and any project related to rTorrent, regarding setup, configuration,
    operations, and development.
-   PyroScope - Collection of command line tools for rTorrent. It
    provides commands for creating and modifying torrent files, moving
    data on completion without having multiple watch folders, and
    mass-controlling download items via rTorrent's XML-RPC interface:
    searching, start/stop, deleting items with or without their data,
    etc. It also offers a documented Python API.
-   ruTorrent with Lighttpd
-   How-to install rTorrent and Hellanzb on CentOS 5 64-bit VPS
-   Installation guide for rTorrent and Pryoscope on Debian - Collection
    of tools for the BitTorrent protocol and especially the rTorrent
    client
-   mktorrent - Command line application used to generate torrent files,
    which is available as mktorrent in the official repositories.
-   Rtorrent Complete Guide - Very helpful archlinux guide for rtorrent
    set-up and configuration.

Forum threads

-   2009-03-11 - Arch Linux - HOWTO: rTorrent stats in Conky

Retrieved from
"https://wiki.archlinux.org/index.php?title=RTorrent&oldid=304767"

Category:

-   Internet applications

-   This page was last modified on 16 March 2014, at 07:04.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
