Rutorrent with lighttpd
=======================

Rutorrent is a php frontend to the rtorrent bitorrent client.

It communicates with rtorrent using XML-RPC. It requires a web server
such as lighttpd or apache to serve it's pages.

To set up rutorrent, we will need to have rtorrent and lighttpd set up.

Contents
--------

-   1 rtorrent
-   2 lighttpd
    -   2.1 lighttpd.conf
        -   2.1.1 Test
    -   2.2 php.ini
-   3 rutorrent
-   4 Testing
-   5 Plugins
-   6 SSL and Authentication
    -   6.1 User Authentication
    -   6.2 SSL
-   7 Troubleshooting
-   8 See Also

rtorrent
--------

Install rtorrent and configure to your liking.

    # pacman -S rtorrent

Information on configuring rtorrent can be found on it's wiki page:
https://wiki.archlinux.org/index.php/Rtorrent.

rtorrent in the repos should be compiled with XML-RPC support.

Add the following line to your rtorrent config file, usually
~/.rtorrent.rc.

    scgi_port = localhost:5050

Instead of using a tcp port, it is also possible to use a socket using
the scgi_local option instead. This did not work for me, as lighttpd
complained about permissions regardless of permissions / location of
socket file.

You can choose a port other than 5050 if you like.

lighttpd
--------

Install lighthttp and php.

    # pacman -S lighttpd php php-cgi fcgi

Information on setting up lighthttp can be found on it's wiki page:
https://wiki.archlinux.org/index.php/Lighttpd

After starting lighthttp as per the wiki, you should be able to access
the test page at http://localhost:80.

By default the pages are served from /srv/http, this is where we will be
putting rutorrent.

> lighttpd.conf

Edit lighthttpd's config file, /etc/lighttpd/lighttpd.conf.

The following lines tell lighttpd to load the fastcgi and simple-cgi
modules. Fast cgi is needed for rutorrent itself, and scgi for rutorrent
to communicate with rtorrent.

    server.modules += ( "mod_fastcgi" )
    server.modules += ( "mod_scgi" )

We need to tell lighttpd how to treat files like css, images (jpg etc.),
js. Otherwise it will not know what to do with them, and you may get a
dialog to download the file or rutorrent will just not work properly.

Here is a long list of filetypes, it is probably overkill as most of
them are not needed, but easier to cover them all.

Add this to /etc/lighttpd/lighttpd.conf also.

    mimetype.assign             = (
          ".rpm"          =>      "application/x-rpm",
          ".pdf"          =>      "application/pdf",
          ".sig"          =>      "application/pgp-signature",
          ".spl"          =>      "application/futuresplash",
          ".class"        =>      "application/octet-stream",
          ".ps"           =>      "application/postscript",
          ".torrent"      =>      "application/x-bittorrent",
          ".dvi"          =>      "application/x-dvi",
          ".gz"           =>      "application/x-gzip",
          ".pac"          =>      "application/x-ns-proxy-autoconfig",
          ".swf"          =>      "application/x-shockwave-flash",
          ".tar.gz"       =>      "application/x-tgz",
          ".tgz"          =>      "application/x-tgz",
          ".tar"          =>      "application/x-tar",
          ".zip"          =>      "application/zip",
          ".mp3"          =>      "audio/mpeg",
          ".m3u"          =>      "audio/x-mpegurl",
          ".wma"          =>      "audio/x-ms-wma",
          ".wax"          =>      "audio/x-ms-wax",
          ".ogg"          =>      "application/ogg",
          ".wav"          =>      "audio/x-wav",
          ".gif"          =>      "image/gif",
          ".jar"          =>      "application/x-java-archive",
          ".jpg"          =>      "image/jpeg",
          ".jpeg"         =>      "image/jpeg",
          ".png"          =>      "image/png",
          ".xbm"          =>      "image/x-xbitmap",
          ".xpm"          =>      "image/x-xpixmap",
          ".xwd"          =>      "image/x-xwindowdump",
          ".css"          =>      "text/css",
          ".html"         =>      "text/html",
          ".htm"          =>      "text/html",
          ".js"           =>      "text/javascript",
          ".asc"          =>      "text/plain",
          ".c"            =>      "text/plain",
          ".cpp"          =>      "text/plain",
          ".log"          =>      "text/plain",
          ".conf"         =>      "text/plain",
          ".text"         =>      "text/plain",
          ".txt"          =>      "text/plain",
          ".dtd"          =>      "text/xml",
          ".xml"          =>      "text/xml",
          ".mpeg"         =>      "video/mpeg",
          ".mpg"          =>      "video/mpeg",
          ".mov"          =>      "video/quicktime",
          ".qt"           =>      "video/quicktime",
          ".avi"          =>      "video/x-msvideo",
          ".asf"          =>      "video/x-ms-asf",
          ".asx"          =>      "video/x-ms-asf",
          ".wmv"          =>      "video/x-ms-wmv",
          ".bz2"          =>      "application/x-bzip",
          ".tbz"          =>      "application/x-bzip-compressed-tar",
          ".tar.bz2"      =>      "application/x-bzip-compressed-tar",
          # default mime type
          ""              =>      "application/octet-stream",
         )

