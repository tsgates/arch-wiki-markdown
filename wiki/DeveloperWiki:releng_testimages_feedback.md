DeveloperWiki:releng testimages feedback
========================================

Introduction to the Release Engineering testimages feedback application
-----------------------------------------------------------------------

The Releng testimages feedback web application allows anyone to submit
feedback after attempting an installation using any of the releng
automatically generated images.

The idea is that users report successes and failures using these images,
clearly mentioning the characteristics of the installation (used
options, media used, etc). By collecting all this information it is
possible to generate an overview of the quality of recent images. When
sufficient positive feedback is available (i.e. success reports for all
options of the most recent image(s)) this is a sign for release
engineers that an autobuild can be promoted to official media. By
leveraging community feedback, less extra testing is needed, so it will
cost less time to make new official releases and will hopefully increase
the frequency of official releases. Of course, users should play nice
and perform the testing and feedback steps properly, in order for this
system to work properly. Either way, feedback will be reviewed and will
not completely replace releng testing.

How to report
-------------

-   download an releng automatic build.
-   use it to (attempt to) perform an installation
-   report the installation feedback on the submission page, marking the
    options/features you used (all of them, even if some failed and some
    succeeded).
-   carefully inspect the resulting system to check it matches
    expectations. Specific pointers for things to check can appear for
    specific parts on the feedback submission page, if anything failed
    during the installation, or something's wrong with the installed
    system, do not mark the "success" field.
-   this application does not replace a bugtracker. If you found
    specific bugs, search if a bug is filed already, and if not, file a
    new one. Don't forget to run /arch/report-issues. you can link to
    the bugs in the comments field.

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:releng_testimages_feedback&oldid=238802"

Category:

-   Arch development
