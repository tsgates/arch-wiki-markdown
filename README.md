# arch-wiki-markdown #

Search and read Arch Wiki offline in your terminal.

```
    $ wget https://raw.github.com/tsgates/arch-wiki-markdown/master/PKGBUILD
    $ makepkg -csi

    $ ./arch-wiki -h
    Usage:

      arch-wiki [-#|-n] {string}
        Search for wiki article names containing "string" and optionally
        specify the number of the search result to automatically view, or
        disable interactive selection.

        -#
            View the #th result.
        -n | --normal
            Normal mode (no interactive searching)

        Examples:
          arch-wiki PKGBUILD
            Search for wiki articles with names containing "PKGBUILD"

          arch-wiki -3 install
            View the 3rd wiki article with a name containing "install"

      arch-wiki [OPTION]
        OPTIONS:
          -g {string} | --grep {string}
            Search the wiki for the given string
          -v | --version
            Display the version and exit
          -h | --help
            Show this help dialog

    Wiki files are located in /usr/share/doc/arch-wiki-markdown
```

## Update ##

Now we have an interactive search mode. You can jump directly to one of the results.

[See, how it works](http://asciinema.org/a/5872)
