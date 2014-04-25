Pipelight
=========

Related articles

-   Wine
-   Moonlight
-   Firefox

Description from the Launchpad page:

"Pipelight is a special browser plugin which allows one to use windows
only plugins inside Linux browsers. We are currently focusing on
Silverlight and its features like watching DRM protected videos. The
project needs a patched version of Wine to execute the Silverlight DLL."

Description from the author's blog:

"Pipelight allows [you] to run your favorite Silverlight application
directly inside your Linux browser. The project combines the effort by
Erich E. Hoover with a new browser plugin that embeds Silverlight
directly in any Linux browser supporting the Netscape Plugin API. He
worked on a set of Wine patches to get Playready DRM protected content
working inside Wine and afterwards created an Ubuntu package called
Netflix Desktop. This package allows one to use Silverlight inside a
Windows version of Firefox, which works as a temporary solution but is
not really user-friendly and moreover requires Wine to translate all API
calls of the browser. To solve this problem we created Pipelight.

Pipelight consists out of two parts: A Linux library which is loaded
into the browser and a Windows program started in Wine. The Windows
program, called pluginloader.exe, simply simulates a browser and loads
the Silverlight DLLs. When you open a page with a Silverlight
application the library will send all commands from the browser through
a pipe to the Windows process and act like a bridge between your browser
and Silverlight. The used pipes do not have any big impact on the speed
of the rendered video since all the video and audio data is not send
through the pipe. Only the initialization parameters and (sometimes) the
network traffic is send through them. As a user you will not notice
anything from that "magic" and you can simply use Silverlight the same
way as on Windows..."

Contents
--------

-   1 Installation
    -   1.1 Location of wine-silverlight (optional)
-   2 Post Install
    -   2.1 User Agent
    -   2.2 Verification
    -   2.3 GPU Acceleration
-   3 Custom variables
-   4 Troubleshooting
-   5 See also

Installation
------------

pipelight is not presently available in the Official repositories, and
will need to be installed from the AUR.

Location of wine-silverlight (optional)

The location of the wine-silverlight dependency is customizable in the
PKGBUILD. Please refer to the #Custom variables section below for
details.

Tip:Pipelight (along with wine-compholio) can alternatively be installed
from the [pipelight] repository, maintained by the Pipelight developers.

Post Install
------------

> User Agent

Since sites like Netflix refuse to stream on a Linux browser, the user
agent may have to be changed.

> Verification

There is a test page available here. Alternatively, detected plugins can
be listed in about:plugins.

> GPU Acceleration

GPU acceleration is enabled by default on verified systems and pages
that require it: https://answers.launchpad.net/pipelight/+faq/2364.

For 1080p streaming, try (needs enableGPUAcceleration=true):
http://www.iis.net/media/experiencesmoothstreaming1080p.

Custom variables
----------------

The selection of custom variables found in Wine-Silverlight and
Pipelight are as following:

-   wine-Silverlight

1.  customprefix
    -   Installs Wine to /opt instead of /usr (to not conflict with
        wine).

2.  _prefix
    -   Allows setting a custom location.

-   pipelight

1.  _prefix
    -   Allows setting a custom location. Default is /usr.

2.  _wine
    -   Location of Wine-Silverlight.

For example, to install Wine-Silverlight in /opt:

-   wine-silverlight: set customprefix=1.
-   pipelight: set _wine=/opt/wine-silverlight.

Warning:Failure to do this in the PKGBUILD will result in the files
having to be modified manually.

Troubleshooting
---------------

Known issues and solutions are often listed in the Pipelight FAQ.

See also
--------

-   Launchpad FAQ
-   Official website
-   Launchpad

Retrieved from
"https://wiki.archlinux.org/index.php?title=Pipelight&oldid=304569"

Category:

-   Web Browser

-   This page was last modified on 15 March 2014, at 03:09.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
