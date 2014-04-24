Ruby-wmii
=========

Contents
--------

-   1 Introduction
-   2 Configuration
    -   2.1 darcs
    -   2.2 ssid
    -   2.3 Low level access
    -   2.4 Plugins
    -   2.5 Bindings
    -   2.6 Summary
-   3 Arch user contributions
    -   3.1 MPD (modified for use w/ multiple hosts)
    -   3.2 POP/IMAP Mail Checker (w/ SSL)
    -   3.3 Bookmark manager
-   4 Users Configs

Introduction
------------

While wmii can be configured using most any language, this document
focuses on the excellent ruby-wmii project developed by Mauricio
Fernandez (mfp).

Note:ruby-wmii is no longer maintained. Try sunaku's Ruby wmiirc
instead.

Configuration
-------------

You'll need to install Ruby, which is available in [extra]. Furthermore,
some plugins may require additional ruby libraries, such as the MPD
plugin which requires ruby-mpd from [community].

mfp's project has many useful basic bar applets and configurations; with
the 0.3.0 release, the script has adopted a useful plugin architecture
making overriding or adding functionality simple.

The ruby-wmii project is installed to ~/.wmii-3, consisting of:

-   ~/.wmii-3/wmiirc -- The heart of the ruby-wmii scripts; shouldn't be
    edited. This is what is run when wmii starts.
-   ~/.wmii-3/wmiirc-config.rb -- Your config file, which should be
    edited (running wmiirc script will create it if it doesn't already
    exist)
-   ~/.wmii-3/plugins -- A directory containing plugins (sets of
    keybindings and bar applets)
-   ~/.wmii-3/plugins/standard-plugin.rb -- The default plugins, which
    you needn't edit.

> darcs

To get a copy of the development version of ruby-wmii from mfp's
repository, checkout the code using darcs (darcs available in [extra]
repos):

    user@host % cd ~/src
    user@host % darcs get --partial http://eigenclass.org/repos/ruby-wmii/head ruby-wmii
    user@host % cd ruby-wmii
    user@host % ruby install.rb

This copy can then be updated at any time via:

    user@host % cd ~/src/ruby-wmii
    user@host % darcs pull
    user@host % ruby install.rb

  
 This last command will copy the updated ruby-wmii over what you have in
~/.wmii-3. CAUTION: This will overwrite any changes you have in
~/.wmii-3/wmiirc or ~/.wmii-3/standard-plugin.rb. For this reason, you
shouldn't edit these files! Rather, make config changes in
~/.wmii-3/wmiirc-config.rb, and if you want to modify a plugin, copy it
into a new file under ~/.wmii-3/plugins and make your edits in this
file.

> ssid

One utility which might not be present on your system is ssid. If you
lack this application you will find that the trust Mod-p menu will no
longer launch applications. It is a tiny application intended as a
replacement for setsid and can be found on the wmii website at [1]. It
needs to be built and put somewhere that wmii-ruby can find it.

    user@host % tar -xvzf ssid-0.1.tar.gz 
    user@host % make
    user@host % make install

Personally I prefer not ever to run a make install unless through a
PKGBUILD so you can alternatively copy the ssid binary somewhere into
your local user's path.

> Low level access

The wmiir command can be used to manipulate wmii at a low level; read
the manpage for details (although this isn't really necessary for a new
user!). Control scripts in different languages can use this command to
control wmii. wmii is controlled through a filesystem interface using
the 9P2000 protocol, which in turn is derived from the plan 9 operating
system. As such, there are also libraries such as ruby-ixp which can be
used to manipulate the window manager programmatically over 9P. This is
technically faster, as no calling of external programs such as 'wmiir is
then needed; however, at the time of writing, ruby-ixp is quite new and
isn't used by the ruby-wmii project.

> Plugins

