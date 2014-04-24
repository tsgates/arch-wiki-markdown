Help:Style
==========

Related articles

-   Help:Style/Formatting and punctuation
-   Help:Style/White space
-   Help:Editing
-   Help:Reading

These style conventions encourage tidy, organized, and visually
consistent articles. Follow them as closely as possible when editing the
ArchWiki.

Contents
--------

-   1 Article pages
    -   1.1 Title
    -   1.2 Layout
    -   1.3 Magic words
    -   1.4 Categories
    -   1.5 Interlanguage links
    -   1.6 Article status templates
    -   1.7 Related articles box
    -   1.8 Preface or introduction
    -   1.9 Section headings
    -   1.10 Code formatting templates
    -   1.11 Command line text
    -   1.12 File editing requests
    -   1.13 Keyboard keys
    -   1.14 Package management instructions
        -   1.14.1 Official packages
        -   1.14.2 AUR packages
        -   1.14.3 Unofficial repositories
    -   1.15 Kernel module operations
    -   1.16 Daemon operations
    -   1.17 Notes, Warnings, Tips
    -   1.18 Shells
    -   1.19 Hypertext metaphor
    -   1.20 Coding style
    -   1.21 Supported kernel versions
    -   1.22 "Tips and tricks" sections
    -   1.23 "Troubleshooting" sections
    -   1.24 "Known issues" sections
    -   1.25 "See also" sections
    -   1.26 Non-pertinent content
    -   1.27 Language register
-   2 Discussion pages
-   3 Category pages
-   4 Redirect pages
-   5 Template pages
-   6 User pages
-   7 Generic rules
    -   7.1 Edit summary
    -   7.2 HTML tags

Article pages
-------------

> Title

-   Titles should use sentence case, e.g. "Title for new page" is
    correct, while "Title for New Page" is not. Note that common words
    that are part of a proper name or an upper-case acronym must be
    capitalized, e.g. "Advanced Linux Sound Architecture", not "Advanced
    Linux sound architecture".   
     Namespaces are not considered part of titles, so "ArchWiki:Example
    article" is correct, while "ArchWiki:example article" is not.
    Subpage names should start with a capital letter, so "My page/My
    subpage" is correct, while "My page/my subpage" is not.
-   If the subject of the article is commonly known both with the full
    name and the acronym, prefer using the full name in the title of the
    article. Do not include both the full name and the acronym (e.g. in
    parentheses) in the title, but rather use a redirect on the acronym
    page that points to the page titled with the full name.
-   See the Help:Article naming guidelines article for more information.

> Layout

-   Order elements in an article as follows:

1.  #Magic words (optional)
2.  #Categories
3.  #Interlanguage links
4.  #Article status templates (optional)
5.  #Related articles box (optional)
6.  #Preface or introduction
7.  Table of contents (automatic)
8.  Article-specific sections

> Magic words

-   Behavior switches — and in general, all of the magic words that
    change how an article is displayed or behaves but do not add content
    by themselves — should all go at the very top of articles.   
     This rule applies in particular to {{DISPLAYTITLE:title}} and
    Template:Lowercase title, which makes use of the former.

> Categories

-   Every article must be categorized under at least one existing
    category.
-   An article can belong to more than one category, provided one is not
    ancestor of the others.
-   Categories must be included at the top of every article, right below
    any magic words.
    Note:This is different from some other MediaWiki projects such as
    Wikipedia, which include categories at the bottom.
-   There should be no blank lines between categories and the first line
    of text (or interlanguage links, if present), because this
    introduces extra space at the top of the article.
-   See the Help:Category article for more information.

> Interlanguage links

-   If the article has translations in the local or an external Arch
    Linux wiki, interlanguage links must be included right below the
    categories and above the first line of text.   
     Note that they will actually appear in the appropriate column to
    the left side of the page.
-   There should be no blank lines between interlanguage links and the
    first line of text, because this introduces extra space at the top
    of the article.
-   When adding or editing interlanguage links you should take care of
    repeating your action for all the already existing translations.
-   Do not add more than one interlanguage link for each language to an
    article.
