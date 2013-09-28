Qt
==

Summary

Qt is a cross-platform application and UI framework for developers using
C++ or QML, a CSS & JavaScript like language. This article covers the
installation and developement with Qt and the tools used to configure
themes, fonts and other options.

Related

KDE

Uniform Look for Qt and GTK Applications

GTK+

Qt is a cross-platform application and widget toolkit that uses standard
C++ but makes extensive use of a special code generator (called the Meta
Object Compiler, or moc) together with several macros to enrich the
language. Some of its more important features include:

-   Running on the major desktop platforms and some of the mobile
    platforms.
-   Extensive internationalization support.
-   A complete library that provides SQL database access, XML parsing,
    thread management, network support, and a unified cross-platform
    application programming interface (API) for file handling.

The Qt framework is emerging as a major development platform and is the
basis of the KDE software community, among other important open source
and proprietary applications such as VLC, VirtualBox, Opera,
Mathematica, Skype, Maya and many others.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Appearance                                                         |
|     -   2.1 Configuration                                                |
|         -   2.1.1 Themes                                                 |
|         -   2.1.2 Fonts                                                  |
|         -   2.1.3 Icons                                                  |
|                                                                          |
|     -   2.2 Manual configuration                                         |
|     -   2.3 Qt Style Sheets                                              |
|     -   2.4 GTK+ and Qt                                                  |
|                                                                          |
| -   3 Development                                                        |
|     -   3.1 Supported platforms                                          |
|     -   3.2 Tools                                                        |
|     -   3.3 Bindings                                                     |
|         -   3.3.1 C++                                                    |
|         -   3.3.2 QML                                                    |
|         -   3.3.3 Python                                                 |
|         -   3.3.4 C#                                                     |
|         -   3.3.5 Ruby                                                   |
|         -   3.3.6 Java                                                   |
|         -   3.3.7 Perl                                                   |
|         -   3.3.8 Lua                                                    |
|                                                                          |
| -   4 Resources                                                          |
+--------------------------------------------------------------------------+

Installation
------------

Two versions of Qt are currently available in the official repositories.
They can be installed with the following packages:

-   Qt 5.x is available in the qt5-base package, with documentation in
    the qt5-doc package.
-   Qt 4.x is available in the qt4 package.
-   Qt 3.x is availalbe in the qt3 package, with documentation in the
    qt3-doc package.

Note:Qt3 is no longer developed, but there are still applications in the
official repositories that depend on it. The Trinity Project is
maintaining a version of Qt3 in the form of the trinity-qt3 package,
available in the AUR.

Warning:Qt3 or Qt4 do not provide the usual bins (e.g. qmake) in
/usr/bin anymore. Instead, -qt3 and -qt4 symlinks are provided (e.g.
qmake-qt4, qmake-qt3). This may cause compilation failures in Qt3/4
applications.

Appearance
----------

> Configuration

Qt application will try to mimic the behavior of the desktop environment
they are running on, unless they run into some problems or hard-coded
settings. For those who still want to change the look and feel of Qt
application, the Qt Configuration (qtconfig or qt3config) tool is
available. QtConfig offers a very simple configuration for the
appearance of Qt applications that gives the user easy access to the
current Qt Style, colors, fonts and other more advanced options.

Although not part of Qt, the KDE System Settings offer many more
customization options that are also picked up by Qt applications.

Themes

Several styles are already included with Qt, such as a GTK+ style, a
Windows style, a CDE style, etc., but others can be installed from the
official repositories or the AUR (most are written for the KDE desktop):

-   Oxygen — A desktop theme that comes with the KDE desktop.

http://www.oxygen-icons.org/ || kdebase-runtime

-   QtCurve — A very configurable and popular desktop theme with support
    for GTK+ and Qt applications.

http://kde-look.org/content/show.php?content=40492 || qtcurve-kde3
qtcurve-kde4

-   Skulpture — A GUI style addon for KDE and Qt programs that features
    a classical three dimensional artwork with shadows and smooth
    gradients to enhance the visual experience.

