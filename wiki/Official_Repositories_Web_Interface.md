Official Repositories Web Interface
===================================

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: This API does    
                           not have any other       
                           documentation: if you    
                           have knowledge of        
                           Django, please help      
                           adding any missing       
                           functionalities by       
                           looking at the source    
                           code. (Discuss)          
  ------------------------ ------------------------ ------------------------

This article provides documentation for the web interface through which
it is possible to query the official repositories and obtain results in
JSON format.

Contents
--------

-   1 Package information
    -   1.1 Details
    -   1.2 Files
-   2 Package search
    -   2.1 Name or description
    -   2.2 Exact name
    -   2.3 Description
    -   2.4 Repository
    -   2.5 Architecture
    -   2.6 Maintainer
    -   2.7 Packager
    -   2.8 Flagged
-   3 See also

Package information
-------------------

Base URL: https://www.archlinux.org/packages/

> Details

Syntax: /repository/architecture/package/json

Example: https://www.archlinux.org/packages/core/x86_64/coreutils/json/

> Files

Syntax: /repository/architecture/package/files/json

Example:
https://www.archlinux.org/packages/core/i686/coreutils/files/json/

Package search
--------------

The interface supports the same query parameters as the HTML search
form, except for sort.

Base URL: https://www.archlinux.org/packages/search/json

> Name or description

Parameter: q

Example: https://www.archlinux.org/packages/search/json/?q=pacman

> Exact name

Parameter: name

Example: https://www.archlinux.org/packages/search/json/?name=coreutils

> Description

Parameter: desc

Example: https://www.archlinux.org/packages/search/json/?desc=pacman

> Repository

It is possible to use this parameter more than once in order to search
in more than one repository (but note that omitting it altogether will
search in all repositories).

Parameter: repo

Values: Core, Extra, Testing, Multilib, Multilib-Testing, Community,
Community-Testing

Example:
https://www.archlinux.org/packages/search/json/?q=cursor&repo=Community&repo=Extra

> Architecture

It is possible to use this parameter more than once in order to search
for more than one architecture (but note that omitting it altogether
will search for all architectures).

Parameter: arch

Values: any, i686, x86_64

Example:
https://www.archlinux.org/packages/search/json/?q=cursor&arch=any&arch=x86_64

> Maintainer

Parameter: maintainer

Example:
https://www.archlinux.org/packages/search/json/?repo=Community&maintainer=orphan

> Packager

Parameter: packager

> Flagged

Parameter: flagged

Values: Flagged, Not+Flagged

Example:
https://www.archlinux.org/packages/search/json/?arch=x86_64&flagged=Flagged

See also
--------

-   AurJson
-   Forum thread
-   Initial feature request: FS#13026
-   Kittypack: A silly little tool to poke archlinux.org/packages for
    info

Retrieved from
"https://wiki.archlinux.org/index.php?title=Official_Repositories_Web_Interface&oldid=280424"

Category:

-   Package management

-   This page was last modified on 30 October 2013, at 14:55.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
