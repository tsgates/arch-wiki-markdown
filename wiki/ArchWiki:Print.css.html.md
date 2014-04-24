ArchWiki:Print.css
==================

/* Do not print:

      1: When in mainspace: Article message boxes,
         navboxes, sister project boxes, disambig links,
         and items marked as metadata.
      2: section edit links.
      3: Show/hide toggles for collapsible items.

-   /

.ns-0 .ambox, .ns-0 .navbox, .ns-0 .vertical-navbox, .ns-0
.infobox.sisterproject, .ns-0 .dablink, .ns-0 .metadata, .editlink,
a.NavToggle, span.collapseButton, span.mw-collapsible-toggle {

       display: none !important;

}

/* Add formatting to make sure that "external references" from templates

      like Template:Ref do not get URL expansion, not even when printed.
      The anchor itself has class "external autonumber" and the url expansion
      is inserted when printing (see the common printing style sheet at
      http://en.wikipedia.org/skins-1.5/common/commonPrint.css) using the
      ":after" pseudo-element of CSS. Also hide in  elements.

-   /

1.  content cite a.external.text:after,

.nourlexpansion a.external.text:after, .nourlexpansion
a.external.autonumber:after {

       display: none !important;

}

/* Uncollapse collapsible tables/divs.

      The proper way to do this for tables is to use display:table-row,
      but this is not supported by all browsers, so use display:block as fallback.

-   /

table.collapsible tr, div.NavPic, div.NavContent {

       display: block !important;

} table.collapsible tr {

       display: table-row !important;

}

/* Hiding some items when printing with Simple skin */ .skin-simple
div#column-one, .skin-simple div#f-poweredbyico, .skin-simple
div#f-copyrightico, .skin-simple .editsection {

       display: none; 

}

/* On websites with siteSub visible, the margin on the firstHeading is
not needed. */

1.  firstHeading {

       margin: 0px;

}

/* We don't want very long URLs (that are added to the content in print)
to widen the canvas */

1.  content a.external.text:after,
2.  content a.external.autonumber:after {

word-wrap: break-word; }

Retrieved from
"https://wiki.archlinux.org/index.php?title=ArchWiki:Print.css&oldid=233661"

-   This page was last modified on 4 November 2012, at 16:36.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
