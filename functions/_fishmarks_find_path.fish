function _fishmarks_find_path --argument-names bookmark_name
    _fishmarks_ensure_sdirs

    while read -l line
        set -l entry (string match -r '^export[[:space:]]+DIR_([A-Za-z0-9_]+)=(.+)$' -- "$line")
        if test (count $entry) -lt 3
            continue
        end

        if test "$entry[2]" = "$bookmark_name"
            _fishmarks_decode_path "$entry[3]"
            return 0
        end
    end <"$SDIRS"

    return 1
end
