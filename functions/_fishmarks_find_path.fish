function _fishmarks_find_path --argument-names bookmark_name
    for entry in (_fishmarks_entries)
        set -l parts (string split -m 1 '=' -- "$entry")
        if test "$parts[1]" = "$bookmark_name"
            printf '%s\n' "$parts[2]"
            return 0
        end
    end

    return 1
end
