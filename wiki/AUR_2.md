AUR 2
=====

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: This article is  
                           about the dead AUR2      
                           project and it is not    
                           related to version 2.0.0 
                           of the official AUR. It  
                           shoudl be removed to     
                           avoid confusion.         
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Note:This is not an official Arch Linux project; it is community driven.

Ages ago, the development of the AUR had been picked up by several
individuals and the discussion on the tur-users mailing list had been
revived without much results. However, the maintainability and
extendibility of the current AUR codebase is being questioned yet again.
A few people have shown interest in finally getting the 'AUR 2' project
going -- a total rewrite with important design reconsiderations, easing
the addition of new features and making the AUR code much easier to
maintain.

The original AUR 2 ideas and suggestions can be found at the bottom of
this page.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Update                                                             |
|     -   1.1 Code repositories                                            |
|     -   1.2 Mailing list                                                 |
|     -   1.3 Todo                                                         |
|         -   1.3.1 High priority                                          |
|         -   1.3.2 Medium priority                                        |
|         -   1.3.3 Low priority                                           |
|                                                                          |
|     -   1.4 Interested in helping development?                           |
|                                                                          |
| -   2 Brainstorming                                                      |
|     -   2.1 API                                                          |
|         -   2.1.1 Draft                                                  |
|             -   2.1.1.1 Retrieving information                           |
|             -   2.1.1.2 Manipulating Packages                            |
|             -   2.1.1.3 Content Types                                    |
|             -   2.1.1.4 Versioning                                       |
|             -   2.1.1.5 Authentication                                   |
|                                                                          |
|     -   2.2 Ideas                                                        |
+--------------------------------------------------------------------------+

Update
------

I thought it may be a good idea to update this wiki a bit, though it
doesn't seem like anyone cares. Nonetheless, we have chosen to use
Django and development has progressed quite a bit. The basic
functionality of the site is pretty much finished and we will hopefully
be able to start working on the new and exciting features soon.

> Code repositories

We have chosen to use git as the SCM for the project. You can clone the
latest code from these repositories:

-   git://gitorious.org/aur2/aur2.git -- the "central" repository with
    the stable branch
-   git://github.com/sebnow/aur2.git -- Xilon's repository
-   git://ius.student.utwente.nl/aur2 -- Thralas's repository
-   git://git.berlios.de/aur2 -- Djszapi's repository

> Mailing list

-   aur2-dev@googlegroups.com - archive
-   aur2-dev@lists.berlios.de - link

> Todo

High priority

-   Compatibility with Django 1.0
-   Support for the community repo (Community is no longer in the AUR -
    should binary package support still be implemented?)
    -   Currently only unsupported is supported (ironically). More
        information on how the community side of things works on the AUR
        is necessary. I suppose a better solution may be in order. NOTE:
        This might not be required at all.
    -   It would be a good idea to aim for a flexible system, so that
        binary-based, and PKGBUILD-based, repositories can easily be
        added. Currently some things are hard-coded.

-   User profiles / Accounts

Last time logged (useful to drop packages from an inactive user , this
feature should be just for Dev's, TU's)

This is provided via Django's Auth app and the third party
django-registration app (commit c415a)

-   List dependencies from the official repos
-   Permission checks when uploading packages

Only users who maintain the package or users of higher status (dev, TU)
can upload packages

-   Parsing of pkgbuilds, we can no longer use bash to do it because
    bash sucks and is riddled with security flaws. This is really
    important.
    -   One solution would be to create our own, minimal, bash parser
        using tools such as Lex/Yacc, Flex/Bison or natively in Python
        using PLY. This would probably be the best option as we have
        complete control over the security and features available. The
        obvious downsides are that the parser will probably be more
        buggy, less accurate, and we have to maintain it.
    -   The parched project has been started to provide a (Python)
        PKGBUILD parser. This will be made into bindings for pkgparse.
    -   The pkgparse project has been started to provide a PKGBUILD
        parser using Lex/Yacc.

-   Unit tests
    -   Any ideas on testing file based operations (package
        uploading/removal)? So far all I can think of is changing
        MEDIA_ROOT to a temporary directory and just going from there,
        but it would also require duplicating some code from
        PackageSubmitForm -- Xilon