ruby-wmii's plugins consist of both bar applets and key bindings. The
standard-plugin.rb file provides the following plugins: volume, mode,
dict, battery-monitor, mpd, cpuinfo, status. These are mostly
self-explanatory, except perhaps mode, which toggles between wmii
catching key combos and passing them to programs directly. It also
provides a lot of sensible key bindings and actions, such as being able
to tag and rename windows with ease (check out this for more information
about tagging in wmii).

Bar applets are used by editing ~/.wmii-3/wmiirc-config.rb, and
modifying/adding "use_bar_applet" lines. Traditionally, numbers are used
to modify the order in which plugins appear in the bar; I personally
prefer to specify them thusly:

     order_index = 1
     from "nogoma" do
       %w{mpd}.each do |plugin|
         use_bar_applet plugin, "%03d" % order_index
         order_index += 1
       end
     end
     from "standard"  do
       %w{cpuinfo volume status battery-monitor mode}.each do |plugin|
         use_bar_applet plugin, "%03d" % (order_index)
         order_index+=1
       end
     # More configuration...
     end

This will cause mpd (my custom one, listed below, in namespace
"nogoma"), cpuinfo, etc. to be included in the bar, in the given order.

Many plugins also provide parameters that can be modified. For example,
the "volume" plugin allows you to specify the mixer used:

     plugin_config["standard:volume"]["mixer"] = "Headphone"

Here, we've set the mixer parameter of the volume plugin in the standard
namespace to be "Headphone". These sort of configuration parameters make
life a lot easier as users do not need to create custom plugins to
modify existing behaviour.

> Bindings

Another aspect of wmii is keybindings; how different key combinations
affect the wm. Some plugins define key combos by default when they're
used; others define sets of bindings that can be selectively
included/excluded in the wmiirc-config.rb. They can be used by
including:

     use_binding("<binding-name>")

in your wmiirc-config.rb

Basic keybindings can also be made with the on_key command in
wmiirc-config.rb:

    on_key("MODKEY-LEFT") {
     #actions
    }

> Summary

Don't forget you can leverage most all of the power of Ruby when using
this control script; there are a lot more functions and helpers the
ruby-wmii project provides. The files are fairly self documenting, and
Ruby a fairly sensible and readable language. Don't be afraid to
experiment and add new plugins and keybindings!

Arch user contributions
-----------------------

Here are some plugins/snippets from users on the Arch forums.

> MPD (modified for use w/ multiple hosts)

