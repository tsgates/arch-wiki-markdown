# arch-wiki-markdown #

Search and read the Arch Wiki offline in your terminal.

## Install ##

### Download Package ###

The package can be found in the [AUR](https://aur.archlinux.org/packages/arch-wiki-markdown-git) as well as on [Github](https://raw.github.com/tsgates/arch-wiki-markdown), and building can be initiated on pacman-based Linux distributions by running `makepkg` in the base project directory.

### Configure ###

#### Language ####

The wiki is downloaded in English by default, but other languages can be set by changing the `$_wiki_lang` variable in the _PKGBUILD_, or setting it at runtime (ie: `_wiki_lang=fr makepkg`).


#### Download Method ####

The wiki can be downloaded in one of two ways:

1. Pre-compiled in the _arch-wiki-docs_ package, which takes much less time to download, but is also frequently a few weeks out of date.
2. Directly from the live wiki.

No action needs to be taken if you plan to use the pre-compiled package, and if you would like to download directly from the live wiki, you can do so by changing the `$_wiki_downloadlive` variable to `1` in the _PKGBUILD_ or at runtime (ie: `_wiki_downloadlive=1 makepkg`).

**Note**: Due to the size of the download, once the wiki has been downloaded to `src/wiki-docs/`, the PKGBUILD will use that version until you remove the directory.

#### Prevent Rebuild ###

By default, the wiki gets converted from html to markdown each time you build the package. If you would like to prevent this (maybe you want to tweak the package without waiting for it to rebuild), set the `$_wiki_norebuild` variable to `1` in the _PKGBUILD_ or at runtime (ie: `_wiki_norebuild=1 makepkg`), and pandoc won't be used to convert the wiki if the folder with the converted files already exists.

## Usage ##

To view the list of valid commands, run the help option:

```
USAGE:
    arch-wiki [-n|-#] {STRING}

        Search for wiki article names containing the given {STRING},
        and optionally disable interactive search with the -n flag,
        or choose to directly view a given result using the -#
        flag, where # is the search result number you wish to view.

        -n | --normal
            Normal mode (no interactive searching)
        -#
            View the #th result

    arch-wiki [OPTION]

        OPTIONS:
        -g {STRING} | --grep {STRING}
            Search the wiki for the given string
        -v | --version
            Display the version and exit
        -h | --help
            Show this help dialog

EXAMPLES:
    arch-wiki PKGBUILD
        Search for wiki articles with names containing PKGBUILD

    arch-wiki -3 install
        View the 3rd wiki article with a name containing install

Wiki files are located in /usr/share/doc/arch-wiki-markdown
```

## Credits ##

Written by: Taesoo Kim ([tsgates](https://github.com/tsgates))

### Contributors ###

* Kevin MacMartin ([prurigro](https://github.com/prurigro))