Medium priority

-   Caching
-   API
-   TU voting app (This should be a separate django app)
-   RSS/Atom feeds
-   Migration (South appears to be a strong contender).

Low priority

-   Download counter
-   Think about changing the way submitting and updating packages works.
-   Internationalisation

The code is i18n aware and mostly prepared for it, we just need a
frontend interface to set the language and the actual translations. Best
to leave this till the end.

-   OpenID support

> Interested in helping development?

If you're interested in helping contributing to development, please add
your name to the list below. Discussions are being held on aur2-dev.

-   Thralas: Fluent in PHP, yet willing to learn python and possibly
    ruby
-   Xilon: Fluent in PHP, familiar with Python and Django. XHTML, CSS,
    and even artwork!
-   Louipc: General programming/scripting knowledge. HTML, CSS, etc. If
    you have code I can learn it and hack it. Maybe.
-   Husio: HTML, CSS, JavaScript (jQuery), Python - almost fluent in
    Django.
-   Zio: HTML,PHP,Perl,Python,Ruby,C# I'm rewriting makepkg in Ruby for
    uArch.org. I can help out with testing design w/e.
-   Rcoyner: Fluent in Java, PHP, Python and very experienced with
    Django.
-   Angvp: Very experienced with PHP,JavaScript,XHTML,CSS, and fluent in
    Python, Django.
-   Andrewjames: Programmer in PHP, JavaScript, XHTML, CSS. Less
    asciidoc, python, ruby, lua
-   void: Experienced in Django development, XHTML, CSS. I can help with
    the Django site/backend implementation, also have some experience
    implementing REST JSON webservices in Django.
-   Djszapi: Some experience in C, Assembly, Python, Lua, Javascript,
    HTML, CSS.
-   SpeedVin: Shell,XHTML/HTML,CSS,Python.
-   Cmb: C/C++, Java (servlets and JSP), Python, Perl. I'm teaching
    myself Django. I can write decent documentation in English.

Brainstorming
-------------

So I pose some questions to anyone who cares:

-   What works about the AUR now?
-   What doesn't work about the AUR now?
-   What kinds of things could be improved?
-   What features are missing?
-   What features are useless?

Address those questions and anything else you think is worth
contributing, below. When making suggestions, make sure you keep
security and practicality in mind. The AUR should not be more complex
than it needs to be.

API

In order to make the API useful, it must be well designed, simple, and
easy to use. There are a few "AUR clients" which currently scrape the
AUR site in order to gather information. By creating a useful API those
clients will be able to efficiently gather information, and possibly
even upload packages.

as I commented in the forum, the API could be implemented in Django
itself using django-piston. Also the Django views could return different
kind of responses in the same URLs depending on the content_type of the
request, this would make URLs unique for API calls and web client views.
---void

Draft

The API should make full use of the HTTP specification, and probably
also be RESTful.

Retrieving information

To retrieve information about a specific package, a GET request should
be sent:

    GET /api/package/package_name HTTP/1.1

The response should return with a 200 OK status code and contain all the
relevant information about a package:

    HTTP/1.1 200 OK
    Content-Type: application/json
    Content-Length: ...

    {
        "name": "package_name",
        "version": "1.0",
        "release": 1,
        "description": "An example package",
        "permalink": "https://aur.archlinux.org/package/package_name",
        "url": "http://www.example.com/package_name",
        "maintainers": ["dude", "guy"],
        "repository": "unsupported",
        "category": "x11",
        "tarball": "https://aur.archlinux.org/files/package_name/package_name.tar",
        "tarball_checksum": "5495d9c72dbba5c100835181317af780",
        "licenses": ["GPL"],
        "architectures": ["i686", "x86_64"],
        "depends": ["another_package"],
        "makedepends": [],
        "replaces": [],
        "conflicts": [],
        "provides: [],
        "outdated": false,
        "added": 1234567890,
        "updated": 1234567890,
        "groups": [],
        "comments": 0,
        "backup": [],
        "install": "https://aur.archlinux.org/files/package_name/files/package_name.install",
        "noextract": [],
        "sources": ["http://example.com/package_name.tar.gz", "https://aur.archlinux.org/files/package_name/files/Makefile"],
        "checksums": {
            "md5": ["d5770be2d9ca4b3ce2cbfc45943a6b9e", "0c74a27dff40c0f345136e8ec2109ab0"],
            "sha1": ["718e4460fb179fec0e5790244ce1e2f637eb9b94", "f83ebf093432d42f110e37425d6f2302a941e8c2"],
            ...
        }
    }

