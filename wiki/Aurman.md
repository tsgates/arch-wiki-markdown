Aurman
======

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Overview                                                           |
| -   2 Getting Involved                                                   |
|     -   2.1 Source Code                                                  |
|     -   2.2 Mailing List                                                 |
|                                                                          |
| -   3 Documentation                                                      |
|     -   3.1 .PKGINFO                                                     |
|     -   3.2 New AUR database schema                                      |
+--------------------------------------------------------------------------+

Overview
--------

The AUR Manager is an unofficial development project to improve upon
AUR. The goal of the project is to build a backend, API, and a
command-line interface written in C, similar to Pacman.

  

Getting Involved
----------------

> Source Code

You may clone the source code from the GIT repository:

-   Log/Summary
-   Repository URL: git://git.berlios.de/aurman

> Mailing List

The mailing list can also be found at berliOS.

  

Documentation
-------------

As more documention becomes available, it will be posted here.

> .PKGINFO

Please review this document and please let us know if you have any
suggestions by posting on the mailing list.

> New AUR database schema

CREATE TABLE "aur_architecture" ( "id" integer NOT NULL PRIMARY KEY,
"name" varchar(10) NOT NULL )

CREATE TABLE "aur_repository" ( "id" integer NOT NULL PRIMARY KEY,
"name" varchar(20) NOT NULL )

CREATE TABLE "aur_license" ( "id" integer NOT NULL PRIMARY KEY, "name"
varchar(24) NOT NULL )

CREATE TABLE "aur_group" ( "id" integer NOT NULL PRIMARY KEY, "name"
varchar(10) NOT NULL )

CREATE TABLE "aur_provision" ( // provides=() "id" integer NOT NULL
PRIMARY KEY, "name" varchar(30) NOT NULL )

CREATE TABLE "aur_package" ( "id" integer NOT NULL PRIMARY KEY, "name"
varchar(30) NOT NULL UNIQUE, "version" varchar(20) NOT NULL, "release"
smallint NOT NULL, "description" varchar(180) NOT NULL, "url"
varchar(200), "repository_id" integer NOT NULL REFERENCES
"aur_repository" ("id"), // to be flexible, even if there's only one
repository or not. "tags" varchar(255) NOT NULL, // basically the
"categories" feature request "slug" varchar(50) NOT NULL, // slug is
just the url for it, e.g.
https://aur.archlinux.org/packages/pacman-color/, it's useful for the
server code instead of ID contained url "tarball" varchar(100) NOT NULL,
"deleted" bool NOT NULL, "outdated" bool NOT NULL, "added" datetime NOT
NULL, "updated" datetime NOT NULL )

CREATE TABLE "aur_packagefile" ( "id" integer NOT NULL PRIMARY KEY,
"package_id" integer NOT NULL REFERENCES "aur_package" ("id"),
"filename" varchar(100), "url" varchar(200) )

CREATE TABLE "aur_packagehash" ( "hash" varchar(128) NOT NULL PRIMARY
KEY, // the checksum of the package file "type" varchar(12) NOT NULL,
"file_id" integer NOT NULL REFERENCES "aur_packagefile" ("id") )

CREATE TABLE "aur_comment" ( "id" integer NOT NULL PRIMARY KEY,
"package_id" integer NOT NULL REFERENCES "aur_package" ("id"),
"parent_id" integer, "user_id" integer NOT NULL REFERENCES "auth_user"
("id"), "message" text NOT NULL, "added" datetime NOT NULL, "ip"
char(15) NOT NULL, "hidden" bool NOT NULL )

CREATE TABLE "aur_packagenotification" ( "id" integer NOT NULL PRIMARY
KEY, "user_id" integer NOT NULL REFERENCES "auth_user" ("id"),
"package_id" integer NOT NULL REFERENCES "aur_package" ("id") )

CREATE TABLE "aur_package_maintainers" ( "id" integer NOT NULL PRIMARY
KEY, "package_id" integer NOT NULL REFERENCES "aur_package" ("id"),
"user_id" integer NOT NULL REFERENCES "auth_user" ("id"), UNIQUE
("package_id", "user_id") )

CREATE TABLE "aur_package_licenses" ( "id" integer NOT NULL PRIMARY KEY,
"package_id" integer NOT NULL REFERENCES "aur_package" ("id"),
"license_id" integer NOT NULL REFERENCES "aur_license" ("id"), UNIQUE
("package_id", "license_id") )

