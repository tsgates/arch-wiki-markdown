Luakit
======

Luakit is an extremely fast, lightweight and flexible web browser using
the webkit engine. It is customizable through lua scripts and fully
usable with keyboard shortcuts.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Basic usage                                                        |
|     -   2.1 Browsing                                                     |
|     -   2.2 Input fields                                                 |
|     -   2.3 Bookmarks                                                    |
|                                                                          |
| -   3 Configuration                                                      |
|     -   3.1 Homepage                                                     |
|     -   3.2 Custom search engines                                        |
|     -   3.3 Download location                                            |
|     -   3.4 Adblock                                                      |
|     -   3.5 Bookmarks management                                         |
|         -   3.5.1 Sync                                                   |
|         -   3.5.2 Converting plain text bookmarks to SQLite format       |
|         -   3.5.3 Import from Firefox                                    |
|         -   3.5.4 Export bookmarks                                       |
|                                                                          |
|     -   3.6 Tor                                                          |
|                                                                          |
| -   4 External links                                                     |
+--------------------------------------------------------------------------+

Installation
------------

The luakit package can be found in the official repositories and can be
installed with pacman.

You can also use the git version available from the [AUR].

With the Unix philosophy in mind, Luakit is entirely customizable
through its configuration files. Those files are written in the Lua
scripting language, thus allowing virtually unlimited features. First,
copy the configuration files to your $XDG_CONFIG_HOME folder:

    cp -r $XDG_CONFIG_DIRS/luakit $XDG_CONFIG_HOME

Now you can edit any of these files to make your browser fits your
needs. Even if you do not know much about Lua, the configuration is
simple and well commented enough to make it straightforward.

Basic usage
-----------

Note:Most of the shortcuts are viewable and customizable from binds.lua.

Press : to access the command prompt. You can do nearly everything from
there. Use Tab to autocomplete commands.

To quit, use the quit command, or the ZQ shortcut. You can also close
the browser while remembering the session (i.e. restoring the tabs) by
using the writequit command instead, or the ZZ shortcut.

> Browsing

-   Press o to open a prompt with the open command and enter the URI you
    want. Press O to edit the current URI.
-   If it is not a recognized URI, Luakit will use the default search
    engine specified in globals.lua.
-   Specify which search engine to use by prefixing the entry with the
    appropriate keywork (e.g. :open google foobar will search foobar on
    Google).
-   Use common shortcuts to navigate. For emacs and vim aficionados,
    some of their regular shortcuts are provided. You can use the mouse
    as well.
-   Use f to display the index of all visible links. Enter the
    appropriate number or a part of the string to open the link.
-   Use F instead to open link in a new tab.
-   Press Ctrl+t to open a new tab, Ctrl+w to close it. Press t to
    prompt for an URI to be opened in a new tab, and T to edit the
    current URI in a new tab.
-   Press w to prompt for an URI to be opened in a new window, and W to
    edit the current URI in a new window.
-   Switch from one tab to another with gt and gT, or Ctrl+Page Up and
    Ctrl+Page Down.
-   You can switch to a specific tab with Alt+number.
-   Reorder the tabs with < and >.
-   Reload the page with r, stop the loading with Ctrl+c.
-   You can re-open last closed tab with u.
-   Open downloads page with gd (or gD fo a new tab).
-   Copy URI to primary selection with y.
-   View page source code with :viewsource. Return to normal view with
    :viewsource!.
-   View image source with ;i (or with ;I for new tab).
-   Inspect elements with :inspect. Repeat to open in a new window.
    Disable inspector with :inspect!

> Input fields

Many webpages have editable elements like dropdown lists, checkboxes,
text fields and so on. While they work perfectly with the mouse, you may
encounter some troubles using the follow commands. In such a case,
pressing the arrow keys may help. Alternatively, you can use the focus
input gi shortcut.

> Bookmarks

If enabled (default configuration), bookmarks can be used from within
Luakit.

-   The :bookmarks command opens the bookmarks page. (Shortcut: gb or gB
    for new tab).
