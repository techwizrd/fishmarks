# fishmarks

[![CI](https://github.com/techwizrd/fishmarks/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/techwizrd/fishmarks/actions/workflows/ci.yml?query=branch%3Amaster)
[![GitHub Release](https://img.shields.io/github/v/release/techwizrd/fishmarks?sort=semver)](https://github.com/techwizrd/fishmarks/releases)
[![Fish 3+](https://img.shields.io/badge/fish-3%2B-4AAE46)](https://fishshell.com/)
[![SemVer](https://img.shields.io/badge/versioning-semver-3f4551)](https://semver.org/)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)
[![Contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)](CONTRIBUTING.md)

Fishmarks lets you save and jump to frequently used directories in
[Fish shell](https://fishshell.com/). It is fast, script-friendly, and compatible
with existing [bashmarks](https://github.com/huyng/bashmarks) data.

## Quickstart (15 seconds)

```fish
fisher install techwizrd/fishmarks
s proj
g proj
l
```

- `s <name>` saves the current directory
- `g <name>` jumps to a saved directory
- `l` lists saved bookmarks

## Demo

![fishmarks demo](.github/assets/fishmarks-demo.gif)

This demo is recorded with [asciinema](https://asciinema.org/) and rendered with
[agg](https://github.com/asciinema/agg).

## Installation

### Automatic Installation

To install fishmarks automatically, paste the following in your terminal.

```fish
curl -fsSL https://raw.githubusercontent.com/techwizrd/fishmarks/master/install.fish | fish
```

Please note that you should _never_ install things by piping untrusted install scripts
downloaded through `curl` directly into your shell (whether `bash` or `fish`).
Even if you read through the install script and think you understand it, you could still
be prone to a
[man-in-the-middle](https://en.wikipedia.org/wiki/Man-in-the-middle_attack) attack
or other security vulnerabilities.
While manual installations are tedious, they are recommended for situations where
security is a concern (and it should almost always be a concern).

### Fisher Installation

If you use [Fisher](https://github.com/jorgebucaran/fisher), install fishmarks with:

```fish
fisher install techwizrd/fishmarks
```

### Fundle Installation

If you use [Fundle](https://github.com/danhper/fundle), add fishmarks to your fish config:

```fish
fundle plugin 'techwizrd/fishmarks'
fundle init
```

Then install plugins:

```fish
fundle install
```

Fish plugin managers load fishmarks from `functions/`, `conf.d/`, and `completions/`.
The top-level `marks.fish` file remains as a compatibility loader
for existing manual installs.

### Manual Installation

To install fishmarks manually:

1. Clone fishmarks into `~/.fishmarks`.

```fish
git clone https://github.com/techwizrd/fishmarks.git ~/.fishmarks
```

1. Source `~/.fishmarks/marks.fish` from a file in `~/.config/fish/conf.d/`.

```fish
mkdir -p ~/.config/fish/conf.d
printf '# Load fishmarks (https://github.com/techwizrd/fishmarks)\n' \
  'source ~/.fishmarks/marks.fish\n' > ~/.config/fish/conf.d/fishmarks.fish
```

### Update to the latest version

To update to the latest version of fishmarks:

1. Navigate to the directory where fishmarks is installed (`~/.fishmarks` by default).

```fish
cd ~/.fishmarks
```

1. Use git to fetch the latest version.

```fish
git fetch --all
```

1. Pull the latest version.

```fish
git pull --ff-only
```

## Compared to other directory-jump tools

- Popular alternatives you might know:
  - [zoxide](https://github.com/ajeetdsouza/zoxide): fast, frecency-based jumping across shells
  - [autojump](https://github.com/wting/autojump): classic usage-history directory jumping
  - [z](https://github.com/rupa/z): original "jump around" script that inspired later tools
  - [z.lua](https://github.com/skywind3000/z.lua): modern Lua implementation with broad shell support
- Use fishmarks when you want explicit, named bookmarks (`g work`, `g dotfiles`)
- Use history/frecency tools when you want automatic ranking by usage

Many users combine both: automatic jumping for exploration, fishmarks for stable project bookmarks.

## Usage

### Commands

```text
save_bookmark [--force] [bookmark_name] (or s) - Saves the current directory as "bookmark_name"
rename_bookmark <old_name> <new_name> - Renames an existing bookmark
bookmark_exists <bookmark_name> - Returns success if bookmark exists
go_to_bookmark <bookmark_name> (or g) - Goes (cd) to the directory associated with "bookmark_name"
print_bookmark <bookmark_name> (or p) - Prints the directory associated with "bookmark_name"
delete_bookmark <bookmark_name> (or d) - Deletes the bookmark
list_bookmarks [--names-only] (or l) - Lists all available bookmarks
fishmarks_doctor - Checks bookmarks file for common issues
fishmarks_version - Prints the installed fishmarks version
```

### Configuration Variables

All variables must be set before `marks.fish` is sourced in fish startup files.

- `SDIRS` - default: `~/.sdirs`; location where bookmarks are stored.
- `NO_FISHMARKS_COMPAT_ALIASES` - disable bashmark-compatible aliases such as `p`.

### Example

```text
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

Or with make:

```sh
make check
```

Run all checks and tests with:

```sh
make test
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

GitHub Actions CI runs checks (`tests/check.fish`, `tests/run.fish`), installer smoke tests,
and plugin-manager smoke tests for Fisher and Fundle on every push and pull request.

## Versioning

fishmarks follows [Semantic Versioning](https://semver.org/).
Notable changes are tracked in `CHANGELOG.md`.

### Contributing

See `CONTRIBUTING.md` for setup, validation commands, and pull request guidelines.

## License

Copyright 2013-present Kunal Sarkhel

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License. You may obtain a copy of the
License at `https://www.apache.org/licenses/LICENSE-2.0`.

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.
