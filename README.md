# fishmarks
Fishmarks is a clone of [bashmarks](https://github.com/huyng/bashmarks) for the
[Fish shell](https://fishshell.com/). Fishmarks is compatible with your existing
bashmarks and bookmarks added using fishmarks are also available in bashmarks.

## Installation

### Automatic Installation

To install fishmarks automatically, paste the following in your terminal.

```fish
curl -fsSL https://raw.githubusercontent.com/techwizrd/fishmarks/master/install.fish | fish
```

Please note, however, that you should _never_ install things by piping untrusted "install" scripts downloaded through ``curl`` directly into your shell (be it ``bash`` or ``fish``). Even if you read through the install script and think you understand it, you could be prone to a [man-in-the-middle](https://en.wikipedia.org/wiki/Man-in-the-middle_attack) attack or any number of security vulnerabilities. While manual installations are tedious, they are recommended for any situations where security is a concern (and it should almost always be a concern).

### Fisher Installation

If you use [Fisher](https://github.com/jorgebucaran/fisher), install fishmarks with:

```fish
fisher install techwizrd/fishmarks
```

### Manual Installation

To install fishmarks manually:

1.  Clone fishmarks into `~/.fishmarks`

```fish
$ git clone https://github.com/techwizrd/fishmarks.git ~/.fishmarks
```

2.  Source `~/.fishmarks/marks.fish` from a file in `~/.config/fish/conf.d/`

```fish
mkdir -p ~/.config/fish/conf.d
printf '# Load fishmarks (https://github.com/techwizrd/fishmarks)\nsource ~/.fishmarks/marks.fish\n' > ~/.config/fish/conf.d/fishmarks.fish
```
### Update to the latest version

To update to the latest version of fishmarks:

1.  Navigate to the directory where your fishmarks code is kept (It is located in `~/.fishmarks` by default)
```fish
cd ~/.fishmarks
```

2.  Use git to fetch the latest version:

```fish
git fetch --all
```
3.  Pull the latest version:

```fish
git pull --ff-only
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
All of these must be set before `marks.fish` is sourced in your fish startup files.

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

## Running tests

Run the test suite with:

```fish
fish tests/run.fish
```

### Contributing

*Have you noticed any bugs or issues with fishmarks? Do you have any features you would like to see added?*

1. [Check on Github](https://github.com/techwizrd/fishmarks/issues?state=open) to see whether anyone else has encountered the same issue or has the same feature request. If someone someone has encountered the same issue or has the same feature request, comment to let me know that it affects you too.
2. If no one has encountered the same issue, [file an issue](https://github.com/techwizrd/fishmarks/issues?state=open) on Github with the "bug" label, your operating system version, fish shell version, clear steps describing how to reproduce the error. If no one has requested the same feature, [file an issue](https://github.com/techwizrd/fishmarks/issues?state=open) on Github with the "enhancement" label and a brief, clear description of your feature and why it would make a great addition to fishmarks.
3. Once you have filed the issue, if you would like to fix the issue or add the feature yourself, assign the issue to yourself on Github and fork the repository. Clone your fork and make your changes, commit them, and push them to Github. After you have pushed all your changes to Github, send me a merge request and comment on the issue to let me know that your merge request fixes the bug or adds the requested feature. Please make sure to write good commit messages and keep your history clean and understandable. Good commit messages and clean history make it easier for me to merge your changes and keep the history nice and useful.

I recommend the following guides on writing good commit messages:
- [GIT Commit Good Practice](https://wiki.openstack.org/wiki/GitCommitMessages)
- [A Note About Git Commit Messages](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
- [Proper Git Commit Messages and an Elegant Git History](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)


## License
Copyright 2013 Kunal Sarkhel

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License.  You may obtain a copy of the
License at `https://www.apache.org/licenses/LICENSE-2.0`.

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied.  See the License for the
specific language governing permissions and limitations under the License.
