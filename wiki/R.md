R
=

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

R is a free software environment for statistical computing and graphics
(http://www.r-project.org/).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing R                                                       |
|     -   1.1 Installing R packages                                        |
|                                                                          |
| -   2 Running R                                                          |
| -   3 Adding a graphical frontend to R                                   |
|     -   3.1 R Commander frontend                                         |
|     -   3.2 RKWard frontend                                              |
|     -   3.3 Rstudio IDE                                                  |
+--------------------------------------------------------------------------+

Installing R
------------

It is very easy to install R in Arch Linux:

    # pacman -S r

R has some dependencies in tcl and tk (required to install an R package
from R). To install then:

    # pacman -S tcl tk

Some external packages may require to be compile in Fortran as well, so
installing gcc-fortran can be a good idea:

    # pacman -S gcc-fortran

> Installing R packages

There are many add-on R packages, which can be browsed on The R
Website.. They can be installed from within R using the R
install.packages command. It is not necessary to be superuser or have
root privileges when doing this -- R can install its packages locally
for the individual user. This is the safest way to install R packages
and won't conflict with the pacman package management.

To set the location of your local R package library, create a
~/.Renviron file and set R_LIBS_USER:

    ~/.Renviron

    R_LIBS_USER=/home/username/path/to/R/packages

Running R
---------

R can be run from the command line, by using the R command:

    $ R

Adding a graphical frontend to R
--------------------------------

The linux version of R does not include a graphical user interface.
However, third-party user interfaces for R are available, such as R
commander and RKWard.

> R Commander frontend

R Commander is a popular user interface to R. There is no Arch linux
package available to install R commander, but it is an R package so it
can be installed easily from within R. R Commander requires Tk:

    # pacman -S tk

To install R Commander, run 'R' from the command line. Then type:

    > install.packages("Rcmdr", dependencies=TRUE)

This can take some time.

You can then start R Commander from within R using the library command:

    > library("Rcmdr")

> RKWard frontend

RKWard is an open-source frontend which allows for data import and
browsing as well as running common statistical tests and plots. You can
install rkward from AUR.

> Rstudio IDE

RStudio an open-source R IDE. It includes many modern conveniences such
as parentheses matching, tab-completion, tool-tip help popups, and a
spreadsheet-like data viewer.

Install rstudio-desktop-bin (binary version from the Rstudio project
website) or rstudio-desktop-git (development version) from AUR.

The R library path is often configured with the R_LIBS environment
variable. RStudio ignores this, so the user must set R_LIBS_USER in
~/.Renviron, as documented above.

Retrieved from
"https://wiki.archlinux.org/index.php?title=R&oldid=253159"

Category:

-   Programming language
