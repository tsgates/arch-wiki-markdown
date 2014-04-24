Ros
===

ROS is an open-source, meta-operating system for your robot. It provides
the services you would expect from an operating system, including
hardware abstraction, low-level device control, implementation of
commonly-used functionality, message-passing between processes, and
package management.

Setup Notes - Hydro
-------------------

For ROS Hydro, see Installation Instructions for Hydro in Arch Linux.

Setup Notes - Groovy
--------------------

ROS Groovy core, comm, and robot variants have meta-packages that should
install all the necessary packages: ros-groovy-ros, ros-groovy-ros-comm,
(TODO: robot metapackage). In addition, ros-groovy-rviz (along with its
dependencies) has a package. Beware, the dependency tree goes at least
five levels deep at times. yaourt handles it (somewhat), packer falls
flat. It is strongly recommended that you install ros-groovy-ros first
to prevent yaourt's ridiculous dependency thrashing.

The packages are all available in the maintainer's github:
arch-ros-stacks. Not all packages there are in a working state, so use
with caution. Please, report any issues with the packages on their
respective AUR pages.

Usage Notes - Groovy
--------------------

Due to the fact that Ubuntu and Arch handle the python2/3 binary split
differently, catkin_make[_isolated] will not work on its own. To use
these commands, create the following aliases in your ~/.bashrc (or
equivalent):

    alias catkin_make='catkin_make -DPYTHON_EXECUTABLE=/usr/bin/python2 -DPYTHON_INCLUDE_DIR=/usr/include/python2.7 -DPYTHON_LIBRARY=/usr/lib/libpython2.7.so'
    alias catkin_make_isolated='catkin_make_isolated -DPYTHON_EXECUTABLE=/usr/bin/python2 -DPYTHON_INCLUDE_DIR=/usr/include/python2.7 -DPYTHON_LIBRARY=/usr/lib/libpython2.7.so'

Without these lines, cmake will default to python 3, which you don't
want. It is also possible to simply add the defines into any call of
catkin_make[_isolated] (which you have to do if you want to call those
commands within a script).

For further information on how to use ROS, see the ROS Tutorials.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ros&oldid=303586"

Category:

-   Mathematics and science

-   This page was last modified on 8 March 2014, at 10:47.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