void: the packages could be identified by their unique URL, so for
example in depends you will return an array of the packages URLS, i.e:

    "depends": ["https://aur.archlinux.org/packages/another_package']

A list of all packages could be retrieved:

    GET /api/packages HTTP/1.1

But this would be very inefficient, instead the list should be queried:

    GET /api/packages?query=package&limit=50&orderby=name&offset=10 HTTP/1.1

The allowed parameters would be:

 query
    The actual query, which should be a URL encoded string. In order to
    greatly increase the flexibility and power of searching, it should
    be possible to search on various fields. The possible fields should
    be:

+--------------------------------------+--------------------------------------+
| Possible fields                      | Searching for these fields should be |
| -   maintainer                       | done by constructing a query similar |
| -   repository                       | to that on Google, e.g.,             |
| -   category                         | "maintainer:username OR              |
| -   license                          | maintainer:other_user",              |
| -   architecture                     | "repository:unsupported", etc.       |
| -   depends                          |                                      |
| -   makedepends                      | The difficult field is updated,      |
| -   conflicts                        | since it requires a range, one       |
| -   provides                         | solution would be to use             |
| -   updated                          | "updated>=2008-01-01 and update      |
| -   group                            | <=2009-01-01 E.g.,                   |
|                                      |                                      |
|                                      | The query "ng updated>=2008-01-01    |
|                                      | AND updated<=2009-01-01              |
|                                      | repository:unsupported" would return |
|                                      | all packages with "ng" in their name |
|                                      | and description, that were updated   |
|                                      | between 2008 and 2009, and are in    |
|                                      | the "unsupported" repository. The    |
|                                      | request should look like this:       |
|                                      |                                      |
|                                      |     GET /api/packages?query=ng+updat |
|                                      | ed%3E%3D2008-01-01+AND+updated \     |
|                                      |     %3C%3D2009-01-01+repository%3Aun |
|                                      | supported&limit=25&offset=0 HTTP/1.1 |
|                                      |                                      |
|                                      |                                      |
|                                      | The example query was edited to      |
|                                      | suggest that AUR2 use the format     |
|                                      | date YYYY-MM-DD. The format is       |
|                                      | standard defined at                  |
|                                      | http://www.w3.org/QA/Tips/iso-date.  |
|                                      | To conform with the standard:        |
|                                      |                                      |
|                                      | -   print the date in the format for |
|                                      |     a user to read wherever date is  |
|                                      |     written, for example, when they  |
|                                      |     choose the date from a calendar  |
|                                      |     or the listed date a package was |
|                                      |     updated, or the date of a        |
|                                      |     comment                          |
|                                      | -   send the date in the format to   |
|                                      |     query                            |
|                                      |                                      |
|                                      | To do, validate that to send hyphens |
|                                      | in GET request is fine               |
+--------------------------------------+--------------------------------------+

 orderby
    The field to order the results by. The order in which results are
    ordered should be descending. The client can reverse these results
    easily, so a order parameter is not necessary.
 limit
    The maximum amount of results to be returned
 offset
    The amount of results to omit in the results. E.g., with limit=10
    and offset=40, the results returned would be 40-50. This is mainly
    for pagination purposes.

void Say:

The package searching and listing could be also exposed in another set
of URLs with some parameters like:

gives you all the packages by maintainer

    /packages/mantainer/mantainer_id 

and this view would accept also parameters like ordering, limiting,
offset, etc. This makes URLs more readable and bookmarkeable :)

some information about packages could be exposed in another url like
dependencies could be shown in

    /packages/package_id/depends

Which would return the results:

    HTTP/1.1 200 OK
    Content-Type: application/json
    Content-Length: ...

    [
        {
            "name": "a_package",
            ...
        },
        {
            "name": "another_package",
            ...
        },
        ...
    ]