I (nogoma) like to be able to control either mpd on my laptop when out
and about, or my media pc via my laptop when at home. So, I (trivially)
modified the standard mpd plugin to allow me to change hosts. The
ruby-wmii is relatively self-documenting about how to define your own
plugins; hopefully the below makes sense (it defines a new plugin in the
"nogoma" namespace, which contains a bar applet called "mpd". Notice
that this new applet doesn't conflict with the mpd applet shipped w/
ruby-wmii, because it is referred to as "nogoma:mpd" instead of
"standard:mpd").

    Plugin.define "nogoma" do
     # {{{ MPD Bar
     bar_applet("mpd", 100) do |wmii, bar|
       require 'mpd'
       server = wmii.plugin_config["nogoma:mpd"]["default_host"] || `hostname`
       mpd_do_action = lambda do |action, *args|
         Thread.new do
           begin
             mpd = MPD.new(server)
             r = mpd.__send__(action, *args)
             LOGGER.info "MPD #{action}"
             r
           ensure
             mpd.close
           end
         end
       end
       mpdserv = MPD.new
       bar.data = "Connecting: #{server}"
       update_bar = lambda do
         if /^Connecting/ =~ bar.data
           mpdserv = MPD.new(server = bar.data.split[-1])
         end
         begin
           mpdserv_status = mpdserv.status["state"]
         rescue
           show_info = false
         end
         case mpdserv_status
         when 'play' : text = ">>: "; show_info = true
         when 'pause': text = "||: "; show_info = true
         else show_info = false
         end
         if show_info
           title = mpdserv.strf("%t")[0..(wmii.plugin_config["standard:mpd"]["title_maxlen"] || -1)]
           author = mpdserv.strf("%a")[0..(wmii.plugin_config["standard:mpd"]["author_maxlen"] || -1)]
           bar.data = text + "#{author} - #{title} " + mpdserv.strf("(%e/%l)") + " [#{server}]"
         else   # Player is stopped or connection not yet initialized...
           bar.data = "[#{server}]: NOT PLAYING"
         end
       end
       keys = wmii.plugin_config["nogoma:mpd"]["switch_server"] || ["MODKEY-Control-m"]
       wmii.on_key(*keys) do
         wmii.wmiimenu([]) do |server|
           bar.data = "Connecting: #{server}"
         end
         end
       end
       # Initialize MPD status
       Thread.new do
         loop{ begin; update_bar.call; rescue Exception; end; sleep 1 }
       end
       bar.on_click(MOUSE_SCROLL_UP)  { mpd_do_action[:previous] }
       bar.on_click(MOUSE_SCROLL_DOWN){ mpd_do_action[:next] }
       bar.on_click(MOUSE_BUTTON_LEFT) do
         Thread.new do
           begin
             mpd = MPD.new(server)
             mpdserv_status = mpd.status
           ensure 
             mpd.close rescue nil
           end
           case mpdserv_status["state"]
           when "play":           mpd_do_action[:pause]
           when "pause", "stop" : mpd_do_action[:play]
           end
         end
       end
       bar.on_click(MOUSE_BUTTON_RIGHT) do
         mpd_handle = wmii.on_createclient do |cid|
           wmii.write("/view/sel/sel/ctl", "sendto 0")
           wmii.write("/view/sel/sel/geom", "400 0 center+200 south")
           wmii.unregister mpd_handle
         end
         wmii.write("/view/ctl", "select toggle")
         term = wmii.plugin_config["standard"]["x-terminal-emulator"] || "xterm"
         system "wmiisetsid #{term} -e ncmpc -h #{server}&"
       end
     end
    end

This plugin also provides the default keybinding of MODKEY-Control-M for
switching hosts. Typing in a new hostname and hitting enter will cause
the mpd applet to try connecting to that host. It also exposes two
configuration values which can be set:

     plugin_config["nogoma:mpd"]["default_host"] = "foohost" # host to connect to on startup
     plugin_config["nogoma:mpd"]["switch_server"] = "MODKEY-Control-m" # Key combo to change current host

> POP/IMAP Mail Checker (w/ SSL)

mailchecker at Why the lucky stiff's homepage.

> Bookmark manager

Bookmark manager in the development darcs repos for ruby-wmii, on mfp's
site. To get a recent copy of ruby-wmii, follow the Ruby-wmii#darcs
directions.

Feature list:

-   mouse-less interaction
-   search as you type (extended autocompletion) for both title and
    URLs: the set of bookmarks matching what I'm typing at any position
    in the title or the URL is updated instantaneously as I type
-   del.icio.us integration: importing bookmarks from del.icio.us and
    getting new ones automatically
-   tagging (it will import your del.icio.us tags if you let it try)
-   powerful search expressions (as many criteria as you want):
    -   all bookmarks in the last week: ~d <7d
    -   all bookmarks whose description matches a regexp: ~t regexp
    -   all bookmarks with "redhanded" on the description or the URL,
        defined/last used in the last month: redhanded ~d <1m
    -   all bookmarks with "ruby" on the URL, defined/last used in 2006:
        ~d 2006 ~u ruby
    -   all bookmarks tagged as "blog", defined/last used in Q1: :blog
        ~d q1
-   progressive refining: I can enter successive expressions and each
    one further restricts the possible choices, which are shown in the
    menu

Users Configs
=============

Add your configuration URL to the list

_Gandalf_

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ruby-wmii&oldid=197259"

Category:

-   Dynamic WMs

-   This page was last modified on 23 April 2012, at 14:32.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
