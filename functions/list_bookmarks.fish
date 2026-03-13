function list_bookmarks --description "List all available bookmarks"
    if _check_help "$argv[1]"
        return 0
    end

    set -l names_only 0
    for arg in $argv
        switch "$arg"
            case --names-only
                set names_only 1
            case '*'
                _fishmarks_print_error "unknown option '$arg'"
                return 1
        end
    end

    for entry in (_fishmarks_entries)
        set -l parts (string split -m 1 '=' -- "$entry")

        if test $names_only -eq 1
            printf '%s\n' "$parts[1]"
            continue
        end

        set_color yellow
        printf '%-20s' "$parts[1]"
        set_color normal
        printf ' %s\n' "$parts[2]"
    end
end