Whether there will be comments for packages or not determined, however
should there be any, it would be nice to retrieve them as well. To
retrieve comments for a package, a GET request should be sent:

    GET /api/package/some_package/comments?limit=10&offset=0

 limit
    The maximum amount of results to be returned
 offset
    The amount of results to omit in the results. E.g., with limit=10
    and offset=40, the results returned would be 40-50. This is mainly
    for pagination purposes.

Upon success a 200 OK response will be returned.

    HTTP/1.1 200 OK
    Content-Type: application/json
    Content-Length: ...

    [
        {
            "author": "username",
            "author_url": "https://aur.archlinux.org/profile/username",
            "author_email": "username@gmail.com",
            "comment": "This package is the best thing since sliced pineapple!",
            "submit_date": 1234567890
        },
        {
            "author": "another_user",
            "author_url": "https://aur.archlinux.org/profile/another_user",
            "author_email": "another_user@gmail.com",
            "comment": "I totally agree",
            "submit_date": 1234567900
        }
    ]

To retrieve all notifications about a package for a user, send a GET
request::

    GET /api/package/some_package/notifications HTTP/1.1

This will return all the notifications a user has subscribed to. The
exact information returned is not determined yet, but it would be
something like::

    HTTP/1.1 200 OK
    Content-Type: application/json
    Content-Length: ...

    [
        {
            "title": "update_notification"
            "settings": {
                "digest": True,
            }
        },
        ...
    ]

Manipulating Packages

* * * * *

It would be handy if 3rd party clients were able to also upload and
modify packages. This would obviously require authentication first.

To upload a package a POST request should be sent:

I am not entirely sure on the format of a multipart POST entity body

    POST /api/packages HTTP/1.1
    Content-Type: multipart/form-data; boundary=---1234567890---
    Content-Length: ...

    ---1234567890---
    Content-Disposition: form-data; name="repository"

    unsupported
    ---1234567890---
    Content-Disposition: form-data; name="package"; filename="some_package.tar"
    Content-Type: application/x-gtar

    <tarball data>

If the upload is successful the response should be with a 201 Created
status:

    HTTP/1.1 201 Created
    Location: https://aur.archlinux.org/package/some_package
    Content-Type: application/json
    Content-Length: ...

    {
        "name": "some_package",
        ...
    }

Updating an existing package should be done by sending a PUT request:

    PUT /api/package/some_package HTTP/1.1
    Content-Type: multipart/form-data; boundary=---1234567890---
    Content-Length: ...

    ---1234567890---
    Content-Disposition: form-data; name="package"; filename="some_package.tar"
    Content-Type: application/x-gtar

    <tarball data>

On success a ``200 OK`` status will be returned.

To subscribe a user to package notifications, a PUT request should be
sent::

    POST /api/packages/some_package/notifications HTTP/1.1
    Content-Type: application/json
    Content-Length: ...

    {
        "name": "update_notification",
        "settings": {...},
    }

And to modify the settings::

    PUT /api/packages/some_package/notification/update_notification HTTP/1.1
    Content-Type: application/json
    Content-Length: ...

    {
        "settings": {...},
    }

To unsubscribe a DELETE request should be sent::

    DELETE /api/package/some_package/notification/update_notification HTTP/1.1

Note: The specifics of notifications has not been determined yet.

Content Types

By default JSON should be used as the content type, as it is lightweight
and can represent everything we need. It should be possible to specify
and alternate format by appending an extension to the URL, as per Ruby
on Rails convention:

void: django-piston makes really easy to provide different view formats
for the same data, we could serve any format depending on request or on
a parameter.

    GET /api/package/some_package.xml HTTP/1.1

    HTTP/1.1 200 OK
    Content-Type: application/xml
    Content-Length: ...

    ...

Versioning

There are bound to be changes to the API, so some indication of the
current version should be present. It is possible to define custom HTTP
headers, so this seems to be the simplest way to go. Each response from
the server should contain this header to indicate the version being
used:

    HTTP/1.1 200 OK
    X-AURAPI-Version: 1.0

If the header is specified in a request, the specified version should be
used. For instance if the current version is 2.0:

    GET /api/packages HTTP/1.1
    X-AURAPI-Version: 1.5

    HTTP/1.1 200 OK
    X-AURAPI-Version: 1.5

