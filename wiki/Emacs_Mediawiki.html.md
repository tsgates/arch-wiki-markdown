Emacs Mediawiki
===============

Summary help replacing me

Emacs Mediawiki Mode is an emacs major mode which is evolved from an old
copy of mediawiki mode frome wikipedia.org. It helps to edit remote wiki
articles on wiki sites running mediawiki in emacs editor directly.

> Related

Emacs

ArchWiki:About

Contents
--------

-   1 Installation
-   2 Configuration
-   3 Usage
-   4 Tips and tricks
    -   4.1 Autofill off
    -   4.2 Specifying the browser
-   5 See also

Installation
------------

There is a package in AUR:emacs-mediawiki-bzr.

Or you can directly download the source from
https://launchpad.net/mediawiki-el .

Configuration
-------------

After you install the package from AUR, open your emacs configuration
file (usually, ~/.emacs) and add the following line in it.

    (require 'mediawiki)

Then add the mediawiki sites to the configuration file. For example, the
following line adds ArchWiki to it.

    (setq mediawiki-site-alist
          (append '("ArchWiki" "https://wiki.archlinux.org/" "username" "password" "Main Page")
                  mediawiki-site-alist))

Where Archwiki is the name for the site. https:/wiki.archlinux.org/ is
the url of the site and username and password is your username and
password of this site. Main Page is the default page opened when you
connect to the site.

Other sites can also be added by appending the configuration list to the
list variable mediawiki-site-alist.

Usage
-----

After the configuration, you can use emacs to edit the wiki pages
directly. Open your emacs and do the following to connect to the site.

    M-x mediawiki-site RET {site name} RET

Now that you are connected, the default page should be opened. If you
would rather edit another page. do the following to open it.

    M-x mediawiki-open RET {page title} RET

Some useful keybindings are:

-   C-x C-s – save this page
-   C-c C-c – save this page and bury the buffer
-   C-return – open the page under point for editing
-   TAB – go to the next wiki link
-   M-n – next page in the page ring
-   M-p – previous page in the page ring
-   M-g – reload the current page

Now enjoy editing wiki pages in emacs!

Tips and tricks
---------------

MediaWiki provies a hook to customize configuration. For example, if
C-return does not work for you, you can redefine it easily:

    (setq mediawiki-mode-hook
        (lambda ()
            (define-key mediawiki-mode-map (kbd "C-c RET") 'mediawiki-open-page-at-point)
    ))

> Autofill off

Wikis do not autofill paragraphs. If you do so, it might confuse history
diffs, and thus making them useless. So you'd be better off turning the
auto-fill feature completely off. Add to the hook the following line:

    (setq mediawiki-mode-hook (lambda ()
                              ;; ...
                                (turn-off-auto-fill)
    ))

> Specifying the browser

A convenient feature of Mediawiki is the mediawiki-browse function which
let you see the result of the page in a web browser. The browser is
chosen following the browse-url plugin. You can configure this
behaviour. For example:

    (setq browse-url-generic-program (executable-find (getenv "BROWSER"))
    browse-url-browser-function 'browse-url-generic)

will use your environment browser, whereas

    (setq browse-url-generic-program (executable-find "dwb")
    browse-url-browser-function 'browse-url-generic)

will specifically use the dwb browser.

See also
--------

-   MediaWikiMode
-   launchpad project page

Retrieved from
"https://wiki.archlinux.org/index.php?title=Emacs_Mediawiki&oldid=273666"

Category:

-   Text editors

-   This page was last modified on 1 September 2013, at 11:01.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
