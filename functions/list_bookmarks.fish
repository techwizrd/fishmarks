function list_bookmarks --description "List all available bookmarks"
    if not _check_help "$argv[1]"
        for entry in (_fishmarks_entries)
            set -l parts (string split -m 1 '=' -- "$entry")
            set_color yellow
            printf '%-20s' "$parts[1]"
            set_color normal
            printf ' %s\n' "$parts[2]"
        end
    end
end