void: when making backward incompatible changes could be good to provide
the old api in another url like /api/1.0 /api/1.5 so clients that
haven't updated could continue working.

Authentication

Ideally a widely used standard, such as OAuth should be used.

void: django-piston provides OAuth out of the box

Ideas

-   The AUR should be scalable and try to remain more generic. So it
    should be simple enough that I could easily deploy it for internal
    use in my office, and robust enough to run on archlinux.org.

-   I already like the old AUR, so I'm not sure we need an AUR2, but
    this is ONLY because I can access it from yaourt. So if a new AUR is
    made I think cmd-line access should be made just as easy/easier.
    Other things to consider is correct transition from the old AUR
    keeping all users not to mention PKGBUILDS & files intact without
    any problems.
    -   Maybe AUR2 should implement something like JSON but for bash:
        provide a script that fills an array with the results of a query
        (be it a search or package details) so it can then be sourced
        and ready to rock, without AWK|Sed work on the client side. --
        Phrodo_00 19:57, 6 April 2008 (EDT)

-   The User Interface does need a bit of a polish it's a bit wonky but
    those small bugs should be fixed on redesign, as for the system it
    self, I think it's brilliant - there are some good alternatives that
    might also work, for example on package ownership; if a package was
    owned/maintained by multiple people that would be smashing, some
    times I come across some PKGBUILD scripts that are just inefficient
    and/or out of date and contacting the owner seems impossible, if the
    package worked like a group, the package creator, group member, TU
    or even the System ( if the request is not answered in a week or
    some odd timeout ) could approve new maintainers. Also an API might
    be great, that might make the whole experience better in the long
    run by adding people to make some apps. -- thewonka -- 23:36, 25
    December 2006 (PST)
    -   The database structure allows for this but security policies and
        such still need implementing. -- Xilon

-   You should be able to search by entering the URL, just like on
    https://www.archlinux.org/packages/search/?q=packagename. It is easy
    to enter few strings in a browser and search for packages directly
    from the browser. URL should generaly be more descriptive.
    -   you can actually do that in the AUR as well:
        https://aur.archlinux.org/packages.php?K=foo. uppercase param is
        icky though. q would be better. --huma

-   Current time out message is annoying. Time out message shouldn't
    disrupt your AUR browsing, searching, etc. User shouldn't be forced
    to press back and search again just because his session timed out.

-   things bugging me:

1.  disable browser caching, it leads to trouble when encountering the
    already mentioned timeout
2.  display versioned dependencies
3.  features like searching in comments and displaying the pkgs one has
    voted for or enabled comment notifications would be nice

-   Whenever the AUR asks the user to log in, there should be an easy
    way to log in and then return to that page. Often, I want to vote
    for a package, but I have to go back to the main page, login, and
    then search for the package again.
    -   Implemented. - Xilon

-   There should definitely be some XML-RPC interface, because now
    external utilities (like aurbuild, aurscripts, etc.) must parse HTML
    pages (which is really wrong approach).
    -   i found this project for django framework: django-xmlrpc. not
        sure about its state though. has anyone tried it? --huma
    -   I'm looking into it. A JSON interface would probably be more
        suitable since XML is just too heavy weight and hard to parse.
        I'd imagine yaourt and similar would have to parse it manually.
        - Xilon
        -   XML-RPC isn't the same thing as parsing normal html page.
            But, we can use XML-RPC, SOAP, REST or just generate
            specific XHTML page, that would be easy to parse. Anyway, as
            far as using AUR from web browser isn't so popular, it's IMO
            the main thing to code. Also uploading packages by done by
            script would be nice. --Husio 14:57, 24 January 2008 (EST)
        -   See AUR_2#API --Xilon (Tue 17 Feb 2009 16:44:09 WST)

-   There should be email notifications for package maintainers about
    marking their package as out-of-date and about new entry in
    discussion under their packages.

-   The login dialog should be in the header so you have access it
    whenever. I think haing it on only one page and having no easy way
    to get back to what you're doing is dumb. Also emphasis on the
    timeout page and the wonky interface like some options for packages
    are available on the search page while other are only in the package
    details. They should be available on both pages and in the same spot
    on both.