-   Do not add interlanguage links for the same language of the article.
-   The interlanguage links must be sorted alphabetically based on the
    language tag, not the local name, so for example [[fi:Title]] comes
    before [[fr:Title]] even though "Suomi" would come after "Français".
-   See the Help:i18n and Wikipedia:Help:Interlanguage links articles
    for more information.

> Article status templates

-   Article status templates can be included right below the categories
    (or interlanguage links, if present) and right above the
    introduction (or the Related articles box, if present).
-   Article status templates can also be used inside article sections,
    when appropriate.
-   Always accompany an article status template with some words of
    explanation in the dedicated field (examples are provided in each
    template's page), possibly even opening a discussion in the talk
    page.

> Related articles box

-   Provides a simple list of related internal articles.
-   Optionally included right below categories (or interlanguage links,
    or Article status templates, if present).
-   It can only be made of Template:Related articles start,
    Template:Related and Template:Related articles end. See also the
    guidelines in those pages.
-   Non-English articles can make use of Template:Related2 for
    translating the anchor text.
-   Use the "See also" section for a more complete and detailed list
    that also includes link descriptions and interwiki or external
    links.

> Preface or introduction

-   Describes the topic of the article.   
     Rather than paraphrasing or writing your own (possibly biased)
    description of a piece of software, you can use the upstream
    author's description, which can usually be found on the project's
    home page or about page, if it exists. An example is MediaTomb.
-   Included right above the first section of the article.
-   Do not explicitly make an ==Introduction== or ==Preface== section:
    let it appear above the first section heading. A table of contents
    is shown automatically between the preface and first section when
    there are sufficient sections in the article.
-   See Help:Writing article introductions for more information.

> Section headings

-   Headings should start from level 2 (==), because level 1 is reserved
    for article titles.
-   Do not skip levels when making subsections, so a subsection of a
    level 2 needs a level 3 heading and so on.
-   Headings use sentence case; not title case: My new heading; not My
    New Heading.
-   Avoid using links in headings because they break style consistency
    and do not stand out well enough. Usually the anchor text is also
    found in the section content, otherwise you can use a simple
    sentence like See also My new page.   
     For the same reason, also avoid using any kind of HTML or wiki
    markup code, including #Code formatting templates. See also
    Help:Style/Formatting and punctuation.
-   See the Help:Effective use of headers articles for more information.

> Code formatting templates

-   Use {{ic|code}} for short lines of code, file names, command names,
    variable names and the like to be represented inline, for example:
      
     Run sh ./hello_world.sh in the console.
-   Use {{bc|code}} for single or multiple lines of code (command line
    input or output code and file content) to be represented in a proper
    frame, for example:

    $ sh ./hello_world.sh

    Hello World

    #!/bin/sh

    # Demo
    echo "Hello World"

For short lines of code, you can just start them with a space instead of
using {{bc|code}} (see Help:Editing).

-   Use {{hc|input|output}} when in the need of representing both
    command line input and output, for example:

    $ sh ./hello_world.sh

    Hello World

-   When you need to represent file content and you feel it may be
    difficult for readers to understand which file that code refers to,
    you can also use {{hc|filename|content}} to show the file name in
    the heading, for example:

    ~/hello_world.sh

    #!/bin/sh

    # Demo
    echo "Hello World"

-   See the Help:Template article for more information and for
    troubleshooting problems with template-breaking characters like = or
    |.

> Command line text

-   When using block code (Template:bc), introduce each command with a
    proper prompt symbol. When using inline code (Template:ic), though,
    no prompt symbol is to be represented, but any notes about
    permissions must be added explicitly to the surrounding text.
-   In block code, use $ as a prompt for regular user commands; use # as
    a prompt for root commands.
    Note:Because # is also used to denote comments in text files, you
    should always make sure to avoid ambiguities, usually by explicitly
    writing to run the command or edit a text file.
-   The sentence introducing a command should usually end with :.
-   Prefer using # command instead of writing $ sudo command unless it
    is really necessary.
-   Do not assume the user uses sudo or other privilege escalation
    utilities (e.g. gksu, kdesu).
-   # sudo command is redundant and must be avoided. The only exception
    is when sudo is used with the -u flag: in this case the prompt can
    match the others of the same code block, or default to $.
-   Do not add comments in the same box of a command (e.g.
    # pacman -S foo  #Install package foo)
-   Avoid writing excessively long lines of code: use line-breaking
    techniques when possible.

> File editing requests

-   Do not assume a specific text editor (nano, Vim, Emacs, etc.) when
    requesting text file edits, except when necessary.
-   Do not use implicit commands to request text file edits, unless
    strictly necessary. For example,
    $ echo -e "clear\nreset" >> ~/.bash_logout should be:

Append the following lines to ~/.bash_logout:

    clearreset

> Keyboard keys

-   The standard way to represent keyboard keys in articles is using
    instances of Template:ic.
-   Letter keys should be represented in lower case: a. To represent
    upper-case letters, use Shift+a instead of Shift+A or A.
-   The correct way to represent key combinations makes use of the +
    symbol to join keys, with no additional spaces around it, in a
    single instance of the template: Ctrl+c.   
     Ctrl + c, Ctrl+c, Ctrl-c are non-compliant forms, and should be
    avoided.
-   The following are the standard ways of representing some special
    keys:
    -   Shift (not SHIFT)
    -   Ctrl (not CTRL or Control)
    -   Alt (not ALT)
    -   Super (not Windows or Mod)
    -   Enter (not ENTER or Return)
    -   Esc (not ESC or Escape)
    -   Space (not SPACE)
    -   Backspace
    -   Tab
    -   Ins (not INS or Insert)
    -   Del (not DEL or Delete)
    -   Print Screen

> Package management instructions

Official packages

-   Please avoid using examples of pacman commands in order to give
    instructions for the installation of official packages: this has
    been established both for simplicity's sake (every Arch user should
    know pacman's article by memory) and to avoid errors such as
    pacman -Sy package or possibly never-ending discussions like the
    choice between pacman -S package and pacman -Syu package. All the
    more reason you should not suggest the use of pacman frontends or
    wrappers.   
     Instead, just use a simple statement like:   
     Install package from the official repositories.  
     Or, if for example the application name differs from the package
    name:   
     MyApplication can be installed with the package my-app-pkg,
    available in the official repositories.   
     The instructions for the installation of a list of packages may
    appear as:   
     Install package1, package2 and package3 from the official
    repositories.   
     You are granted the flexibility to adapt the wording to your
    specific article.
-   Links to the referenced packages are mandatory and should be created
    using Template:Pkg, for example {{Pkg|package}}.
-   The above examples also make use of an implicit link to the pacman
    article (e.g. [[pacman|Install]] ...) and one to official
    repositories ([[official repositories]]): these are recommended to
    be used at least on the first occurrence of an installation request,
    especially in articles that are more likely to be visited by Arch
    novices.
-   Examples of pacman commands are nonetheless accepted and even
    recommended in the Beginners' guide and its subpages.
-   If the package is hosted in the core, extra, or community
    repositories, do not make reference to the repository, thus
    facilitating maintenance because it is not uncommon for a package to
    be moved to a different repository. If however the package is hosted
    in an official repository which is not enabled by default (multilib,
    testing, etc.), mentioning it is required, using a wording like:   
     Install package from the official multilib repository.

AUR packages

-   Please avoid using examples of how to install AUR packages, neither
    with the official method nor mentioning AUR helpers: every user who
    installs unofficial packages should have read the Arch User
    Repository article, and be aware of all the possible consequences on
    his system.   
     Instead, just use a simple statement like:   
     Install package from the Arch User Repository.   
     You are granted the flexibility to adapt the wording to your
    specific article, see the section on #Official packages for more
    examples.
-   Links to the referenced packages are mandatory and should be created
    using Template:AUR, for example {{AUR|package}}.
-   You should always make clear that the package is unofficial, also
    linking to the Arch User Repository article or one of its redirects,
    e.g. AUR.

Unofficial repositories

-   When suggesting to use an unofficial repository for installing a
    pre-built package, do not provide instructions for enabling the
    repository, but make sure such repository is included in Unofficial
    user repositories and then simply link to it. Also, just like with
    official packages, do not add examples of pacman commands. For
    example:   
     Install package from the example repository.   
     If the package is also available in the AUR:   
     Install package from the Arch User Repository or the example
    repository.   
     If the package is available in the AUR with a different name:   
     Install aurpackage from the Arch User Repository or builtpackage
    from the example repository.   
     You are granted the flexibility to adapt the wording to your
    specific article.
-   The link to Unofficial user repositories is mandatory and should
    point to the relevant repository section, for example
    [[Unofficial user repositories#example|example]].

> Kernel module operations

-   Giving examples of how to load, remove, blacklist or perform any
    other basic operation with modules is deprecated: the standard
    phrasing is a list of the modules involved, possibly remarking
    dependencies or conflicts with other modules, a description of the
    actions to be performed, and a link to Kernel modules.
-   The Beginners' guide and its subpages are the only exceptions to the
    rule above.

> Daemon operations

-   Giving examples of how to enable, start, or perform any other basic
    operations with daemons is deprecated: the standard phrasing is a
    list of the daemons involved, possibly remarking dependencies or
    conflicts with other daemons, a description of the actions to be
    performed, and a link to systemd#Using_units or the full systemd
    article.
-   The Beginners' guide and its subpages are the only exceptions to the
    rule above.

> Notes, Warnings, Tips

-   A Note should be used for information that somehow diverges from
    what the user would naturally expect at some point in the article.
    This includes also information that gives more in-depth knowledge on
    something in particular that otherwise would be considered a bit
    extraneous to the article. Another example is when needing to point
    out a temporary announcement like a change in the name of a package.
      
     A Note can also be used to highlight information that is important
    but easily overlooked by someone new to the subject area.
-   A Warning should be used where the described procedure could carry
    severe consequences such as being reasonably difficult to undo or
    resulting in damage to the system. Warnings should generally
    indicate both the worst case scenarios as well as the conditions
    that could lead to or avoid such worst cases.
-   A Tip should indicate a method or procedure that could be useful and
    bring benefits to somebody, albeit not needed to complete the
    operation being dealt with, and therefore safely ignorable.
-   When two or more notes, warnings or tips have to appear one after
    each other at the same point of an article, prefer grouping their
    texts in a list inside a single template, avoiding stacking the
    templates unless they are completely unrelated. For example:

> Tip:

-   Tip example #1.
-   Tip example #2.

> Shells

-   Do not assume a particular shell as the user's shell (e.g. Bash),
    except when really needed: try to be as shell-neutral as possible
    when writing or editing articles.

> Hypertext metaphor

-   Try to interlink your article with as many others as you can, using
    the various keywords in the text.
-   For technical terms, such as system call, not covered by an article
    in the ArchWiki, link to the relevant Wikipedia page.
-   When linking to other articles of the wiki, do not use full URLs;
    take advantage of the special syntax for internal links:
    [[Wiki Article]]. This will also let the wiki engine keep track of
    the internal links, hence facilitating maintenance.   
     See Help:Editing#Links for in-depth information and more advanced
    uses of interwiki links syntax.
-   Avoid implicit links whenever possible. For example, prefer
    instructions like "See the systemd article for more information"
    instead of "See here for more information".
-   Except in rare cases, you should not leave an article as a dead-end
    page (an article that does not link to any other) or an orphan page
    (an article that is not linked to from any other).
-   Before writing a specific procedure in an article or describing
    something in particular, always check if there is already an article
    that treats that part in detail: in that case, link that article
    instead of duplicating its content.
-   If the upstream documentation for the subject of your article is
    well-written and maintained, prefer just writing Arch-specific
    adaptations and linking to the official documentation for general
    information.
-   Do not use interwiki links for links to localized pages of the same
    language of the article being edited because they will not be shown
    in Special:WhatLinksHere pages. For example, using [[:hu:Main Page]]
    in a Hungarian article is wrong, while [[Main Page (Magyar)]] is
    correct.   
     Using this kind of links between different languages is instead
    acceptable because this would make it easier to move the articles to
    a separate wiki in case a separate wiki is created in the future.   
     Finally, note the difference of this kind of links from
    #Interlanguage links, which do not have the colon at the beginning.

> Coding style

-   When adding commands or scripts, use a consistent coding style
    throughout the article, possibly also referring to the other
    articles, especially if there are any related ones. If available,
    respect the official or most common coding style guidelines for the
    language.
-   Avoid deprecated features of the programming/scripting language you
    are using: for example, use the $() syntax for shell command
    substitution instead of the backticks/grave (``) syntax.

> Supported kernel versions

-   Do not remove any notes or adaptations regarding kernel versions
    greater than or equal to the minimum version between the current
    linux-lts package in the core repository and the kernel on the
    latest installation media.

> "Tips and tricks" sections

-   Tips and tricks sections provide advanced tips or examples of using
    the software.
-   Use the standard title of Tips and tricks.
-   The various tips and tricks should be organized in subsections.

> "Troubleshooting" sections

-   Troubleshooting sections are used for frequently asked questions
    regarding the software or for solutions to common problems (compare
    to #"Known issues" sections).
-   Use the standard title of Troubleshooting. Common misspellings that
    should be avoided are Trouble shooting, Trouble-shooting, and
    TroubleShooting.
-   You can also report temporary workarounds for known bugs, but in
    this case, it is very desirable that you provide a link to the bug
    report. In case it has not been reported yet, you should report it
    yourself, thus increasing the chances that the bug will be properly
    fixed.   
     There are great benefits in linking to a bug report both for
    readers and editors:
    -   For readers, the Wiki does not become a stopping point: they can
        find more information close to the source that may have
        otherwise been missed by their search efforts.
    -   For Wiki editors, it makes cleanup easier by reducing the effort
        involved in researching whether the reported bug is still an
        issue; this can even lead to greater autonomy if the reader
        finds new information and comes back to edit the wiki.

> "Known issues" sections

-   Known issues sections are used for known bugs or usage problems
    which do not have a solution yet (compare to #"Troubleshooting"
    sections).
-   Use the standard title of Known issues.
-   If a bug report exists for the known issue, it is very desirable
    that you provide a link to it; otherwise, if it does not exist, you
    should report it yourself, thus increasing the chances that the bug
    will be fixed.

> "See also" sections

-   See also sections contain a list of links to references and sources
    of additional information.
-   This should be a list where each entry is started with *, which
    creates a MediaWiki bulleted list.
-   Use the standard title of See also. Other similar titles such as
    External links, More resources, etc. should be avoided.

> Non-pertinent content

-   Please do not sign articles, nor credit article authors: the
    ArchWiki is a work of the community, and the history of each article
    is enough for crediting its contributors.   
     Reporting the sources used to write an article, though, is good
    practice: you can use the "See also" section for this purpose.
-   Uploading files is disabled for normal users, and including the
    existing images in articles is not allowed. As an alternative you
    can include links to external images or galleries, and if you need
    to draw simple diagrams you may use an ASCII editor like Asciiflow.
    Rationale:
    -   Maintenance: Arch is rolling release, and images would make
        updating articles much more difficult.
    -   Necessity: Arch does not develop nor maintain any sort of GUI
        application, so we do not need to display any screenshot.
    -   Moderation: free image upload would require time to be spent
        removing oversized or inappropriate images.
    -   Accessibility: we support users with slow connections, text-only
        browsers, screen readers and the like.
    -   Efficiency: images waste server bandwidth and storage space.
    -   Simplicity: text-only articles just look simpler and tidier.

> Language register

-   Articles should be written using formal, professional, and concise
    language.
-   Remember not only to answer how, but also why. Explanatory
    information always goes further toward imparting knowledge than does
    instruction alone.
-   Avoid contractions: "don't", "isn't", "you've", etc. should be "do
    not", "is not", and "you have", for example.
-   Avoid unnecessary shortening of words: For example, instead of
    "repo", "distro", and "config", prefer "repository", "distribution",
    and "configuration".
-   Do not omit terms that are necessary to give an exact, unambiguous
    meaning to a sentence. For example, always add the word "repository"
    when mentioning the name of a repository.
-   Write objectively: Do not include personal comments on articles; use
    discussion pages for this purpose. In general, do not write in first
    person.

Discussion pages
----------------

-   Add new discussions at the bottom of discussion pages and include a
    proper heading. You can also make use of the + button at the top of
    each discussion page.
-   Indent your answers using colons at the beginning of new lines.
-   Do not edit your posts if someone has already replied; otherwise,
    you will break the flow of the discussion and make it difficult for
    others to further respond. Only striking (using the <s> HTML tag)
    words or sentences is allowed, but the related explanation should be
    given in a regular reply.
-   Always append a signature (using ~~~~) to your edits.
-   Discussion pages should not be categorized.
-   You should take care to strike the header of exhausted discussions
    using <s> HTML tags.   
     Exhausted discussions will be deleted three days or more after
    striking.
-   See also Help:Editing#Discussion pages.

Category pages
--------------

-   Every category must be appropriately categorized under at least one
    parent category, except for root categories.   
     Root categories are Category:DeveloperWiki, Category:Languages and
    Category:Sandbox.
-   A category can be categorized under more than one category, provided
    one is not ancestor of the others.
-   Avoid circular relationships: two categories cannot be reciprocal
    ancestors.
-   Do not categorize a category under itself (self-categorized
    category).
-   Categories must be included at the top of the category page.
-   Categories should not redirect.

Redirect pages
--------------

-   Redirect pages should contain only the redirect code and nothing
    else.
-   Redirect only to internal articles; do not use interwiki
    redirections.

Template pages
--------------

-   See Help:Template.

User pages
----------

-   Pages in the User namespace cannot be categorized.
-   Pages in the User namespace can only be linked from other pages in
    the User or talk namespaces, unless authorization to do otherwise is
    given by Administrators.

Generic rules
-------------

> Edit summary

-   The changes made daily to the articles are bravely checked by
    dedicated and voluntary patrols, whom you must help by making sure
    that all of your edits are accompanied by an explanatory phrase in
    the "Summary" field of the editor page.
    -   If the edit is minor, e.g. grammar or orthography corrections or
        the simple rewording of a sentence, a simple description of your
        edit is perfectly enough.
    -   If you are performing a major change — such as adding, moving,
        modifying or removing content — besides summarizing your edit,
        you should make sure to explain the reason why you edited the
        article, even linking to a discussion on the wiki or the forums,
        if one exists.
    -   An explanation is not mandatory in talk pages, where the why
        should be already evident.   
         When deleting exhausted discussions, however, some explanation
        words are required (e.g. "closed discussion", "fixed", etc.) and
        including also the title of the discussion could help retrieving
        it in the history, in case it needs to be reopened.

Tip:Take a look at the edit summaries in the Recent Changes to get an
idea of what you should write in your summary, but be warned that,
unfortunately, not all users respect these guidelines.

-   When performing major changes to articles, you should better try to
    split your work in multiple edits, based on the logical steps needed
    to complete the change.   
     Especially when moving sections (both within the same article or
    between two articles), you should avoid also modifying their content
    in the same edit; otherwise, it will be more difficult to check the
    consequent diff.

> HTML tags

-   Usage of HTML tags is generally discouraged: always prefer using
    wiki markup or templates when possible, see Help:Editing and
    related.
-   When tempted to use <pre>code</pre>, always resort to {{bc|code}}.
    When tempted to use <tt>text</tt> or <code>text</code>, always
    resort to {{ic|text}}.
-   Especially avoid HTML comments (<!-- comment -->): it is likely that
    a note added in a HTML comment can be explicitly shown in the
    article's discussion page.   
     You can add an appropriate Article status template in place of the
    comment.
-   Use <br> only when necessary: to start a new paragraph or break a
    line, put a blank line below it.   
     Common exceptions to this rule are when it is necessary to break a
    line in a list item and you cannot use a sub-item, or inside a
    template and you cannot use a list.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Help:Style&oldid=304703"

Category:

-   Help

-   This page was last modified on 16 March 2014, at 05:44.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
