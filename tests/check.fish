#!/usr/bin/env fish

set -l files

if test (count $argv) -gt 0
    for file in $argv
        if test -f "$file"; and string match -rq '\\.fish$' -- "$file"
            set -a files "$file"
        end
    end
else
    set files \
        marks.fish \
        install.fish \
        conf.d/*.fish \
        functions/*.fish \
        completions/*.fish \
        tests/*.fish
end

if test (count $files) -eq 0
    exit 0
end

fish -n $files
or exit $status

fish_indent --check $files