http://kde-look.org/content/show.php/?content=59031 || skulpture

-   Polymer — A port of the KDE Plastik Style to Qt3.

http://kde-look.org/content/show.php?content=21748 || polymer

-   Bespin — A very configurable KDE theme.

http://cloudcity.sourceforge.net/frame.php || bespin-svn

Fonts

Qt fonts can be configured from QtConfig under Fonts > Default Font.

Icons

There is no way of setting the icon theme from QtConfig, but since Qt
follows the Freedesktop.org Icon Specification, any theme set for X is
picked up by Qt.

> Manual configuration

Qt keeps all its configuration information in ~/.config/Trolltech.conf.
The file is rather difficult to navigate because it contains a lot of
information not related to appearance, but for any changes you can just
add to the end of the file and overwrite any previous values (make sure
to add your modification under the [Qt] header).

For example, to change the theme to QtCurve, add:

    ~/.config/Trolltech.conf

    ...
    [Qt]
    style=QtCurve

> Qt Style Sheets

An interesting way of customizing the look and feel of a Qt application
is using Style Sheets, which are just simple CSS files. Using Style
Sheets, one can modify the appearance of every widget in the
application.

To run an application with a different style just execute:

    $ qt_application --stylesheet style.qss

For more information on Qt Style Sheets see the official documentation
or other tutorials. As an example Style Sheet see this Dolphin
modification.

> GTK+ and Qt

If you have GTK+ and Qt applications, their looks might not exactly
blend in very well. If you wish to make your GTK+ styles match your Qt
styles please read Uniform Look for QT and GTK Applications.

Development
-----------

> Supported platforms

Qt supports most platforms that are available today, even some of the
more obscure ones, with more ports appearing every once in a while. For
a more complete list see the Qt Wikipedia article.

> Tools

The following are official Qt tools:

-   Qt Creator — A cross-platform IDE tailored for Qt that supports all
    of its features.

http://qt.digia.com/Product/Developer-Tools/ || qtcreator

-   Qt Linguist — A set of tools that speed the translation and
    internationalization of Qt applications.

http://qt.digia.com/Product/Developer-Tools/ || qt

-   Qt Assistant — A configurable and redistributable documentation
    reader for Qt qch files.

http://qt.digia.com/Product/Developer-Tools/ || qt

-   Qt Designer — A powerful cross-platform GUI layout and forms builder
    for Qt widgets.

http://qt.digia.com/Product/Developer-Tools/ || qt

-   Qt Quick Designer — A visual editor for QML files which supports
    WYSIWYG. It allows you to rapidly design and build Qt Quick
    applications and components from scratch.

http://qt.digia.com/Product/Developer-Tools/ || qtcreator

-   QML Viewer — A tool for loading QML documents that makes it easy to
    quickly develop and debug QML applications.

http://doc.qt.digia.com/4.7-snapshot/qmlviewer.html || qt

-   qmake — A tool that helps simplify the build process for development
    project across different platforms, similar to cmake, but with fewer
    options and tailored for Qt applications.

https://qt-project.org/doc/qt-4.8/qmake-manual.html || qt

-   uic — A tool that reads *.ui XML files and generates the
    corresponding C++ files.

http://qt-project.org/doc/qt-4.8/uic.html || qt

-   rcc — A tool that is used to embed resources (such as pictures) into
    a Qt application during the build process. It works by generating a
    C++ source file containing data specified in a Qt resource (.qrc)
    file.

http://qt-project.org/doc/qt-4.8/rcc.html || qt

-   moc — A tool that handles Qt's C++ extensions (the signals and slots
    mechanism, the run-time type information, and the dynamic property
    system, etc.).

http://doc.qt.digia.com/4.7-snapshot/moc.html || qt

> Bindings

Qt has bindings for all of the more popular languages, for a full list
see this list.

The following examples display a small 'Hello world!' message in a
window.

C++