Next we add the configuration for scgi to connect to rtorrent. Make sure
to use the same port as when configuring rtorrent.

    scgi.server = ( "/RPC2" =>
        ( "127.0.0.1" =>
            (
                "host" => "127.0.0.1",
                "port" => 5050,
                "check-local" => "disable"
            )
        )
    )

And finally the fastcgi settings so lighthttpd knows how to deal with
php.

    fastcgi.server = ( ".php" => ((
                     "bin-path" => "/usr/bin/php-cgi",
                     "socket" => "/tmp/php.socket"
    )))

Test

At this point, you should be able to test if rtorrent and lighttpd's
scgi are working properly using the xmlrpc command to ask rtorrent for a
list of functions. ( See
http://libtorrent.rakshasa.no/wiki/RTorrentXMLRPCGuide#Usage ).

       $ xmlrpc localhost system.listMethods

This should output a log list of methods that can be accessed through
rtorrent's scgi interface. If it doesn't then something may be wrong.

> php.ini

We need to make a small change to the open_basedir line in
/etc/php/php.ini, to allow rutorrent to access the binaries it needs to
run.

       open_basedir = /srv/http/:/home/:/tmp/:/usr/share/pear/:/usr/bin

The binaries are stat, id, php, curl, gzip. If these are installed
somewhere other than /usr/bin, then you may need to append that to the
line also.

rutorrent
---------

We will download rutorrent to lighttpd http directory.

       # cd /srv/http
       # wget http://rutorrent.googlecode.com/files/rutorrent-3.5.tar.gz
       # tar xvfx rutorrent-3.5.tar.gz
       # rm rutorrent-3.5.tar.gz

These should download and extract rutorrent to /srv/http. You may need
to change rutorrent-3.5 to the desired version from the rutorrent
website.

rutorrent's config files are in /srv/http/rutorrent/conf/.

We need to edit /srv/http/rutorrent/conf/config.php, and change the port
to the one we used in rtorrent and lighttpd.

    $scgi_port = 5050;
    $scgi_host = "127.0.0.1";

Change the owner of the rutorrent to http (the user that lighttpd runs
as by default).

    # chown -R http rutorrent

Testing
-------

rutorrent should now be set up.

Start rtorrent, and restart lighttpd if you have not done so since
changing the configuration.

You should now be able to access the rutorrent interface on localhost or
127.0.0.1 on port 80 (assuming you did not change the default port for
lighttpd).

http://localhost

Plugins
-------

To install plugins for rutorrent, download the archive of the plugin you
want and extract to rutorrent's plugin directory.

    /srv/http/rutorrent/plugins

Plugins can be found on the rutorrent website:
http://code.google.com/p/rutorrent/wiki/Plugins

SSL and Authentication
----------------------

> User Authentication

Detailed information on the different authentication methods can be
found here: http://redmine.lighttpd.net/projects/1/wiki/Docs_ModAuth

In this example we will digest authentication with htdigest method.

In your lighttpd directory, we will create a file called
"lighttpd-htdigest.user" or some other filename of your choice to hold
the passwords.

For htdigest, the format of the lines is:

    username:Realm:hash

Username is your desired username, Realm is a name you chose to give to
the access level. Hash is an md5sum of a string that looks like:

    username:Realm:password

So your actual password is not stored in the file, it just contributes
to the md5sum.

So using username: 'tom', Realm: 'rtorrent' and password: 'secret_pass',
we can obtain the hash by running:

       $ echo -n "tom:rtorrent:secret_pass" | md5sum | cut -b -32
       a4aaa1091eb2d1d025bbd692dee3f0c

-n tells echo not to print a newline, the cut command takes just the
first 32 bytes so we don't get the dash at the end.

So now save the hash in a variable by running:

       $ hash=$(echo -n "tom:rtorrent:secret_pass" | md5sum | cut -b -32)
       $ echo $hash
       6a4aaa1091eb2d1d025bbd692dee3f0c

Now save it to our password file:

    # echo "tom:rtorrent:$hash" > /etc/lighttpd/lighttpd-htdigest.user

You can use any file name you like, just add the same file to
lighttpd.conf.

root as owner of this file should work ok, however it didn't work for me
unless I made http owner.

    # chown http /etc/lighttpd/lighttpd-htdigest.user
    # chmod 400 /etc/lighttpd/lighttpd-htdigest.user

Now we will change /etc/lighttpd/lighttpd.conf to tell it to use this
password file for anytime rutorrent is accessed.

Add the following lines:

       server.modules += ( "mod_auth" )
       auth.debug = 0
       auth.backend = "htdigest"
       auth.backend.htdigest.userfile = "/etc/lighttpd/lighttpd-htdigest.user"

  

       auth.require = ( "/rutorrent/" => (
                        "method"  => "digest",
                        "realm"   => "rtorrent",
                        "require" => "valid-user"
                      ))

Restart lighttpd, and it should now require you to enter your username
and password when you reload rutorrent.

    # systemctl restart lighttpd

> SSL

The following resources can help you add ssl to lighttpd:

https://wiki.archlinux.org/index.php/Lighttpd#SSL
http://redmine.lighttpd.net/projects/1/wiki/Docs_SSL
http://redmine.lighttpd.net/projects/1/wiki/HowToSimpleSSL

If you just want to get it working, the following commands should work.

Create pem file:

       sudo mkdir /etc/lighttpd/certs
       sudo openssl req -new -x509 -newkey rsa:2048 -keyout /etc/lighttpd/certs/lighttpd.pem -out /etc/lighttpd/certs/lighttpd.pem -days 730 -nodes

Then add the following lines to /etc/lighttpd/lighttpd.conf (remove '#'
comments if you still want plain http enabled:

       #$SERVER["socket"] == ":443" {
            ssl.engine = "enable"
            ssl.pemfile = "/etc/lighttpd/certs/lighttpd.pem"
       #}

And change this line from 80 to 443 (if you only want ssl enabled):

       server.port     = 443

Then https should work, and depending on what you changed, http may not
work anymore.

Note: This cert is not signed by a Certificate Authority, so you will
have to add an exception in firefox.

Troubleshooting
---------------

For problems with rutorrent or lighttpd, the best place to check first
is probably the lighttpd log files, in /var/log/lighttpd/. Particularly
error.log.

       $ tail /var/log/lighttpd/error.log

See Also
--------

-   rutorrent Project page
-   Rtorrent Wiki page
-   Lighttpd
-   RuTorrent (with Apache)
-   Using XMLRPC with rtorrent

Retrieved from
"https://wiki.archlinux.org/index.php?title=Rutorrent_with_lighttpd&oldid=302657"

Category:

-   Internet applications

-   This page was last modified on 1 March 2014, at 04:30.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
