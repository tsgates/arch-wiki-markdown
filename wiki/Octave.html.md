Octave
======

Summary help replacing me

This article contains information about the installation, configuration
and use of GNU Octave.

> Related

Matlab

Sage-mathematics

Mathematica

From the official website:

GNU Octave is a high-level interpreted language, primarily intended for
numerical computations. It provides capabilities for the numerical
solution of linear and nonlinear problems, and for performing other
numerical experiments. It also provides extensive graphics capabilities
for data visualization and manipulation. Octave is normally used through
its interactive command line interface, but it can also be used to write
non-interactive programs. The Octave language is quite similar to Matlab
so that most programs are easily portable.

Contents
--------

-   1 Installation
-   2 Octave-Forge
    -   2.1 Using Octave's installer
    -   2.2 Using the AUR
-   3 Plotting
-   4 Graphical interfaces
-   5 Reading Microsoft Excel Spreadsheets
    -   5.1 Converting to an open format
    -   5.2 Reading xls files directly from Octave
        -   5.2.1 Steps necessary to make Java Interface available

Installation
------------

Octave can be installed with the package octave, available in the
official repositories.

Octave-Forge
------------

Octave provides a set of packages, similar to Matlab's Toolboxes,
through Octave-Forge. The complete list of packages is here.

Packages can be installed directly in Octave, or from the AUR. See
below.

> Using Octave's installer

Packages can be managed using Octave's installer. They are installed to
~/octave, or in a system directory with the -global option. To install a
package:

    octave:1> pkg install -forge packagename

To uninstall a package:

    octave:3> pkg uninstall packagename

Some packages get loaded automatically by Octave, for those which do
not:

    octave:4> pkg load packagename

or

    octave:5> pkg load all

To see which packages have been loaded use pkg list, the packages with
an asterisk are the ones that are already loaded.

  
 A way to make sure that all packages gets loaded at Octave startup:

    /usr/share/octave/site/m/startup/octaverc

    ## System-wide startup file for Octave.
    ##
    ## This file should contain any commands that should be executed each
    ## time Octave starts for every user at this site. 
     pkg load all

> Using the AUR

Some packages may be found in the AUR (search packages). New
Octave-forge packages for Arch can be created semi-automatically using
the Octave-forge helper scripts for Archlinux.

Plotting
--------

Octave has two official plotting backends:

-   Gnuplot — A classic Linux plotting utility.

http://www.gnuplot.info/ || gnuplot

-   FLTK Backend — A new experimental OpenGL backend based on the FLTK
    GUI toolkit.

http://www.gnu.org/software/octave/ || octave

Note:To enable the FLTK backend, you need to install the fltk package.
This package now comes as a dependency of octave.

FLTK is now the default plotting utility, but due to some serious
problems with the experimental interface, you may want to re-enable
gnuplot.

    octave:1> graphics_toolkit("gnuplot");

To make this change permanent add it to your ~/.octaverc file.

Graphical interfaces
--------------------

Since Octave 3.8, Octave has it's own (experimental) GUI based on QT.
Unfortunately it's not in Arch Linux repos yet. So you have to build it
for your own. To start the GUI, run octave --force-gui

The following GUIs are unofficial.

-   Cantor — A graphical user interface that delegates its mathematical
    operations to one of several back ends (Scilab, Maxima, Octave and
    others).

http://edu.kde.org/cantor/ || kdeedu-cantor

-   QtOctave — A Qt frontend for Octave.

https://forja.rediris.es/projects/csl-qtoctave/ || qtoctave

Reading Microsoft Excel Spreadsheets
------------------------------------

There are several ways to read Microsoft Excel files with Octave.

Converting to an open format

The easiest way to use .xls files in Octave would be to convert them to
.csv or .ods using Calc (limited to 1024 columns) from Libreoffice or
Sheets(limited to 32768 columns) from the the Calligra Suite.

After the conversion is complete you can use the build-in Octave
function csvread for .csv files:

    octave:1> csvread('myfile.csv');

For .ods files the octave-io package is necessary which contains the
odsread function:

    octave:1> odsread('myfile.ods');

For .xlsx files you can use the xlsx2csv package from AUR:

     xlsx2csv -t /path/to/save/location -x /path/to/myfile.xlsx 

Reading xls files directly from Octave

If you must work with XLS files and you cannot convert them to CSV or
ODS, for whatever reason, you can use the xlsread function from the
octave-io package.

Since octave-io version 1.2.5., an interface called 'OCT' was added,
which perform reading .xlsx (not .xls!), ods and .gnumeric without any
dependencies. However, the Java-based interface still exist (special for
reading .xls files and writing those file formats).

Steps necessary to make Java Interface available

The steps necessary to make it work are:

1. Install jdk7-openjdk, available in the official repositories.

Note:A common problem is that Octave cannot find the JDK path. To fix
this execute the following commands in your shell:

    $ export JAVA_HOME=/usr/lib/jvm/java-7-openjdk

You may also want to add this to your ~/.bashrc and append it to your
PATH.

2. Install a Java XLS library for xlsread. There are more such libraries
available, a comparison can be found at here. The recommended library is
apache-poi, available in the AUR.

3. Finally, install the octave-java package from AUR.

To check if Java is working correctly in Octave, see the output of:

     octave:1> javaclasspath 
      STATIC JAVA PATH
         - empty -
      DYNAMIC JAVA PATH
         - empty -

To load the selected library in Octave, check if it is in the Java path.
If not:

     octave:1> javaaddpath path/to/file.jar

In the case you chose apache-poi, the relevant JAR files can be found in
/usr/share/java/apache-poi/poi-3.x.jar and
/usr/share/java/apache-poi/poi-ooxml-3.x.jar.

To check if it works

     octave:1> chk_spreadsheet_support 

The output should be > 0:

                       0 No spreadsheet I/O support found
                     ---------- XLS (Excel) interfaces: ----------
                       1 = COM (ActiveX / Excel)
                       2 = POI (Java / Apache POI)
                       4 = POI+OOXML (Java / Apache POI)
                       8 = JXL (Java / JExcelAPI)
                      16 = OXS (Java / OpenXLS)
                     --- ODS (OpenOffice.org Calc) interfaces ----
                      32 = OTK (Java/ ODF Toolkit)
                      64 = JOD (Java / jOpenDocument)
                     ----------------- XLS & ODS: ----------------
                     128 = UNO (Java / UNO bridge - OpenOffice.org)

To make this permanent add the javaaddpath commands to your ~/.octaverc
file.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Octave&oldid=303807"

Category:

-   Mathematics and science

-   This page was last modified on 9 March 2014, at 16:37.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
