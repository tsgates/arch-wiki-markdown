# arch-wiki-markdown #

Search and read the Arch Wiki offline in your terminal.

## Install ##

This package can be installed through the [AUR](https://aur.archlinux.org/packages/arch-wiki-markdown-git), or manually from github by running:

```
    $ wget https://raw.github.com/tsgates/arch-wiki-markdown/master/PKGBUILD
    $ makepkg -csi
```


## Usage ##

To view the list of valid commands, run the help option:

```
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

## Interactive Search Mode ##

You can now interactively select one of the results (use the `-n` option to search the old way).

[See, how it works](http://asciinema.org/a/5872)

## Update Wiki ##

Before running `makepkg -csi`, the wiki can be updated by running `./gen-wiki.sh`.

### Requirements ###

#### Pacman ####

Pacman packages that need to be installed:

* **ghc**: Glawsgow Haskell Compiler
* **alex**: Lexical analyser generator for Haskell
* **happy**: Parser generator for Haskell
* **cabal-install**: CLI tool for Cabal and Hackage to install Haskell packages in $HOME
* **wget**: Network utility to retrieve files from the web

#### Cabal ####

Haskell libraries that need to be installed with `cabal`:

```
    $ cabal update
    $ cabal -j install tagsoup pandoc MissingH filemanip
```
