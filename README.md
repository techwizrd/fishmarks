# fishmarks
Fishmarks is a clone of [bashmarks](https://github.com/huyng/bashmarks) for the
[Fish shell](http://fishshell.com/). Fishmarks is compatible with your existing
bashmarks and bookmarks added using fishmarks are also available in bashmarks.

## Installation
To install fishmarks automatically, paste the following in your terminal.

```fish
curl -L https://github.com/techwizrd/fishmarks/raw/master/install.fish | fish
```

## Updates

To install fishmarks manually:

1.  Clone fishmarks into `~/.fishmarks`

```fish
$ git clone http://github.com/techwizrd/fishmarks.git
```

2.  Source `fishmarks/marks.fish` in your `config.fish` by inserting the
    following into your `~/.config/fish/config.fish`

```fish
# Load fishmarks (http://github.com/techwizrd/fishmarks)
. ~/.fishmarks/marks.fish
```

To update to the latest version of fishmarks:

1.  Navigate to the directory `~/.fishmarks`

2.  Type the following to fetch the new version:

```fish
git fetch --all
```
3.  Type the following to force the update:

```fish
git reset --hard origin/master
```


## Usage

### Commands

```
s <bookmark_name> - Saves the current directory as "bookmark_name"
g <bookmark_name> - Goes (cd) to the directory associated with "bookmark_name"
p <bookmark_name> - Prints the directory associated with "bookmark_name"
d <bookmark_name> - Deletes the bookmark
l - Lists all available bookmarks'
```

### Configuration Variables
All of these must be set before `virtual.fish` is sourced in your `~/.config/fish/config.fish`.

* `SDIRS` - (default: `~/.sdirs`) where all your bookmarks are kept.
* `NO_FISHMARKS_COMPAT_ALIASES` - set this to turn off the bashmark-compatible aliases (e.g., `p` for `print_bookmark`)

### Example

```
[~]$ cd /var/www/
[/var/www]$ s webfolder
[/usr/local/lib]$ cd /usr/local/lib/
[/usr/local/lib]$ s locallib
[/usr/local/lib]$ l
locallib             /usr/local/lib
webfolder            /var/www
[/usr/local/lib]$ g webfolder
[/var/www]$
```

## License
Copyright 2013 Kunal Sarkhel

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License.  You may obtain a copy of the
License at `http://www.apache.org/licenses/LICENSE-2.0`.

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied.  See the License for the
specific language governing permissions and limitations under the License.
