Hadoop
======

Apache Hadoop is a framework for running applications on large cluster
built of commodity hardware. The Hadoop framework transparently provides
applications both reliability and data motion. Hadoop implements a
computational paradigm named Map/Reduce, where the application is
divided into many small fragments of work, each of which may be executed
or re-executed on any node in the cluster. In addition, it provides a
distributed file system (HDFS) that stores data on the compute nodes,
providing very high aggregate bandwidth across the cluster. Both
MapReduce and the Hadoop Distributed File System are designed so that
node failures are automatically handled by the framework.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
| -   3 Single Node Setup                                                  |
|     -   3.1 Standalone Operation                                         |
|     -   3.2 Pseudo-Distributed Operation                                 |
|         -   3.2.1 Set up passphraseless ssh                              |
|         -   3.2.2 Execution                                              |
+--------------------------------------------------------------------------+

Installation
------------

Install the hadoop package which is available in the Arch User
Repository.

Configuration
-------------

By default, hadoop is already configured for pseudo-distributed
operation. Some environment variables are set in
/etc/profile.d/hadoop.sh with different values than traditional hadoop.

  ENV               Value                Description                             Permission
  ----------------- -------------------- --------------------------------------- ----------------
  HADOOP_CONF_DIR   /etc/hadoop          Where configuration files are stored.   Read
  HADOOP_LOG_DIR    /tmp/hadoop/log      Where log files are stored.             Read and Write
  HADOOP_SLAVES     /etc/hadoop/slaves   File naming remote slave hosts.         Read
  HADOOP_PID_DIR    /tmp/hadoop/run      Where pid files are stored.             Read and Write

You also should set up follow files correctly.

    /etc/hosts
    /etc/hostname 
    /etc/locale.conf

JAVA_HOME should be set automatically by jdk7-openjdk
/etc/profile.d/jre.sh. You could check JAVA_HOME:

    $ echo $JAVA_HOME

If it does not print anything, maybe you should log out and log in to
make it right.

Single Node Setup
-----------------

Note:This part is base on the Hadoop Official Documentation

> Standalone Operation

By default, Hadoop is configured to run in a non-distributed mode, as a
single Java process. This is useful for debugging.

The following example copies the unpacked conf directory to use as input
and then finds and displays every match of the given regular expression.
Output is written to the given output directory.

    $ export HADOOP_CONF_DIR=/usr/lib/hadoop/orig_conf
    $ mkdir input
    $ cp /etc/hadoop/*.xml input
    $ hadoop jar /usr/lib/hadoop/hadoop-examples-*.jar grep input output 'dfs[a-z.]+'
    $ cat output/*

> Pseudo-Distributed Operation

Hadoop can also be run on a single-node in a pseudo-distributed mode
where each Hadoop daemon runs in a separate Java process.

By default, Hadoop will run as the user root. If you use initscripts,
you can change the user in /etc/conf.d/hadoop-all:

    HADOOP_USERNAME="<your user name>"

Set up passphraseless ssh

Now check that you can ssh to the localhost without a passphrase:

    $ ssh localhost

If you cannot ssh to localhost without a passphrase, execute the
following commands:

    $ ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
    $ cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys2

Execution

Format a new distributed-filesystem:

    $ hadoop namenode -format

Start the hadoop daemons:

    # systemctl start hadoop-datanode
    # systemctl start hadoop-jobtracker
    # systemctl start hadoop-namenode
    # systemctl start hadoop-secondarynamenode
    # systemctl start hadoop-tasktracker

  
 The hadoop daemon log output is written to the ${HADOOP_LOG_DIR}
directory (defaults to /var/log/hadoop).

Browse the web interface for the NameNode and the JobTracker; by default
they are available at:

-   NameNode - http://localhost:50070/
-   JobTracker - http://localhost:50030/

Copy the input files into the distributed filesystem:

    $ hadoop fs -put /etc/hadoop input

Run some of the examples provided:

    $ hadoop jar /usr/lib/hadoop/hadoop-examples-*.jar grep input output 'dfs[a-z.]+'

Examine the output files:

Copy the output files from the distributed filesystem to the local
filesytem and examine them:

    $ hadoop fs -get output output
    $ cat output/*

or

View the output files on the distributed filesystem:

    $ hadoop fs -cat output/*

When you're done, stop the daemons with:

    # systemctl stop hadoop-datanode
    # systemctl stop hadoop-jobtracker
    # systemctl stop hadoop-namenode
    # systemctl stop hadoop-secondarynamenode
    # systemctl stop hadoop-tasktracker

Retrieved from
"https://wiki.archlinux.org/index.php?title=Hadoop&oldid=251537"

Category:

-   Web Server
