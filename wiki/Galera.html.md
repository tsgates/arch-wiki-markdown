Galera
======

Galera is a synchronous multi-master cluster for MySQL/InnoDB databases.
For more information about the product and its features, please visit
the official webpage.

Note:Currenty replication is supported only for InnoDB tables.

Contents
--------

-   1 Instalation
    -   1.1 Enable at startup
-   2 Configuration
-   3 Troubleshooting
-   4 See also

Instalation
-----------

The two components Galera cluster comprised of are Galera plugin itself
and a patched version of MySQL server which connect using wsrep API.

Install the mysql-wsrep and galera packages from the AUR.

> Enable at startup

To enable mysql daemon to start at boot, add the mysqld service to
systemd:

    # systemctl enable mysqld.service

Configuration
-------------

Once you have installed the galera and mysql-wsrep packages, you need to
configure the cluster.

On each node edit /etc/mysql/my.cnf and update the wsrep_cluster_address
variable so it contains the list of all nodes in the cluster:

    wsrep_cluster_address="gcomm://192.168.1.4,192.168.1.5,192.168.1.6"

Change the variables wsrep_node_address and wsrep_node_name to the IP
address/hostname and name(this doesn't need to be unique) for each node,
e.g.:

    wsrep_node_address='192.168.1.4'
    wsrep_node_name='node1'

The wsrep_cluster_name variable should contain the same name for all
cluster nodes:

    wsrep_cluster_name='my_galera_cluster'

Also, set wsrep_sst_method to the desired state snapshot transfer
method, the preferred one is rsync.

    wsrep_sst_method=rsync

When you have finished with /etc/mysql/my.cnf, start the mysqld service
on the first node:

    # systemctl start mysqld-bootstrap.service

This will bootstrap the cluster. Use MySQL's command line tool to log in
as root into your MySQL server:

    $ mysql -p -u root

Check the status of the cluster:

    mysql> SHOW STATUS LIKE 'wsrep_%';

This will show you wsrep-related status variables:

    ...
    | wsrep_local_state          | 4                                    |
    | wsrep_local_state_comment  | Synced                               |
    | wsrep_cert_index_size      | 0                                    |
    | wsrep_causal_reads         | 0                                    |
    | wsrep_incoming_addresses   | 192.168.1.4:3306                     |
    | wsrep_cluster_conf_id      | 1                                    |
    | wsrep_cluster_size         | 1                                    |
    | wsrep_cluster_state_uuid   | 6cd96745-2ea8-11e3-bbc8-d666651b51ef |
    | wsrep_cluster_status       | Primary                              |
    | wsrep_connected            | ON                                   |
    | wsrep_local_index          | 0                                    |
    | wsrep_provider_name        | Galera                               |
    ...

If you use xtrabackup or mysqldump SST method, you will need to create a
MySQL user for sst transfers.

Once you configured the first node, you should be able to start all
other nodes with:

    # systemctl start mysqld.service

Troubleshooting
---------------

TODO

See also
--------

Galera Wiki Percona XtraDB Cluster’s documentation

Retrieved from
"https://wiki.archlinux.org/index.php?title=Galera&oldid=306107"

Category:

-   Database management systems

-   This page was last modified on 20 March 2014, at 17:42.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
