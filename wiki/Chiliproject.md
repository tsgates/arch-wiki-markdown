Chiliproject
============

> Summary

How to install and configure Chiliproject

> Related

Redmine

Chiliproject is a fork of Redmine, a flexible project management web
application written using Ruby on Rails. The reason they forked is
basically a lack of effort from the main developer, see complete
explanation here: Chiliproject: why fork?

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Setup                                                              |
|     -   2.1 Short version                                                |
|     -   2.2 Long Version                                                 |
+--------------------------------------------------------------------------+

Installation
------------

A number of packages are available in the AUR for installing
Chiliproject:

-   chiliproject
-   chiliproject-git
-   chiliproject-standalone

Each of these packages provides a different version of Chiliproject. The
regular 'chiliproject' package should always provide the latest stable
chiliproject release, built from a tarball. The 'chiliproject-git'
package will provide whatever is HEAD on the chiliproject github master
branch. The 'chiliproject-standalone' package only provides initscripts,
user and group for running Chiliproject in a standalone manner, through
webrick. This is mainly useful for testing your new setup. Please note
that running Chiliproject through webrick is only meant for testing
deployments, not for running in production.

Setup
-----

> Short version

Install bundle dependencies

    cd /var/lib/chiliproject
    bundle install

Generate the session store

    bundle exec rake generate_session_store

Setup database + user (db-specific) Edit the config files accordingly:

-   config/database.yml
-   config/configuration.yml

Create db structure

    RAILS_ENV=production bundle exec rake db:migrate

Load default configuration data in case of a fresh start

    RAILS_ENV=production bundle exec rake redmine:load_default_data

> Long Version

For a more in-depth explanation of the entire setup procedure, how to
adapt the bundle setup to suit your needs, how to use different database
adapters, take a look at the official chiliproject installation guide
for the full explanation: Official Chiliproject installation guide

Retrieved from
"https://wiki.archlinux.org/index.php?title=Chiliproject&oldid=255944"

Category:

-   Web Server
