function print_bookmark --description "Print the directory associated with a bookmark"
    if test (count $argv) -lt 1
        _fishmarks_print_error "bookmark name required"
        return 1
    end

    if not _check_help "$argv[1]"
        set -l target (_fishmarks_find_path "$argv[1]")
        if test -z "$target"
            _fishmarks_print_error "'$argv[1]' bookmark does not exist"
            return 1
        end

        printf '%s\n' "$target"
    end
end
