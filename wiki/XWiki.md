XWiki
=====

XWiki is an open-source enterprise-ready wiki written in Java, with a
focus on extensibility. For more information, see the Wikipedia article,
and the XWiki Homepage.

You may also be interested in Foswiki, which caters to similar needs,
but is written in Perl.

Installation
------------

Feel free to follow along on the XWiki Installation Guide. These
instructions assume you will be using Tomcat and PostgreSQL. It
shouldn't be too difficult to apply these guidelines to other
combinations.

-   Install PostgreSQL.
-   For easier PostgreSQL administration, install phpPgAdmin.
-   Install Tomcat 7. (Don't forget tomcat-native.)

Note:Tomcat 7 is set up to expect jre7-openjdk by default. If you prefer
to use openjdk6, you'll need to alter the TOMCAT_JAVA_HOME variable in
/etc/conf.d/tomcat7, or Tomcat will not start.

-   Download the XWiki WAR file.
-   Rename the WAR file to xwiki.
-   Move the WAR file into the /var/lib/tomcat7/webapps directory.
-   Tomcat should automatically extract the WAR file. If not, restart
    Tomcat.
-   At this point, you may find that a data directory has appeared in
    /var/lib/tomcat7/webapps. Delete it.
-   As root:

    # cd /var/lib/tomcat7
    # mkdir data
    # chown tomcat:tomcat data

-   Inside the /var/lib/tomcat7/webapps/xwiki/WEB-INF directory:
    -   Open the xwiki.cfg file and alter the xwiki.work.dir field to
        read /var/lib/tomcat7/data/xwiki.
    -   Open the xwiki.properties file and alter the
        container.persistentDirectory field to read
        /var/lib/tomcat7/data/xwiki.
    -   Open the hibernate.cfg.xml file and:
        -   Comment-out the section entitled "Configuration for the
            default database".
        -   Uncomment the section entitled "PostgreSQL Configuration".
        -   Modify the database name (in connection.url), username, and
            password as desired.

-   Create a role and database in PostgreSQL to match the hibernate
    configuration.
-   Install postgresql-jdbc from the Arch User Repository.
-   As root:

    # cd /usr/share/java/tomcat7
    # ln -s /usr/share/java/postgresql-jdbc/postgresql-jdbc4.jar

-   Restart Tomcat.
-   Launch the XWiki application by clicking on /xwiki in Tomcat
    Manager.
-   Download the XAR file for XWiki and upload it to populate the empty
    Wiki.

Nginx Proxy Configuration
-------------------------

I found that instructing nginx to proxy to http://localhost:8080/xwiki/
did not work: the generated URLs were incorrect. Contrary to what is
indicated in the XWiki documentation, I could not make the URLs correct
through the use of HTTP headers.

The only solution I'm aware of so far is to create a new Host element in
Tomcat's server.xml file:

-   Duplicate the existing Host element and alter the name attribute to
    read xwiki.
-   Alter the appBase attribute to read /var/lib/tomcat7/webapps-xwiki.
-   Move the xwiki application from /var/lib/tomcat7/webapps/xwiki to
    /var/lib/tomcat7/webapps-xwiki/ROOT.
-   Restart Tomcat
-   Add xwiki as an alias to localhost in /etc/hosts (add it to the end
    of the 127.0.0.1 line).
-   Instruct Nginx to proxy to http://xwiki:8080/ instead.

Retrieved from
"https://wiki.archlinux.org/index.php?title=XWiki&oldid=207234"

Category:

-   Web Server
