TORQUE
======

Summary

Installation and configuration of TORQUE.

Related

distcc

TORQUE is an open source resource manager providing control over batch
jobs and distributed compute nodes. Basically, one can setup a home or
small office Linux cluster and queue jobs with this software. A cluster
consists of one head node and many compute nodes. The head node runs the
torque-server daemon and the compute nodes run the torque-client daemon.
The head node also runs a scheduler daemon.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Pre-note                                                           |
| -   2 Installation                                                       |
| -   3 Must haves                                                         |
|     -   3.1 /etc/hosts                                                   |
|     -   3.2 Firewall configuration (if installed)                        |
|     -   3.3 NFS                                                          |
|                                                                          |
| -   4 TORQUE setup                                                       |
|     -   4.1 Server (head node) configuration                             |
|     -   4.2 Client (compute node) configuration                          |
|     -   4.3 Restart the server and client(s)                             |
|                                                                          |
| -   5 Verifying cluster status                                           |
| -   6 Queuing jobs                                                       |
| -   7 Checking job status                                                |
| -   8 Links                                                              |
+--------------------------------------------------------------------------+

Pre-note
--------

Note:Although TORQUE is a very powerful queuing system, if the goal of
the cluster is solely to increase compilation throughout, distcc is a
much easier and elegant solution.

Installation
------------

Install the torque package found in the AUR.

Must haves
----------

> /etc/hosts

Make sure that /etc/hosts on all of the boxes you plan to use in your
cluster contains the hostnames of every PC in the cluster. Example,
cluster consists of 3 PCs, mars, phobos, and deimos.

    192.168.0.20   mars
    192.168.0.21   phobos
    192.168.0.22   deimos

> Firewall configuration (if installed)

Be sure to open TCP for all machines using TORQUE.

The pbs_server (server) and pbs_mom (client) by default use TCP and UDP
ports 15001-15004. pbs_mom (client) also uses UDP ports 1023 and below
if privileged ports are configured (the default).

> NFS

Technically, one does not need to use NFS but doing so simplifies the
whole process. An NFS or NFSv4 share either on the server or another
machine is highly recommended to simplify the process of sharing common
build disk space.

See the NFS and NFSv4 wiki articles for setting this up.

TORQUE setup
------------

> Server (head node) configuration

Follow these steps on the head node/scheduler.

Edit /var/spool/torque/server_name to name the head node. It is
recommended to match the hostname in /etc/rc.conf for simplicity's sake.

Create and configure your torque server:

    # pbs_server -t create
    PBS_Server localhost.localdomain: Create mode and server database exists, 
    do you wish to continue y/(n)?y

A minimal set of options are provided here. Adjust the first line
substituting "mars" with the hostname entered in
/var/spool/torque/server_name:

    qmgr -c "set server acl_hosts = mars"
    qmgr -c "set server scheduling=true"
    qmgr -c "create queue batch queue_type=execution"
    qmgr -c "set queue batch started=true"
    qmgr -c "set queue batch enabled=true"
    qmgr -c "set queue batch resources_default.nodes=1"
    qmgr -c "set queue batch resources_default.walltime=3600"
    qmgr -c "set server default_queue=batch"

It may be of interest to keep finished jobs in the queue for a period of
time.

    qmgr -c "set server keep_completed = 86400"

Here, 86400 sec = 24 h after which point, the job will be auto removed
from the queue. One can see the full log of jobs removed from the queue
with the -f switch on qstat:

    qstat -f

Verify the server config with this command:

    # qmgr -c 'p s'

Edit /var/spool/torque/server_priv/nodes adding all compute nodes.
Again, it is recommended to match the hostname(s) of the machines on
your LAN. The syntax is HOSTNAME np=x gpus=y properties

-   HOSTNAME=the hostname of the machine
-   np=number of processors
-   gpus=number of gpus
-   properties=comments you wish to add

Only the hostname is required, all other fields are optional.

Example:

    mars np=4
    phobos np=2
    deimos np=2

Note:One can run both the server and client on the same box.

Note:Re-running pbs_server -t create may delete this nodes file.

Restart the server and the new options are sourced:

    # rc.d start torque-server

> Client (compute node) configuration

Follow these steps on each compute node in your cluster.

Note:If running both the server and client on the same box, be sure to
complete these steps as well for that machine as well as other pure
clients on your cluster.

Edit /var/spool/torque/mom_priv/config to contain some basic info
identifying the server:

    $pbsserver      mars          # note: this is the hostname of the headnode
    $logevent       255           # bitmap of which events to log

> Restart the server and client(s)

That should be it. Restart the server and client(s):

    # rc.d restart torque-server
    # rc.d start torque-node

Verifying cluster status
------------------------

To check the status of your cluster, issue the following:

    $ pbsnodes -a

Each node if up should indicate that it is ready to receive jobs echoing
a state of free. If a node is not working, it will report a state of
down.

