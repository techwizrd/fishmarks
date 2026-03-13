function rename_bookmark --description "Rename an existing bookmark"
    if test (count $argv) -lt 1
        _fishmarks_print_error "old and new bookmark names required"
        return 1
    end

    if _check_help "$argv[1]"
        return 0
    end

    if test (count $argv) -ne 2
        _fishmarks_print_error "old and new bookmark names required"
        return 1
    end

    set -l old_name "$argv[1]"
    set -l new_name "$argv[2]"

    if string match -q -- '--*' "$old_name"
        _fishmarks_print_error "unknown option '$old_name'"
        return 1
    end

    if string match -q -- '--*' "$new_name"
        _fishmarks_print_error "unknown option '$new_name'"
        return 1
    end

    if not _fishmarks_valid_name "$old_name"
        _fishmarks_print_error 'Bookmark names may only contain alphanumeric characters and underscores.'
        return 1
    end

    if not _fishmarks_valid_name "$new_name"
        _fishmarks_print_error 'Bookmark names may only contain alphanumeric characters and underscores.'
        return 1
    end

    if test "$old_name" = "$new_name"
        _fishmarks_find_path "$old_name" >/dev/null
        if test $status -eq 0
            return 0
        end

        _fishmarks_print_error "bookmark '$old_name' does not exist"
        return 1
    end

    set -l old_path (_fishmarks_find_path "$old_name")
    if test $status -ne 0
        _fishmarks_print_error "bookmark '$old_name' does not exist"
        return 1
    end

    _fishmarks_find_path "$new_name" >/dev/null
    if test $status -eq 0
        _fishmarks_print_error "bookmark '$new_name' already exists"
        return 1
    end

    set -l updated_entries
    for entry in (_fishmarks_entries)
        set -l parts (string split -m 1 '=' -- "$entry")
        if test "$parts[1]" = "$old_name"
            set -a updated_entries "$new_name=$old_path"
            continue
        end

        set -a updated_entries "$entry"
    end

    _fishmarks_write_entries $updated_entries
end
