Binfmt misc for Java
====================

From Wikipedia:

"binfmt_misc is a capability of the Linux kernel which allows arbitrary
executable file formats to be recognized and passed to certain user
space applications, such as emulators and virtual machines."

In plain language, this allows you to take a Java jar file that you
would ordinarily run via a line such as

    java -jar /path/to/MyProgram.jar

and instead run it simply with

    MyProgram.jar

as long as it's on the PATH.

The information in this article is almost entirely taken from the files
binfmt_misc.txt and java.txt in the Documentation sub-directory of the
Linux kernel source tree.

Contents
--------

-   1 Setup
    -   1.1 Mounting binfmt_misc
    -   1.2 Registering the file type with binfmt_misc
    -   1.3 The wrapper scripts
        -   1.3.1 jarwrapper
        -   1.3.2 javawrapper
        -   1.3.3 javaclassname
-   2 Testing
-   3 Notes

Setup
-----

> Mounting binfmt_misc

For an ad-hoc mount:

    mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc

For a persistent mount via fstab add the line:

    none  /proc/sys/fs/binfmt_misc binfmt_misc defaults 0 0

> Registering the file type with binfmt_misc

This is done by echoing a specially formatted line to
/proc/sys/fs/binfmt_misc/register. The contents of the line is explained
in the Documentation/binfmt_misc.txt file. To make the file
registrations automatic at boot you can add the appropriate lines to
your rc.local file, for example:

    # binfmt_misc support for Java applications:
    echo ':Java:M::\xca\xfe\xba\xbe::/usr/local/bin/javawrapper:' > /proc/sys/fs/binfmt_misc/register
    # binfmt_misc support for executable Jar files:
    echo ':ExecutableJAR:E::jar::/usr/local/bin/jarwrapper:' > /proc/sys/fs/binfmt_misc/register
    # binfmt_misc support for Java Applets:
    echo ':Applet:E::html::/opt/java/bin/appletviewer:' > /proc/sys/fs/binfmt_misc/register

The first two of the above entries run Java class and jar files via
'wrapper' scripts describe in the next section. The final entry runs
Java applets in the usual way. You may reboot or run the file to put the
registrations into effect immediately.

> The wrapper scripts

jarwrapper

    #!/bin/bash
    # /usr/local/bin/jarwrapper - the wrapper for binfmt_misc/jar

    # set path to java using JAVA_HOME if available, otherwise assume it's on the PATH
    JAVA_PATH=${JAVA_HOME:+$JAVA_HOME/jre/bin/}java
    $JAVA_PATH -jar "$@"

javawrapper

    #!/bin/bash
    # /usr/local/bin/javawrapper - the wrapper for binfmt_misc/java

    if [ -z "$1" ]; then
    	exec 1>&2
    	echo Usage: $0 class-file
    	exit 1
    fi

    CLASS=$1
    FQCLASS=`/usr/local/bin/javaclassname $1`
    FQCLASSN=`echo $FQCLASS | sed -e 's/^.*\.\([^.]*\)$/\1/'`
    FQCLASSP=`echo $FQCLASS | sed -e 's-\.-/-g' -e 's-^[^/]*$--' -e 's-/[^/]*$--'`

    # for example:
    # CLASS=Test.class
    # FQCLASS=foo.bar.Test
    # FQCLASSN=Test
    # FQCLASSP=foo/bar

    unset CLASSBASE

    declare -i LINKLEVEL=0

    while :; do
    	if [ "`basename $CLASS .class`" == "$FQCLASSN" ]; then
    		# See if this directory works straight off
    		cd -L `dirname $CLASS`
    		CLASSDIR=$PWD
    		cd $OLDPWD
    		if echo $CLASSDIR | grep -q "$FQCLASSP$"; then
    			CLASSBASE=`echo $CLASSDIR | sed -e "s.$FQCLASSP$.."`
    			break;
    		fi
    		# Try dereferencing the directory name
    		cd -P `dirname $CLASS`
    		CLASSDIR=$PWD
    		cd $OLDPWD
    		if echo $CLASSDIR | grep -q "$FQCLASSP$"; then
    			CLASSBASE=`echo $CLASSDIR | sed -e "s.$FQCLASSP$.."`
    			break;
    		fi
    		# If no other possible filename exists
    		if [ ! -L $CLASS ]; then
    			exec 1>&2
    			echo $0:
    			echo "  $CLASS should be in a" \
    			     "directory tree called $FQCLASSP"
    			exit 1
    		fi
    	fi
    	if [ ! -L $CLASS ]; then break; fi
    	# Go down one more level of symbolic links
    	let LINKLEVEL+=1
    	if [ $LINKLEVEL -gt 5 ]; then
    		exec 1>&2
    		echo $0:
    		echo "  Too many symbolic links encountered"
    		exit 1
    	fi
    	CLASS=`ls --color=no -l $CLASS | sed -e 's/^.* \([^ ]*\)$/\1/'`
    done

    if [ -z "$CLASSBASE" ]; then
    	if [ -z "$FQCLASSP" ]; then
    		GOODNAME=$FQCLASSN.class
    	else
    		GOODNAME=$FQCLASSP/$FQCLASSN.class
    	fi
    	exec 1>&2
    	echo $0:
    	echo "  $FQCLASS should be in a file called $GOODNAME"
    	exit 1
    fi

    if ! echo $CLASSPATH | grep -q "^\(.*:\)*$CLASSBASE\(:.*\)*"; then
    	# class is not in CLASSPATH, so prepend dir of class to CLASSPATH
    	if [ -z "${CLASSPATH}" ] ; then
    		export CLASSPATH=$CLASSBASE
    	else
    		export CLASSPATH=$CLASSBASE:$CLASSPATH
    	fi
    fi

    shift
    # set path to java using JAVA_HOME if available, otherwise assume it's on the PATH
    JAVA_PATH=${JAVA_HOME:+$JAVA_HOME/jre/bin/}java
    $JAVA_PATH $FQCLASS "$@"

