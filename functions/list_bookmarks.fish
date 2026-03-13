function list_bookmarks --description "List all available bookmarks"
    if _check_help "$argv[1]"
        return 0
    end

    for entry in (_fishmarks_entries)
        set -l parts (string split -m 1 '=' -- "$entry")
        set_color yellow
        printf '%-20s' "$parts[1]"
        set_color normal
        printf ' %s\n' "$parts[2]"
    end
end
