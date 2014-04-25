Gopher
======

Gopher is a protocol for information transfer over the internet that was
very popular before HTTP took over as the dominant protocol, but there
is still a community of gopher users that prefer the simplicity of the
protocol over the more complex and large protocols more often
encountered. A few examples of gopher sites can be found here. Note that
not all browsers support gopher, or have incomplete support. Firefox has
limited support, but it can be enhanced with this add-on.

Contents
--------

-   1 GoFish
    -   1.1 Installation
    -   1.2 Configuration
-   2 .cache
-   3 Additional Resources

GoFish
------

GoFish is a basic gopher server that allows you to run your own
gopherspace. The setup is somewhat like other servers, but generally
requires less resources to function.

> Installation

Install gofish from the AUR.

> Configuration

There are some basic settings for the server you can change in the
/etc/gofish.conf file, but the defaults will work. If you do not alter
any settings, the root of the gopher server will be /var/gopher and it
will run on port 70. (Note that Firefox can only use the gopher protocol
on port 70, so changing it will mean your users must use some other
client.)

To run the server:

    # /etc/rc.d/gopherd start

As always, put in the daemons array in your /etc/rc.conf to autostart it
at boot. You can now connect to your server and see what you have by
navigating to gopher://127.0.0.1

.cache
------

Unlike FTP which automatically shows all files, gopher relies on a file
called .cache in each directory to determine how the page will be shown
to the end user. Although GoFish comes with a manpage for the .cache
files - man dotcache - it can be a little confusing. GoFish also comes
with a program to autogenerate .cache files for all the directories and
files in your server root.

    mkcache -r

This will create all the needed .cache files recursively, but you may
want to edit some names. A sample .cache file will look something like
this:

    iHello         none            example.com     70
    0ReadMe	0/ReadMe.txt	example.com	70
    1Ebooks	1/ebooks	example.com	70

The gopher protocol uses number prefixes to describe filetype. 0 is a
plain text file, 1 is a directory and 9 is a binary file. The i
indicates an image, and if it is linked to 'none', it will show up as
plain text. This is good for introducing your site. See the manpage for
dotcache for more info on the prefixes. After the prefix number is the
name that will appear in the client, and it does not need to be the same
as the file it links to. In the second section, we see the "path" to the
file. There is not a directory named '0' or '1' in the file system, it
is only added in the URI to let the gopher server and end user know what
sort of file it is. The third section is whatever domain name the site
is, and the fourth is the port it is on, default is 70. The space
between each of the 4 sections must be a tab, not a space or it will not
be parsed correctly.

Now let's look at the .cache file in the ebooks directory.

    9Book 1	9/ebooks/Book1.chm	example.com	70
    9Book 2	9/ebooks/Book2.pdf	example.com	70

Notice that the URI is 9/ebooks/Book1.chm, NOT 1/ebooks/9Book1.chm .
There is always only one prefix number for the last item in the URI.
Also notice that a chm file nor a pdf file is really a binary, but it is
still given the prefix of 9. In the GoFish server, any file that is not
a text file or a directory is given the binary prefix. Remember that if
there are files within your server's root, people can download or view
them even if they are not in your .cache file, so be careful.

Additional Resources
--------------------

GoFish Homepage

Retrieved from
"https://wiki.archlinux.org/index.php?title=Gopher&oldid=198285"

Category:

-   Networking

-   This page was last modified on 23 April 2012, at 17:35.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
