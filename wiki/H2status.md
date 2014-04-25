H2status
========

h2status is a trivial (about 60 LOC) bash wrapper to i3status that
nevertheless allows to conveniently:

-   Write custom modules in bash to add full-fledged json entries to the
    status bar.
-   Write mouse event handlers in bash with access to the full set of
    event parameters as bash variables.
-   Arbitrarily transform the final output to change formatting, order
    of entries, etc.
-   Compute and cache expensive status entries asynchronously, updating
    them only at desired frequencies.

Besides reading the documentation below it's recommended that you take a
look at the code in [1] as it can be more eloquent than the following
wording.

Contents
--------

-   1 Configuration
-   2 Store
-   3 CLI
-   4 Examples
    -   4.1 Check gmail folders
    -   4.2 Switch keyboard layout
    -   4.3 Application launchers
    -   4.4 Dynamic icons
-   5 Dependencies

Configuration
-------------

The configuration is done in ~/.h2statusrc by (optionally) defining the
following bash functions:

1. status() -> json

This outputs the status entries to be concatenated to the beginning of
the original i3status output. As a convenience for outputting json
status entries, the function entry(module,text[,other]) is provided. For
example:

     function status {
       ...
       entry random $RANDOM '"color":"$00FF00"'
       ...
     }

2. on_event()

This handles mouse events. The execution environment of this function is
augmented with the variables name, instance, button, x, y described at
the end of [2].

3. transform(json) -> json

This is intended for simple sed style hackish manipulations that change
order and format of the final json line to be consumed by i3bar. Use it
as a last resort.

An example configuration is provided in /usr/share/h2status/h2statusrc
(you can also browse it online at [3]). Use this as a template to write
your own stuff.

Store
-----

h2status allows for module status storage and retrieval in a
concurrent-safe way through the file system. The purpose of this is
two-folded:

-   To implement a basic IPC mechanism that supports communication with
    external scripts that need to update the status.
-   To implement a basic cache mechanism that supports asynchronous
    status updating.

The interface to the store consists of three functions:

1. write_status(module,value)

2. read_status(module) -> value

3. cached_status(module,interval,command) -> value

The first two are self-explanatory but the third one requires some
motivation and explanation. i3status implements a simple model of status
updating: each time an update event happens (every n seconds or after
receiving an USR1 signal) the entire status line is recomputed. This is
fine for fast/cheap status computations but makes it difficult to
integrate relatively long/expensive computations that could delay the
update for a perceptible amount of time or overload the cpu when
frequently called. To support this kind of status computations while
keeping i3status as h2status workhorse, cached_status() implements a
basic cache mechanism that allows to asynchronously update status
values. For example, if you want to check the folders "inbox" and "work"
in your IMAP account every 60 seconds you could add this line to
status():

     function status {
       ...
       entry mail "Mail: $(cached_status mail 60 'checkmail inbox work')"
       ...
     }

Here mail is the module name, 60 is the update interval and
checkmail inbox work is the command implementing the update logic which
would be evaluated in background every 60 seconds (this is not exactly
true, as the cache is only read/updated at points in time when i3status
itself gets updated, according to the interval setting in i3status
configuration).

Then, if you wanted to force an update by clicking on the mail status
entry, you could also implement an event handler like this one:

     function on_event {
       case $name in
       ...
       mail) [[ $button == 1 ]] && write_status mail "$(checkmail inbox work)" ;;
       ...
       esac
     }

CLI
---

Most of the status computing and updating logic is implemented inside
13status and h2status, but sometimes you need an external script to
force a status update or to write some specific value to the status
store. To support these cases, h2status provides an elementary command
line interface consisting of two commands:

1. h2status update

This calls update(), which immediately updates the status line (similar
to, and based upon, pkill -USR1 i3status).

2. h2status write <module> <value>

This calls write_status() passing <module> and <value> as arguments.
After writing the new value to the store the status line is updated, but
this is just what write_status() always does.

Of course, both update() and write_status() can also be directly called
as functions from inside h2status. The usual use case is to invoke these
functions when reacting to click events in on_event().

Examples
--------

> Check gmail folders

This will check gmail folders MAIL_INBOXES for unread messages every
MAIL_INTERVAL seconds using the external script checkmail. A version of
this script that works with firefox cookies database is given here [4].

     MAIL_INTERVAL=60
     MAIL_INBOXES=("" livra jampp)
     function status {
       local unread_list=$(cached_status mail $MAIL_INTERVAL 'checkmail "${MAIL_INBOXES[@]}"')
       local -i total_unread=$((${unread_list// /+}))
       ((total_unread)) && entry mail "Mail: $unread_list" '"color":"$00FF00"'
     }

> Switch keyboard layout

The following makes for a nice solution to keyboard layout switching
between multiple languages. Left-button clicking on the keyboard status
entry switches to the default (first) layout. Right-button clicking
iterates over all configured layouts. The layouts are configured in
~/.xinitrc using setxkbmap, v.g. setxkbmap "us,es,fr". You must install
xkblayout-state from the AUR.

     function status {
       entry lang $(xkblayout-state print "%s")
     }

     function on_event {
       case $name in
       lang)   [[ $button == 1 ]] && xkblayout-state set 0 || xkblayout-state set +1; update ;;
       esac
     }

> Application launchers

Just:

-   Add a status entry consisting only of an iconic font glyph (read
    this [5] if you don't know what I'm talking about), and
-   Add a handler to on_event() in order to launch the application when
    the icon is clicked upon. Remember to launch it in background to
    avoid blocking the event cycle.

> Dynamic icons

You can show different iconic font glyphs (read this [6] if you don't
know what I'm talking about) according to the current status of some
modules. For example, different battery icons corresponding to different
charge levels or different volume icons corresponding to different
volume levels. Just write your own transformation hook and add it to the
transform() function in ~/.h2statusrc.

Dependencies
------------

flock (in util-linux) for safe concurrent cache read/write.

i3status configured with output_format="i3bar".

Retrieved from
"https://wiki.archlinux.org/index.php?title=H2status&oldid=292212"

Categories:

-   Tiling WMs
-   Dynamic WMs

-   This page was last modified on 10 January 2014, at 17:02.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
