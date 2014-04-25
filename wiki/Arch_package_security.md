Arch package security
=====================

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Pacman      
                           package signing.         
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Current state of affairs
------------------------

A package can become malicious (we consider original sources safe)
either intentionally or unintentionally. In the first case packager
prepares the package (by modifying sources, adding scripts, modifying
build scripts) with intention to make harm to user system or data. In
the second case packager by mistake or omission creates the package that
if installed puts the user's system in jeopardy.

Malicious package may enter the package universe when packager provides
it directly or puts it into legitimate repository or mirror. Threat
level depends here on what software contained in package can do and how
popular package is. The former quality is possible to determine by
careful inspection of package and its contents (also running software in
testing environment). The latter can be estimated by basing on download
statistics (assuming that package downloaded is package installed).

What to do to make package management more secure?
--------------------------------------------------

There's no way to stop packagers from intentionally forging packages
that can do bad things to user system and providing them on their own
repositories. There is however a way to make users to be more careful
when downloading packages outside from official repositories. Malicious
packager will have to convince users to download his package. He'll have
to do it by advertising his package as the one containing very popular
software that is missing from official repositories, software that is
very rich in features, software that promises to fulfill user's
subconscious needs (security, speed, ease of use). A chance to counter
this efforts is to educate user to use packages outside of official
repos only if absolutely necessary (at least until some way of
preventing damage potentially caused by such software won't be devised
systemwise).

Dangerous packages can also be injected on mirror level. Making this
level more secure is in the hands of mirror administrators mostly but
there also is a thing or two that Arch can do to help them. Firstly
mirroring could be done through secure connection. This takes care of
proving that packages are downloaded exactly from intended server, what
in effect excludes possibility of man-in-the-middle attack. Secondly
downloaded packages can be verified the same way as they would be on
user machine. This would demand a bit of processing power from server's
side but hopefully little enough to do it.

Finally packages can be signed and their signatures automatically
verified what in connection with provided database of trusted packagers
will lower the possibility of installing dangerous package from
untrusted source. Package signing would be a subject of separate policy
which will be described lower.

Arch Linux has relatively small and educated user base which makes it
unlikely target of malicious packages based attack but it doesn't mean
that obvious gaps in security shouldn't be taken care of. One of this
gaps is package management security.

Package signing policy
----------------------

See Pacman package signing.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Arch_package_security&oldid=198620"

Category:

-   Security

-   This page was last modified on 23 April 2012, at 18:24.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
