function _fishmarks_complete
    for entry in (_fishmarks_entries)
        set -l parts (string split -m 1 '=' -- "$entry")
        printf '%s\n' "$parts[1]"
    end
end