-   AUR2 should check if the deps of the PKGBUILD exist, something like
    colored link (red for non existing packages, orange for packages in
    unsupported and green for the official repos)
    -   I second this, the package should show where the dependencies
        are (AUR, or other repos --void
    -   This is not really possible since the AUR does not have access
        to the main database (where the official repos are). It would be
        impossible determine if a package exists without this
        information. We would have to look at merging the databases or
        implementing some sort of IPC. - Xilon
    -   I think this kind of integration with the main site would be
        easy to implement, is as simple as making a request to the arch
        site packages search url and checking for response, but some
        better interface could be provided by main arch site. - void

-   should not allow uploading PKGBUILD without the license=tag *FIXED
    IN LATEST SVN*

-   It might be useful to have a votes/date chart, just to know if the
    package is still requested or not

-   It should use standard Atom 1.0 instead of RSS 2.0 as syndication
    format.

-   Add a function to search outdated packages for a specified location
    (as community, extra). --by STiAT

-   Throw in some lint checks of PKGBUILDs. There are a lot of messy,
    non-standards-conforming PKGBUILDs out there, and I believe some
    script could be fashioned in order to check these PKGBUILDs for
    consistency against the PKGBUILD standards (proper variable order,
    proper content, etc). These checks could be made automatically upon
    upload, reorder the PKGBUILD and pass a small info line on the
    bottom 'your PKGBUILD has been rearranged. Please read <here> for
    info on how it should look, and <here> to see what exactly was
    sorted.' <- The info on what was rearranged I'm thinking something
    alike the w3.org validator list. Had the reordering been too much
    strain on the aur servers (which I doubt) the PKGBUILD could be
    simply rejected with a "bofh'y" info line 'this pkgbuild is wrong.
    fix it!'. I'd naturally opt for solution number one. by imachine
    -   Various checks and possibly normalisation is planned, but
        rearranging variable order is not necessary imo. - Xilon
    -   Could also be worthy to check if packages with the same (some
        identifier fields as project website) exists already in the
        database and show them to the user before accepting the
        submission, this would help to reduce duplication. - void

-   Also, when searching aur for packages, and having the search come up
    with more than one page of results, having a direct link to the
    result page, numbered, like 1 2 3 4 5 on the bottom instead of just
    'forward' 'backward' would be great. Currently, searching for say
    orphaned packages and getting to packages starting with a late
    letter, say, 'n', even with 100 results per page, takes unnecesarily
    valuable time skipping through pages of no interest with the 'next'
    and 'previous' buttons at the bottom. by imachine
    -   it would be also nice to add some basic regexp support. --huma
    -   Numbered pagination is already implemented. Regexp will most
        likely be implemented. Django has in-built support for it. -
        Xilon
    -   Searching is a very important feature of AUR, I think that we
        need full text searching here, django-haystack provides this
        with different backends. --void

-   It should all be a WIKI.

-   Have the back-end interface with the chosen SCM directly. Comments
    posted by maintainers upon uploading a new package would act as the
    commit message. This will allow for some cool features like diffs
    between commits and such.
    -   I think this is a great idea. Have the back-end similar to the
        current ABS, such that I can synchronize and diff between
        different versions of PKGBUILDs. For example, new versions of
        kernel packages tend to have major changes that affect the
        PKGBUILD as well as the included patches. The only way to merge
        these changes is through a manual diff between the PKGBUILD and
        all related files in the directory. A distributed SCM such as
        Mercurial or GIT would work well here, since AUR users tend to
        customize PKGBUILDs with their own patches, and a distributed
        SCM would lend well for each user to maintain their own
        "branch". --Mintcoffee 11:12, 26 June 2008 (EDT)
    -   This could be implemented as git hooks that interact with the
        api. - void

-   LDAP SUPPORT

-   i think we should distinguish unsupported repo from the rest of aur.
    its packages are not checked by tu's and may not conform to Arch
    Packaging Standards, which doesn't add reliability to aur as a
    whole. it would be a good idea to keep it away from the clean
    community repo. packages quality should be high on our priority list
    to keep a good reputation of aur and happy experience of the arch
    users. as a side note, i think we should implement the package
    verification on upload. it would ease the work of tu's and keep us
    from broken or bogus packages. --huma

-   Show number of downloads. -- UnbreakableMJ 06:31, 9 October 2007
    (EDT)

-   Git, Mercirial, Bazaar suport to control your PKGBUILDs. It's not
    easy to manage PKGBUILDs. Little change, then you have to pack it
    and send to AUR. It would be nice, if I can just send my (git,
    mercurial or bazaar) repo to AUR, and script will get the last
    change and make update on server. It doesn't have to use (git,
    mercurial, bazaar) as version control system, and store all those
    files. --Husio 03:10, 29 May 2008 (EDT)
    -   The AUR package upload interface could accept some repo urls and
        fetch the PKGBUILDS from there, something like you will do in a
        RSS agregator - void

