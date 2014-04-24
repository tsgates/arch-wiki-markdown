Help:i18n
=========

This article serves as a comprehensive guideline for ArchWiki
internationalization and localization.

See also International communities.

Contents
--------

-   1 Guidelines
    -   1.1 Article titles
    -   1.2 Localized redirects
    -   1.3 Interlanguage links
        -   1.3.1 Finding articles with specific interlanguage links
-   2 Languages
    -   2.1 Adding local interlanguage links
    -   2.2 Adding external interlanguage links
    -   2.3 Moving local languages to external wikis

Guidelines
----------

Note:The following guidelines apply to articles included on the English
ArchWiki. See International Wikis (2010 edition) for the latest
discussion regarding the new interwiki implementation.

> Article titles

Non-English article titles must be of the form "Title in English
(Language)" where "Language" is the localized spelling of said language.
Note the space between the title and the language tag. For example:
Beginners' Guide (Nederlands). English titles should not include a
language tag.

Also note that in case of sub-pages, the language tag still goes at the
end, so "Title (Language)/Sub-page" is wrong, while "Title/Sub-page
(Language)" is correct. For example: PulseAudio/Examples (Italiano).
This may seem inconsistent, but it is more practical and safe for bots
to detect the language of an article.

The root categories for every language are the only exception to this
rule, as they must not repeat the language name in a suffix.

See #Languages for a list of languages and expected localized spellings.

Rationale:

-   English titles facilitate administration; all administrators
    understand English, but may not be multilingual. When browsing
    Special:RecentChanges and other special pages, admins need to know
    what is being edited without resorting to external translation
    programs.
-   Standardized article titles simplify inter-language linking.

> Localized redirects

Localized titles can and should be created, but must redirect to the
English-named article as described above. Redirect titles need not
include language tags. For example: Guía para Principiantes redirects to
Beginners' Guide (Español).

Rationale:

-   Localized titles improve navigability for international readers.
    Both the internal search feature and external search engines can
    utilize such redirects.
-   Useful redirects facilitate internal linking.

> Interlanguage links

If an article exists in more than one language, please add interlanguage
links at the top of each translation:

    [[de:Title]]
    [[en:Title]]
    [[es:Title]]

Note:Interlanguage links add the suffix mentioned in #Article titles
automatically, so the interlanguage link associated to e.g. Main Page
(Dansk) is [[da:Main Page]].

See #Languages for a list of the available language tags. See
Help:Style#Interlanguage links for usage guidelines.

Rationale:

-   Including inter-language links at the beginning of an article allows
    international readers to promptly determine whether content is
    available in their language, and similarly allows translators to
    ascertain whether an article requires translation.

Finding articles with specific interlanguage links

In order to obtain a list of the articles with interlanguage links
pointing to a specific title (language backlinks), use:

https://wiki.archlinux.org/api.php?action=query&list=langbacklinks&lbllimit=500&lblprop=lltitle&lbllang=en&lbltitle=Main%20Page

This example looks for ([[en:Main Page]]), but for other links it is
enough to change the value of lbllang and lbltitle.

If you want to obtain a list of the articles using interlanguage links
of a specific language, just omit the lbltitle key:

https://wiki.archlinux.org/api.php?action=query&list=langbacklinks&lbllimit=500&lblprop=lltitle&lbllang=de

This example uses German (de), but for the other languages it is enough
to change the value of lbllang.

Note:This query may not find all redirects using interlanguage links
(not Help:Style-compliant by the way, except when #Adding external
interlanguage links): a search like this should work instead (if you get
zero results it means that everything is fine).

Note that API queries are always limited, so if a language has more than
500 backlinks it will be necessary to continue the search adding the
lblcontinue attribute that appears at the bottom of the list to the
query string.

Languages
---------

The following table lists all languages encountered on the wiki along
with related links.

English name

Localized name

Subtag

Root category

External wiki

Arabic

العربية

ar

Category:العربية

Bulgarian

Български

bg

Category:Български

Catalan

Català

not supported 1

Category:Català

Chinese (Simplified)

简体中文

zh-CN

Category:简体中文

Chinese (Traditional)

正體中文

zh-TW

Category:正體中文

Croatian

Hrvatski

hr

Category:Hrvatski

Czech

Česky

cs

Category:Česky

Danish

Dansk

da

Category:Dansk

Dutch

Nederlands

nl

Category:Nederlands

English

English

en

Category:English

Esperanto

Esperanto

not supported 1

Category:Esperanto

Finnish

Suomi

fi

Category:Suomi

http://www.archlinux.fi/wiki/

French

Français

fr

—

http://wiki.archlinux.fr/

German

Deutsch

de

—

https://wiki.archlinux.de/

Greek

Ελληνικά

el

Category:Ελληνικά

Hebrew

עברית

he

Category:עברית

Hungarian

Magyar

hu

Category:Magyar

Indonesian

Bahasa Indonesia

id

Category:Indonesia

Italian

Italiano

it

Category:Italiano

Japanese

日本語

ja

Category:日本語

Korean

한국어

ko

Category:한국어

Lithuanian

Lietuviškai

lt

Category:Lietuviškai

Norwegian (Bokmål)

Norsk Bokmål

not supported 1

Category:Norsk Bokmål

Persian

فارسی

fa

—

http://wiki.archlinux.ir/

Polish

Polski

pl

Category:Polski

Portuguese

Português

pt

Category:Português

Romanian

Română

ro

—

http://wiki.archlinux.ro/

Russian

Русский

ru

Category:Русский

Serbian

Српски (Srpski)

sr

Category:Српски

http://wiki.archlinux.rs/

Slovak

Slovenský

sk

Category:Slovenský

Spanish

Español

es

Category:Español

Swedish

Svenska

sv

—

http://wiki.archlinux.se/

Thai

ไทย

th

Category:ไทย

Turkish

Türkçe

tr

—

http://archtr.org/wiki/

Ukrainian

Українська

uk

Category:Українська

Vietnamese

Tiếng Việt

not supported 1

—

http://archlinuxvn.tuxfamily.org/

1 The not supported note in the "Subtag" field means that interlanguage
links for that language are not available. See #Adding local
interlanguage links and #Adding external interlanguage links.

For information regarding subtags, please see:

-   http://www.iana.org/assignments/language-subtag-registry
-   http://tools.ietf.org/rfc/bcp/bcp47.txt
-   http://rishida.net/utils/subtags/

> Adding local interlanguage links

If you want interlanguage links to be enabled for a new language hosted
in wiki.archlinux.org, please open a request in Help talk:i18n. Note
that a minimum number of translated articles will be required by the
administrators for the request to be fulfilled. Setting up an external
wiki is however always preferable.

> Adding external interlanguage links

If you want interlanguage links to be set for a new or existing language
that has set up a separate wiki, please open a request in Help talk:i18n
or directly contact one of the ArchWiki:Administrators: the
interlanguage links will be set as soon as possible!

> Moving local languages to external wikis

Moving local languages to their own wikis is a very welcome and
encouraged thing, which will get all the assistance that is needed. The
procedure consists on setting up temporary interlanguage links that will
be used to redirect the various articles to the external wiki as they
are moved one by one. Once the move is complete, all the local redirects
will be deleted and the regular interlanguage links will be pointed to
the external wiki.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Help:I18n&oldid=299612"

Category:

-   Help

-   This page was last modified on 22 February 2014, at 02:00.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