Example output:

    mars
         state = free
         np = 4
         ntype = cluster
         status = rectime=1308479899,varattr=,jobs=0.localhost.localdomain,state=free,netload=1638547057,
    gres=,loadave=2.69,ncpus=4,physmem=8195892kb,availmem=7172508kb,totmem=8195892kb,
    idletime=24772,nusers=1,nsessions=5,sessions=1333 1349 1353 1388 9095,
    uname=Linux mars 2.6.39-ck #1 SMP PREEMPT Sat Jun 18 14:19:01 EDT 2011 x86_64,opsys=linux
         mom_service_port = 15002
         mom_manager_port = 15003
         gpus = 2

    phobos
         state = free
         np = 2
         ntype = cluster
         status = rectime=1308479933,varattr=,jobs=,state=free,netload=1085755815,
    gres=,loadave=2.84,ncpus=2,physmem=4019704kb,availmem=5753552kb,totmem=6116852kb,
    idletime=7324,nusers=2,nsessions=6,sessions=1565 1562 1691 1716 1737 1851,
    uname=Linux phobos 2.6.37-ck #1 SMP PREEMPT Sun Apr 3 17:16:35 EDT 2011 x86_64,opsys=linux
         mom_service_port = 15002
         mom_manager_port = 15003
         gpus = 1

    deimos
         state = free
         np = 2
         ntype = cluster
         status = rectime=1308479890,varattr=,jobs=2.localhost.localdomain,state=free,netload=527239670,
    gres=,loadave=0.52,ncpus=2,physmem=4057808kb,availmem=3955624kb,totmem=4057808kb,
    idletime=644,nusers=1,nsessions=1,sessions=865,
    uname=Linux deimos 2.6.39-ck #1 SMP PREEMPT Sat Jun 11 12:36:21 EDT 2011 x86_64,opsys=linux
         mom_service_port = 15002
         mom_manager_port = 15003
         gpus = 1

Queuing jobs
------------

Queuing to the cluster is accomplished via the qsub command.

A trivial test is to simply run sleep:

    $ echo "sleep 30" | qsub

Check the status of the queue via the qstat command described below. At
this point, the work will have a status of "Q" which means queued. To
start it, run the scheduler:

    # pbs_sched

Note:One can easily make a daemon for pbs_sched in /etc/rc.d - just copy
/etc/rc.d/torque-server and change the daemon. Future releases of the
AUR package may contain this as the default.

Another usage of qsub is to name a job and queue a script:

    $ qsub -N x264 /home/facade/bin/x264_HQ.sh

Note:STDOUT and STDERR for a queued job will be logged by default in the
form text files corresponding to the respective outputs pid.o and pid.e
and will be written to the path from which the qsub command was issued.

Another example can use a wrapper script to make and queue work en mass
automatically. For an example, see graysky's build.functions.

Checking job status
-------------------

qstat is used to check work status.

    $ qstat

    Job id                    Name             User            Time Use S Queue
    ------------------------- ---------------- --------------- -------- - -----
    13.localhost               generic-i686.pbs facade         00:05:06 R batch          
    14.localhost               atom-i686.pbs    facade         00:03:09 R batch          
    15.localhost               core2-i686.pbs   facade         00:01:02 R batch          
    16.localhost               k7-i686.pbs      facade                0 Q batch          
    17.localhost               k8-i686.pbs      facade                0 Q batch          
    18.localhost               k10-i686.pbs     facade                0 Q batch          
    19.localhost               p4-i686.pbs      facade                0 Q batch          
    20.localhost               pentm-i686.pbs   facade                0 Q batch          
    21.localhost               ...ic-x86_64.pbs facade                0 Q batch          
    22.localhost               atom-x86_64.pbs  facade                0 Q batch          
    23.localhost               core2-x86_64.pbs facade                0 Q batch          
    24.localhost               k8-x86_64.pbs    facade                0 Q batch          
    25.localhost               k10-x86_64.pbs   facade                0 Q batch          

Append the -n switch to see which nodes are doing which jobs.

    $ qstat -n

    localhost.localdomain: 
    405.localhost.lo     facade  batch    i686-generic       3035     1   0    --  01:00 C 00:12
       mars/3+mars/2+mars/1+mars/0
    406.localhost.lo     facade  batch    i686-atom          5768     1   0    --  01:00 C 00:46
       phobos/1+phobos/0
    407.localhost.lo     facade  batch    i686-core2        22941     1   0    --  01:00 C 00:12
       mars/3+mars/2+mars/1+mars/0
    408.localhost.lo     facade  batch    i686-k7           10152     1   0    --  01:00 C 00:12
       mars/3+mars/2+mars/1+mars/0
    409.localhost.lo     facade  batch    i686-k8           29657     1   0    --  01:00 C 00:12
       mars/3+mars/2+mars/1+mars/0
    410.localhost.lo     facade  batch    i686-k10          16838     1   0    --  01:00 C 00:12
       mars/3+mars/2+mars/1+mars/0
    411.localhost.lo     facade  batch    i686-p4           25340     1   0    --  01:00 C 00:46
       deimos/1+deimos/0
    412.localhost.lo     facade  batch    i686-pentm        12544     1   0    --  01:00 R 00:20
       phobos/1+phobos/0
    413.localhost.lo     facade  batch    x86_64-generic     4024     1   0    --  01:00 C 00:13
       mars/3+mars/2+mars/1+mars/0
    414.localhost.lo     facade  batch    x86_64-atom       19330     1   0    --  01:00 C 00:13
       mars/3+mars/2+mars/1+mars/0
    415.localhost.lo     facade  batch    x86_64-core2       2146     1   0    --  01:00 C 00:13
       mars/3+mars/2+mars/1+mars/0
    416.localhost.lo     facade  batch    x86_64-k8         17234     1   0    --  01:00 R 00:11
       mars/3+mars/2+mars/1+mars/0
    417.localhost.lo     facade  batch    x86_64-k10          --      1   0    --  01:00 Q   -- 
        -- 

Links
-----

-   TORQUE short course from University of California, San Francisco -
    Good guide with templates.
-   TORQUE admin manual - great resource and easy to read.
-   Boston College's Torque User Guide - not extensive but gives a
    flavor for how end-users can use a cluster. Probably overkill for
    home clusters where only one user is submitting work.
-   TORQUE Mailing Lists - The TORQUE community is very knowledgeable
    and a key asset.
-   TORQUE Users Mailing List Archives - Searchable archive of
    TORQUE-users.

Retrieved from
"https://wiki.archlinux.org/index.php?title=TORQUE&oldid=240637"

Category:

-   Networking