-   Add support for the main Arch repos ([core], [extra], etc.). --
    [[User:deltaecho|deltaecho]

-   Add support for multiple PKGBUILD maintainers (I saw this request
    somewhere on the forums). -- [[User:deltaecho|deltaecho]

-   Free user tagging and/or more packager categories. Tagging would
    allow much better searching and browsing than what is currently
    possible. Could be complemented/supplanted by having more
    descriptive categories in the PKGBUILD, e.g.

     pkgname=transmission
     interface=cli,daemon,gtk,web (yeah, i know the different interfaces aren't packaged together - it's just an example)
     category=network
     type=bittorrentclient
     features=('bandwidth caps' 'peer exchange' 'download priorities' 'encryption' '...' )
     lastupdate=09112008
     ...

which would allow you to search for a bittorrent client with a gtk
interface, that was being actively developed with peer exchange (or some
other feature X to the extent that features can be standardized - at any
rate it wouldn't need to be a particularly exact science to be useful)
-- Chochem 12:18, 21 December 2008 (EST)

-   Extra metainformation could be handled by some clients without
    modifiying the PKGBUILD format, altought I think that taggin would
    be a great addition and help to find packages. - void
-   another good metainformation could be to mark a package as a
    "alternative" to another, like pidgin-mini is an alternative of
    pidgin, mutt-ncurses is an alternative to mutt. This information
    could be obtained from the provides PKGBUILD field. Also package
    pages could link to "related packages" (other alternatives of the
    same package for example, or other packages with the same upstream
    URL). - void
-   This would likely not be added to the PKGBUILD spec, thought I can't
    really say on behalf of the pacman devs. A more generic attribute
    "tag" could be added to the AUR database, which could contain such
    information. There is a feature request for a "categories"
    attribute, which would allow packagers to specify the categories
    themselves, instead of it being forced. --Xilon
-   having a standardized categories tree makes both supported packages
    and aur packages compatible, the AUR main page should provide links
    to list packages by category as CPAN. Free tagging is really useful
    for narrowing down searches and finding "relations" between
    packages. - void

-   I think that the main change that needs to be made to the AUR is a
    restructuring of how development happens there (PKGBUILD
    development, not the AUR itself). I think we need a new model, with
    the AUR PKGBUILD development organized like any other open-source
    project, and the TUs are the maintainers, able to make changes at
    will and commit changes to anything. The users, then, have commit
    rights only to their own packages. Then, a central way to offer up
    nice changes to both the TUs and the maintainer of whatever package,
    so that it can be quickly updated by someone, anyone. Obviously, TUs
    should be polite when editing others' PKGBUILDs, and comment on what
    was changed and why, but that would make things SO much simpler.
    Perhaps some light wikification, too -- encourage users to offer
    quick one/two-line suggestion edits which a TU or maintainer must
    then put in place. The current model is broken, because it's like we
    have several thousand sub-projects, each one being a PKGBUILD, and
    each project having its own overhead when trying contribute to it.
    Strict regulations should also be put in place over PKGBUILD syntax,
    etc., and if a package does not meet those guidelines, it will be
    deleted. In part automated, like automatic namcap runs over
    submitted packages. If we move away from bash to something easily
    parsable, this will be made much easier. --Ranguvar 23:04, 24
    November 2009 (EST)

Retrieved from
"https://wiki.archlinux.org/index.php?title=AUR_2&oldid=238157"

Category:

-   Arch development
