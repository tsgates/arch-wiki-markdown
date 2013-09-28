Firefox Privacy
===============

Summary

Configuration and installation of recommended add-ons to the Firefox
browser to improve privacy

Required

Firefox: Installing and troubleshooting the Firefox browser and plugins

Related

Tor: Anonymous proxy network

Browser Plugins: Acquiring and installing plugins such as Flash

Firefox Tweaks: Configuration and modifications

Speed-up Firefox using tmpfs: Caching the profile in RAM

This article overviews some useful extensions which enhance security and
privacy while using the Firefox web browser.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 HTTPS Everywhere                                                   |
| -   2 Adblock Plus                                                       |
| -   3 Ghostery                                                           |
| -   4 NoScript                                                           |
| -   5 Cookie Monster                                                     |
| -   6 RefControl                                                         |
| -   7 RequestPolicy                                                      |
+--------------------------------------------------------------------------+

HTTPS Everywhere
----------------

HTTPS Everywhere is an extension which encrypts your communication with
a website. It forces a connection over HTTPS instead of HTTP wherever
possible.

HTTPS Everywhere will be automatically configured and enabled upon
restarting Firefox. For information on how to set up your own rules for
different websites please visit the official website.

Note:HTTPS Everywhere does not magically enable HTTPS for every site on
the internet. The site needs to support HTTPS and HTTPS Everywhere
should have a ruleset configured for that site.

Adblock Plus
------------

Adblock Plus can be used to stop intrusive advertisments but it can also
be configured to block websites from tracking you.

Once installed visit the Easy List website and add the EasyList and
EasyPrivacy lists to your Adblock Plus filter subscriptions. This is
done by simply clicking any of the "Add [filter] to Adblock Plus" on the
webpage. This will bring up the add filter prompt. Review the details
and click "Add Subscription".

EasyList is the primary subscription that removes adverts from English
webpages, including unwanted frames, images and objects.

EasyPrivacy is a supplementary subscription for EasyList which removes
all forms of tracking from the internet, including web bugs, tracking
scripts and information collectors.

Ghostery
--------

Ghostery is a project to track businesses which employ the use of
website trackers. From the website:

Ghostery tracks over 1,000 trackers and gives you a roll-call of the ad
networks, behavioral data providers, web publishers, and other companies
interested in your activity.

Ghostery can be installed from the official website. Once installed
Ghostery can be configured from:

     chrome://ghostery/content/options.html

Or by selecting preferences from the Add-ons Manager in Firefox which
will bring you to the configuration page.

Alternatively you can configure Ghostery through the included wizard:

     chrome://ghostery/content/wizard.html

From the configuration page you can configure what 3rd party
elements(3pes) Ghostery should block. When navigating the categories you
can click on the individual profiles for more information about that
specific company. You can also choose to clear Flash and Silverlight
cookies on exit. Also, you can enable the cookie protection feature
which prevents selected websites from setting cookies in your browser.

NoScript
--------

NoScript is an extension which disables JavaScript, Java, Flash and
other plugins on any website not specifically whitelisted by the user.
This extension will protect you from exploitation of security
vulnerabilities by not letting anything but trusted sites (e.g: your
bank, webmail) serve you executable content.

Once installed you can configure settings for NoScript by either
clicking its icon on the toolbar or right clicking a page and navigating
to NoScript. You will then have the option to enable/disable scripts for
the current page, as well as any third party scripts that the page is
linking to. Alternatively you can choose to enable scripts temporarily
for that session only.

For more detailed configuration see the NoScript FAQ.

Cookie Monster
--------------

Cookie Monster is a similar extension to NoScript but will the goal of
managing cookies.

From the preferences for Cookie Monster select "Block All Cookies". Once
this is done, just as with NoScript, you can enable the use of cookies
for specific pages from either the Cookie Monster icon on the toolbar or
by right clicking the page and navigating to Cookie Monster. You have
the option to accept cookies from the website in question or
alternatively to only temporarily allow cookies for the current session.

RefControl
----------

RefControl is an extension to control what gets sent as the HTTP
Referer. Once installed RefControl can be configured so that no referer
gets sent when navigating to a new webpage. This prevents the server
from knowing which website you originated from.

To do this open RefControl's preferences and change the setting for
"Default for sites not listed:" to <Block>.

RequestPolicy
-------------

RequestPolicy is an extension for Mozilla browsers which lets you have
control over cross-site requests. The latest development version lets
you blacklist or whitelist requests by default. Disabling unnecessary
cross-site requests leads to better privacy, safety and faster browsing.

For more information on cross-site requests and RequestPolicy visit
here.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Firefox_Privacy&oldid=236636"

Category:

-   Web Browser
