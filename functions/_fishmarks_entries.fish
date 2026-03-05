function _fishmarks_entries
    _fishmarks_ensure_sdirs

    while read -l line
        set -l entry (string match -r '^export[[:space:]]+DIR_([A-Za-z0-9_]+)=(.+)$' -- "$line")
        if test (count $entry) -lt 3
            continue
        end

        set -l name "$entry[2]"
        set -l value (_fishmarks_decode_path "$entry[3]")
        printf '%s=%s\n' "$name" "$value"
    end <"$SDIRS"
end
