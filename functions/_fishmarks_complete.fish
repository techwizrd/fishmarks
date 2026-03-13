function _fishmarks_complete
    _fishmarks_ensure_sdirs

    while read -l line
        set -l entry (string match -r '^export[[:space:]]+DIR_([A-Za-z0-9_]+)=' -- "$line")
        if test (count $entry) -gt 1
            printf '%s\n' "$entry[2]"
        end
    end <"$SDIRS"
end