-   Package: qt4
-   Website: http://qt-project.org/
-   Build with:
    g++ `pkg-config --cflags --libs QtCore QtGui` -o hello hello.cpp
-   Run with: ./hello

    hello.cpp

    #include <QApplication>
    #include <QLabel>

    int main(int argc, char **argv)
    {
        QApplication app(argc, argv);
        QLabel hello("Hello world!");
        
        hello.show();
        return app.exec();
    }

QML

-   Package: qt4
-   Website: http://qt-project.org/
-   Run with: qmlviewer hello.qml

    hello.qml

    import QtQuick 1.0

    Rectangle {
        id: page
        width: 400; height: 100
        color: "lightgray"

        Text {
            id: helloText
            text: "Hello world!"
            anchors.horizontalCenter: page.horizontalCenter
            anchors.verticalCenter: page.verticalCenter
            font.pointSize: 24; font.bold: true
        }
    }

Python

-   Package:
    -   pyqt - Python 3.x bindings
    -   python2-pyqt - Python 2.x bindings

-   Website: http://www.riverbankcomputing.co.uk/software/pyqt/intro
-   Run with: python hello-pyqt.py or python2 hello-pyqt.py

    hello-pyqt.py

    import sys
    from PyQt4 import QtGui

    app = QtGui.QApplication(sys.argv)
    label = QtGui.QLabel("Hello world!")

    label.show()
    sys.exit(app.exec_())

-   Package:
    -   python-pyside - Python 3.x bindings
    -   python2-pyside - Python 2.x bindings

-   Website: http://www.pyside.org/
-   Run with: python hello-pyside.py or python2 hello-pyside.py

    hello-pyside.py

    import sys
    from PySide.QtCore import *
    from PySide.QtGui import *
     
    app = QApplication(sys.argv)
    label = QLabel("Hello world!")

    label.show()
    sys.exit(app.exec_())

C#

-   Package: kdebindings-qyoto
-   Website: http://techbase.kde.org/Development/Languages/Qyoto
-   Build with: mcs -pkg:qyoto hello.cs
-   Run with: mono hello.exe

    hello.cs

    using System;
    using Qyoto;

    public class Hello {
        public static int Main(String[] args) {
            new QApplication(args);
            new QLabel("Hello world!").Show();

            return QApplication.Exec();
        }
    }

Ruby

-   Package: kdebindings-qtruby
-   Website: http://rubyforge.org/projects/korundum/
-   Run with: ruby hello.rb

    hello.rb

    require 'Qt4'
     
    app = Qt::Application.new(ARGV)
    hello = Qt::Label.new('Hello World!')

    hello.show 
    app.exec

Java

-   Package: qtjambi
-   Website: http://qt-jambi.org/

    Hello.java

    import com.trolltech.qt.gui.*;

    public class Hello
    {
        public static void main(String args[])
        {
            QApplication.initialize(args);
            QLabel hello = new QLabel("Hello World!");

            hello.show();
            QApplication.exec();
        }
    }

Perl

-   Package: kdebindings-perlqt
-   Website: http://code.google.com/p/perlqt4/
-   Run with: perl hello.pl

    hello.pl

    use QtGui4;

    my $a = Qt::Application(\@ARGV);
    my $hello = Qt::Label("Hello World!", undef);

    $hello->show;
    exit $a->exec;

Lua

-   Package: libqtlua
-   Website: http://www.nongnu.org/libqtlua/
-   Run with: qtlua hello.lua

    hello.lua

    label = qt.new_widget("QLabel")

    label:setText("Hello World!")
    label:show()

Note:QtLua is not designed to develop an application in pure Lua but
rather to extend a Qt C++ application using Lua as scripting language.

Resources
---------

-   Official Website
-   Qt Project
-   Qt Documentation
-   Planet Qt
-   Qt Applications

Retrieved from
"https://wiki.archlinux.org/index.php?title=Qt&oldid=254148"

Categories:

-   Desktop environments
-   Development
