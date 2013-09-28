Ros
===

ROS is an open-source, meta-operating system for your robot. It provides
the services you would expect from an operating system, including
hardware abstraction, low-level device control, implementation of
commonly-used functionality, message-passing between processes, and
package management.

With the ROS Fuerte release, it is much easier to get ROS running on an
Arch system but still takes some effort. Read the notes below and then
go to the installation page on the ROS website

Setup Notes - Fuerte
--------------------

With Fuerte, ROS is split into two levels. The core libraries are
installed into the system folders (/opt/ros/fuerte) while the
higher-level stacks and packages are installed in the user folders.

The Arch-specific install page lists the packages (official and AUR)
that you will need to install for a full setup.

ros-core, available in the AUR, is the package for the core libraries.

To build the higher level packages you will need to do some work:

1.  Install AUR packages: ros-on-arch pcl-ros swig-wx qhull-ros
2.  Pull the sources with rosinstall
3.  Patch the sources to compile with GCC 4.7 [1]
4.  Resolve dependencies with rosdep
5.  Build with rosmake

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ros&oldid=252495"

Category:

-   Mathematics and science
