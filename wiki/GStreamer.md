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

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Integration                                                        |
| -   3 Hardware Acceleration                                              |
| -   4 Bugs                                                               |
| -   5 Links                                                              |
+--------------------------------------------------------------------------+

Installation
------------

Install the gstreamer0.10-base package from the official repositories.

Integration
-----------

GStreamer should already support PulseAudio for all applications since
gstreamer-pulse is now a part of gstreamer0.10-good-plugins.

To avoid lots of dependencies, you may choose to install
gstreamer0.10-good-plugins-slim from the AUR instead.

If you use KDE (and thus, phonon), you can easily install the GStreamer
backend: phonon-gstreamer. After installation, be sure gstreamer is the
first engine on the list under SystemSettings --> Multimedia -->
Backend.

Lightweight desktop users: to configure GStreamer, for example to change
the audio output device, use gstreamer-properties from package
gnome-media. This can be run by each user or as root for all users.
Per-user configuration files are under $HOME/.gconf/system/gstreamer and
the global files are in /etc/gconf/gconf.xml.defaults.

Hardware Acceleration
---------------------

For hardware acceleration on VAAPI (Intel) hardware, install
gstreamer0.10-vaapi.

More information on hardware acceleration can be found at Hardware
Accelerated Video Decoding

Bugs
----

In case of error
GStreamer-CRITICAL **: gst_mini_object_unref: assertion `mini_object->refcount > 0' failed
which usually occurs when recording video through recording software,
install gstreamer0.10-ffmpeg to fix.

Links
-----

-   Sound
-   http://gstreamer.freedesktop.org/

Retrieved from
"https://wiki.archlinux.org/index.php?title=GStreamer&oldid=255155"

Category:

-   Audio/Video
