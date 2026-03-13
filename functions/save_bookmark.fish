function save_bookmark --description "Save the current directory as a bookmark"
    if _check_help "$argv[1]"
        return 0
    end

    set -l force 0
    set -l bn

    for arg in $argv
        switch "$arg"
            case --force
                set force 1
            case '--*'
                _fishmarks_print_error "unknown option '$arg'"
                return 1
            case '*'
                if test -n "$bn"
                    _fishmarks_print_error 'too many arguments'
                    return 1
                end
                set bn "$arg"
        end
    end

    if test -z "$bn"
        set bn (string replace -ra -- '[^A-Za-z0-9]' '_' (path basename -- "$PWD"))
    end

    if not _fishmarks_valid_name "$bn"
        _fishmarks_print_error 'Bookmark names may only contain alphanumeric characters and underscores.'
        return 1
    end

    if not _fishmarks_path_supported "$PWD"
        _fishmarks_print_error 'Current directory path contains unsupported newline or carriage-return characters.'
        return 1
    end

    set -l existing_path (_fishmarks_find_path "$bn")
    if test $status -eq 0
        if test "$existing_path" = "$PWD"
            return 0
        end

        if test $force -ne 1
            _fishmarks_print_error "bookmark '$bn' already exists; use --force to overwrite"
            return 1
        end
    end

    set -l updated_entries
    for entry in (_fishmarks_entries)
        set -l parts (string split -m 1 '=' -- "$entry")
        if test "$parts[1]" = "$bn"
            continue
        end
        set -a updated_entries "$entry"
    end

    set -a updated_entries "$bn=$PWD"
    _fishmarks_write_entries $updated_entries
    return 0
end