-   The :bookmark [<URI> [<tags>]] command adds the URI specified (or
    the current tab's URI, if omitted) to the bookmarks by specified
    tags. Starting from version 2012-09-13-r1, bookmarks page will be
    opened (new tab) in new bookmark editing mode before saving.
    (Shortcut: B).

Configuration
-------------

> Homepage

Set your homepage as follows:

    globals.lua

    globals = {
        homepage = "about:blank",
    -- ...
    }

> Custom search engines

You can virtually add any search engine you want. Make a search on the
website you want and copy paste the URI to the Luakit configuration by
replacing the searched terms with an %s. Example:

    globals.lua

    search_engines = {
        aur = "https://aur.archlinux.org/packages.php?O=0&K=%s&do_Search=Go",
    -- ...
    }

The variable is used as a keyword for the :open command in Luakit.

Set the defaut search engine by using this same keyword:

    globals.lua

    search_engines.default = search_engines.aur

> Download location

This can be specified in rc.lua :

    -- Add download support                                                                                                                                                                                                                        
    require "downloads"
    require "downloads_chrome"

    -- Set download location                                                                                                                                                                                                                                      
    downloads.default_dir = os.getenv("HOME") .. "/downloads"
    downloads.add_signal("download-location", function (uri, file)
        if not file or file == "" then
            file = (string.match(uri, "/([^/]+)$")
                or string.match(uri, "^%w+://(.+)")
                or string.gsub(uri, "/", "_")
                or "untitled")
        end
        return downloads.default_dir .. "/" .. file
    end)

> Adblock

There are several plugins available out there.

The official website features this one:
https://github.com/mason-larobina/luakit/wiki/AdBlock-Lua-module

-   Put the adblock.lua and adblock_chrome.lua files in your
    $XDG_CONFIG_HOME/luakit. (mostly your ~/.config/luakit folder).
-   Edit rc.lua and add

    rc.lua

    require "adblock"
    require "adblock_chrome"

-   Fetch an adblock-compatible list, like Easylist, and save it to
    $XDG_DATA_HOME/luakit (mostly your ~/.local/share/luakit folder).
-   Restart Luakit to load the extension.
-   Use :adblock-list-enable <number> command within Luakit to turn
    Adblock's list[s] you downloaded on; AdBlock itself becomes enabled
    on startup.

Full info on enabled lists and AdBlock state you can find using :adblock
or gA at luakit://adblock/ internal page, if you enabled adblock_chrome
module which is not a mandatory part.

AdBlock for Luakit plugin is also available as a part of Luakit Plugins
project: https://github.com/mason-larobina/luakit-plugins/

> Bookmarks management

Sync

Starting from version 2012.09.13, Luakit bookmarks are stored in an
SQLite database: $XDG_DATA_HOME/luakit/bookmarks.db.

You can put a symbolic link in place of the default file to store your
bookmarks anywhere on your machine. This way if your are using a cloud
sync application like Dropbox, you can keep your bookmarks synchronized
between your different computers.

Converting plain text bookmarks to SQLite format

Luakit 2012.03.25 featured bookmarks stored in a simple plain text file:
$XDG_DATA_HOME/luakit/bookmarks. Each line is a bookmark. It is composed
of 2 fields:

    $XDG_DATA_HOME/luakit/bookmarks

    link    group   

Warning:Each field is followed by a tabulation. If you insert spaces
instead, the link will not be properly bookmarked.

Groups and links are alphabetically sorted, so there is no need to do it
manually.

If you want to use your bookmarks with the latest Luakit release, you
will have to convert the file. Here follow a sample Lua script to do
that:

    bookmarks_plain_to_sqlite.lua

    local usage = [[Usage: luakit -c bookmarks_plain_to_sqlite.lua [bookmark plaintext path] [bookmark db path]
    ]]

    local old_db_path, new_db_path = unpack(uris)

    if not old_db_path or not new_db_path then
       io.stdout:write(usage)
       luakit.quit(1)
    end

    -- One-pass file read into 'data' var.
    old_db = assert(io.open(old_db_path, "r"))
    local data = old_db:read("*all")
    assert(old_db:close())

    -- Init new_db, otherwise sqlite queries will fail.
    new_db = sqlite3{ filename = new_db_path }
    new_db:exec("CREATE TABLE IF NOT EXISTS bookmarks (id INTEGER PRIMARY KEY, uri TEXT NOT NULL, title TEXT NOT NULL, desc TEXT NOT NULL, tags TEXT NOT NULL, created INTEGER, modified INTEGER )")

    -- Fill
    local url,tag

    for line in data:gmatch("[^\n]*\n?") do

       if string.len(line) > 1 then

          print ("["..line.."]")

          -- Get url and tag (if present) from first line.
          _, _, url, tag = string.find(line, "([^\n\t]+)\t*([^\n]*)\n?")

          -- Optional yet convenient output.
          io.write(url)
          io.write("\t")
          io.write(tag)
          io.write("\n")

          -- DB insertion. Nothing will be overwritten. If URL and/or tag already exists, then a double is created.
          new_db:exec("INSERT INTO bookmarks VALUES (NULL, ?, ?, ?, ?, ?, ?)", 
                      {
                         url, "", "", tag or "",
                         os.time(), os.time()
                      })
          end
    end

    print("Import finished.")
    print("\nVacuuming database...")
    new_db:exec "VACUUM"
    print("Vacuum done.")

    luakit.quit(0)

As stated at beginning of the script, you must run it with Luakit:

    $ luakit -c bookmarks_plain_to_sqlite.lua [bookmark plaintext path] [bookmark db path]

Your old plaintext bookmarks will be left unchanged. If the DB bookmarks
do not exist, the file will be created. If it exist, do not worry, none
of the previous bookmarks will be touched. However, this behaviour
implies that you might get some doubles.

Import from Firefox

Note:This is for Luakit 2012.03.25 only! For newer version, you can
first run this script, then convert the generted plain text bookmarks to
the SQLite format as stated above.

To import your bookmarks from Firefox, first you must export them to an
HTML file using its bookmarks manager. Now we must convert the XML file
to a Luakit format. You can use the following one-line awk command:

    $ cat bookmarks.html | awk '
    {gsub(/\"/," ")}
    /<\/H3>/{FS=">";gsub(/</,">");og=g;g=$(NF-2);FS=" "}
    /<DL>/{x++;if(x>= 3)gl[x-3]=g}
    /<\/DL>/{x--;if(x==2)g=og"2"}
    /HREF/{gsub(/</," ");gsub(/>/," ");if(g!=""){if(og!=g){printf "\n";og=g};printf "%s\t",$4;if(x>=3){for(i=0;i<=x-4;i++){printf "%s-",gl[i]}printf "%s\n",gl[x-3]}else{printf "\n"}}}'

Or if you prefer the more readable script version:

    ff2lk.awk


    # Notes: 'folders' for Firefox bookmarks mean 'groups' for Luakit.

    # Put spaces where it is needed to delimit words properly.
    {gsub(/\"/," ")}

    # Since the folder name may have spaces, delimiter must be ">" here.
    /<\/H3>/ {
        FS=">"
        gsub(/</,">")
        oldgroup=group
        group=$(NF-2)
        FS=" "
    }

    # Each time a <DL> is encountered, it means we step into a subfolder.
    # 'count' is the depth level.
    # Base level starts at 2 (Firefox fault).
    # 'groupline' is an array of all parent folders.
    /<DL>/ {
        count++
        if ( count >= 3 )
            groupline[count-3]=group
    }

    # On </DL>, we step out.
    # If if return to the base level (i.e. not in a folder), then we give 'group' a fake name different
    # from 'oldgroup' to make sure a line will be skipped (see below).
    /<\/DL>/ {
        count--
        if( count == 2 )
            group=oldgroup"ROOT"
    }

    # The bookmark name.
    # If oldgroup is different than group, (i.e. folder changed) then we skip a line.
    # If we are in a folder, then we print the group name, i.e. all parents plus the current folder
    # separated by an hyphen.
    /HREF/ {
        gsub(/</," ")
        gsub(/>/," ")
        if (group != "")
        {
            if(oldgroup != group)
            {
                printf "\n"
                oldgroup=group
            }
            printf "%s\t",$4
            if ( count >= 3 )
            {
                for ( i=0 ; i <= count-4 ; i++ )
                {printf "%s-" , groupline[i]}
                printf "%s" , groupline[count-3]
            }
            printf "\n"
        }
    }

Run it with

    $ awk -f ff2lk.awk bookmarks.html >> bookmarks

Export bookmarks

The following script let you export Luakit bookmarks from its SQLite
format to a plain text file. The resulting file may be suitable for
other web browsers, or may be easily parsed by import scripts.

    bookmarks_sqlite_to_plain.lua

    -- USER CONFIG

    local sep = " "

    -- END OF USER CONFIG

    local usage = [[Usage: luakit -c bookmarks_sqlite_to_plain.lua [bookmark db path] [bookmark plain path]

    DB scheme is

        bookmarks (
            id INTEGER PRIMARY KEY,
            uri TEXT NOT NULL,
            title TEXT NOT NULL,
            desc TEXT NOT NULL,
            tags TEXT NOT NULL,
            created INTEGER,
            modified INTEGER
        );
    ]]

    local old_db_path, new_db_path = unpack(uris)

    if not old_db_path or not new_db_path then
       io.stdout:write(usage)
       luakit.quit(1)
    end

    -- One-pass file read into 'data' var.
    new_db = assert(io.open(new_db_path, "w"))

    -- Open old_db
    old_db = sqlite3{ filename = old_db_path }

    -- Load all db values to a string variable.
    local rows = old_db:exec [[ SELECT * FROM bookmarks ]]

    -- Iterate over all entries.
    -- Note: it could be faster to use one single concatenation for all entries, but
    -- it would be much more code and not so flexible. It is desirable to focus on
    -- clarity. After all, only a few hundred lines are handled.
    for _, b in ipairs(rows) do

       -- Change %q for %s to remove double quotes if needed.
       -- You can toggle the desired fields with comments.
       local outputstr = 
          string.format("%q%s", b.uri or "", sep) .. 
          string.format("%q%s", b.title or "", sep) ..
          string.format("%q%s", b.desc or "", sep) ..
          string.format("%q%s- ", b.tags or "", sep) ..
          ((b.created or "" ) .. sep) ..
          ((b.modified or "" ) .. sep) ..
          "\n"

       -- Write entry to file.
       new_db:write(outputstr)
    end


    print("Export done.")

    assert(new_db:close())

    luakit.quit(0)

As stated at beginning of the script, you must run it with Luakit:

    $ luakit -c bookmarks_plain_to_sqlite.lua [bookmark plaintext path] [bookmark db path]

> Tor

Once Tor has been setup, simply run:

    $ torify luakit

External links
--------------

-   Home page: http://mason-larobina.github.com/luakit/
-   Cheatsheet: http://shariebeth.com/computers/luakitcheatsheet.txt

Retrieved from
"https://wiki.archlinux.org/index.php?title=Luakit&oldid=252424"

Category:

-   Web Browser