CREATE TABLE "aur_package_architectures" ( "id" integer NOT NULL PRIMARY
KEY, "package_id" integer NOT NULL REFERENCES "aur_package" ("id"),
"architecture_id" integer NOT NULL REFERENCES "aur_architecture" ("id"),
UNIQUE ("package_id", "architecture_id") )

CREATE TABLE "aur_package_depends" ( "id" integer NOT NULL PRIMARY KEY,
"from_package_id" integer NOT NULL REFERENCES "aur_package" ("id"),
"to_package_id" integer NOT NULL REFERENCES "aur_package" ("id"), UNIQUE
("from_package_id", "to_package_id") )

CREATE TABLE "aur_package_make_depends" ( "id" integer NOT NULL PRIMARY
KEY, "from_package_id" integer NOT NULL REFERENCES "aur_package" ("id"),
"to_package_id" integer NOT NULL REFERENCES "aur_package" ("id"), UNIQUE
("from_package_id", "to_package_id") )

CREATE TABLE "aur_package_replaces" ( "id" integer NOT NULL PRIMARY KEY,
"from_package_id" integer NOT NULL REFERENCES "aur_package" ("id"),
"to_package_id" integer NOT NULL REFERENCES "aur_package" ("id"), UNIQUE
("from_package_id", "to_package_id") )

CREATE TABLE "aur_package_conflicts" ( "id" integer NOT NULL PRIMARY
KEY, "from_package_id" integer NOT NULL REFERENCES "aur_package" ("id"),
"to_package_id" integer NOT NULL REFERENCES "aur_package" ("id"), UNIQUE
("from_package_id", "to_package_id") )

CREATE TABLE "aur_package_provides" ( "id" integer NOT NULL PRIMARY KEY,
"package_id" integer NOT NULL REFERENCES "aur_package" ("id"),
"provision_id" integer NOT NULL REFERENCES "aur_provision" ("id"),
UNIQUE ("package_id", "provision_id") )

CREATE TABLE "aur_package_groups" ( "id" integer NOT NULL PRIMARY KEY,
"package_id" integer NOT NULL REFERENCES "aur_package" ("id"),
"group_id" integer NOT NULL REFERENCES "aur_group" ("id"), UNIQUE
("package_id", "group_id") )

COMMIT;

BEGIN; CREATE TABLE "auth_permission" ( "id" integer NOT NULL PRIMARY
KEY, "name" varchar(50) NOT NULL, "content_type_id" integer NOT NULL
REFERENCES "django_content_type" ("id"), "codename" varchar(100) NOT
NULL, UNIQUE ("content_type_id", "codename") )

CREATE TABLE "auth_group" ( // Trusted User, Developer, etc.. groups for
authentication "id" integer NOT NULL PRIMARY KEY, "name" varchar(80) NOT
NULL UNIQUE )

CREATE TABLE "auth_user" ( "id" integer NOT NULL PRIMARY KEY, "username"
varchar(30) NOT NULL UNIQUE, "first_name" varchar(30) NOT NULL,
"last_name" varchar(30) NOT NULL, "email" varchar(75) NOT NULL,
"password" varchar(128) NOT NULL, "is_staff" bool NOT NULL, "is_active"
bool NOT NULL, "is_superuser" bool NOT NULL, "last_login" datetime NOT
NULL, "date_joined" datetime NOT NULL )

CREATE TABLE "auth_message" ( "id" integer NOT NULL PRIMARY KEY,
"user_id" integer NOT NULL REFERENCES "auth_user" ("id"), "message" text
NOT NULL )

CREATE TABLE "auth_group_permissions" ( "id" integer NOT NULL PRIMARY
KEY, "group_id" integer NOT NULL REFERENCES "auth_group" ("id"),
"permission_id" integer NOT NULL REFERENCES "auth_permission" ("id"),
UNIQUE ("group_id", "permission_id") )

CREATE TABLE "auth_user_groups" ( "id" integer NOT NULL PRIMARY KEY,
"user_id" integer NOT NULL REFERENCES "auth_user" ("id"), "group_id"
integer NOT NULL REFERENCES "auth_group" ("id"), UNIQUE ("user_id",
"group_id") )

CREATE TABLE "auth_user_user_permissions" ( "id" integer NOT NULL
PRIMARY KEY, "user_id" integer NOT NULL REFERENCES "auth_user" ("id"),
"permission_id" integer NOT NULL REFERENCES "auth_permission" ("id"),
UNIQUE ("user_id", "permission_id") )

C

Retrieved from
"https://wiki.archlinux.org/index.php?title=Aurman&oldid=197587"

Category:

-   Package management
