# fishmarks
[![CI](https://github.com/techwizrd/fishmarks/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/techwizrd/fishmarks/actions/workflows/ci.yml)
[![Latest Release](https://img.shields.io/github/v/release/techwizrd/fishmarks)](https://github.com/techwizrd/fishmarks/releases)
[![License](https://img.shields.io/github/license/techwizrd/fishmarks)](LICENSE)
[![Fish 3+](https://img.shields.io/badge/fish-3%2B-4AAE46)](https://fishshell.com/)

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
l - Lists all available bookmarks
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

Run syntax and formatting checks with:

```fish
fish tests/check.fish
```

## Development workflow

Install [prek](https://prek.j178.dev/latest/) (or pre-commit) hooks locally:

```fish
prek install
```

Run all hooks on demand:

```fish
prek run --all-files
```

GitHub Actions CI runs the same checks (`tests/check.fish`, `tests/run.fish`) and an installer smoke test on every push and pull request.

## Versioning

fishmarks follows [Semantic Versioning](https://semver.org/). Notable changes are tracked in `CHANGELOG.md`.

### Contributing

See `CONTRIBUTING.md` for setup, validation commands, and pull request guidelines.


## License
Copyright 2013-present Kunal Sarkhel

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License.  You may obtain a copy of the
License at `https://www.apache.org/licenses/LICENSE-2.0`.

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied.  See the License for the
specific language governing permissions and limitations under the License.
