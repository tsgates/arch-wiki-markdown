GStreamer
=========

GStreamer is a pipeline-based multimedia framework written in the C
programming language with the type system based on GObject.

GStreamer allows a programmer to create a variety of media-handling
components, including simple audio playback, audio and video playback,
recording, streaming and editing. The pipeline design serves as a base
to create many types of multimedia applications such as video editors,
streaming media broadcasters, and media players.

Designed to be cross-platform, it is known to work on Linux (x86,
PowerPC and ARM), Solaris (Intel and SPARC), Mac OS X, Microsoft Windows
and OS/400. GStreamer has bindings for programming-languages like
Python, C++, Perl, GNU Guile (guile), and Ruby. GStreamer is free
software, licensed under the GNU Lesser General Public License.

Contents
--------

-   1 Installation
    -   1.1 Current version plugins
    -   1.2 Legacy version plugins
-   2 Integration
    -   2.1 PulseAudio
    -   2.2 Lightweight desktops
    -   2.3 KDE / Phonon integration
-   3 Bugs
-   4 See also

Installation
------------

Install a GStreamer version from the official repositories:

-   gstreamer - Current version.
-   gstreamer0.10 - Legacy but widely used version.

To make GStreamer useful, install the plugins packages you require.

> Current version plugins

-   gst-libav - Libav-based plugin containing many decoders and
    encoders.
-   gst-plugins-bad - Plugins that need more quality, testing or
    documentation.
-   gst-plugins-base - Essential exemplary set of elements.
-   gst-plugins-good - Good-quality plugins under LGPL license.
-   gst-plugins-ugly - Good-quality plugins that might pose distribution
    problems.
-   gst-vaapi - VA-API support.

> Legacy version plugins

-   gstreamer0.10-bad-plugins - Plugins that need more quality, testing
    or documentation.
-   gstreamer0.10-base-plugins - Essential exemplary set of elements.
-   gstreamer0.10-ffmpeg - Libav-based plugin containing many decoders
    and encoders.
-   gstreamer0.10-good-plugins - Good-quality plugins under LGPL
    license.
-   gstreamer0.10-good-plugins-slim - Good-quality plugins under LGPL
    license. GNOME and ASCII-art dependency removed.
-   gstreamer0.10-ugly-plugins - Good-quality plugins that might pose
    distribution problems.
-   gstreamer0.10-vaapi - VAAPI support.

Integration
-----------

> PulseAudio

PulseAudio support is provided by good plugins packages.

> Lightweight desktops

To configure GStreamer, for example to change the audio output device,
use gstreamer-properties from package gnome-media. This can be run by
each user or as root for all users. Per-user configuration files are
under $HOME/.gconf/system/gstreamer and the global files are in
/etc/gconf/gconf.xml.defaults.

> KDE / Phonon integration

See Phonon.

Bugs
----

In case of error
GStreamer-CRITICAL **: gst_mini_object_unref: assertion `mini_object->refcount > 0' failed
which usually occurs when recording video through recording software,
install gstreamer0.10-ffmpeg to fix.

See also
--------

-   Sound
-   http://gstreamer.freedesktop.org/

Retrieved from
"https://wiki.archlinux.org/index.php?title=GStreamer&oldid=303316"

Category:

-   Audio/Video

-   This page was last modified on 6 March 2014, at 10:06.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
