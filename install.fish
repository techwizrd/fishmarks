#!/usr/bin/env fish
set -l required_major 3
set -l fish_major (string split . -- (status fish-version))[1]

if test "$fish_major" -lt "$required_major"
    echo "Fish shell version $required_major or newer is required for this script. Get the latest version at https://fishshell.com/."
    exit 1
end

set -l source_file
if test -f "marks.fish"
    set source_file (path resolve "marks.fish")
else if test -f "fishmarks/marks.fish"
    set source_file (path resolve "fishmarks/marks.fish")
else if not test -f "$HOME/.fishmarks/marks.fish"
    git clone https://github.com/techwizrd/fishmarks.git "$HOME/.fishmarks"
    set source_file "$HOME/.fishmarks/marks.fish"
else
    git -C "$HOME/.fishmarks" pull --ff-only
    set source_file "$HOME/.fishmarks/marks.fish"
end

set -l conf_d_dir "$HOME/.config/fish/conf.d"
set -l conf_file "$conf_d_dir/fishmarks.fish"
set -l escaped_source (string replace -- "$HOME" '$HOME' "$source_file")

command mkdir -p -- "$conf_d_dir"

printf '# Load fishmarks (https://github.com/techwizrd/fishmarks)\n' > "$conf_file"
printf 'source %s\n' "$escaped_source" >> "$conf_file"

echo "Fishmarks has been installed to $conf_file"