javaclassname

This program is used by the javawrapper script above. Compile it with
the command

    gcc -O2 -o javaclassname javaclassname.c

and move the executable to /usr/local/bin.

    /* javaclassname.c
     *
     * Extracts the class name from a Java class file; intended for use in a Java
     * wrapper of the type supported by the binfmt_misc option in the Linux kernel.
     *
     * Copyright (C) 1999 Colin J. Watson <cjw44@cam.ac.uk>.
     *
     * This program is free software; you can redistribute it and/or modify
     * it under the terms of the GNU General Public License as published by
     * the Free Software Foundation; either version 2 of the License, or
     * (at your option) any later version.
     *
     * This program is distributed in the hope that it will be useful,
     * but WITHOUT ANY WARRANTY; without even the implied warranty of
     * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
     * GNU General Public License for more details.
     *
     * You should have received a copy of the GNU General Public License
     * along with this program; if not, write to the Free Software
     * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
     */

    #include <stdlib.h>
    #include <stdio.h>
    #include <stdarg.h>
    #include <sys/types.h>

    /* From Sun's Java VM Specification, as tag entries in the constant pool. */

    #define CP_UTF8 1
    #define CP_INTEGER 3
    #define CP_FLOAT 4
    #define CP_LONG 5
    #define CP_DOUBLE 6
    #define CP_CLASS 7
    #define CP_STRING 8
    #define CP_FIELDREF 9
    #define CP_METHODREF 10
    #define CP_INTERFACEMETHODREF 11
    #define CP_NAMEANDTYPE 12

    /* Define some commonly used error messages */

    #define seek_error() error("%s: Cannot seek\n", program)
    #define corrupt_error() error("%s: Class file corrupt\n", program)
    #define eof_error() error("%s: Unexpected end of file\n", program)
    #define utf8_error() error("%s: Only ASCII 1-255 supported\n", program);

    char *program;

    long *pool;

    u_int8_t read_8(FILE *classfile);
    u_int16_t read_16(FILE *classfile);
    void skip_constant(FILE *classfile, u_int16_t *cur);
    void error(const char *format, ...);
    int main(int argc, char **argv);

    /* Reads in an unsigned 8-bit integer. */
    u_int8_t read_8(FILE *classfile)
    {
    	int b = fgetc(classfile);
    	if(b == EOF)
    		eof_error();
    	return (u_int8_t)b;
    }

    /* Reads in an unsigned 16-bit integer. */
    u_int16_t read_16(FILE *classfile)
    {
    	int b1, b2;
    	b1 = fgetc(classfile);
    	if(b1 == EOF)
    		eof_error();
    	b2 = fgetc(classfile);
    	if(b2 == EOF)
    		eof_error();
    	return (u_int16_t)((b1 << 8) | b2);
    }

    /* Reads in a value from the constant pool. */
    void skip_constant(FILE *classfile, u_int16_t *cur)
    {
    	u_int16_t len;
    	int seekerr = 1;
    	pool[*cur] = ftell(classfile);
    	switch(read_8(classfile))
    	{
    	case CP_UTF8:
    		len = read_16(classfile);
    		seekerr = fseek(classfile, len, SEEK_CUR);
    		break;
    	case CP_CLASS:
    	case CP_STRING:
    		seekerr = fseek(classfile, 2, SEEK_CUR);
    		break;
    	case CP_INTEGER:
    	case CP_FLOAT:
    	case CP_FIELDREF:
    	case CP_METHODREF:
    	case CP_INTERFACEMETHODREF:
    	case CP_NAMEANDTYPE:
    		seekerr = fseek(classfile, 4, SEEK_CUR);
    		break;
    	case CP_LONG:
    	case CP_DOUBLE:
    		seekerr = fseek(classfile, 8, SEEK_CUR);
    		++(*cur);
    		break;
    	default:
    		corrupt_error();
    	}
    	if(seekerr)
    		seek_error();
    }

    void error(const char *format, ...)
    {
    	va_list ap;
    	va_start(ap, format);
    	vfprintf(stderr, format, ap);
    	va_end(ap);
    	exit(1);
    }

    int main(int argc, char **argv)
    {
    	FILE *classfile;
    	u_int16_t cp_count, i, this_class, classinfo_ptr;
    	u_int8_t length;

    	program = argv[0];

    	if(!argv[1])
    		error("%s: Missing input file\n", program);
    	classfile = fopen(argv[1], "rb");
    	if(!classfile)
    		error("%s: Error opening %s\n", program, argv[1]);

    	if(fseek(classfile, 8, SEEK_SET))  /* skip magic and version numbers */
    		seek_error();
    	cp_count = read_16(classfile);
    	pool = calloc(cp_count, sizeof(long));
    	if(!pool)
    		error("%s: Out of memory for constant pool\n", program);

    	for(i = 1; i < cp_count; ++i)
    		skip_constant(classfile, &i);
    	if(fseek(classfile, 2, SEEK_CUR))	/* skip access flags */
    		seek_error();

    	this_class = read_16(classfile);
    	if(this_class < 1 || this_class >= cp_count)
    		corrupt_error();
    	if(!pool[this_class] || pool[this_class] == -1)
    		corrupt_error();
    	if(fseek(classfile, pool[this_class] + 1, SEEK_SET))
    		seek_error();

    	classinfo_ptr = read_16(classfile);
    	if(classinfo_ptr < 1 || classinfo_ptr >= cp_count)
    		corrupt_error();
    	if(!pool[classinfo_ptr] || pool[classinfo_ptr] == -1)
    		corrupt_error();
    	if(fseek(classfile, pool[classinfo_ptr] + 1, SEEK_SET))
    		seek_error();

    	length = read_16(classfile);
    	for(i = 0; i < length; ++i)
    	{
    		u_int8_t x = read_8(classfile);
    		if((x & 0x80) || !x)
    		{
    			if((x & 0xE0) == 0xC0)
    			{
    				u_int8_t y = read_8(classfile);
    				if((y & 0xC0) == 0x80)
    				{
    					int c = ((x & 0x1f) << 6) + (y & 0x3f);
    					if(c) putchar(c);
    					else utf8_error();
    				}
    				else utf8_error();
    			}
    			else utf8_error();
    		}
    		else if(x == '/') putchar('.');
    		else putchar(x);
    	}
    	putchar('\n');
    	free(pool);
    	fclose(classfile);
    	return 0;
    }

Testing
-------

Create a simple HelloWorld.java program such as the following:

    class HelloWorld {
        public static void main(String args[]) {
            System.out.println("Hello World!");
        }
    }

Compile it as normal and make the .class file executable with the
command

    chmod +x HelloWorld.class

You should then be able to run it by simply entering:

    ./HelloWorld.class

Notes
-----

-   Some of the material on binfmt_misc refers to it as a module but
    Arch builds it into the standard kernel.
-   The setup given here works with both the Sun JRE & openjdk6.
-   binfmt_misc can be used for other file types as well. For example,
    to be able to run DOS/Windows files without having to explicitly
    specify the wine program, add the following registration entry:

    # binfmt_misc support for DOS / Windows applications via Wine
    echo ':DOSWin:M::MZ::/usr/bin/wine:' > /proc/sys/fs/binfmt_misc/register

Retrieved from
"https://wiki.archlinux.org/index.php?title=Binfmt_misc_for_Java&oldid=198019"

Category:

-   Emulators

-   This page was last modified on 23 April 2012, at 16:54.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
