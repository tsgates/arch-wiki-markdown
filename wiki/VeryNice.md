VeryNice
========

Verynice is a daemon, available on AUR, for dynamically adjusting the
nice levels of executables. The nice level represents the priority of
the executable when allocating CPU resources. Simply define executables
for which responsiveness is important, like X or multimedia
applications, as goodexe in /etc/verynice.conf. Similarly, CPU-hungry
executables running in the background, like make, can be defined as
badexe. This prioritisation greatly improves system responsiveness under
heavy load.

Installation
------------

Install verynice from the AUR.

To start verynice:

    # systemctl start verynice.service

To enable it to run on boot:

    # systemctl enable verynice.service

Configuration
-------------

VeryNice automatically reads configuration information both from a
central location (/etc/verynice.conf ) and from the home directories of
individual users, in the ~/.verynicerc file. The format of both kinds of
configuration files is the same. More restrictive settings in the global
configuration generally take precedence over individual users' settings.
Of course the settings in a user's ~/.verynicerc file only affect that
user's processes. A sample verynice.conf file is usually installed in
/etc/verynice.conf or /usr/local/etc/verynice.conf.

  Parameter                 Function                                                                                                                                                                                                                                                                   Default   Values                                                                                                                                                             Permissions    Multiple?
  ------------------------- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --------- ------------------------------------------------------------------------------------------------------------------------------------------------------------------ -------------- -----------
  notnice                   Set the nice-level of "goodexe" processes                                                                                                                                                                                                                                  -4        Any negative number greater than -20                                                                                                                               Central        no
  batchjob                  Set the nice-level of "badexe" processes                                                                                                                                                                                                                                   18        Any positive number less than 20                                                                                                                                   Central        no
  runaway                   Set the bad karma (nice) level at which runawayexe processes are killed with SIGTERM                                                                                                                                                                                       20        Any positive number                                                                                                                                                Central        no
  kill                      Set the bad karma (nice) level at which runawayexe processes are killed with SIGKILL                                                                                                                                                                                       22        Any positive number                                                                                                                                                Central        no
  badkarmarate              Set the amount of bad karma generated per second of 100% cpu usage (for small bad karma levels)                                                                                                                                                                            .0167     Any positive real number                                                                                                                                           Central        no
  badkarmarestorationrate   Set the amount of bad karma removed per second of 0% cpu usage                                                                                                                                                                                                             .0167     Any positive real number                                                                                                                                           Central        no
  periodicity               Set the approximate number of seconds between iterations through the process analysis code of VeryNice                                                                                                                                                                     60        Any positive integer. Large values use less CPU. Small values give more precise performance.                                                                       Central        no
  rereadcfgperiodicity      Set the approximate number of program cycles (periodicities, above) between attempts to reread the configuration files of VeryNice                                                                                                                                         60        Any positive integer. Be aware that reconfiguring requires looking up the .verynicerc file in each user's home directory and does not affect existing processes.   Central        no
  immuneuser                Inhibit VeryNice from modifying the nice level of a user's processes, except for "goodexe", below, if set in the central config file.                                                                                                                                      (none)    Any user name, unquoted                                                                                                                                            Central        yes
  immuneexe                 Inhibit VeryNice from modifying the nice level of certain executables                                                                                                                                                                                                      (none)    Any substring of the complete path to the executable, quoted with double quotes ("). If it begins with '/', it must match the complete path precisely.             Central/User   yes
  badexe                    Force the nice level of an executable to the BATCHJOB level                                                                                                                                                                                                                (none)    (As above)                                                                                                                                                         Central/User   yes
  goodexe                   Force the nice level of an executable to the NOTNICE level. This is typically used for real-time multimedia applications which need high priority                                                                                                                          (none)    (As above)                                                                                                                                                         Central/User   yes
  runawayexe                Mark an executable as a potential runaway process. Only processes specially marked will ever be killed by VeryNice                                                                                                                                                         (none)    (As above)                                                                                                                                                         Central/User   yes
  hungryexe                 Mark an executable as "assumed to be CPU hungry". Such a process will be treated as if it were using 100% of the CPU, regardless of its actual CPU usage. This is appropriate for programs that do their real work in lots of short-lived subprocesses, such as make(1).   (none)    (As above)                                                                                                                                                         Central/User   yes

See also
--------

Project Site

Retrieved from
"https://wiki.archlinux.org/index.php?title=VeryNice&oldid=244970"

Category:

-   System administration
