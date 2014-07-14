# arch-wiki-markdown #

Search and read the Arch Wiki offline in your terminal.

## Install ##

### Download Packag ###

The package can be found in the [AUR](https://aur.archlinux.org/packages/arch-wiki-markdown-git) as well as on [Github](https://raw.github.com/tsgates/arch-wiki-markdown).

### Configure Language ###

The wiki is downloaded in English by default, but other languages can be set by changing the `$_wiki_lang` variable in the PKGBUILD. A list of available languages is given below the variable, but it's possible that new ones have become available since writing.

### Build and Install ###

The package can be built and installed by running: `makepkg -csi`. It will download the latest image of the wiki contained in the [arch-wiki-docs](https://www.archlinux.org/packages/community/any/arch-wiki-docs/) package, and convert the pages to a usable markdown format before creating the package.

## Usage ##

To view the list of valid commands, run the help option:

```
    $ ./arch-wiki -h
    Usage:

      arch-wiki [-#|-n] {string}
        Search for wiki article names containing the given {**string**},
        and optionally disable interactive search with the `-n` flag,
        or choose to directly view a given result using the `-#`
        flag, where # is the search result number you wish to view.

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

## Interactive Search Mode ##

You can now interactively select one of the results (use the `-n` option to search the old way).

[See, how it works](http://asciinema.org/a/5872)
