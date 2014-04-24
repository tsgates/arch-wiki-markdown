DeveloperWiki:Bash Coding Style
===============================

Policy
------

-   encoding is utf-8
-   use #!/bin/bash
-   indent with tabs
-   tabs have 8 characters
-   do not use more than 132 columns
-   opening braces are top right, closing are bottom left:

    foo() {
            echo bar
    }

-   if and for statements are like this:

    if true; then
            do something
    else
            do something else
    fi

    for i in a b c; do
            echo $i
    done

-   use single quotes if a string does not contain parseable content
-   use source instead of .
-   use $() instead of ``

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:Bash_Coding_Style&oldid=259450"

Category:

-   Arch development

-   This page was last modified on 29 May 2013, at 07:13.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
